### 《民意調查資料分析的R實戰手冊》
### 劉正山著．2018五南出版
### 8.1 面訪調查資料分析實作_TSCS2013

## 第一階段：理論、模型與假設的準備  
# 第一步: 理論與模型的設定 
# 這是整個研究中最重要的一步，展現了你作為研究者的主體性。
# 
# - 理論：「維持現狀」的選擇會受到自身認同及對外在環境評估（戰爭、經濟發展）的影響。
# - 假設1：台灣人認同會影響一個人選擇不要維持現狀。
# - 假設2：預期戰爭會影響一個人選擇維持現狀。
# - 假設3：在乎經濟發展會影響一個人選擇維持現狀。    
# - 依變數：（兩岸關係）維持現狀。  
# - 自變數：台灣人認同、戰爭預期、經濟決擇。

# 第二步: 認識你的資料來源
# - 台灣社會變遷基本調查計畫2013第六期第四次：國家認同組  
# - 計畫主持人：傅仰止,章英華,杜素豪,廖培珊  
# - 計畫執行單位：中央研究院社會學研究所  
# - 經費補助單位：行政院國家科學委員會社會科學研究中心  
# - 調查執行期間：2013.09.22-2013.12.10  
# - 原始檔名：tscs2013q2.sav 
# - 有效觀察值（N）=1,952

## 第二階段：資料的準備
# 第一步：讀入原始資料並轉為rda檔
library(sjlabelled)
tscs2013q2 <- read_spss("../tscs2013q2.sav") 
str(tscs2013q2) # 看看資料的結構

nrow(tscs2013q2) # 確定是1952個觀察值

# 看看有那些變數，以及這些變數的名稱
names(tscs2013q2)

# 將這個原始資料轉存為R專屬的rda格式
save(tscs2013q2, file = "../tscs2013q2.rda", compress = T)

# 第二步：使用sjmisc::set_na()清理整個資料檔中的無效值
library(sjmisc)
tscs2013r <- set_na(tscs2013q2, na=c(92:99, "NA"))  
save(tscs2013r, file="../tscs2013r.rda")
rm(list=ls())

# 第三步：使用sjmisc::rec()做變數編碼
load("../tscs2013r.rda")
library(sjPlot)
library(sjmisc)

# 1、性別：
# (01)男      (02)女
frq(tscs2013r$v1)
tscs2013r$sex <- rec(tscs2013r$v1, as.num = F, rec="1=1; 2=0", 
                     val.labels = c("女","男"))
frq(tscs2013r$sex, weights = tscs2013r$wr)

# 2. 出生的民國年是v2y，age=(102-tscs2013r$v2y)
tscs2013r$age <- 102 - as.numeric(tscs2013r$v2y)
<<<<<<< HEAD
plot_frq(tscs2013r$age, type = "density")

=======
plot_frq(tscs2013r$age, type = "density") #原來的sjp.req()已被更新為plot_frq()
>>>>>>> c6f953821a0d31086e212f0d8ff8dea3840d9ea9

#hist(tscs2013r$age)
tscs2013r$generation <- NA
tscs2013r$generation[tscs2013r$age>=(2013-1931)] <- 1
tscs2013r$generation[tscs2013r$age<=(2013-1932) & tscs2013r$age>=(2013-1953)] <- 2
tscs2013r$generation[tscs2013r$age<=(2013-1954) & tscs2013r$age>=(2013-1968)] <- 3
tscs2013r$generation[tscs2013r$age<=(2013-1969) & tscs2013r$age>=(2013-1978)] <- 4
tscs2013r$generation[tscs2013r$age<=(2013-1979) & tscs2013r$age>=(2013-1988)] <- 5
tscs2013r$generation[tscs2013r$age<=(2013-1989)] <- 6  

table(tscs2013r$generation) #no one in this sameple is less than 24 
#   1   2   3   4   5 
# 171 674 529 361 217 

