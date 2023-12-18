## ML Essentials for Data Analyst
# 1.Caret Interface
# Loading library 
library(tidyverse)
library(caret)
library(mlbench)
library(MLmetrics)

# use caret interface
model_lm_caret <- train(mpg ~ hp + wt + am,
                        data = mtcars,
                        method = "lm") # Algorithm

model_lm_caret
model_lm_caret$finalModel

# Train all predictors (full_model)
set.seed(42)  
model_lm_caret2 <- train(mpg ~ .,
                        data = mtcars,
                        method = "lm")
model_lm_caret2
model_lm_caret2$finalModel

# 2.KNN - K-Nearest Neighbors

## 1. Load & Split Data
# วิธีที่ 1 : แมนนวล 5 บรรทัด
## loading library mlbench
library(mlbench)

## load data set BostonHousing
data("BostonHousing")

## 1. Split Data
## วิธีที่ 1 : แมนนวล 5 บรรทัด
# จะฝากค่าใน df หรือ ใข้ชื่อ dataframe ตรงๆเลยก็ได้
df <- BostonHousing

# เทรนโมเดลกี่รอบก็ต้องทำ 5 บรรทัดนี้ => ควรสร้างเป็นฟังก์ชั่นเอาไว้เลย
set.seed(42)  
n <- nrow(df)  # หาจำนวนแถว df(ถ้าไม่ฝากค่าใน df ใส่ชื่อ dataframe ตรงๆ)
id <- sample(1:n, size = n*0.8) # split data ด้วย sample
train_df <- df[id, ] # ถ้าไม่ฝากค่าใน df ใส่ชื่อ dataframe ตรงๆ
test_df <- df[-id, ] # id ที่ใช้ไปแล้วจะไม่อยู่ในนี้

nrow(train_df); nrow(test_df) # เช็ค nrow 

# วิธีที่ 2 : ฟังก์ชั่น Train-Test-Split [เลือกใช้วิธีนี้]
# เขียนฟังก์ชั่นไว้ใช้งานเอง
# รับค่าจาก df(ชื่อdataframeที่โหลด) และ split data ออกเป็น 2 ส่วน
train_test_split <- function(df, train_size = 0.8) {
		set.seed(42)
		n <- nrow(df)
		id <- sample(1:n, size=n * train_size)
		train_df <- df[id, ]
		test_df <- df[-id, ]
		return(list(train=train_df, test=test_df)) # return ค่าออกมาเป็น list 
}

# ใส่ชื่อ dataframe ลงในฟังก์ชั่นและฝากค่าไว้ในตัวแปร Split data
split_data <- train_test_split(BostonHousing, 0.8) # 0.8 มีหรือไม่ก็ได้

# เช็คโครงสร้าง data
str(split_data) # ดูโครงสร้างของ split_data
split_data$train %>% head # ดู trains set
split_data$test %>% head # ดู test set

# ฝากค่าในตัวแปร train_df และ test_df
train_df <- split_data$train # insert value in variable
test_df <- split_data$test

## 2. Train Model + Predict train set
# ในขั้นตอนนี้จะได้โมเดลแล้วแต่ยังบอกไม่ได้ว่าโมเดลดีหรือไม่ต้องนำไปทดสอบก่อน(บอกไม่ได้ว่า k เท่าไหร่ถึงจะดี)

## 2.1 การเทรนโมเดล แบบใช้ค่า default
# ค่า default ของ resampling "boostrapped"

set.seed(42) # ก่อนเทรนโมเดลควร set.seed() ก่อนทุกครั้ง
knn_model <- train(medv ~ .,
									data = train_df,
									method = "knn")
knn_model

## 2.2 เทรนโมเดลโดยกำหนด metric ในการเทรนเป็น RMSE
# สามารถเปลี่ยนค่า metric ที่ใช้ในการจูนโมเดลเป็น Rsquared ได้
# เปลี่ยน subset ของตัวแปรก็ทำให้ผลลัพธ์เปลี่ยนได้แล้ว(ต้องเข้าใจธุรกิจให้ดี [นี่คือ domain knowleddge])
# abosolute metric จะบอกว่าโมเดลที่เราสร้างขึ้นมาทำนาายได้ดีขนาดไหน
# Rsquared ใช้ในการเปรียบเทียบโมเดล

