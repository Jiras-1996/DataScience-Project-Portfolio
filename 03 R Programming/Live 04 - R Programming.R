## Live 04 - R Programming
# 1.Create your own function
# Functions 1
greeting <- function() {
    print("hello world")
}

# Functions 2
# input ใน my_sum จะเป็นดัมมี่จะตั้งยังไงก็ได้
my_sum <- function(a,b) {
    a + b
}

# Functions 3-4 
# short form ใน R ให้สามารถเขียนฟังก์ชั่นจบในบรรทัดเดียวหากไม่ซับซ้อนมากและมีบรรทัดเดียวสั้นๆ
my_sum2 <- function(a,b) a+b
greeting2 <- function() print("hello world")

# 2.Control flow (if, for, while)
# if
grading <- function(score) {
    if (score >= 90) {
        return("A")
    } else if (score >= 80) {
        return("B")
    } else if (score >= 70) {
        return("C")
    } else {
        return("D")
    }
}

# ifelse (สามารถใช้แทน for loop ได้โดย for loop จะใช้ในกรณีที่เขียนโปแกรมแบบจริงจัง)
# สามารถรันได้ทีละ 1 เงื่อนไข

 
score <- c(95, 90, 78, 56, 82)

ifelse(score >= 80, "Passed", "Failed")

# For Loop (ปกติไม่จำเป็นไม่ต้องใช้)
for (i in 1:10) {
     print("hello world!")
}

# five student scores ={95,50,88,72,75}
scores <- c(95, 50, 88, 72, 75) 

# ควรเขียนให้ descriptive เพื่อให้คนอื่นอ่านรู้เรื่องด้วย
for (score in scores) {
    print(grading(score))
}

# While Loop
# ใกล้เคียงกับ for loop มากแต่ปกติ while loop เราจะไม่รู้ตั้งแต่เริ่มว่าจะรันกี่รอบ 
# แต่จะมี condition ที่จะใช้ exit ออกจาก loop (ถ้าไม่มี = run infinity) 

# While Loop 1
# run ไปเรื่อยๆจนกว่าค่า count จะมากกว่า 10 จึง terminate
# ถ้าติดอยู่ใน infinite loop ให้กด stop เพื่อหยุดการรันโปรแกรม

count <- 0

while (count < 10) { 
    print("hello") # run เรื่อยๆ จนกว่าเงื่อนไขจะเป็น FALSE
		count <- count + 1 # ใช้ update ค่า count (ไม่มี=run infinity)
}

# While Loop 2 (version 1)
# input ใน R คือ readline 
# ถ้า input ที่เราใส่เข้าไปตรงกับคำตอบที่ระบุไว้จะ break loop

animal <- "hippo"

while (TRUE) {
        user_input <- tolower(readline("Guess animal: "))
        if (user_input == animal) {
          print("Congratulations! your guess is correct!")
          break
        } else {
          print("Your guess is incorrect. Please try again.")
        }
    }

# While Loop 2 (version 2)
# ชื่อ animal ที่เป็นคำตอบต้องอยู่ใน " " ถ้าไม่มีตอนรันจะมี error
# tolower เป็น function ใน stringr ที่ช่วยให้พิมพ์อะไรก็เป็น lowercase

guess_animal_game <- function(animal) {
    while (TRUE) {
        user_input <- tolower(readline("Guess animal: "))
        if (user_input == animal) {
          print("Congratulations! your guess is correct!")
          break # ถ้าเป็น animal จะ break ออกจาก loop
        } else {
          print("Your guess is incorrect. Please try again.")
        }
    }  
}

# Username password Login application
# Version 1

login_fn <- function() {

		# set username password
			username <- "jirasinfinity"
			password <- "12345"

		# get input from user
			un_input <- readline("Username: ")
			pw_input <- readline("Password: ")

		# check username, password
			if (username == un_input & password == pw_input) {
					print("Thank you! you have successfully login.")
			} else {
					print("Sorry, please try again.")
			}
}

# Version 2
# Username password Login application (Can try 3 times to login attempt)

