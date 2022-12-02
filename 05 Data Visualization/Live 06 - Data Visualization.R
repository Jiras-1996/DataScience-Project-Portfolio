### Live 06 - Data Visualization
## 1.Important STEPS before data Visualization
# clean data → pipeline → case when → date

## 2.Import tidyverse library
# install packages "tidyverse" 
install.packages(c("tidyverse"))

# import package "tidyverse"
library(tidyverse)

## 3.Data pipeline in R
# Create data pipeline
# rownames_to_column ใช้เปลี่ยน rownames เป็น Column
mtcars <- mtcars%>%
  rownames_to_column()%>%
  rename(model = rowname)%>%
  as_tibble()

## 4.Remove Missing Value
# 1.remove NA
numbers <- c(35,25,50,NA,5)
is.na(numbers)

# filter with column index 
numbers[c(1:3,5)]

# filter เฉพาะตัวที่ไม่ใช่ NA (!is.na)
numbers[ !is.na(numbers)]

# หาค่า aggregate function (average , sum , min , max , count)
numbers[ !is.na(numbers)]%>% sum()
numbers[ !is.na(numbers)]%>% mean()
numbers[ !is.na(numbers)]%>% sd()

# 2.use na.rm = TRUE
sum(numbers, na.rm = TRUE)
mean(numbers, na.rm = TRUE)

## 5.Clean Data msleep
# เรียกดู dataframe msleep
glimpse(msleep)

## How many row have NA?
x <- complete.cases(msleep) # ใช้ complete.cases หาว่า rows ไหนมีข้อมูลที่สมบูรณ์ 
sum(x); sum(!x) # จำนวนของ missing Value [sum(x)] และ Non-Missing Value [sum(!x)]
nrow(msleep) # Total Value(แถวทั้งหมด)

## filter only NA rows

# filter row ที่มี NA ขึ้นมาอย่างน้อย 1 ค่า
msleep %>%
  filter(!complete.cases(.)) # Use ". to represent msleep

# filter missing value ใน column
msleep %>%
  filter(is.na(conservation))

msleep %>%
  filter(is.na(sleep_rem))

# Mean/Median Imputation (Replace NA)
# 1. find Mean/Median value
avg_sleeprem <- msleep %>%
  summarise(mean(sleep_rem, na.rm = T))%>%
  pull()%>%
  round(2)

# 2. replace NA with Mean/Median
clean_msleep <- msleep %>%
  mutate(clean_sleep_rem = replace_na(sleep_rem, avg_sleeprem))%>% 
  glimpse()

# Mode Imputation
# Count function
msleep %>%
  count(vore) %>%
  mutate(pct = n/sum(n) * 100) %>%
  arrange(desc(pct))

# Mode Imputation
msleep2 <- msleep %>%
  mutate(clean_vore = replace_na(vore,
                                 "herbi")) %>%
  select(name, genus, vore, clean_vore)

## 6.Replace NA with Conditional means (case when())
## Replace NA with Conditional means
avg_sleep_by_vore <- msleep %>%
  group_by(vore) %>%
  summarise(avg_sleeprem = mean(sleep_rem, na.rm = TRUE))

avg_sleep_by_vore

# case when() conditional means [version1 เขียน case when แบบหลายเงื่อนไข]
clean_msleep <- msleep %>%
  select(vore, sleep_rem) %>%
  mutate(clean_msleep_rem = case_when(
    is.na(sleep_rem) & vore == "carni"   ~ 2.29,
    is.na(sleep_rem) & vore == "herbi"   ~ 1.37,
    is.na(sleep_rem) & vore == "insecti" ~ 3.52,
    is.na(sleep_rem) & vore == "omni"    ~ 1.96,
    is.na(vore) ~ 1.88,
    TRUE ~ sleep_rem
  ))

clean_msleep

# Use left join [version2]
# เทคนิคขั้นสูง: เวลาทำงานจริงเรามี data original ให้เราสร้างเป็น data Summary ขึ้นมา ถ้าเกิดมี keys เหมือนกันให้เราดึงมา join กัน
# จากตัวอย่าง sleep_rem คือ data original ส่วน avg_sleeprem คือ data Summary

msleep %>% 
  left_join(avg_sleep_by_vore, by = "vore")%>%
  select(vore, sleep_rem, avg_sleeprem)