## 2.2.1 เทรนทุกตัวแปร (แบบที่ 1)

set.seed(42) # ก่อนเทรนโมเดลควร set.seed() ก่อนทุกครั้ง
knn_model <- train(medv ~ ., # สามารถเลือกเฉพาะคอลัมบ์ได้
			data = train_df,
			method = "knn",
			metric = "RMSE") # absolute metric ยิ่งมีค่าต่ำยิ่งดี ส่วน Rsquared ใช้ในการเปรียบเทียบโมเดล
knn_model

## 2.2.2 เทรนแค่บางตัวแปร (แบบที่ 2)
# ถ้ามี 2 โมเดลที่ Performance พอกันเราจะใช้โมเดลที่ Simple กว่า

set.seed(42) # ก่อนเทรนโมเดลควร set.seed() ก่อนทุกครั้ง
knn_model <- train(medv ~ crim + rm + tax + zn +nox, 
		data = train_df,
		method = "knn",
		metric = "RMSE") 
knn_model

## 2.3 เทรนโมเดลโดยต้องการหาค่า k จำนวน 5 ค่า (tuneLength)
# การเลือกค่า k ควรเลือกเป็นเลขคี่ เพื่อป้องกันการเสมอกันในกรณีของ binary (เลือกใช้ให้เหมาะสมกับงานที่ทำ)
# Higher k => Underfit , Lower k => Overfit , Optimal k = ? (ต้องลองเทรนดู)

set.seed(42)
knn_model <- train(medv ~ crim + rm + tax + zn +nox, 
		data = train_df,
		method = "knn",
		metric = "RMSE",
		tuneLength = 5) # ปรับค่า k ที่ใช้ในการเทรนเป็น 5 ค่า
knn_model

## 2.4 เขียน tunegrid เพื่อใส่แทน tuneLength (Grid Search Hyperparameter(ค่า K) Tuning)

set.seed(42)
grid_k <- data.frame(k = 5:9) # กำหนด k จาก 5 ถึง 9

knn_model <- train(medv ~ crim + rm + tax + zn +nox, 
		data = train_df,
		method = "knn",
		metric = "RMSE",
		tunegrid = grid_k) # เปลี่ยน tuneLength เป็น tunegrid
knn_model

## 2.5 เปลี่ยน resampling จาก boostrap => K-fold , LOOCV
# ทุกอย่างที่เราเปลี่ยนจะมีผลต่อผลลัพธ์ในตอนท้ายเสมอ

# 2.5.1 Boostrap Case

set.seed(42)
grid_k <- data.frame(k = 5:9) # กำหนด k จาก 5 ถึง 9

ctrl <- trianControl(
		method = "boot", # Bootstrap
		number = 100 # จำนวนรอบการเทรนโมเดล
)

knn_model <- train(medv ~ crim + rm + tax + zn +nox, 
		data = train_df,
		method = "knn",
		metric = "RMSE",
		tunegrid = grid_k,
		trControl = ctrl)  # ตัวควบคุมพฤติกรรมการเทรนโมเดล
knn_model

# 2.5.2 LOOCV Case

set.seed(42)
grid_k <- data.frame(k = 5:9) # กำหนด k จาก 5 ถึง 9

ctrl <- trianControl(
		method = "LOOCV" # Leave one out CV
)

knn_model <- train(medv ~ crim + rm + tax + zn +nox, 
		data = train_df,
		method = "knn",
		metric = "RMSE",
		tunegrid = grid_k,
		trControl = ctrl) 
knn_model

# 2.5.3 K-fold Case

set.seed(42)
grid_k <- data.frame(k = 2:9) # กำหนด k จาก 5 ถึง 9

ctrl <- trianControl(
		method = "cv", # k-fold cross validation
		number = 5 # ค่า k ที่ใช้ในการ fold ปกติเราจะเลือก 5 หรือ 10
)

