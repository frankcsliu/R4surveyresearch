### 《民意調查資料分析的R實戰手冊》
### 劉正山著．2018五南出版
### 6.1 變數間的相關性檢驗

## 假設
# H0: 性別與「用公投決定統獨」的認知無關。  
# H1: 性別與「用公投決定統獨」的認知有關。

# 讀入資料檔：物件名稱為tscs2013
load("../tscs2013.rda") 

# 變數重新編碼
library(sjmisc)
tscs2013$v73r <- rec(tscs2013$v73, rec="1,2=1; 3,4=0; else=NA") # 1=贊成或非常贊成; 0=不贊成或非常不贊成

# 為變數及其選項數值設定中文標籤
library(sjlabelled)
tscs2013$v73r <- set_label(tscs2013$v73r,
                           label="贊不贊成用公民投票決定統一還是獨立？")
tscs2013$v73r <- set_labels(tscs2013$v73r, labels=c("不贊成","贊成"))

# 看次數分配表
library(sjmisc)
frq(tscs2013$v73r)

# 將含新變數的資料物件另存到專案夾中
save(tscs2013, file="tscs2013.rda") #建議使用新的檔名
rm(list=ls())
load("tscs2013.rda")

## 類別型變數的相關性檢驗
# 方法一：直接以chisq.test()計算卡方值。
chisq.test(tscs2013$v73r, tscs2013$sex)  

# 方法二：以gmodels::CrossTable()做交叉分析及製表
library(gmodels)
CrossTable(tscs2013$v73r) #單一變數的次數分配 
CrossTable(tscs2013$v73r, tscs2013$sex)  #兩個類別變數的交叉次數分配

CrossTable(tscs2013$v73r,　tscs2013$sex,　
           prop.t=FALSE, # 不顯示細格百分比
           prop.r=TRUE,  # 顯示列百分比（預設）
           prop.c=TRUE,  # 顯示欄百分比（預設）
           prop.chisq=FALSE, # 不顯示卡方值的貢獻度
           chisq=TRUE # 顯示卡方檢定數值
           ) 

#方法三：以sjPlot::sjt.xtab()做交叉分析及製表
library(sjPlot)
sjt.xtab(tscs2013$v73r,　tscs2013$sex, encoding="utf8")

library(sjPlot)
sjt.xtab(tscs2013$v73r,　tscs2013$sex, encoding="utf8", 
         show.row.prc = TRUE, # 顯示列百分比
         show.col.prc = TRUE, # 顯示欄百分比
         show.na = FALSE, # 不顯示無效值（預設）
         show.legend = FALSE, # 不顯示圖示（預設）
         show.exp = FALSE,  # 不顯示期望值 （預設）
         show.cell.prc = FALSE,   # 不顯示細格的百分比 （預設）
         tdcol.col = "gray", # 將欄百分比顏色改為灰色 （預設為綠色）
         tdcol.row = "brown" # 將列百分比顏色改為褐色 （預設為藍色）
         )
### 實作：政治世代與國號選擇  
# 理論：不同世代在成年期間所經歷的政治現象會影響其國家的想像與認同。  
# 假設：  
# H0: 世代與國號選擇無關；  
# H1: 世代與國號選擇有關。  

# 76.請問您覺得我們的國家現在應該叫什麼名字比較合乎您的看法？
# (01)中華民國 (02)中華民國在台灣 (03)台灣
# (04)台灣共和國 (05)中國台灣 (06)中華人民共和國
# (07)其他，請說明：____________
library(sjmisc)
tscs2013$cname <- rec(tscs2013$v76, rec="1=1;2=2;3=3;4=4;5:7=5;else=NA", as.num = F)
frq(tscs2013$cname)
library(sjPlot)

# 資料分析結果拒絕虛無假設：兩者高度相關。
sjt.xtab(tscs2013$cname,　tscs2013$generation, 
         show.row.prc = TRUE, # 顯示列百分比
         show.col.prc = TRUE, # 顯示欄百分比
         show.na = FALSE, # 不顯示無效值（預設）
         show.legend = FALSE, # 不顯示圖示（預設）
         show.exp = FALSE,  # 不顯示期望值 （預設）
         show.cell.prc = FALSE,   # 不顯示細格的百分比 （預設）
         tdcol.col = "gray", # 將欄百分比顏色改為灰色 （預設為綠色）
         tdcol.row = "brown" # 將列百分比顏色改為褐色 （預設為藍色）
)

save(tscs2013, file="tscs2013.rda") 


## 兩連續變數間的相關係檢驗
library(car)
data("Prestige")
cor(Prestige$education, Prestige$income) 
cor(Prestige$education, Prestige$prestige)
cor(Prestige$education, Prestige$women)

## 群組式的兩兩相關性檢驗
library(dplyr)
prestige <- select(Prestige, 
                   education, income, prestige, women)
library(sjPlot)
sjt.corr(prestige, 
         show.p = T, # 顯示顯著性 （預設）
         triangle = "lower" #只顯示下方的三角型
         )
