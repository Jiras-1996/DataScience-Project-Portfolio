### Data Visualization with R
# Install & Import tidyverse library
install.packages("tidyverse")
library(tidyverse)

## 1.Base R graph
# Histogram
hist(mtcars$mpg)

## analyzing hourse power
# histogram - One Quantitative Variable
mean(mtcars$hp)   # หาค่า Mean
median(mtcars$hp) # หาค่า Median
hist(mtcars$ hp)  # สร้าง Histogram

# Bar Plot
## Prepare data mtcars$am
str(mtcars)
mtcars$am <- factor(mtcars$am,
                    level  = c(0,1),
                    labels = c("Auto", "Manual"))

## Bar plot - One Qualitative Variable
barplot(table(mtcars$am))

# Box Plot
## Box Plot 1 Variable
fivenum(mtcars$hp) # fivenum 
min(mtcars$hp) # min
quantile(mtcars$hp, probs = c(.25, .5, .75)) # Q1-3 
max(mtcars$hp) # max

boxplot(mtcars$hp) # Box plot

## Whisker Calculation
# Calculation
Q3 <- quantile(mtcars$hp, probs = .75)
Q1 <- quantile(mtcars$hp, probs = .25)
IQR_hp <- Q3 - Q1

Q3 + 1.5*IQR_hp # แขนด้านบน  
Q1 - 1.5*IQR_hp # แขนด้านล่าง

# function boxplot.stats & filter out outliers

# function boxplot.stats
boxplot.stats(mtcars$hp, coef = 1.5)

## filter out outliers
mtcars_no_out <- mtcars %>%
  filter(hp<335)

boxplot(mtcars_no_out$hp)

## Box Plot 2 Variables
# Qualitative x Quantitative
# use function "data" to load original data built-in
data(mtcars)
mtcars$am <- factor(mtcars$am,
                    level  =c(0,1),
                    labels = c("Auto", "Manual"))
boxplot(mpg~ am, data =mtcars,
        col = c("gold", "salmon"))

# Scatter Plot
# 2 x Quantitative
plot(mtcars$hp, mtcars$mpg, pch = 16, 
     col= "blue",
     main = "My first Scatter plot",
     xlab = "Hourse Power", 
     ylab = "Miles Per Gallon")

# ค่า Correlation 
cor(mtcars$hp, mtcars$mpg)

# Linear Regression
lm(mpg ~ hp, data = mtcars)

## 2.Intro to ggplot2
# my first plot ggplot2
ggplot(data = mtcars, mapping = aes(x = hp, y = mpg)) +
  geom_point() + 
  geom_smooth()+
  geom_rug()

# Scatter plot
ggplot(mtcars, aes(hp, mpg))+
  geom_point(size = 3, col ="Blue", alpha = 0.2)

# Scatter plot
ggplot(mtcars, aes(hp, mpg))+
  geom_point(size = 3, col ="Blue", alpha = 0.2)

# Box plot
ggplot(mtcars, aes(hp))+
  geom_boxplot()

## ได้ผลลัพธ์เหมือนด้านบน
# ฝากค่า ggplot ส่วน data ไว้ใน variable แล้วค่อยสร้าง layer พล็อตกราฟ
p <- ggplot(mtcars, aes(hp))
p+geom_histogram(bins= 10)
p+geom_density()
p+geom_boxplot()

## 3. Advance ggplot2
# Box plot by groups
diamonds %>%
  count(cut)

ggplot(diamonds, aes(cut))+
  geom_bar(fill = "#0366fc")
  
# fill = cut
ggplot(diamonds, mapping = aes(cut, fill = cut))+
  geom_bar()

# fill = color
ggplot(diamonds, mapping = aes(cut, fill = color))+
  geom_bar()

# bar plot
# รูปแบบของการพล็อตกราฟ
ggplot(diamonds, mapping = aes(cut, fill =color))+
  geom_bar(position = "fill")

ggplot(diamonds, mapping = aes(cut, fill =color))+
  geom_bar(position = "stack")

ggplot(diamonds, mapping = aes(cut, fill =color))+
  geom_bar(position = "dodge")

# Scatter Plot
set.seed(99)
small_diamond <- sample_n(diamonds, 5000)

ggplot(small_diamond, aes(carat, price)) +
  geom_point()

# Facet (Small Multiple)
## ~color คือ ซอยข้อมูลย่อยตาม color 
## ncol = จำนวนคอลัมบ์
## method = "lm" คือ ให้สร้างเส้นแบบเส้นตรง
## theme_minimal = ให้แสดงผลแบบเรียบง่ายที่สุด

ggplot(small_diamond, aes(carat, price)) +
  geom_point() +
  geom_smooth(method = "lm", col = "red") +
  facet_wrap(~color, ncol = 2) +
  theme_minimal() +
  labs(title =  "Relationship between carat and price by color",
       x="carat",
       y= "price USD",
       caption = "Source: Diamonds from ggplot2 package")

## Final Example
# alpha = 0.2 คือ ความจาง 

ggplot(small_diamond, aes(carat, price, col=cut)) +
  geom_point(size = 3, alpha =0.2) +
facet_wrap(~ color, ncol = 2)+
  theme_minimal()