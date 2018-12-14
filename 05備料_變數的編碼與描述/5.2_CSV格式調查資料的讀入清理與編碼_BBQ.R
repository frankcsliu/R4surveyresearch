### 《民意調查資料分析的R實戰手冊》
### 劉正山著．2018五南出版
### 5.2 CSV格式調查資料的讀入清理與編碼

## 讀入資料檔
# 方法一：以read.csv()讀入資料
bbq <- read.csv("../BBQ.csv", header = T) 
str(bbq)

# 方法二：以`readr::read_csv()`讀入資料
# library(readr)
# bbq <- read_csv("../BBQ.csv", 
#                 locale = locale(encoding = "UTF8"))

str(bbq)

## 為變數重新命名及加上標籤
# 方法一：在讀入csv檔時將所有欄位一次命名完畢
# bbq <- read.csv("BBQ.csv", header = T, 
#                 col.names = c("第一欄位名稱", "第二欄位名稱", "第三欄位名稱", ...))

# 方法二：用sjmisc::var_rename()來重新命名自選的變數
# library(sjmisc)
# bbq <- read.csv("BBQ.csv", header = T) 
# names(bbq)
# var_rename(bbq, 
#            "今年的中秋節您有與家人團聚嗎..延後到國慶連假也算." = "V2", 
#            "對您來說.烤肉費用的支出是不是一種負擔." = "V3"
#            ) 

# 方法三：透過sjmisc::rec()編碼
# library(sjmisc)
# bbq$V2 <- rec(bbq$"今年的中秋節您有與家人團聚嗎..延後到國慶連假也算.", 
#               rec="2=0; 1=1",  
#               var.label = "今年的中秋節您有與家人團聚嗎？延後到國慶連假也算。",
#               val.labels = c("沒有","有"),  
#               as.num = F) 
# table(bbq$V2)

# library(sjmisc)
# bbq$V2 <- rec(bbq$"今年的中秋節您有與家人團聚嗎..延後到國慶連假也算.", 
#               rec="1=1 [有]; 2=0 [沒有]", 
#               var.label = "今年的中秋節您有與家人團聚嗎？延後到國慶連假也算。",
#               as.num = F) 
# table(bbq$V2)

# names(bbq)
# names(bbq[2]) 
# bbq$V2 <- rec(bbq[2],   
#                rec="1=1 [有]; 2=0 [沒有]", 
#                var.label = "今年的中秋節您有與家人團聚嗎？（延後到國慶連假也算）",
#                as.num = F)
# gmodels::CrossTable(bbq$V2) #無法顯示結果

# 正確的做法：
# bbq$V2 <- rec(unlist(bbq[2]),   #注意unlist()的使用
#                rec="1=1 [有]; 2=0 [沒有]", 
#                var.label = "今年的中秋節您有與家人團聚嗎？（延後到國慶連假也算）",
#                as.num = F)
# gmodels::CrossTable(bbq$V2) #可以正確顯示結果

# 方法四：多重方式合而為一
# 先取出欄位名稱
bbq <- read.csv("../BBQ.csv", header = T) 
varlabels <- colnames(bbq) 

# 再以取出的所有欄位名稱，植入同一資料檔中當作變數標籤。
bbq <- read.csv("../BBQ.csv", header = F)   # 變數名稱會變為V1, V2, ...
# 替代做法1
# bbq <- readr::read_csv("../BBQ.csv", col_names=F) # 變數名稱變為X1, X2, ... 
# 替代做法2：參考8.5（頁329）直接為變數命名

library(sjlabelled)
bbq <- bbq[-1,]   　# 移除第一列
set_label(bbq) <- varlabels 

library(sjlabelled)
set_labels(bbq$V2, labels=c("有", "沒有"))  # 原始資料中，1=有; 2=沒有

## 移除不必要的欄位
# 方法一：使用NULL刪除欄位
names(bbq)
bbq[15] <- NULL # 移除第15欄

# 方法二：使用sjmisc::remove_var()刪除欄位
library(sjmisc)
names(bbq)
bbq <- remove_var(bbq, 4:14, 39)  # 舉例：移除4到14欄以及第39欄。

## 單一變數的檢視
table(bbq$V2, exclude=NULL) #次數分配表把無效值報出來

library(gmodels)
CrossTable(bbq$V2)

library(sjPlot)
sjt.frq(bbq$V2)  #若表格標題中文變成了亂碼，試試加上這個參數：encoding="big5"
sjp.frq(bbq$V2)

## 儲存檔案
save(bbq, file="BBQ.rda")