knn_model <- train(medv ~ crim + rm + tax + zn +nox, 
		data = train_df,
		method = "knn",
		metric = "RMSE",
		tunegrid = grid_k,
		trControl = ctrl)  # ตัวควบคุมพฤติกรรมการเทรนโมเดล
knn_model

## 2.6 Model Final Version (repeatedcv) [เลือกใช้โมเดลนี้เป็นโมเดลตามที่เราต้องการ]
# ถือว่าเป็น Super Golden Standard [ถ้าใช้ได้ควรใช้]
# สมมติ k = 5 ใน cv คือ การเทรน k-fold 5 รอบ แต่ repeatcv คือ การเทรน k-fold 5 รอบ วนลูปอีก 5 รอบ (5 * 5 = 25) 

set.seed(42)
grid_k <- data.frame(k = 5:9) # กำหนด k จาก 5 ถึง 9
ctrl <- trainControl(
    method = "repeatedcv",
    number = 5,
    repeats = 5 
)

knn_model <- train(medv ~ crim + rm + tax + zn +nox, 
                   data = train_df,
                   method = "knn",
                   metric = "RMSE",
                   tunegrid = grid_k,
                   trControl = ctrl) 
knn_model

## 2.7 Predict train set หา RMSE ของ Final Model
pred_medv_train <- predict(knn_model)
train_rmse <- sqrt(mean((train_df$medv - pred_medv_train)**2))

## 3. Test Model(Predict test set) & Scoring
# โมเดลดีหรือไม่ต้องทำ scoring ก่อนในขั้นตอนนี้

## Scoring => Prediction test set
pred_medv_test <- predict(knn_model, newdata = test_df)
test_rmse <- sqrt(mean((test_df$medv - pred_medv_test)**2))

## Save Model
saveRDS(knn_model, "knn_model_25June2022_v1.RDS")

## Load Model
knn_model <- readRDS("knn_model_25June2022_v1.RDS")

## Example Train Model K-Fold Cross Validation
# Load library & dataset
library(tidyverse)
library(dplyr)
library(caret)
library(mlbench)

df <- data('BostonHousing')

# import function train_test_split

train_test_split <- function(df, train_size = 0.8) {
		set.seed(42)
		n <- nrow(df)
		id <- sample(1:n, size=n * train_size)
		train_df <- df[id, ]
		test_df <- df[-id, ]
		return(list(train=train_df, test=test_df)) 
}

# 1.Split data

set.seed(42)
split_data <- train_test_split(BostonHousing, 0.8)
train_df <- split_data$train
test_df <- split_data$test

# 2. Train Model K-Fold CV

set.seed(42)
ctrl <- trainControl(
		method = "cv",
		number = 5,  # กำหนดค่า k ของ k-fold
		verboseIter = TRUE # ทุกครั้งที่เทรนโมเดลจะปริ้นท์ค่าlog แสดงลงไปใน console แสดง Progress ว่าไปถึงไหนแล้ว
)

# ยิ่งตัวแปรโมเดลยิ่ง simple มากขึ้น
knn_model <- train(
		medv ~ .,
		data = train_df %>% 
			select(- age, -dis, -chas),  # ใช้ dplyr มาช่วย 
		method = "knn",
		metric = "RMSE",
		tuneLength = 5,
		trControl = ctrl
)

knn_model

## Variable Importance
varImp(knn_model)  # ใช้ดูตัวแปรต้นใน feature ว่าตัวแปรไหนบ้างที่มีผลเยอะหรือน้อย , มีความสำคัญสูงหรือต่ำ

# 3. Test Model
p <- predict(knn_model, newdata = test_df)
RMSE(p, test_df$medv)

## Pre-Process data (Normalization)
## Feature Scaling (การปรับสเกลของตัวแปรให้อยู่ในสเกลเดียวกัน)
# Minimum =0 , Maximum = 1

mtcars$mpg

mpg <- mtcars$mpg
mpg

# จากสูตร (x -min_x) / (max_x - min_x)
(mpg - min(mpg)) / (max(mpg) - min(mpg))

## Create to Function

min_max_scaling <- function(x) {
	(x -min(x)) / (max(x) - min(x))
}

min_max_scaling(mpg)

