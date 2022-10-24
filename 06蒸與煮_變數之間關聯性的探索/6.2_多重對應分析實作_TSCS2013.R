### 《民意調查資料分析的R實戰手冊》
### 劉正山著．2018五南出版
### 6.2 使用FactoMineR套件進行MCA分析：TSCS2013 

# 在正式操作前，請點開本資料夾中的章節專案檔（.Rproj）
# 再將目前的資料夾當作是目前的工作路徑，才正式開始練習
here::here() 

## 資料描述：TSCS2013 面訪資料  
# 台灣社會變遷基本調查計畫2013第六期第四次：國家認同組  
# 計畫主持人：傅仰止,章英華,杜素豪,廖培珊   
# 計畫執行單位：中央研究院社會學研究所  
# 經費補助單位：行政院國家科學委員會社會科學研究中心 
# 調查執行期間：2013.09.22-2013.12.10  
# 有效觀察值（N）= 1,952

## 資料準備
# data$var1 <- as.factor(data$var1)
# data$var1 <- sjmisc::rec(data$var1, "1=1; 2=0", as.num=F)  #注意as.num=F就是將var1設為「非連續型變數」

## 工具準備: 
# install.packages("FactoMineR")
# install.packages("factoextra")

### 挑選變數
library(dplyr)
load("../tscs2013r.rda")

tscs2013forMCA <- select(tscs2013r, 
                         c(# 核心變數 (core vars)
                         　gen.1, gen.2, gen.3, gen.4, gen.5, # 世代
                           v15r, #「祖國」是哪裡
                           v54ar, v54br, v54cr, v54dr,　# 最有承傳價值的歷史事件
                           v57r, #台灣人/既是台灣人也是中國人/其他
                         　v61r, # 統獨立場
                           v76r, # 國號
                           v89ar, v89br, v89cr, v89dr, 
                         　v89er, v89fr, v89gr, v89hr, v89ir, # 民族－國家
                      
                           # 輔助用的連續變數（quantatative supplementary vars）
                         　v58r, # 自認台灣人程度
                         　v59r, # 自認中國人程度

                           # 輔助用的類別變數（qualitative supplementary vars）
                           sex, 
                           college, # 大專教育程度
                           camp, # 政黨傾向
                         　v71ar, # 中華民族包含台灣原住民
                         　v71er, # 中華民族包含台灣居民
                           v75r　#　國家領土範圍
                           ))

# 將無效值剔除（list-wise deletion）。
tscs2013forMCA.nona <- na.omit(tscs2013forMCA)
nrow(tscs2013forMCA.nona) #1479

# 以直方圖確認所選的變數之次數分配
par(mfrow=c(2,3))
for (i in 1:ncol(tscs2013forMCA.nona)) {
  plot(tscs2013forMCA.nona[,i], main=colnames(tscs2013forMCA.nona)[i],
       ylab = "Count", col="steelblue", las = 2, ylim=c(0,1500))
}
par(mfrow=c(1,1))

## MCA運算
library(FactoMineR)
library(factoextra)

names(tscs2013forMCA.nona)  
res<-MCA(tscs2013forMCA.nona, ncp=10, quanti.sup=c(23,24), 
         quali.sup=25: 30, graph= F) #ncp 為主觀定的維次個數

summary(res, nb.dec = 3, nbelements=10, nbind = 10, 
        ncp = 2, file="result2dim.txt") 

res$dimdesc <- dimdesc(res, axes = 1:10) # 前三維次
# 分析結果存檔
write.infile(res$dimdesc, file ="MCAresults",append=F)
write.infile(res$eig, file ="MCAresults",append=T)
write.infile(res$var, file ="MCAresults",append=T)

## 繪製陡坡圖（screeplot）
fviz_screeplot(res, ncp=10) 

## 維次歸納描述 （Dimension Description）
# install.packages("corrplot")
library(corrplot) 
corrplot(res$var$cos2, is.corr=FALSE, tl.cex=.6)

## 變數（variables）的關聯分佈圖
library(FactoMineR)
library(factoextra)

