### Live 05 - Data Transformation (Data Wrangling)
## 1.Install & loading Package

# install packages
library(tidyverse) 
library(sqldf)
library(jsonlite)
library(RSQLite)
library(RPostgreSQL)
library(glue)

## 2.View dataframe , rownames and columnnames
## View dataframe mtcars
View(mtcars)

## View rowname and columnname
rownames(mtcars)
colnames(mtcars)

## 3.5 cores functions in dplyr
# 1. select() => SELECT
# 2. filter() => WHERE
# 3. arrange() => ORDER BY
# 4. mutate() => SELECT .. AS newColumn
# 5. summarise() + group_by()

# 1.select() => SELECT
select(mtcars, 1:5)

# 1.1 Use column index
select(mtcars, mpg, wt, hp, 10:11)

# 1.2 use regular expression
select(mtcars, starts_with("h"))
select(mtcars, ends_with("p"))
select(mtcars, contains("a")) # ขอให้มีอักษรตัวนั้นในชื่อ column ให้มันดึงมาให้เราเลย
select(mtcars, carb, everything()) # everything ใช้สำหรับดึงคอลัมบ์ที่เหลือซึ่งไม่ได้ประกาศชื่อออกมาใส่ต่อท้าย

# 1.3 Create new column (ย้าย rownames มาเป็น column)
mtcars$model <- rownames(mtcars) # สร้างคอลัมบ์ใหม่โดยนำ rownames มาเป็นคอลัมบ์
rownames(mtcars) <- NULL # ลบ rownames
mtcars <- select(mtcars, model, everything()) # เอาคอลัมบ์ model มาอยู่หน้าสุด

# 1.4 Build Data pipeline %>% (Pipe operator)
m1 <- mtcars %>%
    select(mpg, hp, wt) %>%
    filter(hp < 100 | wt < 2) %>% # เทียบเท่าการเขียน where clause ใน SQL
    arrange(desc(hp)) # เรียงตามคอลัมบ์ hp จากมากไปน้อย

summary(m1) # เราสามารถหาค่าสถิติของทุกคอลัมบ์ได้ได้เลย

# 2. filter() => WHERE
# 2.1 filter ข้อมูลที่เป็นตัวเลข
mtcars %>%
  select(model, mpg, hp, wt, am) %>%
  filter(mpg > 30) 

mtcars %>%
  select(model, mpg, hp, wt, am) %>%
  filter(mpg >= 25 & mpg <= 30) 

mtcars %>%
  select(model, mpg, hp, wt, am) %>%
  filter( between(mpg, 25, 30) ) # between

# 2.2 filter ข้อมูลที่เป็น factor
mtcars %>%
  select(model, cyl) %>%
  filter( cyl %in% c(6,8))

# 2.3 filter ข้อมูลที่เป็นอักษร
mazda_data <- mtcars %>%
  select(model, mpg, hp, wt, am) %>%
  filter(grepl("^Mazda", model))

mazda_data  # เรียกดูข้อมูล

# 3.arrange() => ORDER BY (Data Sorting)
mtcars %>% 
		arrange(desc(mpg)) %>%
		head()

# 4.mutate() => SELECT .. AS newColumn (Create new Column) 
## mutate() create new column

mtcars %>%
		select(model, mpg, hp, wt, am) %>%
		mutate(hello = 555)

mtcars %>%
    select(model, mpg, hp, wt, am) %>%
    mutate(hp_segment = if_else(hp<100, "low", "high")) %>%
    head(10)

# การ glimpse data structure
# ฟังก์ชั่น str() ใช้สำหรับดูโครงสร้างของ dataframe แต่เป็นฟังก์ชั่นแบบเก่าจึงดูยาก
# ฟังก์ชั่น glimpe() เป็นฟังก์ชั่นใน tidyverse ที่ใช้สำหรับดูโครงสร้างของdataframeเหมือนกันแต่ดูง่ายกว่า

## glimpse data structure
glimpse(mtcars)

## convert column am => 0=Auto, 1=Manual 

## Version 1
# เป็นการเขียนทับ column เดิมเลยเนื่องจากมีชื่อ column อยู่แล้วจะเป็นการ replace column 
mtcars %>%
	select(model, am) %>%
	mutate(am = if_else(am == 0, "Auto", "Manual"))%>%
	count(am) # นับรถแต่ละประเภทในคอลัมบ์ am

