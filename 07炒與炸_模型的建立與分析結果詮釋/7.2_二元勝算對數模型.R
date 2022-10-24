### 《民意調查資料分析的R實戰手冊》
### 劉正山著．2018五南出版
### 7.2 二元勝算對數模型


# 在正式操作前，用本資料夾中的章節專案檔（.Rproj）點開專案再正式開始練習
# 請用此指令確認目前工作路徑是現在章節的資料夾
here::here() 

## 實作一：用`glm()`進行線性與二元勝算對數分析
load("../wgcoll.rda")
summary(lm(aa ~ pe*c, data=wgc))
summary(glm(aa~ pe*c, family=gaussian, data=wgc))
pass <- ifelse(wgc$aa>=60,1,0)  # 1= 60分及格; 0=不及格
md01 <- glm(pass ~ pe + factor(sm) + factor(g),
            family=binomial, data=wgc)
summary(md01)

## 製作、比較多個模型
md02 <- update(md01, .~. -factor(sm) -factor(g)) 
summary(md02) # pe的迴歸係數為1.007
exp(1.007) # 將pe的迴歸係數還原為odd，也就是計算e的1.007次方

## 補充盒子：透過自動計算來挑選最佳模型
library(MASS)
stepAIC(md01) #自動化的結果建議使用 aa~pe的最簡模型

## 實作二：為模型加入虛擬變數
load("../teds2006_kao.rda")
attach(kao06)
partyID <- NA
partyID[L2B==1]<-1   #KMT　國民黨
partyID[L2B==2]<-2   #DPP　民進黨
partyID[L2B==3]<-3   #NP　新黨
partyID[L2B==4]<-4   #PFP　親民黨
partyID[L2B==6]<-5   #TSU　台聯黨
partyID[L2B==90]<-90 #others 其他

turnout <- NA　　　  # 投票參與
turnout[H01==1]<-1   # 有去投票
turnout[H01==2]<-0   # 沒去投票

gender <- NA
gender[SEX==1] <- 1　# 男
gender[SEX==2] <- 0　# 女

age <- AGE
detach(kao06)

# summary(glm(turnout ~ gender + age + partyID, # 錯誤
#             family=binomial,data=kao06)) 

attach(kao06)
table(L2B)

KMT <- NA
KMT[L2B==1]<-1   #KMT
KMT[L2B==2]<-0   #DPP
KMT[L2B==3]<-0   #NP
KMT[L2B==4]<-0   #PFP
KMT[L2B==6]<-0   #TSU
KMT[L2B==95]<-0 #others

DPP <- NA
DPP[L2B==1]<-0   #KMT
DPP[L2B==2]<-1   #DPP
DPP[L2B==3]<-0   #NP
DPP[L2B==4]<-0   #PFP
DPP[L2B==6]<-0   #TSU
DPP[L2B==95]<-0 #others

NP <- NA
NP <- ifelse(L2B==3,1,0)

TSU <- NA
TSU <- ifelse(L2B==6,1,0)

PFP <- NA
PFP <- ifelse(L2B==4,1,0)

others <- NA
others <- ifelse(L2B==95,1,0)

detach(kao06)

kao06.mod.1 <- glm(turnout ~ gender + age + 
                     KMT + NP + PFP + TSU + others,
                   family=binomial,
                   data=kao06)
summary(kao06.mod.1)  

## 補充盒子：使用sjmisc::to_factor()來設定有標籤變數的對照組
library(sjmisc)
kao06$partyID <- rec(kao06$L2B,
                     rec="98:hi=NA; else=copy", 
                     var.label="政黨傾向", 
                     val.labels = c("國民黨","民進黨","新黨",
                                    "親民黨", "台聯黨", "其他政黨"), 
                     as.num=F)
str(kao06$partyID)

# 重設對照組
kao06$partyID <- to_factor(kao06$partyID, ref.lvl="民進黨")
kao06.mod.2 <- glm(turnout ~ gender + age + partyID,
                   family=binomial, 
                   data=kao06)

summary(kao06.mod.2)

## 共線性檢定
library(car)
vif(kao06.mod.1)  # 此模型沒有明顯共線性的問題

## 不要忘了將編輯過的資料存檔
save(kao06, file="../kao06r.rda")
