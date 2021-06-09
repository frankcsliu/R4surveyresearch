### 《民意調查資料分析的R實戰手冊》
### 劉正山著．2018五南出版
### 7.3 多元勝算對數模型

## 多元勝算對數迴歸分析
# 方法一：使用VGAM:vglm()
load("../wgcoll.rda")

# 重新創造一個多類別依變數grade
wgc$grade <- NA
wgc$grade[wgc$aa<=100] <- 5 # grade "A"
wgc$grade[wgc$aa<90] <- 4   # grade "B"
wgc$grade[wgc$aa<80] <- 3   # grade "C"
wgc$grade[wgc$aa<70] <- 2   # grade "D"
wgc$grade[wgc$aa<60] <- 1   # grade "F"
table(wgc$grade)
wgc$grade <- factor(wgc$grade, 
                    levels= 5:1, 
                    labels= c("grade A", "grade B", "grade C",
                              "grade D", "grade F"))
table(wgc$grade)

# 重新設定對照組為grade F
wgc$grade <- relevel(wgc$grade, ref="grade F")
levels(wgc$grade)
#[1]  "grade F" "grade A" "grade B" "grade C" "grade D"

library(VGAM)
mod.vglm <- vglm(grade ~ pe + c, 
                 family=multinomial, 
                 data=wgc)
summary(mod.vglm)

# 方法二：使用 nnet::multinom()
# 計算z值: 迴歸係數除以標準誤
library(nnet)
mod.nnet <- multinom(grade~pe+c, data=wgc)
z <-coef(mod.nnet) / summary(mod.nnet)$standard.error
z

# 計算Wald test下的p值：將雙尾檢定下的z值用pnorm()轉為常態分佈下的機率後，取兩端拒絕域的機率合
p <- (1-pnorm(abs(z), 0, 1))*2  
p

## 有序勝算對數回歸分析
# 方法一：使用VGAM:vglm()
library(pscl)
data(admit)
levels(admit$score) # "1" "2" "3" "4" "5" 
# OLR模型-不採「平行預設」
library(VGAM)
psapp <- vglm(score ~ gre.quant #GRE的數量成績 （滿分800）
              + gre.verbal  #GRE的字彙成績滿分 （滿分800）
              + ap  # 1=有表示對美國政治有興趣
              + pt  # 1=有表示對政治思想有興趣
              + female, 
              data=admit,
              family= cumulative(reverse = T))  
summary(psapp)

# OLR模型-採「平行預設」(parallel assumption)
library(VGAM)
psapp.pl <- vglm(score ~ gre.quant 
              + gre.verbal  
              + ap  
              + pt  
              + female, 
              data=admit,
              family= cumulative(reverse = T, parallel = T))  
summary(psapp.pl)

# 方法二：MASS::polr() 
library(pscl)
data(admit)
olr.1 <- MASS::polr(score ~ gre.quant + gre.verbal + ap + pt + female, 
                    Hess=TRUE,
                    data=admit,
                    method="logistic")
summary(olr.1)

# 將迴歸係數還原為勝算(odd ratio)
olr.1.or <-exp(coef(olr.1)) 
olr.1.or
 # gre.quant gre.verbal         ap         pt     female 
 #     1.012      1.004      5.090      0.984      1.897 

# 計算p值
ctable <- coef(summary(olr.1))
p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2

# 計算p值的信賴區間
ci <- confint(olr.1)
ctable <- cbind("OR"=olr.1.or, p, ci)

# 勝算、p值及p值信賴區間列表
ctable

## 勝算對數模型的適配度指標 pseudo-Rsquare
# install.packages("rms")
rms::lrm(psapp, data=admit)# Nagelkerke's R-square=.604
