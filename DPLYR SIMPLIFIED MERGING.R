directory<-getwd()
data_folder<- paste0(directory,"/data")

colours<- read.csv(paste0(data_folder,"/colors.csv"),as.is=TRUE,header=TRUE)
elements<- read.csv(paste0(data_folder,"/elements.csv"),as.is=TRUE,header=TRUE)
inventories<- read.csv(paste0(data_folder,"/inventories.csv"),as.is=TRUE,header=TRUE)
inv_minifig<- read.csv(paste0(data_folder,"/inventory_minifigs.csv"),as.is=TRUE,header=TRUE)
inv_parts<- read.csv(paste0(data_folder,"/inventory_parts.csv"),as.is=TRUE,header=TRUE)
inv_sets<- read.csv(paste0(data_folder,"/inventory_sets.csv"),as.is=TRUE,header=TRUE)
minifig<- read.csv(paste0(data_folder,"/minifigs.csv"),as.is=TRUE,header=TRUE)
part_cat<- read.csv(paste0(data_folder,"/part_categories.csv"),as.is=TRUE,header=TRUE)
part_rel<- read.csv(paste0(data_folder,"/part_relationships.csv"),as.is=TRUE,header=TRUE)
parts<- read.csv(paste0(data_folder,"/parts.csv"),as.is=TRUE,header=TRUE)
sets<- read.csv(paste0(data_folder,"/sets.csv"),as.is=TRUE,header=TRUE)
themes<- read.csv(paste0(data_folder,"/themes.csv"),as.is=TRUE,header=TRUE)

library(dplyr)

# consider sets data
# it contains "theme_id" column which corresponds to the "themes" dataset
# the theme_id variable lonks to id variable in themes db


##### "INNER_JOIN"
# it is like an intersection of two databases

sets_with_themes <- sets %>% inner_join(themes, by= c("theme_id" = "id"))
# this db now is the union of sets and themes where theme id is used to map to id
# since both db have "names" column, "x" and "y" are added to distinguish between them
# we can change this by
sets_with_themes <- sets %>% inner_join(themes, by= c("theme_id" = "id"),suffix= c("_sets","_themes"))

# we can now find the most common lego theme

sets_with_themes %>% count(name_themes,sort=TRUE) %>% rename( "count"="n")
#  name_themes   count
#1   Star Wars   769
#2        Gear   609
#3   Basic Set   555



### THIS WAS EASY BECAUSE EACH SET HAD ONE CORRESPONDING THEME
# IT GETS TRICKY IF THERE IS ONE-TO-MANY MAPPING
# consider inventories and sets db
# both have "set_num" but multiple versions , hence there will be increase in length of sets

sets_inv <- sets %>% inner_join(inventories,by=c("set_num"="set_num"))
# we can then filter it depending on the version we need

sets_inv %>% filter(version==5)


###### joining three or more tables
# we now want to join using "set_num" in sets to "set_num" in inventories and then
# "theme_id" of new table with "id" of themes
set_inv_theme<- sets %>% inner_join(inventories, by=("set_num"="set_num")) %>%
  inner_join(themes, by=c("theme_id"="id"),suffix=c("_sets","_themes"))

##### "LEFT_JOIN" 
# it keeps all obs in first table but only the common ones in the right table

##### "RIGHT JOIN"
# keeps all obs from right table and common ones from left table

sets %>% count(theme_id,sort=TRUE)
#    theme_id   n
#1        158 743
#2        501 609
#3        494 364

#this info is not very helpful without the theme names

sets %>% count(theme_id,sort=TRUE) %>% inner_join(themes,by=c("theme_id"="id"))
#theme_id   n      name parent_id
#1    158 743  Star Wars   NA
#2    501 609  Gear        NA
#3    494 364  Friends     NA

#this tells us that the most common theme is "star wars"
#but, this table is not complete. This is because it doesnt contain the themes that didnt
# occur in any set in the db

p <-sets %>% count(theme_id,sort=TRUE) %>% right_join(themes,by=c("theme_id"="id"))
# this would give the same o/p as above but would also inlcude the themes that didnt occur
# at the end of the table with n=NA

# we need to chnage these NA values to 0

library(tidyr)
p <-sets %>% count(theme_id,sort=TRUE) %>% right_join(themes,by=c("theme_id"="id")) %>% replace_na(list(n=0))
# this gives a complete table


#### "FULL_JOIN"
# it is the union between the two tables

inv_parts_joined<- inventories%>% inner_join(inv_parts, by=c("id" = "inventory_id")) %>%
  arrange(-quantity) %>% select(-id,-version)

batmobile<- inv_parts_joined %>% filter(set_num == "7784-1") %>%
  select(-set_num)
#        part_num color_id quantity is_spare
#1          3023       72       62        f
#2          2780        0       28        f
#3         50950        0       28        f
#4          3004       71       26        f

batwing<- inv_parts_joined %>% filter(set_num == "70916-1") %>%
  select(-set_num)
#        part_num color_id quantity is_spare
#1          3023        0       22        f
#2          3024        0       22        f
#3          3623        0       20        f
#4         11477        0       18        f

# we now want to see which parts are present in both and their quantities

batmobile %>% full_join(batwing, by=c("part_num","color_id"),suffix=c("_batmobile","_batwing"))
#         part_num color_id quantity_batmobile is_spare_batmobile quantity_batwing is_spare_batwing
#1          3023       72                 62                  f               NA             <NA>
#2          2780        0                 28                  f               17                f
#3         50950        0                 28                  f                2                f
#4          3004       71                 26                  f                2                f

#we can use replace_na for the above too


###### "SEMI_JOIN"
# it returns all rows from x where there are matching values in y, keeping just columns from x.

##### "ANTI_JOIN"
# it return all rows from x where there are not matching values in y, keeping just columns from x.

