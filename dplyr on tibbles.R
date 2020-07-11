URL <-"http://cran-logs.rstudio.com/2020/2020-07-09.csv.gz"
directory<- getwd()
destfile<- paste(directory,"/data.csv",sep="")
download.file(URL,destfile,method="curl")
data<- read.csv(paste0(directory,"/data.csv"),as.is = TRUE, header = TRUE)

complete<- complete.cases(data)
data<- data[complete,]
#       date     time    size   r_version r_arch    r_os  package  version   country ip_id
#5  2020-07-09 15:41:02    538     3.5.2 x86_64 linux-gnu  conquer   1.0.1      US     3
#25 2020-07-09 15:41:08 254064     3.4.3 x86_64 linux-gnu   tibble   3.0.2      KR    11
#35 2020-07-09 15:40:38 659235     3.5.3 x86_64 linux-gnu   crayon   1.3.4      US    15
#38 2020-07-09 15:41:15 254063     4.0.2 x86_64   mingw32   tibble   3.0.2      US    18
#39 2020-07-09 15:41:02 255593     4.0.2 x86_64   mingw32  usethis   1.6.1      GB    19
#44 2020-07-09 15:41:03 375767     4.0.2 x86_64   mingw32 devtools   2.3.0      GB    19

library(dplyr)

############## grouping

# if we want to work on the data in such a way that "package" is the main reference point, we can group it

data_package <- group_by(data, package)
# A tibble: 1,088,939 x 10
# Groups:   package [15,999]
#  date       time       size r_version r_arch r_os      package    version country ip_id
#    <chr>      <chr>     <int> <chr>     <chr>  <chr>     <chr>      <chr>   <chr>   <int>
#1  2020-07-09 15:41:02    538 3.5.2     x86_64 linux-gnu conquer    1.0.1   US          3
#2  2020-07-09 15:41:08 254064 3.4.3     x86_64 linux-gnu tibble     3.0.2   KR         11
#3  2020-07-09 15:40:38 659235 3.5.3     x86_64 linux-gnu crayon     1.3.4   US         15
#4  2020-07-09 15:41:15 254063 4.0.2     x86_64 mingw32   tibble     3.0.2   US         18
#5  2020-07-09 15:41:02 255593 4.0.2     x86_64 mingw32   usethis    1.6.1   GB         19
#6  2020-07-09 15:41:03 375767 4.0.2     x86_64 mingw32   devtools   2.3.0   GB         19
#7  2020-07-09 15:41:07  99120 4.0.2     i386   mingw32   glue       1.4.1   KR         11
#8  2020-07-09 15:41:10  43637 3.3.3     x86_64 linux-gnu purrr      0.3.4   GB         31
#9  2020-07-09 15:40:38 134542 4.0.2     x86_64 mingw32   commonmark 1.7     US         15
#10 2020-07-09 15:41:02    543 4.0.2     x86_64 mingw32   Rcpp       1.0.5   US          3
# … with 1,088,929 more rows

# mean size of each package

summarise(data_package,mean(size))
#  A tibble: 15,999 x 2
#    package     `mean(size)`
#   <chr>              <dbl>
#  1 A3                90786.
#  2 aaSEA           1578595.
#  3 AATtools         229121.
#  4 ABACUS           136167.
#  5 abbyyR          1763684.

# we want different summaries pertaining to grouped data
#

summary_package <- summarise(data_package, count = n(), unique = n_distinct(ip_id), 
                             countries= n_distinct(country), avg_bytes = mean(size))
# A tibble: 15,999 x 5
#  package        count unique countries avg_bytes
#  <chr>          <int>  <int>     <int>     <dbl>
#  1 A3              7      7         5    90786.
#  2 aaSEA           4      4         4  1578595.
#  3 AATtools        4      4         4   229121.
#  4 ABACUS          3      3         3   136167.
#  5 abbyyR          6      6         4  1763684.

# we want to see which packages were the most popular
# we isolate top 1% of the packages

quantile(summary_package$count, probs=0.99)
#    99% 
# 1211.14

#thus packages with 1211 or more counts will be in our top 1%

top_downloads <- filter(summary_package,count >1211)
# A tibble: 160 x 5
#   package    count unique countries avg_bytes
#    <chr>      <int>  <int>     <int>     <dbl>
#  1 abind       1228   1009        83    60010.
#  2 askpass     2811   1867       100   125824.
#  3 assertthat  3994   2630       106    41656.
#  4 backports   5844   3404       115    60706.
#  5 base64enc   3241   2156       100    33934.
# … with 155 more rows
# thus 160 such packages exist

# we now want to set them in the order of most downloads

top_downloads_sorted <- arrange(top_downloads,desc(count))
# A tibble: 160 x 5

#     package  count unique countries avg_bytes
#     <chr>    <int>  <int>     <int>     <dbl>
#  1 jsonlite 44968   3305       110  1062271.
#  2 fs       42715   2172        94   811517.
#  3 devtools 41751   1314        79   374287.
#  4 usethis  41517   1270        80   263640.
#  5 ggplot2  25723   3600       114  3147541.
#… with 155 more rows

# thus, "jsonlite" was downloaded the most

# if we want to see unique downloads, we would do the same process with the unique variable

#################### PIPING
# we couldve done the entire process like this too :

library(magrittr)
result <- data %>% group_by(package) %>%
  summarise(count = n(), unique= n_distinct(ip_id), countries = n_distinct(country, mean_size=mean(size))) %>%
    filter(count > 1211) %>%
      arrange(desc(count)) %>%
        print()
# A tibble: 160 x 4
#    package  count unique countries
#     <chr>    <int>  <int>     <int>
#  1 jsonlite 44968   3305       110
#  2 fs       42715   2172        94
#  3 devtools 41751   1314        79
#  4 usethis  41517   1270        80
#  5 ggplot2  25723   3600       114
  
