library(gapminder)
library(dplyr)

## dplyr package is used to work on data frames, especially tibbles
## its functions are known as "verbs"
## these are : filter , arrange and mutate

gapminder
#tibble [1,704 × 6] (S3: tbl_df/tbl/data.frame)
#$ country  : Factor w/ 142 levels "Afghanistan",..: 1 1 1 1 1 1 1 1 1 1 ...
#$ continent: Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 3 3 3 3 3 3 ...
#$ year     : int [1:1704] 1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
#$ lifeExp  : num [1:1704] 28.8 30.3 32 34 36.1 ...
#$ pop      : int [1:1704] 8425333 9240934 10267083 11537966 13079460 14880372 12881816 13867957 16317921 22227415 ...
#$ gdpPercap: num [1:1704] 779 821 853 836 740 ...


###### "SELECT" VERB
# it is used to subset particular rows from the original df

gapminder %>% select(year,country)
# prints a new df with year and country columns



###### "FILTER" VERB
# it is used to take a subset of the data frame based on a certain condition

gapminder %>% filter(year == 2007) 
# getting obervations for only 2007

gapminder %>% filter( year==2007, country=="United States")
# getting observations for USA 2007



###### "ARRANGE" VERB
# it is used to sort observations in the dataset based on certian conditions 

gapminder %>% filter(year == 2007) %>% arrange(gdpPercap)
# observations of 2007 arranged for increasing order of gdp value

gapminder %>% filter(year == 2007) %>% arrange(desc(gdpPercap))
# OR
gapminder %>% filter(year == 2007) %>% arrange(-gdpPercap)
# for descending order



###### "MUTATE" VERB
#it is used to make changes or add new variables to the existing df

gap_data <- gapminder
gap_data %>% mutate( pop = pop/100000) %>% arrange(-pop)
# population now in millions and then sorted in descending manner

gap_data %>% mutate( GDP = gdpPercap*pop) %>% mutate(GDP=GDP/100000)
# total gdp now in million dollars

gap_data %>% mutate( GDP = gdpPercap*pop) %>% mutate(GDP=GDP/100000) %>% 
  filter(year ==2007) %>% arrange(-GDP)


###### "SUMMARISE" VERB
# it is used to generally make inferences from the df

gapminder %>% summarise(max(year))
# [1] 2007

gapminder %>% summarise(mean(lifeExp))
# [1] 59.5


###### "GROUP_BY" VERB
# it is used to make virtual groups that are generally used to make summaries

gapminder %>% summarise(mean(lifeExp))
# [1] 59.5

gapminder %>% group_by(country) %>% summarise(mean(lifeExp))
# A tibble: 142 x 2
# country     `mean(lifeExp)`
# <fct>                 <dbl>
# 1 Afghanistan            37.5
# 2 Albania                68.4
# 3 Algeria                59.0
# 4 Angola                 37.9
# 5 Argentina              69.1