login_fn <- function() {
    username <- "toyeiei"
    password <- "1234"
    count <- 0 
    
    # get input from user
    while (count < 3) {
        un_input <- readline("Username: ")
        pw_input <- readline("Password: ")
        
        # check username, password
        if (username == un_input & password == pw_input) {
            print("Thank you! you have successfully login.")
            break
        } else {
            print("Sorry, please try again.")
            count <- count + 1
        }
    }
}

# 3.Data Types
## Data Types
## index in r start at 1

## character  
friends <- c("toy", "ink", "aan", "top", "wan")

## numeric
ages <- c(33, 30, 34, 28, 25)

# logical
movie_lover <- c(TRUE, TRUE, FALSE, T, F)

## create dataframe
length(friends)
df <- data.frame(friend_id = 1:5,
                 friends,
                 ages,
                 movie_lover,
                 jobs,
                 handsome_degree)

# 4.Factor
# nominal factor = ตัวแปรกลุ่มที่ไม่สามารถเรียงลำดับสูง-ต่ำได้
jobs <- c("data", "data", "digital", "digital", "phd")
jobs <- factor(jobs)
class(jobs)

# ordinal factor = ตัวแปรกลุ่มที่สามารถเรียงลำดับสูง-ต่ำได้
# จะสร้าง ordinal factor เราจะใช้ 2 ฟังก์ชั่น คือ level กับ ordered โดย ordered ทำให่สามารถเรียงแบบ ต่ำ กลาง สูง ได้
handsome_degree <- c("low", "medium", "high", "high", "high")
handsome_degree <- factor(handsome_degree,
                          levels = c("low", "medium", "high"),
                          ordered = TRUE)

# 5.Dataframe
## Create Dataframe
## การสร้าง Dataframe vectorที่จะใช้ต้องมีความยาวเท่ากัน เช็คด้วยคำสั่ง length()

lenghth(friends)
friends <- c("toy", "ink", "aan", "top", "wan")
ages <- c(33, 30, 34, 28, 25)
movie_lover <- c(TRUE, TRUE, FALSE, T, F)
jobs <- c("data", "data", "digital", "digital", "phd")
handsome_degree <- c("low", "medium", "high", "high", "high")

df <- data.frame( friend_id = 1:5,
				friends,
				ages,
				movie_lover,
				jobs,
				handsome_degree)

View(df) = ใช้สำหรับเรียกดู dataframe

## Write CSV file
write.csv(df, "friends.csv",
					row.names = FALSE) # ใช้สำหรับสั่งไม่ให้เอา rowname มาด้วย

## Read CSV file
friends <- read.csv("friends.csv")

## Read CSV file from internet
url <- "https://gist.githubusercontent.com/seankross/a412dfbd88b3db70b74b/raw/5f23f993cd87c283ce766e7ac6b329ee7cc2e1d1/mtcars.csv"

mtcars_df <- read.csv(url)

View(mtcars_df)

## subset dataframe by index
friends[1:3, ]
friends[1:3, 1:3]
friends[ , c(2, 4, 5)]

## subset dataframe by logic (base on condition)
friends[friends$ages < 30, 2:5]
friends[friends$movie_lover, 2:5]
friends[friends$jobs == "digital", ] # equal case
friends[friends$jobs != "digital", ] # not equal case

## subset with in operator
# %in% => in operator in R
friends[friends$jobs %in% c("data", "digital"), ]  

## subset by name (ใช้เมื่อรู้ชื่อ column)
friends[ , c("friends", "ages", "movie")]

cond1 <- friends$jobs == "data"
cond2 <- friends$movie_lover == TRUE

# หากมีหลายกรณีก็สสามารถเขียนต่อไปได้เรื่อยๆ
friends[cond1 & cond2, ] # and case
friends[cond1 | cond2, ] # or case

# statistic function
mean(friends$age)

ages <- friends$ages
mean(ages); median(ages); min(ages); max(ages); var(ages) 

# Create column
friends$segment <- ifelse(friends$ages >= 30, "Old", "Young")

