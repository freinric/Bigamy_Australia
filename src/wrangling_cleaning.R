## .R in case needs to run specific file. This will be updated to reflect changes. I use the .Rmd foremost as it is easier to explore cleaning needs.
library(readr)
library(anytime)
library(stringr)
library(ggplot2)
library(lubridate)

# importing all data
allNSW <- read_csv("data/states_csv/NSW.csv", show_col_types = FALSE)
allQueensland <- read_csv("data/states_csv/Queensland.csv", show_col_types = FALSE)
allSouth_Australia <- read_csv("data/states_csv/South Australia.csv", show_col_types = FALSE)
allTasmania <- read_csv("data/states_csv/Tasmania.csv", show_col_types = FALSE)
allVictoria <- read_csv("data/states_csv/Victoria.csv",show_col_types = FALSE)
allWestern_Australia <- read_csv("data/states_csv/Western Australia.csv",show_col_types = FALSE)


# WRANGLING & CLEANING DATES
# only keeping rows I'm interested in: date, gender, plea, judge, sentence, marriage dates
NSW <- subset(allNSW, select = c(DATE, GENDER,PLEA,JUDGE,SENTENCE,25,30,36))
Queensland <- subset(allQueensland, select = c(DATE, GENDER,PLEA,JUDGE,SENTENCE,25,30,35))
South_Australia <- subset(allSouth_Australia, select = c(1, GENDER,PLEA,JUDGE,SENTENCE,25,30,35))
Tasmania <- subset(allTasmania, select = c(1, GENDER,Plea,JUDGE,SENTENCE,25,30,35))
Western_Australia <- subset(allWestern_Australia, select = c(1, GENDER,PLEA,JUDGE,SENTENCE,25,30,35))
Victoria <- subset(allVictoria, select = c(1, 20,PLEA,JUDGE,SENTENCE,26,31,36))

# standardizing column names
#states <- list(NSW, Queensland,South_Australia,Tasmania,Victoria,Western_Australia)
colnames(South_Australia) <- c("DATE", "GENDER","PLEA","JUDGE","SENTENCE", "FIRST_", "SECOND_", "THIRD_")
colnames(Tasmania) <- c("DATE", "GENDER","PLEA","JUDGE","SENTENCE", "FIRST_", "SECOND_", "THIRD_")
colnames(Western_Australia) <- c("DATE", "GENDER","PLEA","JUDGE","SENTENCE", "FIRST_", "SECOND_", "THIRD_")
colnames(Victoria) <- c("DATE", "GENDER","PLEA","JUDGE","SENTENCE", "FIRST_", "SECOND_", "THIRD_")
colnames(Queensland) <- c("DATE", "GENDER","PLEA","JUDGE","SENTENCE", "FIRST_", "SECOND_", "THIRD_")
colnames(NSW) <- c("DATE", "GENDER","PLEA","JUDGE","SENTENCE", "FIRST_", "SECOND_", "THIRD_")

# adding column with state name; probably an easier way to do this
NSW <- cbind('NSW', NSW); colnames(NSW)[1] <- 'state'
Queensland <- cbind('Queensland', Queensland); colnames(Queensland)[1] <- 'state'
South_Australia <- cbind('South_Australia', South_Australia); colnames(South_Australia)[1] <- 'state'
Tasmania <- cbind('Tasmania', Tasmania); colnames(Tasmania)[1] <- 'state'
Western_Australia <- cbind('Western_Australia', Western_Australia); colnames(Western_Australia)[1] <- 'state'
Victoria <- cbind('Victoria', Victoria); colnames(Victoria)[1] <- 'state'

# convert date to character
South_Australia$DATE <- as.character(South_Australia$DATE)
Western_Australia$DATE <- as.character(Western_Australia$DATE)

# merging all together
states <- rbind(NSW, Queensland,South_Australia,Tasmania,Western_Australia,Victoria)

# removing rows with no dates
states <- states[!(is.na(states$DATE)), ]
# resetting index
rownames(states) <- NULL 

# clean typos
states$DATE <- str_replace_all(states$DATE,"--","-")
states[1681,2] <- "1949-07-27"

#states$Date <- as.Date(states$DATE, format = "%Y-%m-%d") # this doesn't work b/c apparently as.Date only starts from 1970 ...

# Convert character date to date format using the 'anydate()' function
states$Date <- anydate(states$DATE)


# CLEANING GENDER
# table(states$GENDER, exclude = NULL) # inspect
states$GENDER <- tolower(states$GENDER) # convert all to lower case
states$GENDER <- str_replace_all(states$GENDER, "males", "male")


# EXPORTING AS CSV
write_csv(states, "data/states.csv")

