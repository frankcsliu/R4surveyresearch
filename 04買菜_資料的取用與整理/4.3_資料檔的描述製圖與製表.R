### 《民意調查資料分析的R實戰手冊》
### 劉正山著．2018五南出版
### 4.3 資料檔的描述製圖與製表

# 在正式操作前，用本資料夾中的章節專案檔（.Rproj）點開專案再正式開始練習
# 請用此指令確認目前工作路徑是現在章節的資料夾
here::here() 

# 安裝sjPlot套件家族
# install.packages(c("sjPlot", "sjmisc", "sjlabelled")) 

## 資料檔的讀入、描述與製表
library(sjlabelled)
TNSS2015 <- read_spss("../TNSS2015.sav") #若有亂碼時加上參數 enc="big5"
str(TNSS2015, list.len=5) # 為節省版面只顯示其中的五筆

# 移除欄位
TNSS2015$TEL <- NULL　#含個資的欄位應予刪除不使用

save(TNSS2015,file= "TNSS2015.rda") # 另存到目前所在的資料夾

## 使用`sjPlot::view_df()`來製作資料的次數分配報表
load("TNSS2015.rda")
library(sjPlot)
view_df(TNSS2015,  #若有亂碼, 可使用參數: encoding="big5",
        file="TNSS2015tab.html",  # 結果直接另存新檔
        show.na = T, # 顯示未重新編碼前的無效值個數
        show.frq = T, # 顯示次數
        show.prc = T # 顯示百分比 
        )

## 補充盒子：製作加權之後的資料報表 
library(sjPlot)
view_df(TNSS2015,
        file="TNSS2015tab2.html",  # 結果直接另存新檔
        show.na = T, # 顯示無效值（拒答）個數
        show.frq = T, # 顯示次數
        show.prc = T, # 顯示百分比
        weight.by = w, # 使用加權值
        show.wtd.frq = T, # 顯示加權後的次數
        show.wtd.prc = T # 顯示加權後的百分比
)

## 檢視資料檔中無效值的比例
library(sjmisc)
load("../tscs2013.rda") 
descr(tscs2013, v62, v70, v93)  # 以純文字顯示特定變數的資訊
descr(tscs2013, v62, v70, v93, out="browser") # 以瀏覽器開啟所有變數的資訊（html檔）

# 檢視資料中無效值的圖形化工具Amelia::missmap
library(Amelia)
missmap(tscs2013)



## 補充：看資料結構的替代方法　tidyverse::glimpse()
library(tidyverse)
library(summarytools)
TNSS2015 <- read_spss("../TNSS2015.sav") |> glimpse()

## 補充：製作大表的替代方法　summarytools::dfSummary() 
## 注意：需要用haven套件讀入原始資料才能在summarytools套件功能正確呈現選項標籤
library(haven)
TNSS2015df <- read_sav("../TNSS2015.sav")
TNSS2015df |>
        dfSummary(
                graph.col = T,　
                style = "grid",
                graph.magnif = 0.75,
        ) |>
        view()