## Version 2
# เป็นการเขียนทับ column เดิมเหมือน Version 1
mtcars <- mtcars %>%
  mutate(am = if_else(am == 0, "Auto", "Manual"),
         vs = if_else(vs == 0, "V-Shaped", "Straight"))

View(mtcars)

## count column am , vs
mtcars %>%
  count(am)

mtcars %>%
  count(vs)

mtcars %>%
  count(am , vs)

nrow(mtcars)
ncol(mtcars)
dim(mtcars)

glimpse(mtcars)

# ในการเขียนโปรแกรมพยายามอย่า hard code ลงไปในโปรแกรมพยายามใช้ฟังก์ชั่นที่เรียก attribute หรือ ค่าที่เราต้องการ
m3 <- mtcars %>%
  count(am, vs) %>% # count หลายคอลัมบ์
  mutate(percent = n/ nrow(mtcars)) 

View(m3)

## Read-Write CSV Files
library(tidyverse)
write_csv(m3, "summary_mtcars.csv") # create csv file
m3 <- read_csv("summary_mtcars.csv") # read csv file

# convert data type
m3 <- as.data.frame(m3) # convert data type to dataframe
m3 <- as_tibble(m3) # convert data type to tibble

## Change Data Types
mtcars <- mtcars %>%
  mutate(vs = as.factor(vs),
         am = as.factor(am))

	glimpse(mtcars) # check data type vs, am

# 5.summarise() + group_by()=> GROUP BY in SQL
## summarise() + group_by()

mtcars %>%
  group_by(am) %>%     
  summarise(             
    avg_mpg = mean(mpg),
    sum_mpg = sum(mpg),
    min_mpg = min(mpg),
    max_mpg = max(mpg),
    var_mpg = var(mpg),
    sd_mpg  = sd(mpg),
    median_mpg = median(mpg),
    n = n()
)

mtcars %>%
  group_by(am, vs) %>%   # ก่อนทำการ sammarise ให้เราจับกลุ่มก่อน
  summarise(             # สรุปผลข้อมูลเทียบเท่าการ aggregate function in SQL
    avg_mpg = mean(mpg),
    sum_mpg = sum(mpg),
    min_mpg = min(mpg),
    max_mpg = max(mpg),
    var_mpg = var(mpg),
    sd_mpg  = sd(mpg),
    median_mpg = median(mpg),
    n = n() # นับจำนวน row ทั้งหมดใน dataframe (COUNT in SQL)
  )

## 4.Join table
## JOIN TABLES (use build-in dataframe)
band_members      # table 1 
band_instruments  # table 2

# inner join
inner_join(band_members,
           band_instruments,
           by = "name")

# left join
left_join(band_members,
          band_instruments,
          by = "name")

# right join
right_join(band_members,
          band_instruments,
          by = "name") 

# full join
full_join(band_members,
          band_instruments,
          by = "name")

## 5.Refactor code
## refactor (การเขียนโค้ดให้ดูง่ายมากยิ่งขึ้น)
# concept คือ พยายาม refactor code ให้มาอยู่ใน pipeline โดยมี maximum ไม่เกิน 8-10 data pipeline
# ถ้ามากกว่านั้น เราควรสร้างเป็น tmp data (ตัวแปรเก็บค่า intermediate step) ขึ้นมาก่อนแล้วค่อยใช้ tmp ไปสร้าง pipeline ใหม่
band_members %>%
    full_join(band_instruments, 
              by="name") %>%
    filter(name %in% c("John", "Paul")) %>%
    mutate(hello = "OK")

## 6.NYCflights13
## library load package
library(nycflights13)

glimpse(flights) # check data structure

flights %>%
	count(origin) # นับจำนวนไฟล์ทบินของแต่ละสนามบินในปี 2013

flights %>%
  filter(month == 9 , day == 15) %>% # filter เลือกเดือนที่ 9 , วันที่ 15
  count(origin) # จากแต่ละสนามบิน

flights %>%
  filter(month == 9) %>%
  count(origin, dest) # บินจากไหนและไปลงจอดที่ไหน