## Standardization => Z-Score
# ค่าจะอยู่ในช่วง -3 ถึง +3 โดย + คือ อยู่สูงกว่าค่าเฉลี่ย , - คือ อยู่ต่ำกว่าค่าเฉลี่ย 

# จากสูตร (x -mean_x) / sd_x
(mpg - mean(mpg)) / sd(mpg) 

## Create to Function

z_norm <- function(x) {
	(x -mean(x)) / sd(x)
}

z_norm(mtcars$mpg)

## หรือเพิ่มคำสั่ง "preProcess" ในขั้นตอนการเทรนโมเดลเพื่อทำ Standardization

knn_model <- train(
		medv ~ .,
		data = train_df %>% 
			select(- age, -dis, -chas),  # ใช้ dplyr มาช่วย 
		method = "knn",
		metric = "RMSE",
		preProcess = c("center", "scale"), # การทำ center & scale ในเชิงสถิติ
		tuneLength = 5,
		trControl = ctrl
)

# 3.Binary Classification
## Load dataset
data("Sonar")

table(Sonar$class)

## ก่อนเทรนโมเดลต้อง make sure ว่า data มี missing value มั้ย หรือ ต้อง normalize data หรือเปล่า
# 1. Check missing value => ถ้ามีเราต้องจัดการกับ missing value เช่น การทำ mean/median/mode imputation , สร้างโมเดลขึ้นมาทำนาย
mean(complete.cases(Sonar)) # ถ้าไม่มี missing value จะมีค่าเป็น 1

# 2. preview data for normalize data (ทำหรือไม่ขึ้นกับ data)
# เราจะใช้ preprocess(normalize) ในกรณีที่ range ของ data กว้างมากๆ
Sonar %>% head() # จากตัวอย่างนี้ไม่ต้องมี normalize ก็ได้ 

## Split data with createDataPartition
# 1. Split data
# createDataPartition เป็นฟังก์ชั่นใน caret ทำหน้าที่เหมือนกับฟงัก์ชั่นที่เราเขียนเองด้านบนเลย โดย p ใช้สำหรับแบ่งข้อมูล train set กับ test set 
# list = FALSE ทำให้มีการแสดงผลแบบเป็นคอลัมบ์ 
set.seed(42)
id <- createDataPartition(y = Sonar$Class, 
			                    p = 0.7, 
			                    list = FALSE)
id # Check split data 
 
train_df <- Sonar[id, ] # add split data into train_df
test_df <- Sonar[-id, ] # add non-split data into test_df

nrow(train_df); nrow(test_df) # Check nrow

# 2. Train model
set.seed(42)
ctrl <- trainControl(
  method = "cv",
  number = 3, # ใช้น้อยเพราะมี จำนวน record น้อย จึงต้องมี fold น้อย
  verboseIter = TRUE # เซ็ทค่าให้มีการ print log
) 

# Logistic Regression (Binary Classification)
logistic_model <- train(Class ~ .,
                        data = train_df,
                        method = "glm",
                        trControl = ctrl)

logistic_model

# KNN Model
knn_model <- train(Class ~ .,
                        data = train_df,
                        method = "knn",
                        trControl = ctrl)

knn_model

# Random Forest
rf_model <- train(Class ~ .,
                   data = train_df,
                   method = "rf",
                   trControl = ctrl)

rf_model

# varImp
varImp(logistic_model)
varImp(knn_model)
varImp(rf_model)

## Compare Model
# compare three models
result <- resamples(
  list(
    logisticReg = logistic_model,
    knn = knn_model,
    randomForest = rf_model
  )
)
summary(result)

# 3. Test model

# Predict Logistic Model
# เอาข้อมูลที่เราทำนายไปเทียบกับของจริงเลยใน test_df
p <- predict(logistic_model, newdata = test_df)
mean(p == test_df$Class) # หาค่า accuracy

## Confusion Matrix
table(p, test_df$Class, dnn=c("Prediction", "Actual"))

confusionMatrix(p, test_df$Class, mode="prec_recall")