tscs2013r$gen.1 <- as.factor(ifelse(tscs2013r$generation==1,1,0))
tscs2013r$gen.2 <- as.factor(ifelse(tscs2013r$generation==2,1,0))
tscs2013r$gen.3 <- as.factor(ifelse(tscs2013r$generation==3,1,0))
tscs2013r$gen.4 <- as.factor(ifelse(tscs2013r$generation==4,1,0))
tscs2013r$gen.5 <- as.factor(ifelse(tscs2013r$generation==5,1,0))
tscs2013r$gen.6 <- as.factor(ifelse(tscs2013r$generation==6,1,0))

# 13.請問您覺得自己是哪裡人？
# (01)台灣閩南人 (02)台灣客家人 (03)台灣原住民
# (04)大陸各省市人 (05)台灣的外省人(06)金門、馬祖人
# (07)東南亞（國家）的人(08)其他，請說明：____________
table(tscs2013r$v13)
tscs2013r$v13r <- rec(tscs2013r$v13, rec="97:98=NA; else=copy", as.num = F, 
                     var.label = "v13族群",  
                     val.labels = c("台灣閩南人", "台灣客家人", "台灣原住民","大陸各省市人",
                                    "台灣外省人","金門馬祖人", "東南亞國家人", "其他"))
str(tscs2013r$v13r)

# 15.如果有人問您的祖國是哪裡，請問您會怎麼回答？（訪員請唸選項）
# (01)台灣(02)中華民國 (03)中國(04)中華人民共和國
# (05)其他，請說明：____________
table(tscs2013r$v15)
tscs2013r$v15r <- rec(tscs2013r$v15, rec="3:5=3; 95:98=NA; else=copy", as.num = F, 
                     var.label = "v15祖國",  
                     val.labels = c("台灣", "中華民國", "中國/中華人民共和國/其他"))
str(tscs2013r$v15r)

# 21. 請問您的教育程度是：
# (01)無/不識字（跳答23） (02)自修/識字/私塾（跳答23） (03)小學
# (04)國(初)中(05)初職(06)高中普通科
# (07)高中職業科(08)高職(09)士官學校
# (10)五專(11)二專(12)三專
# (13)軍警校專修班(14)軍警校專科班(15)空中行專/商專
# (16)空中大學(17)軍警官校或大學(18)技術學院、科大
# (19)大學(20)碩士(21)博士
# (22)其他，請說明：____________
table(tscs2013r$v21)
tscs2013r$college <- rec(tscs2013r$v21, rec="10:21=1; else=0", as.num = F) #大專（含）以上學歷

# 31.如果要成為我們真正的同胞，有人認為下列條件重要，也有人認為不重要。請問您覺得它們重不重要？（提示卡4）(ISSP Q2)
# 非常重要 有點重要 不怎麼重要 一點也不重要 無法決定(NA)
# (a)在我國出生 (01) (02) (03) (04) (05)
# (b)有我國的國籍 (01) (02) (03) (04) (05)
# (c)一生中大部分時間都居住在我國(01) (02) (03) (04) (05)
# (d)會說國語（中文） (01) (02) (03) (04) (05)
# (e)有沒有拜拜(01) (02) (03) (04) (05)
# (f)尊重我國的政治體制和法律(01) (02) (03) (04) (05)
# (g)在感情上認同我們的國家(01) (02) (03) (04) (05)
# (h)祖先都是本國人(01) (02) (03) (04) (05)
with(tscs2013r, frq(v31a, weights = wr))
with(tscs2013r, table(v31a))
tscs2013r$v31ar <- rec(tscs2013r$v31a, rec="1,2=1; 3:5=0; 93:98=NA", as.num = F)
tscs2013r$v31br <- rec(tscs2013r$v31b, rec="1,2=1; 3:5=0; 93:98=NA", as.num = F)
tscs2013r$v31cr <- rec(tscs2013r$v31c, rec="1,2=1; 3:5=0; 93:98=NA", as.num = F)
tscs2013r$v31dr <- rec(tscs2013r$v31d, rec="1,2=1; 3:5=0; 93:98=NA", as.num = F)
tscs2013r$v31er <- rec(tscs2013r$v31e, rec="1,2=1; 3:5=0; 93:98=NA", as.num = F)
tscs2013r$v31fr <- rec(tscs2013r$v31f, rec="1,2=1; 3:5=0; 93:98=NA", as.num = F)
tscs2013r$v31gr <- rec(tscs2013r$v31g, rec="1,2=1; 3:5=0; 93:98=NA", as.num = F)
tscs2013r$v31hr <- rec(tscs2013r$v31h, rec="1,2=1; 3:5=0; 93:98=NA", as.num = F)
with(tscs2013r, table(v31ar))

