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

gapminder %>% select(year:pop)

gapminder %>% select(contains("p"))
#   lifeExp     pop gdpPercap
#    <dbl>    <int>     <dbl>
#1    28.8  8425333      779.
#2    30.3  9240934      821.
#3    32.0 10267083      853.

gapminder %>% select(starts_with("c"))
#   country     continent
#   <fct>       <fct>    
#1 Afghanistan Asia     
#2 Afghanistan Asia     
#3 Afghanistan Asia     

gapminder%>% select(last_col())
#   gdpPercap
#      <dbl>
#1      779.
#2      821.

gapminder %>% select(-(continent:pop))
#   country     gdpPercap
#  <fct>           <dbl>
#1 Afghanistan      779.
#2 Afghanistan      821.
#3 Afghanistan      853.



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

gapminder %>% group_by(country) %>% summarise(mean(lifeExp)) %>% ungroup()
# A tibble: 142 x 2
# country     `mean(lifeExp)`
# <fct>                 <dbl>
# 1 Afghanistan            37.5
# 2 Albania                68.4
# 3 Algeria                59.0
# 4 Angola                 37.9
# 5 Argentina              69.1

# we can group_by multiple vsriables as well
gapminder %>% group_by(year,continent) %>% summarise (mean(lifeExp)) %>% ungroup()
#     year continent `mean(lifeExp)`
#   <int> <fct>               <dbl>
#1  1952 Africa               39.1
#2  1952 Americas             53.3
#3  1952 Asia                 46.3
#4  1952 Europe               64.4
#5  1952 Oceania              69.3
#6  1957 Africa               41.3
# ....

# when you use group_by with summarise, there is no addition of new column
# for that purpose, we use group_by + mutate



##### "COUNT" VERB

gapminder %>% count(continent)
#  continent     n
#   <fct>     <int>
#1 Africa      624
#2 Americas    300
#3 Asia        396
#4 Europe      360
#5 Oceania      24

gapminder %>% count(continent, sort=TRUE)
#  continent     n
#  <fct>     <int>
#1 Africa      624
#2 Asia        396
#3 Europe      360
#4 Americas    300
#5 Oceania      24

gapminder %>% count(continent,wt=pop, sort=TRUE)
# continent           n
#  <fct>           <dbl>
#1 Asia      30507333901
#2 Americas   7351438499
#3 Africa     6187585961
#4 Europe     6181115304
#5 Oceania     212992136


####### "TOP_N" VERB
# returns the exreme observations

gapminder %>% top_n(1,pop)
# 1 China   Asia       2007    73.0 1318683096     4959.

gapminder %>% group_by(year) %>% summarise(total_pop=sum(pop)) %>% top_n(3,total_pop)
#    year  total_pop
#   <int>      <dbl>
#1  1997 5515204472
#2  2002 5886977579
#3  2007 6251013179

gapminder %>% group_by(continent) %>% top_n(1,lifeExp)
#  country   continent  year lifeExp       pop gdpPercap
#   <fct>     <fct>     <int>   <dbl>     <int>     <dbl>
#1 Australia Oceania    2007    81.2  20434176    34435.
#2 Canada    Americas   2007    80.7  33390141    36319.
#3 Iceland   Europe     2007    81.8    301931    36181.
#4 Japan     Asia       2007    82.6 127467972    31656.
#5 Reunion   Africa     2007    76.4    798094     7670.



##### "RENAME" VERB
# it is used to rename columns

gapminder %>% rename(GDP_percap = gdpPercap)
# country     continent   year   lifeExp      pop    GDP_percap

gapminder %>% select( country, continent, year, GDP_percap = gdpPercap)
# renaming inside the select verb



###### "TRANSMUTE" VERB
# it is a combination of select and mutate

gapminder %>% transmute(country, continent,total_GDP = gdpPercap*pop/1000000)
# country     continent   total_GDP
#  <fct>       <fct>         <dbl>
#1 Afghanistan Asia          6567.
#2 Afghanistan Asia          7585.
#3 Afghanistan Asia          8759.


######## "WINDOW" FUNCTION

v<- c(1,3,6,14)
# [1]  1  3  6 14
lag(v)
# [1] NA  1  3  6


gapminder_fraction <- gapminder %>% filter(continent=="Asia") %>% group_by(year) %>%
  mutate(gdp_total=sum(gdpPercap)) %>% ungroup() %>% mutate(gdp_fraction = gdpPercap/gdp_total) %>%
  mutate(cons_diff = gdp_fraction-lag(gdp_fraction))
gapminder_fraction

library(ggplot2)
ggplot(gapminder_fraction,aes(x=year,y=cons_diff,colour=country)) +geom_line()