### การทำ Compare Model 
## Train Model Step
# Step 1
# ล็อคค่าให้ใช้ชุดข้อมูลแบบเดียวกันในการเทรนโมเดลทุกแบบที่ต้องการทราบผล
set.seed(42)

# Step 2
# สามารถสร้างพารามิเตอร์สำหรับการจูนโมเดลเพิ่มเติมได้ในขั้นตอนนี้
# ค่าต่างๆในพารามิเตอร์สามารถปรับได้ตามความต้องการของเรา
ctrl <- trainControl(
    method = "cv",
    number = 3,  
    verboseIter = TRUE 
)

# Step 3
# เทรนโมเดลที่เราต้องการทดลอง โดยโมเดลที่นิยมใช้บ่อยๆ เช่น regression , knn , randomforest เป็นต้น
model 1 <- train(Class ~ .,
                 data = train_df,
                 method = "method_name",
                 trControl = ctrl)

model 2 <- train(Class ~ .,
                 data = train_df,
                 method = "method_name",
                 trControl = ctrl)

model 3 <- train(Class ~ .,
                 data = train_df,
                 method = "method_name",
                 trControl = ctrl)

model n <- train(Class ~ .,
                 data = train_df,
                 method = "method_name",
                 trControl = ctrl)

# Step 4
# เปรียบเทียบโมเดลต่างๆที่เราได้ทดสอบและแสดงผลออกมา
result <- resamples(
  list(
    name_1 = model 1,
    name_2 = model 2,
    name_3 = model 3,
		name_n = model n
  )
)
summary(result)

## AUC (Area Under Curve)
# ใช้ database "Pima Indian Diabetes (Binary)"

# Load data
data("PimaIndiansDiabetes")

## เราต้องเช็คว่า data complete มั้ย?
# 1. ใช้คำสั่ง mean(complete.cases(df)) ในการเช็คว่า data complete มั้ย หรือ ถ้าใช้บ่อยให้ทำเป็นฟังก์ชั่นออกมา               

df <- PimaIndiansDiabetes # Insert value into dataframe

check_complete <- function(df) mean(complete.cases(df))

check_complete(df)

# 2. เราจะทำนายคอลัมบ์ชื่ออะไร target/label ชื่อว่าอะไร?
# ต้อง make sure ว่าคอลัมบ์ที่ต้องการทำนายเป็น factor โดยใช้ฟังก์ชั่น glimpse

glimpse(df)

# 3. Check distribution ทำเพื่อให้เข้าใจคาแรกเตอร์ก่อนเริ่มเทรนโมเดล

df %>% 
		count(diabetes)%>%
		mutate(pct = n/sum(n))

# จากตัวอย่างเกิดปัญหา imbalance class คือมีเปอร์เซ็นต์สัดส่วนของทั้งสองตัวไม่ใกล้เคียงกัน(diff เยอะ) โดยสัดส่วนที่ดี คือ 60:40 , 55:45 เป็นต้น
# ในกรณีนี้เราจะไม่ดูค่า accuracy เพราะเริ่มมี bias เกิดขึ้น(ออกสอบบ่อยตอนสัมภาษณ์ถามเช็คความเข้าใจ binary classification) โดยเราจะดูค่าอื่นแทน
# ค่าที่เราดูแทน เช่น Recall , Precision , F1-score หรือ AUC(Area Under Curve)

## Step 1 : split data
# data ที่เรามีอยู่สมควรทำ Normalization โดยใช้ Center, Scale ใน preProcess
set.seed(42)
id <- createDataPartition(y = df$diabetes,
                          p = 0.8,
                          list = FALSE)
train_df <- df[id, ]
test_df <- df[-id, ]

# check nrow เพื่อความชัวร์ว่า split data ได้ตรงกับที่เราต้องการ
nrow(train_df);nrow(test_df);nrow(PimaIndiansDiabetes)

## Step 2 : train model
# Logistic Regression

set.seed(42)
ctrl <- trainControl(
	method = "cv",
	number = 5,
	verboseIter = TRUE
)

logistic_model <- train(
		diabetes ~ .,
		data = train_df,
		method = "glm",
		metric = "Accuracy",  # ค่า default ของ metric คือ accuracy สามารถเปลี่ยนได้
		preProcess = c("center", "scale"), # ลำดับมีผลต่อผลลัพธ์
		trControl = ctrl		
)

