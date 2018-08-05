# R4surveyresearch

## 歡迎  
《民意調查資料分析的R實戰手冊》於2018年8月由五南出版。[點我購書。](http://www.wunan.com.tw/bookdetail.asp?no=13929) 請按此頁右上角的"clone and download"綠色按鈕，更可下載本書最新的語法檔及資料檔。  

## 本書特色  
- 本書主要針對人文社科學子，以及有興趣以R分析民意調查資料的學習者所打造。以多種民意調查進行資料分析實作，包含大型面訪調查資料、電話調查資料及網路調查資料，從資料描述到報表輸出，都能用R輕鬆完成。
- 提供清楚的學習路徑圖，幫助三種學習者快速上手：無論如何都想入門R，卻苦無任何程式訓練背景的學習者、正在不同資料分析工具之間評估R的學習者，以及準備好要用R處理民意調查資料的學生、從業人員或是學者。  
- 提供對應每個章節的R語法檔，讓學習者快速上手實作練習並反覆磨練基本技巧。讀者可以發現這本手冊為您帶來簡單好上手的優秀工具以及在指間即可完成資料分析的成就感。  
- 介紹sjPlot套件家族，教你如何使用這個新的工具更有效率進行資料分析、編碼、製表及製圖。  
- 介紹如何將RStudio當作書寫及成果分享平台。讀者將有機會體會到將語法及分析結果同時嵌進HTML檔案中，或是轉為Word檔與人分享的愉快過程。  
- 介紹「探索式資料分析」的工具。大數據高手將有機會一窺小資料的潛力，而入門的學習者將能感受到這個探索途徑在假設檢證的研究傳統之外所帶來的啟示。  

## 檔案使用注意事項
下載、解壓縮並設定好專案之後，請注意語法檔（.R）中的資料路徑表示方式。"../" 表示的是「相對路徑中的上一層目錄」的意思。詳見3.1.1 (p.42-44)。若執行時仍有讀取資料檔的錯誤訊息，有兩個解決方法：  

- 一是**重新設定好工作路徑**（也就是R可以找到的、該語法檔所在位置）。建議使用這個方法。做法是（1）在右下角檔案總管區，切換到語法案所在資料夾；（2）到Files標籤工具列中按下齒輪（More）圖示，點選"Set as Working Directory"）。  

- 二是_將語法檔中的相對路徑改為絕對路徑_（例如"D:/Document/R語法檔及資料檔/BBQ.csv"）。在Windows中取得檔案所在位置的絕對路徑的做法，是在資料檔上按右鍵-內容，就找到該檔案的路徑。請注意：複製、貼上絕對路徑到語法檔的時候，路徑所使用的是斜線（`/`）而不是反斜線（`\`）。 

## 聯絡  
本書若有任何錯誤，或您有指正、建議，歡迎您聯絡: [lawmen833@gmail.com](lawmen833@gmail.com) 。

## 勘誤及補充
此處為作者持續匯整、更新中的勘誤及補充。  

|章節|頁碼|原文|修改|
|----|----|----|-------|
|4.2.2 | p.81 | `dat<- read_excel("xlssample.xls")` | `dat<- read_excel("../xlssample.xls")` | 
|4.2.2 | p.81 | `dat<- read.xlsx("xlssample.xls")` | `dat<- read.xlsx("../xlssample.xls")` |
|4.3.1 | p.89 |`load("../TNSS2015.rda") str(TNSS2015, list.len=5)`|`library(sjlabelled) TNSS2015 <- read_spss("../TNSS2015.sav", enc="big5") save(TNSS2015,file= "../TNSS2015.rda") str(TNSS2015, list.len=5)` |
|4.3.2 | p.91 | `show.prc=T,` | `show.prc=T, encoding="big5"`|
|4.3.2 | p.91 | `weight.by = TNSS2015$w,` | `weight.by = w,`|
|5.1.3 | p.99 | `sjPlot::sjt.frq()` | `sjmisc::frq()` |
|5.3.1 | p.123 | `describe(tscs2013$age)` | `describe(tscs2013$v65r)`  |
|5.3.1 | p.123 | `descr(tscs2013$age)`  | `descr(tscs2013$v65r)`  |
|5.3.2 | p.132 |`kao06$mediaAtt <- apply(tmp,1,sum)`| 此行新增註解：`等同於 kao06$mediaAtt <- rowSums(tmp)`|
|5.4.1 | p.133 | `kao06$mediaAtt <- row_sums(kao06,tv, radio, internet, newspaper, na.rm=T) table(kao06$mediaAtt)` | `library(dplyr) kao06 <- row_sums(kao06, tv, radio, internet, newspaper, na.rm = T, append = T) table(kao06$rowsums)`| 
|5.4.1 | p.137 |`tmp.nona <- na.omit(tmp)`| 此行之後新增一行註解：` # install.packages("GPArotation")`|
|6.1| p.140 | `sjt.frq(tscs2013$73r)`| `sjt.frq(tscs2013$v73r, encoding="big5")` |
|6.1.1|p.146| `sjt.xtab(tscs2013$v73r,　tscs2013$sex)`|`sjt.xtab(tscs2013$v73r,　tscs2013$sex, encoding="utf8")`|
|7.4| p.242 | | `sjt.glm()` 加入 `p.numeric=F, #切換為以星號表示顯著程度` |
|8.2.2| P.288 | `id15 <- read_spss("../Total.sav", option="foreign", enc = "big5", attach.var.labels = T)` | 簡化為 `id15 <- read_spss("../Total.sav", enc = "big5")` |
|8.5.6 | p.348 | #581 | #629 | 
