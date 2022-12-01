# Data Tranformations

# 1.How to install package & Load
## install new package in RStudio
install.packages("dplyr")

## load library
library(dplyr)

# 2.load CSV file
## Read CSV file
imdb <- read.csv("imdb.csv", stringsAsFactors = FALSE)
View(imdb)

## function glimpse -> review data structure
glimpse(imdb)

## head & tail of data (dafault show 6 data in table)
head(imdb)
tail(imdb)

## show 10 data in table
head(imdb, 10) ## -> show 10 data in table
tail(imdb, 10)

# 3.Select Columns
## select columns
select(imdb, MOVIE_NAME, RATING)
select(imdb, 1, 5)
select(imdb, movie_name = MOVIE_NAME, released_year = YEAR)

## pipe operator (ไม่ควรใช้ไม่เกิน 7-8 สเต็ป)
imdb %>% 
 select(movie_name = MOVIE_NAME, released_year = YEAR)%>%
 head(10)

 # 4.filter numeric columns
 ## filter data
filter(imdb, SCORE >= 9.0)

imdb %>% filter(SCORE >= 9.0)

# tolower คือ เปลี่ยนชื่อเป็นตัวพิมพ์เล็กทั้งหมด เมื่อใช้จะทำให้เมื่อเรียกคอลัมบ์ไม่ต้องกด "shift" เพื่อพิมพ์ตัวใหญ่
names(imdb) <- tolower(names(imdb)) 
head(imdb)

## And Case ( & )
imdb %>%
  select(movie_name, year, score) %>%
  filter(score >= 9.0 & year > 2000)

## Or Case ( | )
imdb %>%
  select(movie_name, year, score) %>%
  filter(score == 8.8 | score == 8.3 | score == 9.0)

## IN operator
# IN operator (%IN%)
# %in% คือ score อยู่ในช่วงตัวนี้
imdb %>%
  select(movie_name, year, score) %>%
  filter(score %in% c(8.3, 8.8, 9.0)) 

# 5.filter string column
## Exact match case
imdb %>%
  select(movie_name, genre, rating)%>%
  filter(genre == "Drama")

## pattern matching case (use grepl)
imdb %>%
  select(movie_name, genre, rating)%>%
  filter( grepl("Drama", imdb$genre))

## ข้อควรระวัง
# grepl เป็นcase-sensitive ทำให้ The ไม่เท่ากับ the
# ต้องเลือกแค่ตัวใดตัวหนึ่ง

imdb %>%
  select(movie_name) %>%
filter (grepl("the", imdb$movie_name)) 

# 6.Mutate new columns (สร้างคอลัมบ์ใหม่) 
imdb %>%
  select(movie_name, score, length) %>%
  mutate(score_group = if_else(score >= 9, "High Rating", "Low Rating"),
         lenght_group = if_else(length >= 120, "Long Film", "Short Film"))

imdb %>%
  select(movie_name, score)%>%
  mutate(score = score + 0.1)%>%
  head(10)

# 7.Arrange Data (Sort data)
## asscending order
head(imdb)
imdb%>%
  arrange(length)%>%
  head(10)

## descending order
imdb%>%
  arrange(desc(length))%>%
  head(10)

## 2 column sort
imdb %>%
  arrange(rating, desc(length))

# 8.Summary Statistics and Group_by
imdb %>%
  filter(rating != "") %>% #filer blank out
  group_by(rating) %>%
  summarise(mean_length = mean(length),
            sum_length = sum(length),
            sd_length = sd(length),
            max_length = max(length),
            n =n())

# 9.Join Table
favourite_films <- data.frame(id = c(5,10, 25,30,98))

favourite_films %>%
  inner_join(imdb, by = c("id" = "no"))

# 10.write csv file (export result)
imdb_prep <- imdb %>%
  select(movie_name, released_year = year, rating, length, score) %>%
  filter(rating == "R"  & released_year > 2000)

# export file
write.csv(imdb_prep, "imdb_prep.csv", row.names = FALSE)