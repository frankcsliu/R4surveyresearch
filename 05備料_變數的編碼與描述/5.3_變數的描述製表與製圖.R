### 《民意調查資料分析的R實戰手冊》
### 劉正山著．2018五南出版
### 5.3 變數的描述製表與製圖 

## 用製表的方式描述變數
load("../tscs2013.rda")

# table()
table(tscs2013$v65, exclude=NULL) # exclude=NULL 顯示無效值

# gmodels::CrossTabsle()
library(gmodels)
CrossTable(tscs2013$v65)

# sjmisc::frq()
library(sjmisc)
frq(tscs2013$v65)
# frq(tscs2013$v65, weight.by = tscs2013$wr)  #加權

# sjPlot::sjt.frq()
library(sjPlot) 

## 清除無效值、重新編碼、排序及上標籤
tscs2013$v65r <- rec(tscs2013$v65, 
                     rec="94:99=NA; else=copy",  
                     as.num = F)
tscs2013$v65r <- rec(tscs2013$v65r, rec="rev", 
                     var.label="how serious the issue is", 
                     val.labels = c("not at all (1)", 
                                    "not very serious (2)", 
                                    "serious (3)", 
                                    "very serious (4)"))
sjt.frq(tscs2013$v65r, weight.by = tscs2013$wr) 

# psych::describe()
library(psych)
describe(tscs2013$age) 

# sjmisc::decr()
library(sjmisc)
descr(tscs2013$age) 
```

## 使用sjPlot為單一變數製圖
library(sjPlot)
sjmisc::frq(tscs2013$v65r)
sjp.frq(tscs2013$v65r, 
        weight.by = tscs2013$wr, wrap.title=30)

## 使用sjPlot來視覺化兩個變數之間的關係
# 方法一：sjp.grpfrq()
library(sjlabelled)
frq(tscs2013$sex)
tscs2013$sex <- set_label(tscs2013$sex, label="sex")  # 重設變數標籤
tscs2013$sex <- set_labels(tscs2013$sex, labels= c("female", "male")) #重設選項標籤
sjp.grpfrq(tscs2013$v65r, tscs2013$sex)  # 橫向比較
sjp.grpfrq(tscs2013$v65r, tscs2013$sex, bar.pos = "stack")  # 堆疊

# 方法二：sjp.xtab()
sjt.xtab(tscs2013$v65r, tscs2013$sex) #製表
sjp.xtab(tscs2013$v65r, tscs2013$sex) #製圖

## 補充盒子：用`ggplot2`畫長條圖
library(ggplot2)
load("../wgcoll.rda")
ggplot(data=wgc, aes(x=factor(c), 
                     fill=factor(g))) + 
  geom_bar(width=.6, position="dodge")  