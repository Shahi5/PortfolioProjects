# Data structure and types of variables.

library(tidyverse)

data()

view(msleep)

glimpse(msleep)

head(msleep)

class(msleep$name) #code to know the class of the variable.

length(msleep) # to know the number of variables in the data frame.

length(msleep$name) # to know the number of entries in the name variables.

names(msleep) # all the variable names in the data frame.

unique(msleep$vore) # to observe all the unique values in a column.

missing <- !complete.cases(msleep) # creating an object to get all missing data rows.

msleep[missing,] # to show all the rows with missing data.

# Describing the data

view(msleep)

# Range/Spread

min(msleep$awake)
max(msleep$awake)
range(msleep$awake)
IQR(msleep$awake)

# Centrality

mean(msleep$awake)
median(msleep$awake)

#Variance

var(msleep$awake)

summary(msleep$awake)

msleep %>% 
  select(awake, sleep_total) %>% 
  summary()

msleep %>% 
  drop_na(vore) %>% 
  group_by(vore) %>% 
  summarise(Lower = min(sleep_total),
            Average = mean(sleep_total),
            Upper = max(sleep_total),
            Difference =
              max(sleep_total)-min(sleep_total)) %>% 
  arrange(Average) %>% 
  view()

#Create tables with specific values.

table(msleep$vore)

msleep %>% 
  select(vore, order) %>% 
  filter(order %in% c("Rodentia", "Primates")) %>% 
  table()
