# Getting-and-Cleaning-Data-Course-Project

This repository contains the request files for the peer-graded assignment: Getting and Cleaning Data Course Project in the Coursera's course

## Content

* The `run_analysis.R` script that descript the code and the process of generating tidy data following the instructions
* This `README.md` show how all of the script works and all the instructions
* The `CodeBook.md` with description of all the variables in the final tidy data set
* The `tidydata.txt` with the average of each variable for each activity and each subject.

## How to run the analysis

Firsty you should have the package `"dplyr"` installed in your R through `install.packages ("dplyr")`, then you can run the analysis in this project by just cloning this repo and run in R: source("run_analysis.R") from the home directory of this project.

## How the script works

1. Loading the package

```
library(dplyr)
```

2. Creating the "data" directory if it dosen't exist. Download the data for this project, and unzip it under the data directory.

``` 
if (!file.exists("./data")) {dir.create("./data")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./data/Dataset.zip")
unzip(zipfile ="./data/Dataset.zip", exdir = "./data")
```

2. After unzipping `Dataset.zip`, we will find a directory called "data/UCI HAR Dataset" where the all the files we need are exits. Subsquently, we read the train and test data in this directory.

```
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
```

3. Then we read the `feature.txt` and `activity_labels.txt` in the directory which indicate the information about the variables and activity names. 

```
feature <- read.table("./data/UCI HAR Dataset/features.txt")
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
```

4. Merging the training and the test sets to create one data set. The variables in second column of data frame `feature` are corresponing to the column names in both `X_test` and  `X_train`, while the column names of both `Y_train` and `Y_test` will be named as `activityID`. In addition, The first and second column name of data frame `activity_labels` are named as `"activityID"` and `"activityname"` respectively. Finally, `cbind` and `rbind` function can be used to merge these datasets in to one dataset with 10299 observations of 563 variables.

```
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
```

5. Extracts only the measurements on the mean and standard deviation for each measurement. `grepl` function is uesed to match the column names which contains `mean()`, `std()` and keep the `activityID` and ` subjectID` as the first two column name of the dataset.

```
mean_std <- all[,grepl("activityID", colnames(all))|grepl("subjectID", colnames(all))|(grepl("mean()", colnames(all))|grepl("std()", colnames(all)))]
```

6. Uses descriptive activity names to name the activities in the data set and appropriately labels the data set with descriptive variable names. By using `merge` function to combine two data frames `mean_std` and `activity_label` and label the activity names to the dataset.

```
feature_named <- merge(mean_std, activity_labels, by = "activityID")
```
7. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. By using `aggregate` function, the factors variables `subjectID`, `activityID`, and `activityname` from data frame `feature_named` are taken to exert the `mean` function to generate the tidy data.

```
tidy_data <- aggregate(. ~ subjectID + activityID+ activityname, feature_named, FUN = mean)
tidy_data_final <- arrange(tidy_data, subjectID, activityname)
write.table(tidy_data_final, "tidydata.txt", row.names = FALSE)
```


## Description of the variables

The variables in the final tidydata.txt are described in the `CodeBook.md` file of this repository.

