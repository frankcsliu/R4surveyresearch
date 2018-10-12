### 《民意調查資料分析的R實戰手冊》
### 劉正山著．2018五南出版 
### 8.5 網路調查資料分析實作4：BBQ

## 實作目標
# 我們使用由smilepoll.tw提供的開放資料BBQ.csv（在資料區可看到BBQ問卷檔及報表），學習如何整合本書之前的重點，進行變數描述、存檔、進行MCA探索式分析，以及二元勝算對數（確認式）分析實作。

## 假設
# 假設一：對烤肉的新鮮感不再便會降低明年烤肉的意願  
# 假設二：覺得烤肉影響健康便會降低明年烤肉的意願  
# 假設三：覺得烤肉花費造成負擔便會降低明年烤肉的意願  
# 假設四：覺得烤肉麻煩便會降低明年烤肉的意願  
# 假設五：覺得烤肉影響環境便會降低明年烤肉的意願  
# 假設六：覺得不必要見面就能聯絡感情會降低明年烤肉的意願  
# 假設七：認為烤肉不是聯絡感情的首選便會降低明年烤肉的意願

## 初步處理資料檔
# 讀入資料檔並將變數名稱字串轉為變數標籤 
library(readr)
bbq <- read_csv("../BBQ.csv") 
nrow(bbq) # 共650列 
ncol(bbq) # 共58欄

# 取出變數名稱當作變數標籤
varlabels <- colnames(bbq) 

# 拿掉標籤之後的變數名稱重新命名為V1, V2, ...
colnames(bbq)[1:58] <- paste("V", 1:58, sep="") 

# 為變數名稱裝上標籤
sjlabelled::set_label(bbq) <- varlabels 

# 批次清理無效值
bbq <- sjmisc::set_na(bbq, na="NA")

## 變數編碼與描述
varlabels #列出每個變數的標籤
library(sjmisc)
library(sjPlot)
names(bbq)

## 依變數：「明年會不會烤肉」
# （V44）說回到烤肉，請問您明年會不會想全家人一起烤肉？ (0~10)
# table(bbq$V44)
bbq$V44r <- rec(bbq$V44, rec="0:5=0[不會]; 6:10=1[會]", as.num=F) 
frq(bbq$V44)
frq(bbq$V44r)
sjp.frq(bbq$V44r)

## 自變數
# 假設一：「新鮮感」
# （V18）如果大家都烤肉，您會覺得「不好玩」嗎？*
#  跟別人做類似的活動，不好玩　１
#  跟別人做類似的活動也很ok啊　２
bbq$V18r <- rec(bbq$V18, rec="1=1[不新鮮]; 2=0[沒有差]", as.num=F)
frq(bbq$V18r)

# 假設二：「對健康影響的認知」
# （V20）您覺得戶外的烤肉對您的健康有多大影響？*
#  影響很大　１
#  影響不大　２
#  完全沒影響　３
# table(bbq$V20)
bbq$V20r <- rec(bbq$V20, rec="1=1[有很影響]; 2:3=0[影響不大或沒影響]", as.num=F)
frq(bbq$V20r)

# 假設三：「金錢負擔」
# （V21）對您來說，烤肉費用的支出是不是一種負擔？*
#  是，的確是種負擔　１
#  還好　２
#  不會　３
# table(bbq$V21)
bbq$V21r <- rec(bbq$V21, rec="1=1[是負擔]; 2:3=0[還好或不算負擔]", as.num=F)
frq(bbq$V21r)

# 假設四：「心力負擔」
# （V23）準備烤肉食材對您來說會不會很麻煩？*
#  會麻煩　１
#  不會麻煩　２
# table(bbq$V23)
bbq$V23r <- rec(bbq$V23, rec="1=1[會麻煩]; 2:3=0[不會麻煩]", as.num=F)
frq(bbq$V23r)

# 假設五：「對環境影響的認知」
# （V27）您在不在意您烤肉時造成的污染嗎？*
#  會在意，覺得多少影響了環境　１
#  還好　２
#  不會在意　３
# table(bbq$V27)
bbq$V27r <- rec(bbq$V27, rec="1=1[會在意]; 2:3=0[還好/不會在意]", as.num=F)
frq(bbq$V27r)

# 假設六：「見面聯絡感情是必要的（必要性）」
#  (V45) 平時用社群媒體（Line, Facebook等）與家人聯繫感情。您覺得夠不夠？*
#  很夠了。科技讓我與家人緊緊連在一起，年節不見面也不要緊。　１
#  還算夠。有了科技，家人不必一定要聚在一起。　２
#  不夠！見面較能聯絡感情，所以仍然要經常找時間團聚。　３
#  絕對不夠！我不太相信用社群媒體可以聯繫感情，一定要見到面才行。　４
#  我有其他想法：:  *　９０
# table(bbq$V45)
bbq$V45r <- rec(bbq$V45, rec="1:2=0[不常見面不要緊]; 3,4=1[見面是必要的] ", 
                as.num=F)
frq(bbq$V45r)

# 假設七：「為聯絡感情烤肉是首選（重要性）」
#  (V48) 大家圍著烤肉比其他活動要較為容易聯絡感情。*
#  同意。　１
#  不會/不見得。　２
# table(bbq$V48)
bbq$V48r <- rec(bbq$V48, rec="1=1[同意]; 2=0[不見得] ", as.num=F)
frq(bbq$V48r)

## 控制變數
# 「今年中秋有與家人團聚」
# (V2) 今年的中秋節您有與家人團聚嗎？（延後到國慶連假也算）*
#  有　１
#  沒有　２
# table(bbq$V2)
bbq$V2r <- rec(bbq$V2, rec="1=1[有]; 2=0[沒有] ", as.num=F)
frq(bbq$V2r)