logistic_model

# randomforest
# version 01
set.seed(42)

ctrl <- trainControl(
  method = "cv",
  number = 5,
  verboseIter = TRUE
)

rf_model <- train(
  diabetes ~ .,
  data = train_df,
  method = "rf",  # randomForest
  metric = "Accuracy",
  preProcess = c("center", "scale"),
  trControl = ctrl
)

# version 02 (ใช้ค่า ROC ในการ Optimal model)
set.seed(42)

ctrl <- trainControl(
  method = "cv",
  number = 5,
  classProbs = TRUE, # important
  summaryFunction = twoClassSummary,
  verboseIter = TRUE
)

rf_model <- train(
  diabetes ~ .,
  data = train_df,
  method = "rf",  # randomForest
  metric = "ROC", # ต้องมี classProbs กับ summaryFunction ก่อน
  preProcess = c("center", "scale"),
  trControl = ctrl
)

# version 03 (ไม่ใส่ metric = "Recall" จึงใช้ค่า Accuracy ในการ Optimal model)
set.seed(42)

ctrl <- trainControl(
  method = "cv",
  number = 5,
  classProbs = TRUE, # important
  #summaryFunction = twoClassSummary,
  summaryFunction = prSummary, # prSummary = precision & Recall
  verboseIter = TRUE 
)

rf_model <- train(
  diabetes ~ .,
  data = train_df,
  method = "rf",  # randomForest
  #metric = "Recall", 
  preProcess = c("center", "scale"),
  trControl = ctrl
)

# version 04 (ใช้ค่า Recall ในการ Optimal model)
set.seed(42)

ctrl <- trainControl(
  method = "cv",
  number = 5,
  classProbs = TRUE, # important
  #summaryFunction = twoClassSummary,
  summaryFunction = prSummary, # prSummary = precision & Recall
  verboseIter = TRUE 
)

rf_model <- train(
  diabetes ~ .,
  data = train_df,
  method = "rf",  # randomForest
  metric = "Recall", # เพื่อใช้ Recall ในการ Optimal model
  preProcess = c("center", "scale"),
  trControl = ctrl
)

## Step 3 : test model
# Scoring
p <- predict(rf_model, newdata = test_df)
mean(p == test_df$diabetes)

# evaluate model(confusion matrix)
confusionMatrix(p, test_df$diabetes)

# 3.Decision Tree (Recursive Partitioning)
## Decision Tree in PimaIndiansDiabetes
## Load data
data("PimaIndiansDiabetes")

df <- PimaIndiansDiabetes # Insert value into dataframe

## Step 1 : split data
set.seed(42)
id <- createDataPartition(y = df$diabetes,
                          p = 0.8,
                          list = FALSE)
train_df <- df[id, ]
test_df <- df[-id, ]

## Step 2 : train model
# version 1
set.seed(99)

ctrl <- trainControl(
  method = "cv",
  number = 5,
  classProbs = TRUE, 
  summaryFunction = prSummary,
  verboseIter = TRUE 
)

tree_model <- train(diabetes ~ .,
										data =  train_df,
										method = "rpart",
										trControl = trainControl(
											method = "cv",
											number = 5
										))

# version 2 : Tune cp with tuneLength
set.seed(99)

ctrl <- trainControl(
  method = "cv",
  number = 5,
  classProbs = TRUE, 
  summaryFunction = prSummary,
  verboseIter = TRUE 
)

tree_model <- train(diabetes ~ .,
		data =  train_df,
		method = "rpart",
		tuneLength = 10,
		trControl = trainControl(
				method = "cv",
				number = 5
		))

# version 3 : Tune cp with tuneGrid
set.seed(99)

ctrl <- trainControl(
  method = "cv",
  number = 5,
  classProbs = TRUE, 
  summaryFunction = prSummary,
  verboseIter = TRUE 
)

myGrid <- data.frame(cp = seq(0.001, 0.3, by = 0.005))

