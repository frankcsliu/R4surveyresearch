### 《民意調查資料分析的R實戰手冊》
### 劉正山著．2018五南出版
### 5.3 變數的描述製表與製圖 

## 用製表的方式描述變數
library(sjlabelled)
tscs2013 <- read_data("../tscs2013q2.sav") #讀入原始檔

# table()
table(tscs2013$v65, exclude=NULL) # exclude=NULL 顯示無效值

# gmodels::CrossTabsle()
library(gmodels)
CrossTable(tscs2013$v65)

# sjmisc::frq()
library(sjmisc)
frq(tscs2013$v65)
frq(tscs2013$v65, weights = tscs2013$wr) 

## 清除無效值、重新編碼、排序及上標籤
tscs2013$v65r <- rec(tscs2013$v65, 
                     rec="94:99=NA; else=copy",  
                     as.num = F)
frq(tscs2013$v65r)
tscs2013$v65rv <- rec(tscs2013$v65r, rec="rev", 
                     var.label="how serious the issue is", 
                     val.labels = c("not at all (1)", 
                                    "not very serious (2)", 
                                    "serious (3)", 
                                    "very serious (4)"))
frq(tscs2013$v65rv)
# frq(tscs2013$v65rv, weights = tscs2013$wr) 
save(tscs2013, file="tscs2013r.rda")  #把含有新增變數的資料檔另存在工作資料夾

# psych::describe()
library(psych)
load("../tscs2013.rda")  #讀取本書提供的含有編碼後所有變數的資料檔
describe(tscs2013$age) 

# sjmisc::decr()
library(sjmisc)
descr(tscs2013$age) 

## 使用sjPlot為單一變數製圖
library(sjPlot)
sjmisc::frq(tscs2013$v65r)

# Mac使用者需設定字體才能正常顯示標籤中的中文字
# sjPlot::set_theme(sjPlot::set_theme(theme.font="PingFang TC"))  

plot_frq(tscs2013$v65r, 
        weight.by = tscs2013$wr, wrap.title=30)

## 使用sjPlot來視覺化兩個變數之間的關係
# 方法一：plot_grpfrq()
library(sjPlot)
library(sjlabelled)
frq(tscs2013$sex)
tscs2013$sex <- set_label(tscs2013$sex, label="sex")  # 變更變數標籤
tscs2013$sex <- set_labels(tscs2013$sex, labels= c("female", "male")) # 變更選項標籤
plot_grpfrq(tscs2013$v65r, tscs2013$sex)  # 橫向比較
plot_grpfrq(tscs2013$v65r, tscs2013$sex, bar.pos = "stack")  # 堆疊

# 方法二：plot_xtab()
plot_xtab(tscs2013$v65r, tscs2013$sex) #製表
plot_xtab(tscs2013$v65r, tscs2013$sex) #製圖

## 補充盒子：用`ggplot2`畫長條圖
library(ggplot2)
load("../wgcoll.rda")
ggplot(data=wgc, aes(x=factor(c), 
                     fill=factor(g))) + 
  geom_bar(width=.6, position="dodge")  