# 「今年有參加家庭烤肉活動」
# (V3)  今年中秋節（含國慶連假）團圓時您有烤肉嗎？*
#  有　１
#  沒有　２
# table(bbq$V3)
bbq$V3r <- rec(bbq$V3, rec="1=1[有]; 2=0[沒有（含沒有團聚）] ", 
               as.num=F)
frq(bbq$V3r)

# 「在意對環境的危害」
# （V24）在烤肉活動中，請問下列哪一項是您最無法忍受的？*
#  空氣汙染　１
#  垃圾　２
#  噪音　３
#  隨處亂滴的醬汁　４
#  我覺得還好，沒那麼嚴重　５
#  我最受不了的是：:  *　９０
bbq$V24r <- rec(bbq$V24, 
                rec="1,2,3,4=1[有環境顧慮]; 5=0[都還好]=; 90=NA", 
                as.num=F)
frq(bbq$V24r)

# 「常用手機與網路聯絡感情」
# （V49）「請問您多常使用手機上的社群媒體（Line, FB等）APP與家人聯絡？」*
#  幾乎天天使用　１
#  偶爾使用　２
#  從來沒用（我用手機只打電話）　３
#  我不常使用手機　４
bbq$V49r <- rec(bbq$V49, rec="1=1[很常用]; 2:4=0[偶爾/不常用]", as.num=F) 
frq(bbq$V49r)

# 「聯絡家人時偏好語音（還是文字）」。
# （V50）請問您使用手機與家人聯絡時，比較喜歡使用文字簡訊（例如Line留言），還是使用講話（含視訊）？*
#  整體來說比較常用文字簡訊　１
#  整體來說比較常用語音講話（含視訊）　２
bbq$V50r <- rec(bbq$V50, rec="1=0[偏好文字簡訊]; 2=1[偏好語音視訊]", 
                as.num=F)
frq(bbq$V50r)

#「時間負擔」
# （V37） 請問您覺得一天之內自己可以自由支配的時間（用來做自己想做的事）大約有多少？*
#  很多　１
#  還好　２
#  有點少　３
#  完全沒有　４
bbq$V37r <- rec(bbq$V37, rec="1,2=0[足夠]; 3,4=1[不夠]", as.num=F)
frq(bbq$V37r)

## 儲存檔案
names(bbq) # 確認包含了上面新增的14個變數
save(bbq, file="../BBQ.rda")
rm(list=ls())

## 確認式分析：二元勝算對數模型
# **假設一：對烤肉的新鮮感不再便會降低明年烤肉的意願
# 假設二：覺得烤肉影響健康便會降低明年烤肉的意願
# 假設三：覺得烤肉花費造成負擔便會降低明年烤肉的意願
# **假設四：覺得烤肉麻煩便會降低明年烤肉的意願
# 假設五：覺得烤肉影響環境便會降低明年烤肉的意願
# *假設六：覺得不必要見面就能聯絡感情會降低明年烤肉的意願
# ***假設七：認為烤肉不是聯絡感情的首選便會降低明年烤肉的意願

library(car)
load("../BBQ.rda")

## 模型一：包含所有解釋變數的原始模型
mod.1 <- glm(V44r ~ V18r+V20r+V21r+V23r+V27r+V45r+V48r, 
             data=bbq, 
             family=binomial)
summary(mod.1) 
vif(mod.1) 

## 模型二：加入其他控制變數的完整模型
mod.2 <- update(mod.1, .~. +V2r+V3r+V24r+V49r+V50r+V37r)
summary(mod.2) 
vif(mod.2)

## 模型三：留下有效的控制變數的最終模型
mod.3 <- update(mod.1, .~.+V3r+V49r)
summary(mod.3) 
vif(mod.3)

## 探索式分析：MCA
load("../BBQ.rda")
library(dplyr)
library(FactoMineR)
library(factoextra)

bbqMCA <- select(bbq, V44r, V18r, V20r, V21r, V23r, V27r, V45r, V48r, 
                 V2r, V3r, V24r, V49r, V50r, V37r)
bbqMCA.nona <- na.omit(bbqMCA)
nrow(bbqMCA.nona) # 629
names(bbqMCA.nona)
res<-MCA(bbqMCA.nona, ncp=5, graph= F) 
fviz_screeplot(res, ncp=10) 

# 變數關聯關係圖
plot(res, axes=c(1, 2), new.plot=TRUE, 
     col.var="red", col.ind="black", col.ind.sup="black",
     col.quali.sup="darkgreen", col.quanti.sup="blue",
     label=c("var"), cex=0.8, 
     selectMod = "cos2",
     invisible=c("ind", "quali.sup"), 
     autoLab = "yes",
     title="") 

# 初步假設：覺得自己時間充裕的人(V37r=0)，愈可能傾向見面團聚取代使用手機（V45r=1）；相反的，自覺一天內時間不足的人，反而傾向以手機來取代見面團聚。

## 用卡方檢定來進一步確認肉眼所預判潛在變數之間的相關性
# 做法一
library(gmodels)
CrossTable(bbq$V37r, bbq$V45r, 
           chisq = T,       # 顯示卡方檢定結果
           prop.chisq = F,  # 不必顯示每個細格的卡方值貢獻程度
           prop.t= F        # 不必顯示每個細格次數所佔全體百分比
           )

# 做法二
library(sjPlot)
sjt.xtab(bbq$V37r, bbq$V45r, 
         show.row.prc = TRUE, # 顯示列百分比
         show.col.prc = TRUE  # 顯示欄百分比
         )

## 與資料喝杯咖啡：拿資料來檢視自己對變數關係的判斷
mod.4 <- glm(V45r~V37r, data = bbq, family = binomial)
summary(mod.4) 