tree_model <- train(diabetes ~ .,
		data =  train_df,
		method = "rpart",
		tuneGrid = myGrid,
		trControl = trainControl(
					method = "cv",
					number = 5
		))

tree_model$finalModel

# install package rpart.plot
install.packages("rpart.plot")
library(rpart.plot)

rpart.plot(tree_model$finalModel)

# 4.Random Forest
## Load data
data("PimaIndiansDiabetes")

df <- PimaIndiansDiabetes # Insert value into dataframe

## Step 1 : split data
set.seed(42)
id <- createDataPartition(y = df$diabetes,
                          p = 0.8,
                          list = FALSE)
train_df <- df[id, ]
test_df <- df[-id, ]

## Step 2 : train model
# version 01
set.seed(99)

ctrl <- trainControl(
  method = "cv",
  number = 5,
  classProbs = TRUE, 
  summaryFunction = prSummary,
  verboseIter = TRUE 
)

myGrid <- data.frame(mtry = 2:7)

rf_model <- train(diabetes ~ .,
		data =  train_df,
		method = "rf",
		tuneGrid = myGrid,
		trControl = trainControl(
					method = "cv",
					number = 5
		))

# version 02
set.seed(99)

ctrl <- trainControl(
    method = "cv",
    number = 5,
    classProbs = TRUE, 
    summaryFunction = prSummary,
    verboseIter = TRUE 
)

myGrid <- data.frame(mtry = 2:7)

rf_model <- train(diabetes ~ .,
                  data =  train_df,
                  method = "rf",
                  metric = "AUC",  # กำหนด metric ในการจูนโมเดลเป็น AUC
                  tuneGrid = myGrid,
                  trControl = trainControl(
                      method = "cv",
                      number = 5,
                      verboseIter = TRUE,  # แสดงค่า log ระหว่างประมวลผล
                      classProbs = TRUE,  # เปลี่ยนไปใช้ ROC curve
                      summaryFunction = prSummary # กำหนดค่าการแสดงผลแบบ Precision & Recall
                  ))

# version 03
# nzv(near zero variance) คือ คอลัมบ์ที่มีค่าแบบที่แทบจะเป็น "ค่าConstant(ค่าคงตัว)"
set.seed(99)

ctrl <- trainControl(
    method = "cv",
    number = 5,
    classProbs = TRUE, 
    summaryFunction = prSummary,
    verboseIter = TRUE 
)

myGrid <- data.frame(mtry = 2:7)

rf_model <- train(diabetes ~ .,
                  data =  train_df,
                  method = "rf",
                  metric = "AUC",  
	          preProcess = c("center", "scale", "nzv"),
                  tuneGrid = myGrid,
                  trControl = trainControl(
                      method = "cv",
                      number = 5,
                      verboseIter = TRUE,  
                      classProbs = TRUE,  
                      summaryFunction = prSummary 
                  ))

## Step 3 : test model
p <- predict(rf_model, newdata = test_df)
confusionMatrix(p,
                test_df$diabetes,
                mode = "prec_recall",
                positive = "pos")

# 5.Ridge and Lasso
## Load data
data("PimaIndiansDiabetes")

df <- PimaIndiansDiabetes # Insert value into dataframe

## Step 1 : split data
set.seed(42)
id <- createDataPartition(y = df$diabetes,
                          p = 0.8,
                          list = FALSE)
train_df <- df[id, ]
test_df <- df[-id, ]

## Step 2 : train model
# regularized ช่วยลด Overfitting ได้
# alpha = 0 (ridge) , alpha = 1(lasso)

set.seed(42)

myGrid <- expand.grid(alpha = 0:1,
		lambda = seq(0.001, 1, length = 20))

regularized_model <- train(
			diabetes ~ .,
                        data =  train_df,
			method = "glmnet",  # กำหนดว่าโมเดลจะใช้ Ridge and Lasso
			tuneGrid = myGrid,
			trControl = trainControl(
					method = "cv",
					number = 5,
					verboseIter = TRUE
			))

## Step 3 : test model
p <- predict(regularized_model, newdata = test_df)

confusionMatrix(p,
                test_df$diabetes,
                mode = "prec_recall",
                positive = "pos")
