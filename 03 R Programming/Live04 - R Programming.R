## Live 04 - R Programming
# 1.Basic Calculation
1+1
2*2
5-3
10-6

print("hello world")

# 2.Create & Remove Variables
# Create Variable
income <- 45000
expense <- 26000
saving <- income - expense
print(saving)

# Remove Variable
rm(expense)
rm(saving)

# 3.Create your own function
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

# 3.Control flow (if, for, while)
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

# 4.Username password Login application
# username password login application (Version 1)

login_fn <- function() {

		# set username password
			username <- "jirasinfinity"
			password <- "12345"

		# get input from user
			un_input <- readline("Username: ")
			pw_input <- readline("Password: ")

		# check username, password
			if (username == un_input && password == pw_input) {
					print("Thank you! you have successfully login.")
			} else {
					print("Sorry, please try again.")
			}
}