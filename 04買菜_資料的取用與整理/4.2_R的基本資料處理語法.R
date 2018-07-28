### 《民意調查資料分析的R實戰手冊》
### 劉正山著．2018五南出版
### 4.2 R的基本資料處理語法

## 使用.rda格式存取檔案
# 讀取R資料檔
getwd()
load("../tscs2013.rda") # Environment的data區會出現這筆資料檔的資料物件名稱tscs2013

# 存成R專用的rda檔
save(tscs2013, file="tscs2013.rda", compress=TRUE)  

## 讀取逗點分隔文字格式的csv檔案
library(foreign)
wgc <- read.csv("../wgcoll.csv") # 讀取單機上的資料
wgc <- read.csv("http://www2.nsysu.edu.tw/politics/liu/teaching/dataAnalysis/data/wgcoll.csv")  # 讀取網路上的資料
?read.csv

## 讀取IBM SPSS的sav檔案
# 方法一：使用`sjlabelled::read_spss()`讀取sav檔案
library(sjmisc)
tscs2013 <- read_spss("../tscs2013q2.sav")  

#參考盒子：關於使用`sjlabelled::read_spss()`讀入big-5編碼的中文資料檔
# library(sjlabelled)
# tscs2013 <- read_spss("../tscs2013q2", enc = "big5")
# str(id15)

# 方法二：使用`foreign::read.spss()`讀取sav檔案
library(foreign)
tscs2013 <- read.spss("../tscs2013q2.sav",
                      reencode="big5",  
                      use.value.labels=F, 
                      to.data.frame = T) 

## 讀取Stata的dta格式檔案
library(foreign)
statadat <- read.dta("http://www.stata-press.com/data/r10/fish.dta")
head(statadat)

## 讀取Excel檔案（.xls或.xlsx）
# 方法一：
# install.packages("readxl")  #安裝套件
library(readxl)
dat<- read_excel("../xlssample.xls")

#方法二：
# install.packages(c("xlsx", "rJava")  #安裝套件
# library(xlsx)
# dat <- read.xlsx("../xlssample.xls", 1) # 讀入第一個分頁的資料
# ?read.xlsx

#查詢更多替代方法:
# ??xls

## 讀取SAS的transport檔案
library(foreign)
sasdata <- read.xport("../ACQ_F.XPT") 
?read.xport

## 讀取SAS的sas7bdat格式檔案
# install.packages("sas7bdat")
library(sas7bdat)
sasnew <- read.sas7bdat("https://stats.idre.ucla.edu/wp-content/uploads/2016/02/mlogit.sas7bdat")
tail(sasnew)

## 匯出為其他格式的檔案
# (1) 存成csv格式
write.csv(sasnew, file="sasnew.csv") 

# (2) 存成sav格式
library(sjlabelled)
write_spss(sasnew, "sasnew.sav")

## 資料檔的檢視
View(tscs2013)
names(tscs2013) # 列出所有變數名稱
str(tscs2013)   # 顯示整個資料檔的結構


## 補充盒子：讀入資料檔時可能會遇到的語系或亂碼問題的解決方案
# 方法一：調整Rstudio語系環境
#Windows 使用者：
Sys.getlocale(category = "LC_ALL")  # 查看自己電腦系統所支援的語系，若無中文支援，則使用
Sys.setlocale('LC_ALL','C')

#Mac 使用者：
Sys.setlocale(category = "LC_ALL", locale = "zh_TW.UTF-8")

# 遇到簡體中文資料檔時的設定方式
# Sys.setlocale(category=”LC_ALL”, locale = “Chinese(Simplified)”)

# 方法二：使用`readr::read_csv()`，以加上參數的方式指明所要讀入資料的語系
library(readr)
bbq <- read_csv("../BBQ.csv", 
                locale = locale(encoding = "UTF8"))

#純文字碼的編碼調整
library(readr)
bbq <- read_csv("../BBQ.csv", locale = locale(encoding = "BIG5"))

# 方法三：將原始檔案重新另存為通用萬國碼（utf-8）格式
# (1) 透過Google試算表來轉換資料檔本身的語系  
# (2) 使用自由軟體Open Office或LibreOffice來轉換資料檔本身的語系  
# (3) 在Windows中用筆記本來轉換資料檔本身的語系
# (4) 使用Sublime Text讀入並另存為utf-8格式