### 《民意調查資料分析的R實戰手冊》
### 劉正山著．2018五南出版
### 8.3 電訪資料分析實作_ID2015_假設檢證

## 研究問題:
# 我們接續使用8.2的資料檔來試答這些研究問題：
# 1. 維持現狀的「中間」民眾基本圖像為何？
# 2. 選擇「維持現狀」的原因是自身政黨認同的弱化、對國家與民族認同的混亂、對於中國大陸彼長我消的徬徨，還是有其他因素？
# 3. 維持現狀偏好是跨越藍綠的現象，還是有世代差異？

## 研究目的：
# 1. 解讀「維持現狀」民眾的圖像
# 2. 檢視國號認同如何受政黨認同及民族認同影響

## 第一步：讀入資料
load("../id15.rda")  

## 第二步：檢視結構
names(id15)  # 包含了上一節所新創的變數
str(id15, list.len=5) # 列出前五個變數

## 第三步：新增變數與編碼
# 維持現狀(V27)
# 27、請問，以台灣和大陸的關係來講，您比較贊成統一、獨立，或是維持現狀？
# 【若答維持現狀，則追問選項(02)~(05)】
# (01)獨立   (02)維持現狀，以後獨立   (03)維持現狀，看情形再說   (04)永遠維持現狀 (05)維持現狀，以後統一   (06)統一   (98)不知道/無意見/未回答
library(sjPlot)
library(sjmisc)
frq(id15$V27, weights = id15$WEIGHT)
table(id15$V27, exclude = NULL)
id15$stq <- rec(id15$V27, rec ="1,2,5,6=0; 3,4=1", 
                as.num = F, 
                val.labels = c("否", "是"),
                var.label = "維持現狀")
id15$stq <- as.factor(id15$stq)
frq(id15$stq)

# 改變國號 (V23)
# 23、請問，您希不希望「中華民國」有一天改名叫作「台灣」？
# (01)希望   (02)不希望   (98)不知道/無意見/未回答
library(sjmisc)
library(sjlabelled)
frq(id15$V23)
id15$changeROC <- set_label(as.factor(id15$V23), "改變國號")
id15$changeROC <- rec(id15$changeROC, rec="1=1; 2=0; 98=NA", 
                      val.labels = c("不希望","希望"),
                      as.num = F)
frq(id15$changeROC)

# 國名認同(V17 & V18)
library(sjlabelled)
library(sjmisc)
# 17、請問，您希不希望我們國家永遠都叫做「中華民國」？
# (01)希望   (00)不希望
## 原始資料（加權後）：
table(id15$V17r, exclude=NULL)
frq(id15$V17r, weights = id15$WEIGHT)
id15$idROC <- rec(id15$V17r, rec = "1=1; 0=0", as.num = F, 
                  val.labels = c("不希望","希望"))
id15$idROC <- set_label(id15$idROC, "國名中華民國")
frq(id15$idROC)

# 18、請問，您希不希望我們國家的正式名稱就叫做「台灣」？
# (01)希望   (02)不希望   (98)不知道/無意見/未回答
## 原始資料（加權後）：
frq(id15$V18r, weights = id15$WEIGHT)
id15$idTW <- rec(id15$V18r, rec = "1=1; 0=0", 
                 as.num = F, val.labels = c("不希望","希望"))
id15$idTW <- set_label(id15$idTW, "國名台灣")
frq(id15$idTW)

# 雙重國名認同
id15$idROCTW <- as.factor(ifelse(id15$idROC==1 & id15$idTW==1, 1, 0))
id15$idROCTW <- set_label(id15$idROCTW, "雙重國名認同")
id15$idROCTW <- set_labels(id15$idROCTW, labels=c("否","是"))
frq(id15$idROCTW)

# 民族/族群認同 (V32)
# 32、請問，我們社會上有人說自己是「台灣人」，也有人說自己是「中國人」，也有人說都是。您認為自己是「台灣人」、「中國人」，或者兩種都是？
# (01)台灣人   (02)中國人   (03)是台灣人也是中國人 (98)不知道/無意見/未回答
id15$twnese <- rec(id15$V32, rec = "1=1; else=0", 
                   as.num = F, var.label = "台灣人認同者")
frq(id15$twnese)
id15$cnese <- rec(id15$V32, rec = "2=1; else=0", 
                  as.num = F, var.label = "中國人認同者")
frq(id15$cnese)
id15$bothtwcn <- rec(id15$V32, rec = "3=1; else=0", 
                     as.num = F, var.label = "雙重民族認同者")
frq(id15$bothtwcn)

# 政黨認同 (V15)
library(sjmisc)
library(sjPlot)
# 4、在我們的社會裡，大部份的人對政治都有自己的看法。請問，一般來講，您覺得在目前的政黨當中，哪一個黨的主張，比較接近您自己的看法 
# (01)國民黨    (02)親民黨    (03)傾泛藍    (04)民進黨    (05)台聯    (06)傾泛綠 (07)中立/不一定/看人不看黨
frq(id15$V4)
id15$camps <- rec(id15$V4, rec = "1:3=1; 4:6=2; else=0", 
                  as.num = F, var.label = "藍(1)綠(2)陣營")
