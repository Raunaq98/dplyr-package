songs <- data.frame(song = c("Across the Universe","Come Together","Hello,Goodbye","Peggy Sue"),
                  name=c("John","John","Paul","Buddy"))
#                 song  name
#1 Across the Universe  John
#2       Come Together  John
#3       Hello,Goodbye  Paul
#4           Peggy Sue  Buddy

artists <- data.frame(name=c("Geroge","John","Paul","Ringo"),plays=c("sitar","guitar","bass","drums"))
#     name  plays
#1 Geroge  sitar
#2   John guitar
#3   Paul   bass
#4  Ringo  drums


library(dplyr)

bind_cols(songs,artists)
#              song     name...2 name...3  plays
#1 Across the Universe     John   Geroge   sitar
#2       Come Together     John     John  guitar
#3       Hello,Goodbye     Paul     Paul   bass
#4           Peggy Sue    Buddy    Ringo   drums

bind_rows(songs,artists)
#               song       name  plays
#  1 Across the Universe   John   <NA>
#  2       Come Together   John   <NA>
#  3       Hello,Goodbye   Paul   <NA>
#  4           Peggy Sue  Buddy   <NA>
#  5                <NA> Geroge  sitar
#  6                <NA>   John guitar
#  7                <NA>   Paul   bass
#  8                <NA>  Ringo  drums


# this wont be the correct way to merge the two datasets
# we need to use the left_join() function

left_join(songs,artists,by= "name")   # preference to first dataframe
#           song         name  plays
#1 Across the Universe  John   guitar
#2       Come Together  John   guitar
#3       Hello,Goodbye  Paul   bass
#4           Peggy Sue  Buddy   <NA>

right_join(songs,artists,by="name")  #preference to second dataframe
#           song         name  plays
#1 Across the Universe   John guitar
#2       Come Together   John guitar
#3       Hello,Goodbye   Paul   bass
#4                <NA> Geroge  sitar
#5                <NA>  Ringo  drums

inner_join(songs,artists, by="name")        # union
#               song   name  plays
#1 Across the Universe John guitar
#2       Come Together John guitar
#3       Hello,Goodbye Paul   bass

full_join(songs,artists, by="name")        # intersection
#            song        name  plays
#1 Across the Universe   John guitar
#2       Come Together   John guitar
#3       Hello,Goodbye   Paul   bass
#4           Peggy Sue  Buddy   <NA>
#5                <NA> Geroge  sitar
#6                <NA>  Ringo  drums

semi_join(songs,artists, by="name")        # return all rows from x where there are matching values in y, keeping just columns from x.
#          song          name
#1 Across the Universe   John
#2       Come Together   John
#3       Hello,Goodbye   Paul

anti_join(songs,artists, by="name")        # return all rows from x where there are not matching values in y, keeping just columns from x.
#       song  name
#1 Peggy Sue Buddy