# อยากนับว่ามีอย่างละกี่คน
# ฟังก์ชั่น table ใช้สำหรับสร้างตารางความถี่
# อยากรู้ว่ามีกี่คอลัมบ์กี่แถวให้ใช้คำสั่ง ncol กับ nrow

table(friends$segment)
table(friends$jobs)

ncol(friends)
nrow(friends)

#convert to probability
table(friends$segment)
table(friends$segment) / nrow(friends)

# Summarize data
summary(friends)

str(friends) # check structure dataframe


friends$jobs <- factor(friends$jobs)
friends$segment <- factor(friends$segment)

# หลัง convert แล้วจะมีความเปลี่ยนแปลงที่เป้นประโยชน์กับเรา
# การทำงานในชีวิตจริงการ clean data ใช้เวลาที่นานมาก โดยขั้นตอนแรกคือ การเช็ค data type ใน dataframe ก่อนว่าเป็น type ที่เหมาะสมหรือไม่ในการวิเคราะห์ข้อมูล
# เมื่อทำการ convert แล้วทุกอย่างยังเหมือนเดิมยกเว้น type ที่เปลี่ยนแปลงไป

str(friends) 
summary(friends)

## การ drop column

# method 1 (ใช้การ subset data ขึ้นมาใส่ใน dataframe ใหม่ โดยที่ dataframe เดิมยังอยู่)
friends_subset <- friends[ ,1:5]
friends_subset

# method 2 (assign null in column)
friends$handsome_degree <- NULL
friends$segment <- NULL

# 6.Regular Expression
## Use grep function
# ignore.case ใช้สำหรับยกเว้นให้สามารถค้นหาได้ทั้งตัวพิมพ์ใหญ่-พิมพ์เล็ก
# value ใช้สำหรับรีเทิร์นค่าออกมาเลย

grep("^S", state.name)
state.name[grep("^S", state.name)] # แสดงค่าออกมาเป็นตัวข้อมูล

grep("^s", state.name, ignore.case = TRUE)
state.name[grep("^s", state.name, ignore.case = TRUE)]

grep("^[ABS]", state.name, value = TRUE)

## Use grepl function
# สามารถ sum ค่าเวกเตอร์ได้

grepl("^S", state.name)

x <- grepl("^[ABS]", state.name)
sum(x) # สามารถนับจำนวนข้อมูลได้เลยว่า มีข้อมูลที่ต้องการเท่าไหร่

## gsub function (เหมือน REGXREPLACE ใน google sheet)

gusb("South", "Dragon", state.name)

# 7.Matrix
## Create Matrix
# จำนวน element ต้องมีความสอดคล้องกับ dimension

matrix(1:25, ncol=7)
matrix(1:25, ncol=7, byrow = TRUE)

m <- matrix(1:10, ncol=2)
nrow(m)
ncol(m)

m*2 # จะเป็นการนำค่าที่เราต้องการดำเนินการไป + - * / กับทุกจำนวนใน matrix

## matrix multiplication .dot notation
m1 <- matrix(c(1, 5, 3, 6), ncol=2)
m2 <- matrix(c(2, 4, 5, 5), ncol=2)

m1 + m2 # element wise computation
m1 %*% m2 # matrix multiplication

# 8.list
## Create list

john <- list(
				fullname  = "John Davis",
				age = 26,
				city = "London",
				email = "john.davis@gmail.com"
)

john
john["fullname"]
john$fullname # call value only

marry <- list(
				fullname  = "Marry Anne",
				age = 22,
				city = "Liverpool",
				email = "marry.anne@gmail.com"
)

# nested list (list in list)
customers <- list(john=john, marry=marry)
customers$john$fullname

kevin <- list(
				fullname  = "Kevin Herst",
				age = 25,
				city = "USA",
				email = "kevin.h@gmail.com"
				movies = c("Batman", "Dark Knight", "Dr.Strange")
) 

customers <- list(john=john, marry=marry, kevin=kevin)

customers$kevein$movies
customers$kevein$movies[1]
customers$kevein$movies[2]
customers [["kevin"]] # เทียบเท่าการใช้ $