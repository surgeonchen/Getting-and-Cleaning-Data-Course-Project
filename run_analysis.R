### Loading the package
library(dplyr)

### Downloading the data
if (!file.exists("./data")) {dir.create("./data")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./data/Dataset.zip")
unzip(zipfile ="./data/Dataset.zip", exdir = "./data")

### Reading the train and test data
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")


### Reading the feature and activity name data
feature <- read.table("./data/UCI HAR Dataset/features.txt")
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

## 1. Merging the training and the test sets to create one data set.
colnames(activity_labels) <- c("activityID", "activityname")
colnames(X_test) <- feature[,2]
colnames(Y_test) <- "activityID"
colnames(X_train) <- feature[,2]
colnames(Y_train) <- "activityID"
colnames(subject_train) <- "subjectID"
colnames(subject_test) <- "subjectID"
test <- cbind(Y_test, subject_test,  X_test)
train <- cbind(Y_train,subject_train,  X_train)
all <- rbind(train,test)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
mean_std <- all[,grepl("activityID", colnames(all))|grepl("subjectID", colnames(all))
                |(grepl("mean()", colnames(all))|grepl("std()", colnames(all)))]
## 3. Uses descriptive activity names to name the activities in the data set and 4. Appropriately labels the data set with descriptive variable names
feature_named <- merge(mean_std, activity_labels, by = "activityID")

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data <- aggregate(. ~ subjectID + activityname, feature_named, FUN = mean)
tidy_data_final <- arrange(tidy_data, subjectID, activityname)
write.table(tidy_data_final, "tidydata.txt", row.names = FALSE)
