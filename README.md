# R4surveyresearch

## 歡迎  
![](http://im2.book.com.tw/image/getImage?i=https://www.books.com.tw/img/001/079/48/0010794831.jpg&v=5b5edaa6&w=348&h=348)  

《民意調查資料分析的R實戰手冊》於2018年8月由五南出版。請按此頁右上角的"Code" 綠色按鈕-> "Download Zip"，下載本書最新的語法檔及資料檔。網路購書處：[天瓏](https://www.tenlong.com.tw/products/9789571196879)、[誠品](http://www.eslite.com/product.aspx?pgid=1001116712698095)、[三民](http://www.sanmin.com.tw/Product/index/006878903)、[博客來](http://www.books.com.tw/products/0010794831)、[墊腳石](http://www.tcsb.com.tw/SalePage/Index/4612965)、[讀冊生活](https://www.taaze.tw/sing.html?pid=11100853002)、[Momo](https://www.thenewslens.com/article/138691)

## 本書特色  
- 本書主要針對人文社科學子，以及有興趣以R分析民意調查資料的學習者所打造。以多種民意調查進行資料分析實作，包含大型面訪調查資料、電話調查資料及網路調查資料，從資料描述到報表輸出，都能用R輕鬆完成。
- 提供清楚的學習路徑圖，幫助三種學習者快速上手：無論如何都想入門R，卻苦無任何程式訓練背景的學習者、正在不同資料分析工具之間評估R的學習者，以及準備好要用R處理民意調查資料的學生、從業人員或是學者。  
- 提供對應每個章節的R語法檔，讓學習者快速上手實作練習並反覆磨練基本技巧。讀者可以發現這本手冊為您帶來簡單好上手的優秀工具以及在指間即可完成資料分析的成就感。  
- 介紹sjPlot套件家族，教你如何使用這個新的工具更有效率進行資料分析、編碼、製表及製圖。  
- 介紹如何將RStudio當作書寫及成果分享平台。讀者將有機會體會到將語法及分析結果同時嵌進HTML檔案中，或是轉為Word檔與人分享的愉快過程。  
- 介紹「探索式資料分析」的工具。大數據高手將有機會一窺小資料的潛力，而入門的學習者將能感受到這個探索途徑在假設檢證的研究傳統之外所帶來的啟示。  

## 檔案使用注意事項
下載、解壓縮並設定好專案之後，請注意語法檔（.R）中的資料路徑表示方式。"../" 表示的是「相對路徑中的上一層目錄」的意思。詳見3.1.1 (p.42-44)。若執行時仍有讀取資料檔的錯誤訊息，有兩個解決方法：  

- 一是**重新設定好工作路徑**（也就是R可以找到的、該語法檔所在位置）。建議使用這個方法。做法是（1）在RStudio右下角檔案總管區，切換到語法案所在資料夾；（2）找到檔案總管區Files標籤工具列中的齒輪（More）圖示，點選"Set as Working Directory"）。 

- 二是_將語法檔中的相對路徑改為絕對路徑_（例如"D:/Document/R語法檔及資料檔/BBQ.csv"）。在Windows中取得檔案所在位置的絕對路徑的做法，是在資料檔上按右鍵-內容，就找到該檔案的路徑。請注意：複製、貼上絕對路徑到語法檔的時候，路徑所使用的是斜線（`/`）而不是反斜線（`\`）。 

## 聯絡  
本書若有任何錯誤，或您有指正、建議，歡迎您聯絡: [csliu@mail.nsysu.edu.tw](csliu@mail.nsysu.edu.tw) 。

## 勘誤及補充
此處為作者持續匯整、更新中的勘誤或補充。由於sjPlot系列套件的作者Daniel持續對部份重要指令及參數進行優化與簡化，因此我將依套件的更新資訊，整理到下表中。此頁提供公開下載的語法檔案皆已經依照此表更新。

|章節|頁碼|原文|修改|
|----|----|----|-------|
|2.3.1| p.26| 1900000 | 19000000 |
|4.2.3 補充盒子4.2 | p.84 | ”Home目錄下”|　”專案目錄下”　|
|4.2.2 | p.80 | `read_spss()` | 2019年10月起可以使用新增的通用版的指令: `read_data()` 除了可以自動辨識SPSS, SAS及STATA的副檔名之外，使用者加上atomic.to.fac=T參數之後可以把帶標籤的變數都批次轉為類別變數factor.| 
|4.2.2 | p.81 | `dat<- read_excel("xlssample.xls")` | `dat<- read_excel("../xlssample.xls")` | 
|4.2.2 | p.81 | `dat<- read.xlsx("xlssample.xls")` | `dat<- read.xlsx("../xlssample.xls")` |
|4.3.1 | p.89 |`load("../TNSS2015.rda") str(TNSS2015, list.len=5)`|`library(sjlabelled) TNSS2015 <- read_spss("../TNSS2015.sav", enc="big5") save(TNSS2015,file= "TNSS2015.rda") str(TNSS2015, list.len=5)` |
|4.3.1 | p.89-90 |  | `TNSS2015$TEL <- NULL` 加上移除個資欄位語法 |
|4.3.2 | p.91 | `weight.by = TNSS2015$w,` | `weight.by = w,`|
|4.3.3 | p.92 | `descr(tscs2013, out="browser") ` |`descr(tscs2013, v62, v70, v93, out="browser") `|
|5.1.3 | p.95 | `read_spss()` | 2019年10月起可以使用通用版的指令 `read_data()`|
|5.1.3 | p.99 | `sjPlot::sjt.frq()` | `sjmisc::frq()` | 
|5.1.3 | p.100 | `sjt.frq(tscs2013$sex, weight.by = tscs2013$wr)` | `frq(tscs2013$sex, weights = tscs2013$wr, out="v")` | 
|5.1.3 | p.101 | `sjt.frq(tscs2013$v15r)` | `frq(tscs2013$v15r)` | 
|5.1.3 | p.102 | `with(tscs2013, sjt.frq(v31a))` | `with(tscs2013, frq(v31a))` | 
|5.1.3 | p.106 | `sjt.frq(tscs2013$v67r)` | `frq(tscs2013$v67r)` | 
|5.1.3 | p.100, 105, 106 | `sjp.frq()` | `plot_frq()` |
|5.2.2 | p.116 |`bbq <- read.csv("../BBQ.csv", header = F)` | 補充：替代做法1: `bbq <- readr::read_csv("../BBQ.csv", col_names=F)` ；替代做法2：參考8.5（頁329）直接為變數命名 |
|5.2.4 | p.119 | `sjPlot::sjt.frq()` | `sjmisc::frq(out = "v") ` |
|5.3.1 | p.120 | `sjPlot::sjt.frq()` | `sjmisc::frq(out = "v") ` | 
|5.3.1 | p.121 | `load("../tscs2013.rda")` | 更正為讀入原始檔 `library(sjlabelled) tscs2013 <- read_data("../tscs2013q2.sav")` | |
|5.3.1 | p.122 | `frq(tscs2013$v65, weight.by = tscs2013$wr) ` | `frq(tscs2013$v65, weights = tscs2013$wr)  save(tscs2013, file="tscs2013r.rda") ` |
|5.3.1 | p.123 | `describe(tscs2013$age)` | `load("../tscs2013.rda")  describe(tscs2013$v65r)`  |
|5.3.1 | p.123 | `descr(tscs2013$age)`  | `descr(tscs2013$v65r)`  |
|5.3.2 | p.124 |`sjp.frq()`| `plot_frq()`|
|5.3.2 | p.126 | | 在sex加上標籤之後，後補上一段編碼：`tscs2013$v65r <- rec(tscs2013$v65r, rec="rev", var.label="how serious the issue is", val.labels = c("not at all (1)", "not very serious (2)", "serious (3)", "very serious (4)"))`| 
|5.3.2-3 | p.125-128 | `sjp.grpfrq()` | 指令名稱更新: `plot_grpfrq()` |
|5.3.2-3 | p.125-128 | `sjp.xtab()` | 指令名稱更新: `plot_xtab()` |
|5.3.2 | p.132 |`kao06$mediaAtt <- apply(tmp,1,sum)`| 此行新增註解：`等同於 kao06$mediaAtt <- rowSums(tmp)`|
|5.4.1 | p.133 | `kao06$mediaAtt <- row_sums(kao06,tv, radio, internet, newspaper, na.rm=T) table(kao06$mediaAtt)` | `library(dplyr) kao06 <- row_sums(kao06, tv, radio, internet, newspaper, n=4) table(kao06$rowsums)`| 
|5.4.1 | p.137 |`tmp.nona <- na.omit(tmp)`| 此行之後新增一行註解：` # install.packages("GPArotation")`| 
|6.1| p.140 | `sjt.frq(tscs2013$73r)`| `frq(tscs2013$v73r)` | 
|6.1.1|p.146| `sjt.xtab(tscs2013$v73r,　tscs2013$sex)`|`tab_xtab(tscs2013$v73r,　tscs2013$sex, encoding="utf8")`|
|6.1.1 | p.146 | `sjt.xtab()` | 指令名稱更新: `tab_xtab()` |
|6.2.1|p.158| quali.sup | quali.sub |
|7.4 | p.242-244 | `sjPlot::sjt.glm()`| `sjPlot::tab_model()` 因參數群在指令變更後出現大幅變動，請直接下載本節更新後的語法檔或使用`?tab_model`進行新舊參數對照 |
|8.1.2 |p.251, p.255| `weight.by`| `weights`|
|8.1.2 |p.252 | `sjp.frq()` | `plot_frq()` |
|8.2.2| P.288 | `id15 <- read_spss("../Total.sav", option="foreign", enc = "big5", attach.var.labels = T)` | 簡化為 `id15 <- read_spss("../Total.sav", enc = "big5")` |
|8.3.1| p.291, 295|'weight.by'|`weights`|
|8.3.2| p.300 | `sjt.xtab()` | 指令名稱更新: `tab_xtab()` |
|8.3.2| p.308 |`sjt.glm()`|`tab_model()` 因參數群在指令變更後出現大幅變動，請直接下載本節更新後的語法檔或使用`?tab_model`進行新舊參數對照|
|8.5.3 | p.332 | | 新增提示註解：使用`[ ]`上選項標籤的注意事項  |
|8.5.3 | p.333 | `sjp.frq()` | `plot_frq()` | 
|8.5.6 | p.348 | #581 | #629 | 
|8.5.7| p.352 | `sjt.xtab()` | 指令名稱更新: `tab_xtab()` |
|8.5.8 | p.353 | 語法框中的註記文字假設修正與p.349的內容一致| # 初步假設：覺得自己時間充裕的人(V37r=0)，愈可能傾向見面團聚取代使用手機（V45r=1）；相反的，自覺一天內時間不足的人，反而傾向以手機來取代見面團聚。|