### Question to Analyst
### 1. in March-May 2013 (ตั้งแต่เดือน มีนาคม - พฤษภาคม 2013)
### 2. carriers most flights (สายการบินที่บินเยอะที่สุด)
### 3. origin == JFK (ออกจากสนามบิน JFK)
## คอลัมบ์ carrier คือ ชื่อสายการบิน
## เราจะแปลงคำถามจาก business user ไปเป็นโค้ดได้อย่างไร (เรื่องสำคัญมากกกก+++)
## ต้องฝึกฝนบ่อยๆถึงจะเก่ง ไม่สามารถสอนกันได้มาจากการลงมือทำ
## ต้องแม่น 5 cores functions + add-on function
## ใช้ left join เพื่อป้องกันข้อมูล(ชื่อ) สายการบินหายตอน join data (มักหายกรณีใช้ inner join)

df <- flights %>%
  filter(origin == "JFK" & month %in% c(3,4,5)) %>%  # ย่อขนาดของ table ก่อน
  count(carrier) %>% # ทำการนับจำนวน carrier
  arrange(desc(n)) %>% # sorting data จากมากไปน้อย
  left_join(airlines, by="carrier") # อยากทราบว่า carrier คือ สายการบินอะไร (ต้อง join ตาราง airline)

write_csv(df, "requested_data.csv")

## 7.การ Join เมื่อชื่อของ Column ไม่เหมือนกัน
## Mock up data

student <- data.frame(
    id = 1:5,
    name = c("toy","joe","anna","mary","kevin"),
    cid = c(1,2,2,3,2),    # cid = course_id
    uid = c(1,1,1,2,2)     # uid = uid in university table
)

course <- data.frame(
    course_id = 1:3,
    course_name = c("Data", "R", "Python")
)

university <- data.frame(
    uid = 1:2,
    uname = c("University of London", "Chula University")
)

## One-to-One

student %>%
    left_join(course, by = c("cid" = "course_id")) %>%
		filter(course_name == "R")%>%
		select(name, course_name)

## JOIN more than two tables

student %>%
    left_join(course, by = c("cid" = "course_id")) %>%
    left_join(university, by = "uid")%>%
		select(name, course_name, uname)

student %>%
    left_join(course, by = c("cid" = "course_id")) %>%
    left_join(university, by = "uid")%>%
		select(student_name = name,     # ตั้งชื่อให้คอลัมบ์เลย
					 course_name,
					 university_name = uname) # ตั้งชื่อให้คอลัมบ์เลย

## 8.Long → wideformat or wide → Longformat transformation
## ใช้ dataframe "WorldPhones"
## Wide -> Long format transformation
# rownames_to_column เป็นฟังก์ชั่นใน modern R

long_worldphones <- WorldPhones %>% 
    as.data.frame() %>%   # convert to dataframe
    rownames_to_column(var = "Year") %>% # convert rownames to column name as "year"
    pivot_longer(N.Amer:Mid.Amer,      # เลือกมาทุกคอลัมบ์ยกเว้น year
                 names_to = "Region",
                 values_to = "Sales")

long_worldphones %>%
  filter(Region == "Asia") # filter from long_worldphones

# หาผลรวมยอดขายแต่ละ Region
long_worldphones %>%
  group_by(Region) %>%  # จัดกลุ่มด้วย Region
  summarise(total_sales = sum(Sales)) # สรุปผลข้อมูลโดย sum(Sales) คือ ผลรวมของแต่ละ Region

## long -> wide format transformation
wide_data <- long_worldphones %>%
    pivot_wider(names_from = "Region",
                values_from = "Sales")

write_csv(wide_data, "data.csv")

## 9.Connect SQL database
## Connect SQL database
## 1. SQLite
## 2. PostgreSQL server
library(RSQLite)
library(RPostgreSQL)

## 3 steps to connect database
## create connection > query > close con

con <- dbConnect(SQLite(), "chinook.db") # create connection

dbListTables(con) # ดูว่าใน db มี tables อะไรบ้าง
dbListFields(con, "customers") # ดูว่าใน tables มี column อะไรบ้าง

