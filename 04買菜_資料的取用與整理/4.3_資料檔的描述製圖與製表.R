### 《民意調查資料分析的R實戰手冊》
### 劉正山著．2018五南出版
### 4.3 資料檔的描述製圖與製表

#安裝sjPlot套件家族
install.packages("devtools") # 套件開發者工具箱
devtools::install_github("strengejacke/strengejacke")

## 資料檔的讀入、描述與製表
library(sjlabelled)
TNSS2015 <- read_spss("../TNSS2015.sav", enc="big5")
save(TNSS2015,file= "TNSS2015.rda") # 另存到目前所在的資料夾
str(TNSS2015, list.len=5) # 為節省版面只顯示其中的五筆

## 使用`sjPlot::view_df()`來製作資料的次數分配報表
library(sjPlot)
view_df(TNSS2015,
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