msleep %>% 
  left_join(avg_sleep_by_vore, by = "vore")%>%
  select(vore, sleep_rem, avg_sleeprem) %>%   # ดึงเฉพาะคอลัมบ์ที่ต้องใช้
  mutate(clean_sleep_rem = if_else(           # สร้างคอลัมบ์ clean_sleep_rem
    is.na(sleep_rem),avg_sleeprem, sleep_rem  # ถ้าเป็น NA ให้ดึงคอลัมบ์ avg_sleeprem แต่ถ้าไม่ดึง sleep_rem
  ))

## 7.Working with date
install.packages("lubridate")

#import library
library(lubridate)
library(tidyverse)

#มาตรฐาน ISO-8601  
## ymd()
mydate <- c(
  "2022-06-30", 
  "2025-07-15",
  "2024-12-31"
)

## Check class mydate
ymd(mydate) %>% class()

# mdy()
mydate2 <- c(
  "12-31-2022", 
  "11-30-2025",
  "02-25-2022"
)

## Check class mydate2
mdy(mydate2) %>% class()

# Extract day/month/year
mdy(mydate2) %>% 
  day()

mdy(mydate2) %>% 
  month(label = TRUE, abbr = FALSE)

# dmy()
dmy(c("25-05-2022",
      "25 May 2022",
      "25-May-2022",
      "25/ MAy/2022")) %>% day
# ymd_hms()
ymd_hms(c(
  "2022-05-25 10:11:25",
  "2022 May 25th, 10hour 11 min 25seconds"
))

# work with dataframe 
df <- data.frame(
  id = 1:5,
  date = c("25-05-2022",
           "25 May 2022",
           "25-May-2022",
           "25/ May/ 2022",
           "25 || May || 2022")
)

df %>% 
  mutate(date = dmy(date),
         day = day(date),
         month = month(date, label = TRUE),
         year = year(date))

## 8.data visualization
# import library tidyverse
library(tidyverse)

## basic ggplot2 (grammar of graphics)
# histogram 
ggplot(data = mtcars, 
       mapping = aes(x = mpg))+
  geom_histogram(bins = 10, fill = "gold")

# density plot
ggplot(data = mtcars, 
       mapping = aes(x = mpg))+
  geom_density()

