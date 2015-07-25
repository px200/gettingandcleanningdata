library(plyr)
library(dplyr)
library(reshape2)

# Download data files if not already in the working directory.
if(file.exists("./UCI HAR Dataset")) {
  print("UCI HAR Dataset already downloaded.")
} else {
  print("Downloading dataset.")
  url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
  download.file(url, "data.zip", method = "curl", quiet = TRUE)
  unzip("data.zip")
  file.remove("data.zip")
}

# Read data into R.
print("Reading data.")
train_data <- read.table("UCI HAR Dataset/train/X_train.txt")
train_activity <- readLines("UCI HAR Dataset/train/y_train.txt")
train_subjects <- readLines("UCI HAR Dataset/train/subject_train.txt")
test_data <- read.table("UCI HAR Dataset/test/X_test.txt")
test_activity <- readLines("UCI HAR Dataset/test/y_test.txt")
test_subjects <- readLines("UCI HAR Dataset/test/subject_test.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

# Merge training and test data.
print("Merging training and test data.")
x <- rbind(train_data, test_data)
activity <- c(train_activity, test_activity)
subject <- c(train_subjects, test_subjects)
# Create unique variable names using feature labels.
names(x) <- make.names(features[,2], unique = TRUE)

# Select measures containing mean and standard deviation.
y <- select(x, contains(".mean."), contains("std")) 


# Create descriptive activity names using labels shipped with dataset.
data <- cbind(subject, activity, y)
levels(data$activity) <- activity_labels[, 2]

# Tidy up column names
names(data) <- sub("\\.{3}", ".", names(data))
names(data) <- sub("\\.{2}", "", names(data))

# Create a summary dataset
print("Calculating means of activity means for each subject and each activity")
data %>% melt(id.vars = c("subject", "activity")) %>%
ddply(.(subject, activity, variable), summarize, mean = mean(value)) %>%
dcast(subject + activity ~ variable, value.var = "mean") %>%
write.table(file = "summary.txt", row.names = FALSE)
