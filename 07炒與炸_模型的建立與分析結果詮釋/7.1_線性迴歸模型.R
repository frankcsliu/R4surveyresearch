### 《民意調查資料分析的R實戰手冊》
### 劉正山著．2018五南出版
### 7.1 線性迴歸模型


# 在正式操作前，用本資料夾中的章節專案檔（.Rproj）點開專案再正式開始練習
# 請用此指令確認目前工作路徑是現在章節的資料夾
here::here() 

## 實例操作一：家長教育程度與學生成績表現
#讀入資料並繪資料散佈圖（scatter plot）
load("wgcoll.rda") 
attach(wgc)     #鎖定資料檔
plot(aa ~ pe)   #資料散佈圖

#相關係數
cor(aa, pe)  

# 假設一：家長的背景是影響學生的表現的重要變數
mod.1 <- lm(aa ~ pe)  
summary(mod.1)
cor(aa, pe)^2   # 相關係數的平方剛好就是即R$^2$

# 為資料散佈圖畫出迴歸線
plot(aa~pe, data=wgc)
abline(lm(aa~pe, data=wgc), lty=1, col="red")

# 假設二：家庭居住地對學生成績有影響
mod.2 <- lm(aa ~ pe + c, data=wgc)
summary(mod.2)

# 假設三：學生成就動機對學生成績有影響
table(wgc$sm)
mod.3 <- update(mod.2, .~.+ relevel(factor(sm), ref="2"), data=wgc)  
summary(mod.3)

# 假設四：家長教育程度與居住地區具有互為調節的效果
mod.4 <- lm(aa ~ pe * factor(c), data=wgc)
summary(mod.4)

## 線性模型的檢誤
# 殘差-適配圖
plot(lm(aa ~ pe + c), which=1) 
#也可以這樣畫：
# plot(fitted(mod.3), resid(mod.3)) 

# 分位數散佈圖 
plot(lm(aa ~ pe + c), which=2) 

# 位置尺度圖
plot(lm(aa ~ pe + c), which=3) 

# 殘差-槓杆圖
plot(lm(aa ~ pe + c), which=5)
  
## 補充盒子：一次看完四張診斷圖  
par(mfrow=c(2,2)) # 將四張診斷圖一次輸出為到一張2x2的畫布上成為一張
plot(lm(aa ~ pe + c))
par(mfrow=c(1,1)) # 將畫布調整回一次一張
plot(lm(aa ~ pe + c), which=4)

## 找出林中特殊的樹--挑出極端值（outliers）  
load("../wgcoll.rda") 
attach(wgc)
mod.1 <- lm(aa ~ pe)  
plot(aa~pe, cex=10*sqrt(cooks.distance(mod.1))) 
abline(h=mean(aa), lty=2) # 畫水平線
abline(v=mean(pe), lty=3) # 畫垂直線
abline(mod.1, data=wgc, lty=1, col="red")

# 試畫迴歸線、檢查是否有極端個案
with(wgc, identify(aa ~ pe, labels=id)) #手動點出1個極端值（左下角）的 No. 8
abline(lm(aa ~ pe, data=wgc, subset=c(-8)), lty=2, col="blue")

# 在圖上加圖示
labels <- c("all", "-8")
legend(locator(1), legend=labels, lty=1:2, col=c("red","blue"))  
detach(wgc)

## 補充盒子：寶寶出生重量的迴歸模型    
library(UsingR)
data(babies)
?babies　# 請自讀資料檔的說明書，依變數是寶寶出生的重量。
subbabies <- subset(babies, 
                    gestation < 350 & age < 99 & 
                    ht <99 & wt1 <999 & dage < 99 & dht <99 & dwt <999)  

# 替代的寫法
# library(dplyr)
# subbabis2 <- filter(babies, 
#                     gestation < 350, age < 99, ht <99, 
#                     wt1 <999, dage < 99, dht <99, dwt <999) 

res.lm <- lm(wt ~ gestation + age + ht + wt1 + dage + dht + dwt,
           data = subbabies)

summary(res.lm)　# 請依結果辨識出具有解釋力的變數


# 查找特殊個案
plot(fitted(res.lm), resid(res.lm)) # 殘差看來與模型相互獨立。
plot(res.lm)     # 注意：R需要你按Enter鍵來切換四張圖；也注意一下261這個outlier
babies[260:263,] # 第261個受訪者 (id=4604) 的陣痛期特別短，可能是個特殊例外。

# 移除極端個案後調整的模型
subbabies2  <- subset(subbabies, id!=4604)
res.lm2  <-  lm(wt ~ gestation + age + ht + wt1 + dage + dht + dwt,
             data = subbabies2)
plot(res.lm2)
summary(res.lm2)
