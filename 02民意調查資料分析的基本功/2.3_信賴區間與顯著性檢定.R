### 《民意調查資料分析的R實戰手冊》
### 劉正山著．2018五南出版
# 2.3 信賴區間與顯著性檢定

# 在正式操作前，用本資料夾中的章節專案檔（.Rproj）點開專案再正式開始練習
# 請用此指令確認目前工作路徑是現在章節的資料夾
here::here() 

## 信賴區間的基本概念
pop <- rep(0:1, c(19000000-0.56*19000000,0.56*19000000)) #創造出一個虛擬母體
mean(sample(pop,1068)) #從中抽樣

# 抽樣3000次
result <- replicate(3000, mean(sample(pop,1068, replace=TRUE)))
mean(result)
hist(result)

# 補充盒子：另一種寫法
res <- c()
for(i in 1:3000)
  {
    res[i] <- mean(sample(pop, 1068))
  }
mean(res)


# 觀察一下在這3000個樣本平均數中，90%的樣本平均數會落在那個區間
quantile(result,c(0.05,0.95))

## Z值法的基本概念
# Z值計算
options(digits=3)
n <- 1013              # 受訪者人數
x <- 466               # 支持現任元首的人數
p <- x/n               # 支持現任元首的比例（假設情況是非支持即反對）
SE  <- sqrt(p*(1-p)/n) # 這個樣本的標準誤
Z  <-  (p -.50)/SE
Z

alpha=.05
prop.test(x, n, conf.level=(1-alpha))

## t值法
# 大家都沒在追劇？
x <- c(1, 1, 0, 0, 0, 0.5, 0, 0, 0.5, 1)
t.test(x, conf.level=0.95)
t.test(x, mu=0.7)

## 單一樣本檢定
options(digits=4)
p0  <- .113       # 2010年樣本中的貧窮人口比例
p1 <- .117       # 2011年樣本中的貧窮人口比例
p2  <- .121       # 2012年樣本中的貧窮人口比例
n1  <-  50000    # 2011年樣本的大小
n2  <- 60000      # 2012年樣本的大小
SD  <-  sqrt(p0*(1-p0)/n1)
zscore  <-  (p1-p0)/SD
zscore  # Z-score 大於1.645表示十分顯著 

### 計算p值
pnorm(.117, mean=p0, sd=SD, lower.tail=FALSE)   # 右尾檢定
pnorm(zscore, lower.tail=FALSE)  # 結果一樣
prop.test(x=p1*n1, n=n1, p=p0, alt="greater")

## 兩個樣本獨立性檢定
phat=c(.121, .117)
n=c(50000, 60000)
n*phat
prop.test(n*phat, n, alt="two.sided") 

## 兩波民調資料的品質檢測
load("../ks06a.rda")
load("../ks06b.rda")
ageA <- ks06a$V25[(ks06a$V25>18)&(ks06a$V25<95)]  # 建立新變數&清理無效值
ageB <- ks06b$V19[(ks06b$V19>18)&(ks06b$V19<95)]
length(ageA)
length(ageB)
boxplot(ageA,ageB,col="grey")      #可以看出兩筆樣本資料離散的程度十分相近

# 用公式
zeta <-  (mean(ageA) - mean(ageB)) / (sqrt(var(ageB)/764 + var(ageB)/650))
zeta

# 用指令
t.test(ageA,ageB, alt="two.sided", var.equal=TRUE)

#如果兩筆資料的離散程度不一樣，則用
# t.test(x, y, alt="two.sided", var.equal=FALSE)

plot(density(ageA))
lines(density(ageB),lty=2)
wilcox.test(ageA,ageB,conf.level=0.95, conf.int=TRUE) 
