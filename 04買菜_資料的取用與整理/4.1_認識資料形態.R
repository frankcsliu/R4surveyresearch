### 《民意調查資料分析的R實戰手冊》
### 劉正山著．2018五南出版
### 4.1 認識資料形態

## 向量 (vector)
A <- c(1, 3, 5, 7, 9, 2, 4, 6, 8, 10) 
A  # 列出這個物件裡的數字
length(A) # 長度為10
typeof(A) # 連續數值 double 
A[2]  # 第二個位置的數字是3
A[c(1,3,8)] #第1、3、8個位置的數值為1、5、6
A[A<6] # 列出物件中小於6的是那些數值

B <- sample(100, 50) #隨機從100中取50個數字
class(B) #integer
B # 請仔細看看到每行的開頭座標

# 以重複（`rep()`）與序列（`seq()`）產生向量資料
rep(0, 3) # 數字0重複3次
rep("abc", 4) # 字串abc重複4次
3:7  #產生3到7連續數字
seq(1, 5, 2) # 創造一個從1到5以2漸增的向量
seq(10, 1, -1) # 創造一個10到1的向量

## 矩陣（matrix）
# 將向量資料轉為矩陣
C <- matrix(c(7,1,7,3,4,5,2,0,8), nrow=3)
C

D <- matrix(1:6, nrow=2, ncol=3)  # 數字由1到6，2列3欄
D
D[2,3]  # 第2列第3欄的數值是6

# 為矩陣上標籤
E <- matrix(1:6, nrow=2, byrow=F, 
            dimnames=list(Row=c("a","b"), Col=c("c","d","e")))
E
class(E) #matrix

## 陣列（array）
F <- array(1:24, c(3,4,2))  #3列、4欄、2層
F
F[3, 4, 2] # 第3列、第4欄、第2層的數值是24
class(F) #array

## 資料框（data frame）
G <- data.frame(V1=seq(0,8,2), V2=LETTERS[1:5])  # 創造出一個資料框物件G，5列2欄。
class(G) #data.frame

G[4,2]  # 第4列第2行的值為D
G[1] # 第1欄 

G[3:4, "V2"]  #第二欄"V2"的第3和第4列為C與D，也可以寫為：
G$V2[3:4]

colnames(G) <- c("Var1", "Var2")  # 重新命名多個欄位名稱
names(G)
colnames(G)[2] <- "Variable2"  # 重新命名第二欄的名稱
names(G)

## 串列（list）
H <- list(表一=seq(2,10,2), 
            表二= matrix(1:9, nrow=3), 
            表三=array(1:8, c(2,2,2)),
            表四=data.frame(V1=seq(0,3,1),
                          V2=letters[1:4]))
class(H) #list

H$表一
H$表二
H$表三
H$表四
H$表四[3,2]  # H物件中的表四第3列第2行的值為c
table(H$表四[2]) # 顯示H物件中表四的第2欄資料

## 變數的取用與型態的轉換
wgc <- read.csv("http://www2.nsysu.edu.tw/politics/liu/teaching/dataAnalysis/data/wgcoll.csv")
# 等同：
# wgc <- read.csv("../wgcoll.csv")
names(wgc)
class(wgc)
class(wgc$g)  # 這個變數g（性別）是整數：0女生；1男生
table(wgc$g)
wgc$g <- as.character(wgc$g) # 轉為文字
wgc$g
wgc$g <- as.integer(wgc$g)   # 轉回整數
wgc$g
wgc$g <- as.vector(wgc$g)    # 轉為向量
wgc$g
wgc$g <- as.factor(wgc$g)  # 轉為因子（factor）, 也可使用sjmisc:: to_factor()
table(wgc$g)