dbGetQuery(con, "       # dbGetQuery ใช้สำหรับดึงข้อมูลที่ต้องการออกมาดู
         SELECT         # เขียน Query เป็นภาษา SQL เพื่อดึงข้อมูล
           firstname, 
           lastname, 
           country 
         FROM customers
         WHERE country 
           IN ('France', 'Austria','Belgium') ")

# coding Query to join table
# ในชีวิตจริงเราจะไม่ใช้ * ในการดึงข้อมูลแต่จะใส่ชื่อคอลัมบ์ที่เราต้องการลงไปเพื่อดึงข้อมูลออกมา
query01 <- "             # เขียน Query เพื่อ join table
  SELECT * FROM artists
  JOIN albums ON artists.artistid = albums.artistid
  JOIN tracks ON tracks.albumid = albums.albumid
"

# ดึงข้อมูลโดยใช้ Query ที่เราเขียนไว้แล้ว assign ค่าไว้ใน tracks
# เมื่อ Query ข้อมูลมาเก็บไว้ภายใน R ก็ไม่จำเป็นต้องใช้ SQL แล้วเพราะเข้ามาเป็น dataframe ใน R
tracks <- dbGetQuery(con, query01) 
View(tracks)

# สามารถใช้ dplyr ในการจัดการ data ก้อนนี้ได้
# ข้อดีของ R คือสามารถทำเป็นสเต็ปได้และสามารถเรียกดู preview ได้
# เขียน Query ดึงข้อมูลจาก db มาใส่ใน R แล้วใช้ dplyr ในการจัดการ dataframe
tracks %>%
    select(Composer, Milliseconds, Bytes, UnitPrice) %>%
    filter(Milliseconds > 200000,
           grepl("^C", Composer)) %>%
    summarise(
      sum(Bytes),
      sum(UnitPrice)
    )

# ปิด connection
dbDisconnect(con)
con   # เมื่อปิดการเชื่อมต่อต้องขึ้นสถานะ disconnected

## sample data n=10 (Random sample)
# ชื่อ column ห้ามซ้ำ ตอนดึงข้อมูลต้องใส่ชื่อคอลัมบ์เป๊ะๆเพื่อดึงเฉพาะข้อมูลที่เราอยากได้

library(janitor) # ติดตั้ง library janitor เพื่อช่วยให้เรา clean data ได้ง่ายขึ้น
tracks_clean <- clean_names(tracks) # function clean_names()จะไปจัดการกับคอลัมบ์ที่มีชื่อซ้ำ

set.seed(15)     # ใช้เพื่อล็อคค่าให้ออกมาเหมือนเดิมทุกครั้งที่รันโปรแกรม โดยถ้าเปลี่ยนตัวเลขผลลัพธ์ที่ได้ก็จะเปลี่ยนตามแต่ค่าก็จะถูกล็อคเอาไว้
tracks_clean %>%
    select(1:2) %>%
    sample_n(10)


### R connect to PostgreSQL (Remote Sever)
## username, password, host (server), port, dbname
library(RPostgreSQL)
con <- dbConnect(PostgreSQL(),
                 user = "yphzsabl",
                 password = "9dAsYYS3GDuHUT5sotuktE0yQ13EkRQv",
                 host = "rosie.db.elephantsql.com",
                 port = 5432,
                 dbname = "yphzsabl")

dbListTables(con)

## แบบที่ 1 : ฝากค่าในตัวแปรก่อนแล้วค่อยนำไปอัพโหลด
# สร้าง dataframe ขึ้นมาแล้วฝากค่าไว้ในตัวแปร "course" 
course <- data.frame(
  id = 1:3,
  name = c("Data Science", "Software", "R")
)

# ใช้ตัวแปร "course" อัพโหลดส่ง dataframe ขึ้นไปบน PostgreSQL (PostgreSQLจะสร้างคอลัมบ์ rownames ให้อัตโนมัติ)
dbWriteTable(con, "course", course)
dbListTables(con)

# ดึงข้อมูลจาก dataframe "course"
dbGetQuery(con, "select * from course;")

# ลบ dataframe "course" + check
dbRemoveTable(con, "course")
dbListTables(con)

## แบบที่ 2 : ใช้การเขียนโค้ดสร้าง dataframe ขึ้นมาแล้วอัพโหลดเลย
# เขียนโค้ดสร้าง dataframe ขึ้นมา และ อัพโหลดขึ้นไปบน PostgreSQL เลย 
# ใช้คำสั่ง row.names = FALSE ทำให้ไม่มีคอลัมบ์ rownames

dbWriteTable(con, "course", data.frame(
		id = 1:5,
		course_name = c("Data", "Design", "Design", "R", "SQL")
), row.names = FALSE)

# ดึงข้อมูลจากตาราง course โดยครั้งนี้จะไม่มีคอลัมบ์ rownames ขึ้นมา
dbGetQuery(con, "select * from course;") 

# ปิด connection
dbDisconnect(con)
con # เมื่อปิดการเชื่อมต่อต้องขึ้นสถานะ PostgreSQLConnection 