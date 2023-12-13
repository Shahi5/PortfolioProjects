library(tidyverse)
library(Hmisc)

# importing the data frame to a new file cov_data.
cov_data <- read.csv("covid19_data.csv")

# To view the entire data frame.
view(cov_data)

# Describing the data.
describe(cov_data)

# Cleaned the death column.
cov_data$death_dummy <- as.integer(cov_data$death != 0)

# Death rate
sum(cov_data$death_dummy) / nrow(cov_data)
# The death rate was found to be at 5.8%.

#AGE claim
#The people who died are older than the ones who survived.

# Making a dead and alive subset of the main data with specific condition.
dead <- subset(cov_data, death_dummy == 1)
alive <- subset(cov_data, death_dummy == 0)

# A histogram that shows the frequency of deaths in terms of age.
hist(dead$age)

# Finding the mean age of both dead and alive population.
mean(dead$age, na.rm = TRUE)
mean(alive$age, na.rm = TRUE)

# Mean age of the dead (68.58) is higher than those who survived (48.07).
# But is the result statistically significant?

t.test(alive$age, dead$age, alternative = "two.sided", conf.level = 0.99)
# Since the p-value is less than 0.05 we reject the null hypothesis.
# Hence, the hypothesis is statistically significant.

#Gender claim
# The survival or death from covid is not related to gender in any way.

#Making a subset of men and women population from the main data.
men <- subset(cov_data, gender == "male")
women <- subset(cov_data, gender == "female")

mean(men$death_dummy, na.rm = TRUE)
mean(women$death_dummy, na.rm = TRUE)

#The result is on average men have a 8.4% of death compared to 3.6% chance of women.
# Is the result statistically significant??

t.test(men$death_dummy, women$death_dummy, alternative = "two.sided", conf.level = 0.99)

# Since, the p-value is less than 0.05 so we reject the null hypothesis.
# Men have 0.8% to 8.8% more chance of dying from covid then women.

#Cleaned the recovered column.
cov_data$recovered_dummy <- as.integer(cov_data$recovered != 0)

#Recovery Rate
sum(cov_data$recovered_dummy) / nrow(cov_data)
# The recovery rate was found to be at 14.65%.

live <- subset(cov_data, recovered_dummy == 1)
depart <- subset(cov_data, recovered_dummy == 0)

# Age claim
# It is claimed that young people have higher recovery than old people.

#Getting the mean of both recovered and not recovered people. 
mean(live$age, na.rm = TRUE)
mean(depart$age, na.rm = TRUE)

#The average age for recovered is 42.21 and average age for not recovered is 51.
# But is the result statistically significant??

t.test(live$age, depart$age, alternative = "two.sided", conf.level = 0.99)

#Since the p-value is less than 0.05 we can reject the null hypothesis.
#So, we can say there is a age gap between the recovered and non recovered people.