frq(id15$camps)

id15$indpt <- rec(id15$V4, rec = "7=1; else=0", 
                  as.num = F, var.label = "自稱無政黨認同者", 
                  val.labels = c("否","是"))
frq(id15$indpt)

id15$blue <- rec(id15$V4, rec = "1:3=1; else=0", 
                 as.num = F, 
                 var.label = "泛藍認同者", val.labels = c("否","是"))
frq(id15$blue)

id15$green <- rec(id15$V4, rec = "4:6=1; else=0", 
                  as.num = F, 
                  var.label = "泛綠認同者", 
                  val.labels = c("否","是"))
frq(id15$green)

## 第四步：資料存檔
save(id15, file="id15.rda") #另存到目前的專案夾內，不去覆蓋原始檔

## 第五步：視覺化核心變數之間的關係
load("id15.rda")   # 從目前的專案夾內讀取含增變數的檔案

#（1）用sjPlot套件製類別變數關聯圖  
library(sjPlot)
tab_xtab(id15$indpt, id15$stq, 
         show.obs = T, 
         show.row.prc = T, 
         show.col.prc = T, 
         remove.spaces = T)  

#（2）用VCD套件製類別變數關聯圖  
library(vcd)
cotabplot(~ id15$changeROC + id15$twnese + id15$indpt, shade=TRUE) 
cotabplot(~ id15$stq + id15$twnese, 
          shade=TRUE, compress=FALSE, alternate=F)

## 第六步： 檢視政黨認同及民族認同對國號認同的影響
# (1) 模型一：改變國號模型  
# 假設一：無政黨傾向且認同中華民國國號者將不希望改變國號現狀；  
# 假設二：無政黨傾向且希望國號為台灣者希望改變國號現狀；  
# 假設三：無政黨傾向且自認為台灣人者希望改變國號現狀。

mod.1 <- glm(changeROC ~ idROC + idTW + indpt + green + 
               twnese + indpt:idROC + indpt:idTW + indpt:twnese, 
             data = id15, family = binomial())
summary(mod.1)
library(car)
vif(mod.1)

library(sjPlot)
plot_model(mod.1, type="est", auto.label = F)  # 迴歸係數圖

# (2) 模型二：維持現狀模型
# 假設四：無政黨傾向且認同中華民國國號者將希望兩岸維持現狀；
# 假設五：無政黨傾向且希望國號為台灣者不希望兩岸維持現狀；
# 假設六：無政黨傾向且自認為台灣人者不希望兩岸維持現狀。

library(sjPlot)
mod.2 <- glm(stq ~ idROC + idTW + indpt + green 
             + twnese + indpt:idROC 
             + indpt:idTW + indpt:twnese,
             data = id15, family = binomial)
summary(mod.2)

# 加入其他控制變數
mod.2.1 <- update(mod.2, . ~ . 
                  + V26 # 擔心美國放棄台灣
                  + V1 #性別 （女性較傾向維持現狀）
                  )
summary(mod.2.1)

## 第七步：為迴歸分析結果製表
ivlabels.mod.2 <- c("Intercept",
                    "希望國號中華民國", 
                    "希望國號為台灣", 
                    "無政黨傾向", 
                    "泛綠陣營",
                    "台灣人（非中國人亦非「都是」）",
                    "無政黨傾向*國號中華民國", 
                    "無政黨傾向*國號台灣", 
                    "無政黨傾向*台灣人")

tab_model(mod.1, mod.2, 
          show.aic=TRUE,
          show.loglik=TRUE,
          show.ci=FALSE,
          show.se=TRUE,
          show.r2=TRUE,
          show.intercept=T, 
          digits.p=2,
          digits=3,
          transform = exp, # 顯示勝算值odd ratio（此為預設值）；NULL則會顯示原始迴歸系數
          CSS=list(css.topborder="border-top:1px solid black;"),
          use.viewer=T,
          string.est="勝算",
          string.se="標準誤",
          dv.labels = c("改變國號", "維持現狀"),
          pred.labels = ivlabels.mod.2,
          file="mod.1_and_mod.2.html")

## 三、其他影響維持現狀及統獨選擇的因素: 世代與地區
# 維持現狀是否也是個valience issue? 
# 探討政治世代之間對維持現狀及國號認同的差異
library(sjmisc)
library(sjlabelled)
id15$generation <- set_label(id15$generation, "世代")
id15$generation <- set_labels(id15$generation, 
                              labels= 
                                c("第一世代(>=84)","第二世代(62~83)",
                                  "第三世代(47~61)","第四世代(37~46)",
                                  "第五世代(27~36)","第六世代(<=26)"))
frq(id15$generation)

id15$gen.1 <- set_label(id15$gen.1, "第一世代(>=84)")
id15$gen.2 <- set_label(id15$gen.2, "第二世代(62~83)")
id15$gen.3 <- set_label(id15$gen.3, "第三世代(47~61)")
id15$gen.4 <- set_label(id15$gen.4, "第四世代(37~46)")
id15$gen.5 <- set_label(id15$gen.5, "第五世代(27~36)")
id15$gen.6 <- set_label(id15$gen.6, "第六世代(<=26)")
frq(id15$gen.3)
