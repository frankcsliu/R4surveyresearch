### 《民意調查資料分析的R實戰手冊》
### 劉正山著．2018五南出版
### 5.4 合併變數製作量尺


# 在正式操作前，用本資料夾中的章節專案檔（.Rproj）點開專案再正式開始練習
# 請用此指令確認目前工作路徑是現在章節的資料夾
here::here() 

## 資料讀入與編碼
library(sjmisc)
load("../teds2006_kao.rda")

# A01 去年選舉期間，有些人花很多時間去注意各種媒體的選舉新聞，有些人沒有時間注意，請問您那時平均每天花多少時間注意電視上的選舉新聞？
# 01  ３０分鐘以下
# 02  ３１－６０分鐘
# 03  一小時到一小時半
# 04  一小時半到二小時
# 05  超過二小時
# 06  偶爾注意
# 07  完全不注意
# 96  看情形、不一定
# 98  不知道
table(kao06$A01)
kao06$tv <- rec(kao06$A01, rec="7=0; 8:hi=NA; else=copy")
table(kao06$tv, exclude = NULL)

# A02 那廣播上的政治評論性節目呢？
table(kao06$A02)
kao06$radio <- rec(kao06$A02, rec="7=0; 8:hi=NA; else=copy")
table(kao06$radio, exclude = NULL)

# A03 那網路上的選舉新聞呢？
table(kao06$A03)
kao06$internet <- rec(kao06$A03, rec="7=0; 8:hi=NA; else=copy")
table(kao06$internet, exclude = NULL)

# A04 那報紙上的選舉新聞呢？
table(kao06$A04)
kao06$newspaper <- rec(kao06$A04, rec="7=0; 8:hi=NA; else=copy")
table(kao06$newspaper, exclude = NULL)


## 製作量尺
# 方法一：以apply()製作量尺
attach(kao06) #資料檔鎖定（參見4.2）
tmp <- cbind(tv,radio,internet,newspaper)
kao06$mediaAtt <- apply(tmp,1,sum)  #依列(1)橫向加總（sum）；等同於 kao06$mediaAtt <- rowSums(tmp)
table(kao06$mediaAtt) #0~22
detach(kao06) 


## 方法二：以sjmisc::row_sums()製作量尺
library(sjmisc)
library(dplyr)
kao06 <- row_sums(kao06, tv, radio, internet, newspaper, n=4) #只有這4題都有答的受訪者才會被加總
?row_sums
names(kao06)
table(kao06$rowsums, exclude = NULL)

## 查看加總的結果
head(select(kao06, tv, radio, internet, newspaper, mediaAtt), 10) #看資料檔最前10列
tail(select(kao06, tv, radio, internet, newspaper, mediaAtt), 8) #看資料檔最後8列
dplyr::sample_n(select(kao06, tv, radio, internet, 
                       newspaper, mediaAtt), 5) #隨機挑5列來看

## 補充盒子：以dplyr::mutate()製作量尺
# library(dplyr)
# kao06 <- mutate(kao06, 
#                 mediaatt0 = tv+radio+newspaper,
#                 mediaatt1 = mediaatt0+internet)
# sample_n(select(kao06, tv, radio, newspaper, mediaatt0, 
#                 internet, mediaatt1), 5) # 隨機挑5列來看

## 保存新增變數後的資料檔
kao06 <- data.frame(kao06) # 重新框定含新增的變數的資料檔
save(kao06, file="../kao06r.rda")


## 為量尺製圖
kao06$mediaAtt <- unlist(kao06$mediaAtt)
plot_frq(kao06$mediaAtt, 
        type = "histogram", 
        axis.title = "media attention scale", 
        xlim=c(0,22))

## 判斷量尺或指標的品質
# 用psych::omega()同時計算Alpha與Omega
tmp.nona <- na.omit(tmp)
# install.packages("GPArotation")
psych::omega(tmp.nona) # alpha=0.37; omega=0.42

## 補充盒子：其他計算Alpha的工具
coefficientalpha::alpha(tmp.nona)
sjPlot::sjt.itemanalysis(tmp) 
performance::item_reliability(tmp)

