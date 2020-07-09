library(dplyr)

data<-airquality[1:20,]

temp<- airquality[1:20,]

head(data)
#       Ozone Solar.R Wind Temp Month Day
#   1    41     190   7.4   67     5   1
#   2    36     118   8.0   72     5   2
#   3    12     149  12.6   74     5   3
#   4    18     313  11.5   62     5   4
#   5    NA      NA  14.3   56     5   5
#   6    28      NA  14.9   66     5   6

fault<- complete.cases(data)
data<- data[fault,]

######## select()

ozone_data<- select(data,Ozone)
solar_data<- select(data, Solar.R)

new_data<- cbind(ozone_data,solar_data)

# or we couldve done

new_data_2<- select(data,Ozone,Solar.R)

# or

new_data_3 <- select(data,Ozone:Solar.R)

# or

new_data_4 <- select(data,-(Wind:Day))

###### filter()

month_5 <- filter(data, Month=="5")    # will filter out the data for month = 5

month_5_and_62_temp <- filter(data, Month== "5",Temp== "62")  # will filter out elements
                                            # belonging to month 5 and having 62 temp

month_5_OR_62_temp <- filter(data,Month=="5" | Temp=="62")  # union instead of intersection

month_5_and_windy <- filter(data, Month=="5", Wind >= 12 )


# can also use to filter out NAs from

corrected_ozone<- filter(temp,!(is.na(Ozone)))    # removed all NAs from Ozone col


##### arrange()

arrange(data,Ozone)   # arranged in ascending order of ozone

arrange(data, desc(Ozone))   # arranged in descending order of Ozone


##### mutate()

max_wind<-as.numeric(summarise(data,max(Wind)))
mutate(data,relative_wind_score=Wind/max_wind)

####### summarise()

summarise(data,max(Temp))
# [1] 74