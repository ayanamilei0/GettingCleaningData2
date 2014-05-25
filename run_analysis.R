
library(reshape2)

## loading training data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

## Column binding training data
train_data <- cbind(sub_train, y_train, x_train)

## loading test data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

## column binding test data
test_data <- cbind(sub_test, y_test, x_test)

## Row binding training and test data to create one data set
data <- rbind(train_data, test_data)

## Label the new columns
labels <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)$V2
labels <- c("subject", "activity", labels)
names(data) <- labels

## mean and standard deviations of each measurement
stats <- data[, grep(paste(c("subject", "activity", "^.*mean[(].*$", "^.*std.*$"), 
                                        collapse = "|"), names(data), ignore.case = TRUE)]

## Create tidy data set

datamelt <- melt(stats, id.vars = c("activity", "subject"))
tidydata <- dcast(datamelt, subject + activity ~ variable, mean)

## Label with activity names
act_labels <- read.table("UCI HAR Dataset/activity_labels.txt")$V2[1:6]
stats$activity <- unlist(lapply(stats$activity, function(x) x <- act_labels[x]))
tidydata$activity <- unlist(lapply(tidydata$activity, function(x) x <- act_labels[x]))

## write the tidy data set
write.table(tidydata, file ="F:/Program Files/R/R code/tidydata.txt", sep="\t", row.names = FALSE)