# scatter plot
myplot <- ggplot(data = mtcars, 
       mapping = aes(x = wt, y = mpg)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  geom_rug() +
  theme_minimal()

# Highlight specific data
# split data into 2 dataframes
df1 <- mtcars %>% filter(wt < 5)   # filter data wt < 5
df2 <- mtcars %>% filter(wt >= 5)  # filter data wt >= 5

# การพล็อตกราฟแบบ 2 ตัวแปร
ggplot()+
    geom_point(data = df1,
               mapping = aes(wt, mpg),
               color ="red", size = 3) +
    geom_point(data = df2,
               mapping = aes(wt, mpg),
               color ="blue", size = 3)

# customization
## change data type
mtcars <- mtcars %>%
    mutate(am = factor(am, 
                       levels = c(0,1),
                       labels = c("Auto", "Manual")))

mtcars <- mtcars %>%
    mutate(vs = factor(vs,
                       levels = c(0,1),
                       labels = c("V-Shaped", "Straight")))

# Create chart
# col= am คือ mapping คอลัมบ์ am ไปเป็นสีของ chart
# labs ใช้สำหรับการตกแต่ง chart เช่น title , subtitle , caption , x , y
ggplot(data = mtcars,
       # mapping
       mapping =aes(x= wt, 
                    y= mpg, 
                    col= am,
                    size= hp))+
    # setting
    geom_point(alpha= 0.8) + 
    theme_minimal() +
    labs(
        title = "Scatter plot Weight x MPG",
        subtitle = "We found negative correlation between two variables",
        caption = "Data Source : R Studio 2022",
        x = "Weight (Tonne)",
        y = "Miles Per Gallon"
    )

# Diamonds built-in dataset
library(tidyverse)

View(diamonds)

### EDA => Exploratory Data Analysis

## helper function
# qplot histogram
qplot(price, data=diamonds, 
      geom="histogram",
      bins=100)

## normal form
ggplot(data = diamonds,
			 mapping = aes(x = price)) +
	geom_histogram()

# qplot density
qplot(price, data=diamonds, 
      geom="density")

## Overplotting (จุดที่ใช้ในการพล็อตมีมากเกินไป ทำให้มองไม่เห็นว่า data กระจุกตัวอยู่ตรงไหน)
# แก้ไขเบื่องต้นได้โดยการปรับค่า  alpha ให้น้อยลง หรือ ใช้การ random ตัวอย่างแล้วพล็อตสร้างกราฟออกมา(ตัวอย่างถัดไป)

qplot(x=carat, 
      y=price,
      data=diamonds,
      geom="point",
      alpha = 0.1)

## normal form
ggplot(diamonds, aes(carat, price)) +
  geom_point(alpha = 0.05)

### random data in dplyr (สุ่มตัวอย่างแก้ปัญหา Overplotting)

## sample_n functions
set.seed(42) # lock result จาก sample_n
diamonds %>%
  sample_n(2000) %>% # random sample 2000
  ggplot(aes(x=carat, y=price)) +
  geom_point(alpha = 0.3)

## sample_frac functions
# รับค่าเป็นเปอร์เซ็นต์ เช่น 0.05 คือ 5 เปอร์เซ็นต์
set.seed(42) # lock result 
diamonds %>%
  sample_frac(0.05) %>% # random 5% from datasets 
  ggplot(aes(x=carat, y=price)) +
  geom_point(alpha = 0.3)

# Facet ggplot
ggplot(diamonds %>% sample_n(10000),
       aes(carat, price, col=cut)) +
  geom_point(alpha=0.5) +
  facet_wrap(~cut, ncol=2) + # แบ่งกราฟออกตามตัวแปร cut ของ diamonds
  theme_minimal()

## Facet Grid => มากกว่า 1 dimension
# cut มีตัวแปรทั้งหมด 5 กลุ่ม ส่วน clarity มีตัวแปรทั้งหมด 8 กลุ่ม
ggplot(diamonds %>% sample_n(10000),
       aes(carat, price, col=cut)) +
  theme_minimal() +
  geom_smooth(col="red") +
  geom_point(alpha=0.5) +
  facet_grid(clarity ~ cut) # แบ่งกราฟออกตามตัวแปร clarity(แกนx) กับ cut(แกนy) ของ diamonds

# Bar Chart 
## Bar Chart => ใช้ในกรณีที่เป็น 1 ตัวแปร แบบ Factor
# position แบบต่างๆ เช่น dodge , fill , stack , identity
ggplot(diamonds, aes(cut,fill=color)) +
  geom_bar(position = "fill") + # ใช้ position เป็น fill(เหมาะกับการโชว์เป็นเปอร์เซ็นต์)
  theme_minimal()

# Change Manual Color
mtcars <- mtcars %>%
  mutate(am = factor(am,
                     levels=c(0,1),
                     labels=c("Auto", 
                              "Manual")))
glimpse(mtcars)

# plot chart
ggplot(mtcars, 
       aes(wt, mpg, col=am)) +
  geom_point(size=5, alpha=0.8) +
  theme_minimal() +
  scale_color_manual(
    values = c("gold","#5c4cc0")) # ใช้สำหรับกำหนดสี

# Base layer
## create base layer
p1 <- ggplot(mtcars, aes(wt, mpg)) +
  theme_minimal()

# create scale_color_gradient plot from mtcars
p1 +
  geom_point(mapping=aes(col=hp), 
             size=5) +
  scale_color_gradient(low="gold",
                       high="red")

## back to diamonds
# create scale_fill_manual plot from diamonds

ggplot(diamonds, aes(color, fill=color)) +
  geom_bar() +
  scale_fill_manual( # ใช้เติมสีแบบ manaul
    values = c("red", 
               "blue", 
               "gold",
               "violetred", 
               "tan3", 
               "steelblue" , 
               "slateblue3"))

# Create chart with ggthemes
## install Package "ggthemes"
install.packages("ggthemes")

## load ggthemes
library(ggthemes)
library(tidyverse)

# create chart with gg themes
diamonds %>%
    sample_n(2000) %>%
    ggplot(aes(carat, price,col=cut)) +
    geom_point(alpha=0.5) +
  theme_fivethirtyeight() # เลือกธีมสำหรับใช้ใน ggthemes 

# Create chart with plotly
# install & load Package "plotly"
install.packages("plotly")
library(plotly)

# insert value into variable
myplot <- diamonds %>%
    sample_n(2000) %>%
    ggplot(aes(carat, price,col=cut)) +
    geom_point(alpha=0.5) +
  theme_fivethirtyeight()  

# create chart with plotly
ggplotly(myplot)