# 36.有人說我國的國民教育，須要強調（台語：加強）中華文化的教育，請問您同不同意？
# (01)非常同意 (02)同意 (03)不同意 (04)非常不同意
table(tscs2013r$v36)
tscs2013r$v36r <- rec(tscs2013r$v36, rec="1,2=1; 3,4=0; 
                      93:98=NA", as.num = F)

# 37.有人說我國的國民教育，須要強調（台語：加強）台灣本土文化的教育，請問您同不同意？
# (01)非常同意 (02)同意 (03)不同意 (04)非常不同意
tscs2013r$v37r <- rec(tscs2013r$v37, rec="1,2=1; 3,4=0; 93:98=NA", as.num = F)

# 44.有人認為，台灣的外來移民越多，越不利於國內社會的團結。請問您同不同意這樣的說法？
# (01)非常同意 (02)同意 (03)不同意 (04)非常不同意
table(tscs2013r$v44)
tscs2013r$v44r <- rec(tscs2013r$v44, rec="1,2=1; 3:4=0; 
                      93:98=NA", as.num = F)

# 45.對於移民來台灣的人，請問下面哪個想法是最符合您的看法？(ISSP Q11)
# (01)移民應該保留他們原來的文化，不要採用我國的文化
# (02)移民應該保留他們原來的文化，同時採用我國的文化
# (03)移民應該放棄他們原來的文化，轉而接受我國的文化
table(tscs2013r$v45)
tscs2013r$v45r <- rec(tscs2013r$v45, rec="93:98=NA; else=copy", as.num = F)
table(tscs2013r$v45r)

# 54.請問您覺得下列這些歷史事件是不是很重要，要讓下一代永遠記得？
# 非常重要 重要 不重要 非常不重要 沒聽說過
# (a)二二八事件(01) (02) (03) (04) (05)
# (b)美麗島事件、黨外民主運動(01) (02) (03) (04) (05)
# (c)推翻滿清，建立中華民國(01) (02) (03) (04) (05)
# (d)八年對日抗戰勝利(01) (02) (03) (04) (05)
table(tscs2013r$v54d)
tscs2013r$v54ar <- rec(tscs2013r$v54a, rec="1,2=1; 3,4=0; 
                       93:98=NA", as.num = F)
tscs2013r$v54br <- rec(tscs2013r$v54b, rec="1,2=1; 3,4=0; 
                       93:98=NA", as.num = F)
tscs2013r$v54cr <- rec(tscs2013r$v54c, rec="1,2=1; 3,4=0; 
                       93:98=NA", as.num = F)
tscs2013r$v54dr <- rec(tscs2013r$v54d, rec="1,2=1; 3,4=0; 
                       93:98=NA", as.num = F)

# 56.有人說，台灣人在歷史上都被外來的人欺負。請問您同意不同意這種說法？
# (01)非常同意 (02)同意 (03)不同意 (04)非常不同意
table(tscs2013r$v56)
tscs2013r$v56r <- rec(tscs2013r$v56, rec="1,2=1; 94:98=NA; 
                      3:4=0", as.num = F)

# 57.目前社會上有人會說自己是台灣人，有人會說自己是中國人，也有人會說兩者都是。請問您認為自己是台灣人、中國人還是兩者都是？
# (01)台灣人 (02)中國人 (03)兩者都是 (04)兩者都不是，請說明：____________
table(tscs2013r$kv57_0)
tscs2013r$v57[tscs2013r$kv57_0=="台灣的中國人"] <- 2
table(tscs2013r$v57)
tscs2013r$v57r <- rec(tscs2013r$v57, rec="94:98=NA; else=copy", as.num = F) 
tscs2013r$twnese <- rec(tscs2013r$v57r, rec="1=1; else=0", as.num = F) 


# 58.請您用0 至10 分來表示您自認為是台灣人的程度，10 分表示「完全是台灣人」，0 分表示「完全不是台灣人」。請問您會選幾分？
table(tscs2013r$v58)
tscs2013r$v58r <- as.numeric(rec(tscs2013r$v58, rec="95:98=NA; 
                                 else=copy", as.num = T))
table(tscs2013r$v58r)

# 59.請您用0 至10 分來表示您自認為是中國人的程度，10 分表示「完全是中國人」，0 分表示「完全不是中國人」。請問您會選幾分？
table(tscs2013r$v59)
tscs2013r$v59r <- as.numeric(rec(tscs2013r$v59, rec="95:98=NA; 
                                 else=copy", as.num = T))
table(tscs2013r$v59r)

# 60.請問您認為這種台灣人或是中國人的認同問題重不重要？
# (01)非常重要 (02)重要 (03)不重要 (04)非常不重要
table(tscs2013r$v60)
tscs2013r$v60r <- rec(tscs2013r$v60, rec="1,2=1; 93:98=NA; 
                      3:4=0", as.num = F)
table(tscs2013r$v60r)

# 61.對於未來台灣與中國大陸的關係，有人主張台灣獨立，也有人主張與大陸統一。請問您比較贊成哪一種主張？
# (01)儘快宣布獨立 (02)維持現狀，以後走向獨立 (03)永遠維持現狀
# (04)維持現狀，以後走向統一 (05)儘快與中國大陸統一
table(tscs2013r$v61)
tscs2013r$v61r <- rec(tscs2013r$v61, rec="93:98=NA; 
                      else=copy", as.num = F)
table(tscs2013r$v61r)

# 64.請問您認為您和您的配偶（或同居伴侶）對於統一和獨立的看法一不一樣？
# (01)完全一樣 (02)差不多一樣 (03)不太一樣 (04)完全不一樣
table(tscs2013r$v64)
tscs2013r$v64r <- rec(tscs2013r$v64, rec="1,2=1; 
                      95:98=NA; 3:4=0", as.num = F)# 一樣／同質＝１
table(tscs2013r$v64r) 

# 65.關於統獨問題，現在社會上有各種不同的想法。請問您覺得這種情形對社會的影響嚴不嚴重？
# (01)非常嚴重 (02)嚴重 (03)不嚴重 (04)非常不嚴重
table(tscs2013r$v65)
tscs2013r$v65r <- rec(tscs2013r$v65, rec="1,2=1; 94:98=NA; 3:4=0", as.num = F)
table(tscs2013r$v65r) 

# 66.如果台灣宣布獨立，請問您認為兩岸會不會發生戰爭？
# (01)一定會 (02)可能會 (03)可能不會 (04)一定不會
table(tscs2013r$v66)
tscs2013r$v66r <- rec(tscs2013r$v66, rec="1,2=1; 94:98=NA; 3:4=0", as.num = F)
table(tscs2013r$v66r) 

# 67.有人認為，如果台灣獨立不會引起戰爭，就應該宣佈獨立。請問您同不同意？
# (01)非常同意 (02)同意 (03)不同意（跳答69） (04)非常不同意（跳答69）
table(tscs2013r$v67)
tscs2013r$v67r <- rec(tscs2013r$v67, rec="1,2=1; 93:98=NA; 3:4=0", as.num = F)
table(tscs2013r$v67r) 

# 69.有人認為，如果大陸在經濟、社會、政治方面的發展跟台灣差不多，兩岸就應該統一。請問您同不同意？
# (01)非常同意 (02)同意 (03)不同意（跳答71） (04)非常不同意（跳答71）
table(tscs2013r$v69)
tscs2013r$v69r <- rec(tscs2013r$v69, rec="1,2=1; 93:98=NA; 3:4=0", as.num = F)
table(tscs2013r$v69r) 

# 71.請問您認為中華民族包不包括：
# 包括 不包括 看情形
# (a)台灣的原住民(01) (02) (03)
# (b)中國大陸的西藏人(01) (02) (03)
# (c)台灣的東南亞外籍配偶(01) (02) (03)
# (d)現在居住在國外的僑民（不一定有我國國籍） (01) (02) (03)
# (e)台灣兩千三百萬人(01) (02) (03)
# (f)中國大陸人民(01) (02) (03)
# (g)港澳的居民(01) (02) (03)
## this can be a good measurement for Pan-Nationalism! 
table(tscs2013r$v71a)
tscs2013r$v71ar <- rec(tscs2013r$v71a, rec="1=1; 2=0; 3:98=NA", as.num = F)
table(tscs2013r$v71ar) 
tscs2013r$v71ar <- rec(tscs2013r$v71a, rec="1=1; 2=0; 3:98=NA", as.num = F)
tscs2013r$v71br <- rec(tscs2013r$v71b, rec="1=1; 2=0; 3:98=NA", as.num = F)
tscs2013r$v71cr <- rec(tscs2013r$v71c, rec="1=1; 2=0; 3:98=NA", as.num = F)
tscs2013r$v71dr <- rec(tscs2013r$v71d, rec="1=1; 2=0; 3:98=NA", as.num = F)
tscs2013r$v71er <- rec(tscs2013r$v71e, rec="1=1; 2=0; 3:98=NA", as.num = F)
tscs2013r$v71fr <- rec(tscs2013r$v71f, rec="1=1; 2=0; 3:98=NA", as.num = F)
tscs2013r$v71gr <- rec(tscs2013r$v71g, rec="1=1; 2=0; 3:98=NA", as.num = F)

# 72.有人說，為了台灣的經濟發展，必要時可以和中國大陸統一，請問您同不同意這種說法？
# (01)非常同意 (02)同意 (03)既不同意也不反對
# (04)不同意 (05)非常不同意 (06)無法決定
table(tscs2013r$v72)
tscs2013r$v72r <- rec(tscs2013r$v72, rec="1,2=1; 3:6=0; 
                      93:98=NA", as.num = F)
table(tscs2013r$v72r) 

# 75.請問您認為，我們國家的土地範圍應該包括哪些地方？
# (01)台灣 (02)台灣、澎湖 (03)台灣、澎湖、金門、馬祖
# (04)台灣、澎湖、金門、馬祖、港澳 (05)台灣、澎湖、金門、馬祖、港澳、中國大陸
table(tscs2013r$v75)
tscs2013r$v75r <- rec(tscs2013r$v75, rec="5=1; 94:98=NA; 
                      else=0", as.num = F) #領域包含中國大陸
table(tscs2013r$v75r) 

# 76.請問您覺得我們的國家現在應該叫什麼名字比較合乎您的看法？
# (01)中華民國 (02)中華民國在台灣 (03)台灣
# (04)台灣共和國 (05)中國台灣 (06)中華人民共和國
# (07)其他，請說明：____________
table(tscs2013r$v76)
tscs2013r$v76r <- rec(tscs2013r$v76, rec="5:7=5; 93:98=NA; 
                      else=copy", as.num = F)
table(tscs2013r$v76r) 

# 83.以下我們想請教您兩岸的經濟交流問題。
# (a)請問您或您的家人，有沒有人在大陸做生意或工作？ (01)有 (02)沒有
# (b)請問您或您的家人服務的公司，有沒有在大陸設廠（公司、開店）？ (01)有 (02)沒有
# (c)請問大陸的市場對您或您的家人所服務的公司，有沒有很重要？ (01)有 (02)沒有
table(tscs2013r$v83a)
tscs2013r$v83ar <- rec(tscs2013r$v83a, rec="1=1; 2=0; 94:98=NA", as.num = F)
table(tscs2013r$v83ar) 
tscs2013r$v83ar <- rec(tscs2013r$v83a, rec="1=1; 2=0; 94:98=NA", as.num = F)
tscs2013r$v83br <- rec(tscs2013r$v83b, rec="1=1; 2=0; 94:98=NA", as.num = F)
tscs2013r$v83cr <- rec(tscs2013r$v83c, rec="1=1; 2=0; 94:98=NA", as.num = F)

# 84a.請問您去過中國大陸（不含港澳）嗎？一共去了幾次？
# (01)1-3 次 (02)4-6 次 (03)7-9 次
# (04)10-19 次 (05)20 次或以上(06)從來沒有去過（跳答85）
table(tscs2013r$v84a)
tscs2013r$v84ar <- rec(tscs2013r$v84a, rec="6=0; 97:98=NA; else=copy", as.num = T)
table(tscs2013r$v84ar) 

# 89.關於台灣社會文化的現象，請問您同不同意以下各種說法或想法？
# (01) (02) (03) (04) (05) 非常同意 同意 既不同意也不反對 不同意 非常不同意
# (a)中華民族本來就包含很多族群，不應該分離
# (b)面對外來勢力時，台灣人應該有「自己當家作主」的自覺與決心
# (c)現在的台灣文化已經不能再說是中國文化的一部分
# (d)台灣是個小而美的國度，未來也都會繼續維持下去
# (e)台灣人的祖先就是黃帝，我們要繼承這樣的血統與歷史
# (f)在台灣長久居住或成長的人們應該一起發展出自己的新民族
# (g)台灣人很優秀，各行各業都有人才在世界上有很成功的表現
# (h)作為華夏子孫，我們在國際上應該盡力將中華文化發揚光大
# (i)不管台灣發生任何問題，我都一定會挺它到底，絕對不會想要移民到國外
table(tscs2013r$v89a)
tscs2013r$v89ar <- rec(tscs2013r$v89a, rec="1,2=1; 3:5=0; 93:98=NA", as.num = F)
table(tscs2013r$v89ar)

tscs2013r$v89br <- rec(tscs2013r$v89b, rec="1,2=1; 3:5=0; 
                       93:98=NA", as.num = F)
tscs2013r$v89cr <- rec(tscs2013r$v89c, rec="1,2=1; 3:5=0; 
                       93:98=NA", as.num = F)
tscs2013r$v89dr <- rec(tscs2013r$v89d, rec="1,2=1; 3:5=0; 93:98=NA", as.num = F)
tscs2013r$v89er <- rec(tscs2013r$v89e, rec="1,2=1; 3:5=0; 
                       93:98=NA", as.num = F)
tscs2013r$v89fr <- rec(tscs2013r$v89f, rec="1,2=1; 3:5=0; 
                       93:98=NA", as.num = F)
tscs2013r$v89gr <- rec(tscs2013r$v89g, rec="1,2=1; 3:5=0; 
                       93:98=NA", as.num = F)
tscs2013r$v89hr <- rec(tscs2013r$v89h, rec="1,2=1; 3:5=0; 
                       93:98=NA", as.num = F)
tscs2013r$v89ir <- rec(tscs2013r$v89i, rec="1,2=1; 3:5=0; 
                       93:98=NA", as.num = F)

# 91.為了和中國大陸進行經濟來往，請問您同不同意台灣接受「世界上只有一個中國，台灣是中國的一部分」的原則？
# (01)非常同意(02)同意(03)不同意 (04)非常不同意
table(tscs2013r$v91)
tscs2013r$v91r <- rec(tscs2013r$v91, rec="1,2=1; 3,4=0; 93:98=NA", as.num = F)
table(tscs2013r$v91r)

# 92.去年一月的總統選舉，請問您有沒有去投票？投給誰？
# (01)有，馬英九(02)有，蔡英文
# (03)有，宋楚瑜(04)有，投廢票
# (05)有，但不願意回答或忘記投給誰(06)有，但拒領總統選舉票
# (07)沒有去投票（跳答95） (08)當時年滿20 歲但沒有總統投票權
# (09)當時未滿20 歲（跳答95）
table(tscs2013r$v92)
tscs2013r$v92r <- rec(tscs2013r$v92, rec="1,2=1; 3,4=0; 93:98=NA", as.num = F)
table(tscs2013r$v92r)

# 95.國內的政黨都有它們的支持者，請問您是哪一個政黨的支持者？
# （回答 01～07 者跳答97）
# (01)國民黨 (02)民進黨 (03)親民黨 (04)台聯
# (05)新黨 (06)建國黨 (07)其他政黨，請說明：____________
# (08)泛藍（續答96） (09)泛綠（續答96） (10)有支持政黨，不願意回答（續答96）
# (11)都沒有∕都支持（續答96）
table(tscs2013r$v95)
tscs2013r$blue <- rec(tscs2013r$v95, rec="1,3,5,8=1; else=0; 96:99=NA", as.num = F)
tscs2013r$green <- rec(tscs2013r$v95, rec="2,4,6,9=1; else=0; 96:99=NA", as.num = F)
tscs2013r$camp <- rec(tscs2013r$v95, rec="1,3,5,8=1; 2,4,6,9=2; 7,10,11=3; 96:99=NA", as.num = F) # 1=藍；２＝綠；３＝中間／不表態/其他
table(tscs2013r$camp)

# 96.一般而言，請問您會比較偏向哪一個政黨？
# (01)國民黨 (02)民進黨 (03)親民黨 (04)台聯
# (05)新黨 (06)建國黨 (07)其他政黨，請說明：____________
# (08)泛藍 (09)泛綠 (10)有偏向政黨，不願意回答
# (11)都沒有∕都支持

## 用三種方法，創造統獨立場的三個變數，每一個變數用不用的方法編碼
# 61.對於未來台灣與中國大陸的關係，有人主張台灣獨立，也有人主張與大陸統一。請問您比較贊成哪一種主張？(01)儘快宣布獨立 (02)維持現狀，以後走向獨立 (03)永遠維持現狀 (04)維持現狀，以後走向統一 (05)儘快與中國大陸統一
# load(tscs2013r.rda)

# (1) 用sjmisc::rec()編碼：「選１, 2的編為獨立」（indpt） 
library(sjmisc)
tscs2013r$indpt <- rec(tscs2013r$v61, rec="1,2=1; 3:5=0", as.num = F)
table(tscs2013r$indpt)

# (2) 用ifelse編碼：「選4,5的編為統一」（unif)  
tscs2013r$unif <- ifelse(tscs2013r$v61==4, 1, ifelse(tscs2013r$v61==5,1,0))
table(tscs2013r$unif)

# (3) 用list[]編碼：「選３的編為維持現狀」（stsq）
tscs2013r$stsq  <- 0
tscs2013r$stsq[tscs2013r$v61==3] <- 1
table(tscs2013r$stsq)

# 第四步：再次將加入編碼後變數的檔案存為rda檔
save(tscs2013r, file = "../tscs2013r.rda", compress = T) 


## 第三階段：資料分析
# 第一步：把資料「接上」模型
# 依變數：（兩岸關係）維持現狀 (stsq)
# 自變數：民族認同(twnese)、戰爭預期(v66r)、經濟決擇(v72r)

# 第二步：（重新）讀入編碼後的資料
rm(list=ls()) # 清空所有暫存區的物件
load("../tscs2013r.rda")
names(tscs2013r)

#### 請再看一眼自己的假設，想清楚：
# 你是不是真的相信，你的預期會得到資料的支持呢？  
# 假設1：台灣人認同會影響一個人選擇不要維持現狀。  
# 假設2：預期戰爭會影響一個人選擇維持現狀。  
# 假設3：在乎經濟發展會影響一個人選擇維持現狀。

# 第三步：執行假設檢定  
load("../tscs2013r.rda")
mod.1 <- glm(stsq ~ twnese + v66r + v72r,
             data = tscs2013r, family = binomial)
summary(mod.1)

mod.2 <- glm(unif ~ twnese + v66r + v72r,
             data = tscs2013r, family = binomial)
summary(mod.2)

# 第四步：進行共線性檢定   
library(car)
vif(mod.1)

# 關於虛擬變數的處理
tscs2013r$v76r <- relevel(factor(tscs2013r$v76r), ref="1")  # 把對照組設為「中華民國」(1)
mod.2 <- update(mod.1, .~. + v76r)
summary(mod.2)

# 第五步：將結果視覺化
library(sjPlot)
plot_model(mod.1, axis.labels = "")  

## 第四階段：解讀與解釋
# 請在練習的R檔下方，寫下你對這個結果的解讀，再用滑鼠選取整段文字，按下「Ctrl/Command+Shift+C」轉為註解文字。建議寫下你對以下兩個問題的回答：  
# 1. 那些假設得到資料的支持？  
# 2. 對於沒有到得支持的假設，我有什麼合理（自圓其說）的解釋？是資料的問題、測量的問題，還是當初想錯了？

# 發佈結果
# 最後，到選單點選 「File」 -> 「Knit Document」或按下筆記本按鈕，Rstudio會將R檔（含語法、結果及註解）自動轉為可供分享的html檔。 
