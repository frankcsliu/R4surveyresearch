### 《民意調查資料分析的R實戰手冊》
### 劉正山著．2018五南出版
### 7.4 迴歸模型的比較、製圖與製表

library(sjPlot)
load("../wgcoll.rda")

# 線性模型一
md01 <- lm(aa ~ pe + g, data=wgc)  # 成績 ~ 家長的受教育年數 + 性別
summary(md01)

# 線性模型二
md02 <- update(md01, .~. -g)
plot_model(md02)

# 二元勝算對數模型一（1= 60分過關; 0=沒過關）
wgc$pass60 <- ifelse(wgc$aa>=60,1,0)  
md03 <- glm(pass60 ~ pe + g, 
            family=binomial, data=wgc)
summary(md03)

# 二元勝算對數模型二 （1= 80分過關; 0=沒過關）
wgc$pass80 <- ifelse(wgc$aa>=80,1,0)  
md04 <- update(md01, pass80 ~ . + c)  # 加入城鄉變數(1=郊區；0=都市)

## 模型比較
# 方法一：analysis of variance (ANOVA)
# 比較residual sum of squares (RSS)，數值愈小愈好
anova(md01, md02)  

# 方法二：AIC與BIC 
# 數值較低的模型較好
AIC(md01, md02)  # Akaike Information Criterion
BIC(md01, md02)  # Bayesian Information Criterion

# 方法三：stepAIC
# 自動挑出AIC最小的模型
library(MASS)
stepAIC(md01) # 注意md01必需是個包含全部變數的完整模型（full model）

## 用視覺化方法來比較線性模型
# 方法一：sjPlot::plot_models()
library(sjPlot)
plot_models(md01, md02)

# 方法二：coefplot::multiplot()
# install.pacakges("coefplot")
library(coefplot)
multiplot(md01, md02)

## 用視覺化方法來比較二元勝算對數模型
library(sjPlot)
plot_models(md03, md04, colors = "gs") # 使用灰階色系（greyscale）

## 陽春版的表格
library(sjPlot)
sjt.glm(md01) 

## 專業版的表格
library(sjPlot)
sjt.glm(md03,
        # 設定要顯示的資訊
        exp.coef=FALSE, # 不要將迴歸係數還原為勝算
        show.header = TRUE, # 顯示模型標題列
        show.ci = TRUE, # 顯示信賴區間
        separate.ci.col = TRUE,  # 以獨立欄位顯示信賴區間
        show.se = TRUE, # 顯示標準誤
        show.aic = TRUE, # 顯示AIC 
        show.loglik = TRUE, # 顯示 -2*Log-Likelihood
        show.r2 = TRUE, # 顯示 (pseudo) R-square
        p.numeric=F, #切換為以星號表示顯著程度
        
        # 設定小數點的位數
        digits.est=3,   
        digits.p=3,
        digits.se=3,
        digits.ci=3,
        digits.summary= 2,
        
        # 線的樣式設計
        CSS=list(css.topborder="border-top:1px solid black;"), 

        # 欄位重新命名
        string.est ="迴歸係數",
        string.se ="標準誤 (S.E.)",
        string.p="顯著水準 (C.I.)", 
        string.ci = "信賴區間",
        string.obs = "觀察值（N）", 
        string.interc = "截距", 
        string.dv =  "模型一", 
        string.pred = "解釋變數"
        # file="analysisResult.html" #另存新檔
        )

## 以sjt.glm()製表來比較模型
sjt.glm(md03, md04,
        show.aic=TRUE, 
        show.loglik=TRUE,
        show.ci=FALSE,
        show.se=TRUE,
        show.r2 =FALSE,
        show.header = TRUE,
        digits.p=3, 
        digits.se=3,
        digits.est=3,
        CSS=list(css.topborder="border-top:1px solid black;"), 
        exp.coef=FALSE,
        string.est ="Reg. Coef.",
        string.se ="Std. Error"
        )

### 補充盒子： 為多元及有序勝算對數分析結果製表
library(stargazer)
library(VGAM)
load("../wgcoll.rda")
wgc$grade <- NA
wgc$grade[wgc$aa<=100] <- 5 
wgc$grade[wgc$aa<90] <- 4   
wgc$grade[wgc$aa<80] <- 3   
wgc$grade[wgc$aa<70] <- 2  
wgc$grade[wgc$aa<60] <- 1  
wgc$grade <- factor(wgc$grade, 
                    levels= 5:1, 
                    labels= c("grade A", "grade B", "grade C",
                              "grade D", "grade F"))

library(nnet)
mod.nnet <- multinom(grade ~ pe + c, data=wgc)

# 製表
stargazer(mod.nnet, 
          type="html", 
          out="mod.nnet.htm"   # 到資料夾找到並開啟後進行複製貼上
          )