plot(res, axes=c(1, 2), new.plot=TRUE, choix="var", 
     col.var="red", col.quali.sup="darkgreen", 
     label=c("quali.sup", "quanti.sup", "var"), 
     invisible=c("ind"), 
     autoLab = "yes",
  #  title="The Distribution of Variables on the MCA Factor Map",
     title="", cex=0.8,
     xlim=c(0,0.4), ylim=c(0, 0.6))

# 拉近
plot(res, axes=c(1, 2), new.plot=TRUE, choix="var", 
     col.var="red", col.quali.sup="darkgreen", 
     label=c("quali.sup", "quanti.sup", "var"), 
     invisible=c("ind"), 
     autoLab = "yes",
     #title="The Distribution of Variables on the MCA Factor Map", cex=0.8,
     title="", cex=0.8,
     xlim=c(0,0.03), ylim=c(0, 0.05))

## 變數類別（categories）關係圖
plot(res, axes=c(1, 2), new.plot=TRUE, 
     col.var="red", col.ind="black", col.ind.sup="black",
     col.quali.sup="darkgreen", col.quanti.sup="blue",
     label=c("var"), cex=0.8, 
     selectMod = "cos2 70",
     invisible=c("ind", "quali.sup"), 
     autoLab = "yes",
     #title="Distribution of Elements on the MCA Factor Map") 
     title="") 

# 最具維度辨識力的變數類別組合
plot(res, axes=c(1, 2), new.plot=TRUE, 
     col.var="red", col.ind="black", col.ind.sup="black",
     col.quali.sup="darkgreen", col.quanti.sup="blue",
     label=c("var"), cex=0.8, 
     selectMod = "cos2 30",  #共52個變數
     invisible=c("ind", "quali.sup"), 
     xlim=c(-1.2,1.2), ylim=c(-0.6,2), 
     autoLab = "yes",
     # title="Top 30 Critical Elements on the MCA Factor Map") 
     title="") 

#拉近
plot(res, axes=c(1, 2), new.plot=TRUE, 
     col.var="red", col.ind="black", col.ind.sup="black",
     col.quali.sup="darkgreen", col.quanti.sup="blue",
     label=c("var"), cex=0.8, 
     selectMod = "cos2 30", 
     invisible=c("ind", "quali.sup"), 
     xlim=c(-1.2,1.2), ylim=c(-0.6,0.5), 
     autoLab = "yes",
    # title="Top 30 Critical Elements on the MCA Factor Map 2")
     title="") 

# 維次貢獻
library(factoextra)
# 第一維度的重要變數類別
fviz_contrib(res, choice ="var", axes = 1)
# 第二維度的重要變數類別
fviz_contrib(res, choice ="var", axes = 2)

# 第三維度的重要變數類別
# fviz_contrib(res, choice ="var", axes = 3)
# 對前三個維度最有貢獻的變數類別
# fviz_contrib(res, choice ="var", axes = 1:3)

## 受訪者在兩個維度的分佈  
plot(res, axes=c(1, 2), new.plot=TRUE, choix="ind", 
     col.var="red", col.quali.sup="darkgreen",
     label=c("var"),
     selectMod ="cos2 15", select="cos2 1",
     xlim=c(-1,1),
     invisible=c("quali.sup", "var"), 
     #title="The Distribution of Individuals on the MCA Factor Map")
     title="")

## 橢圓圖（Ellipse）
library(FactoMineR)
plotellipses(res, keepvar=c("v57r"), magnify = 5, lwd = 4, label = "var")
plotellipses(res, keepvar=c("v76r"), magnify = 5, lwd = 4, label = "var")
plotellipses(res, keepvar=c("v61r"), magnify = 5, lwd = 4, label = "var")

## 世代分佈的差異
library(factoextra)
plotellipses(res, keepvar = c("gen.1","gen.2","gen.3",
                              "gen.4","gen.5"))

## 藍綠支持者分佈的差異
library(factoextra)
plotellipses(res, keepvar = c("camp"), label="ind.sup")

# 輔助連續型變數的影響值
plot(res, axes=c(1, 2), new.plot=TRUE, choix="quanti.sup", 
     col.quanti.sup="blue", label=c("quanti.sup"), 
    # title="Quantitative Supplementary Variables")
     title="Quantitative Supplementary Variables")
