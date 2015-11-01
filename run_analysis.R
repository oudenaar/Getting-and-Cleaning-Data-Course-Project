##
# Getting and Cleaning Data Course Project / 
# Bas v. Oudenaarde 
#
# Download dataset.ZIP from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# Unzip it under the RStudio working directory
# Step 0.

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "UCI_HAR_Dataset.zip", method="curl")
unzip("UCI_HAR_Dataset.zip", overwrite = TRUE)

#The UCI HAR Dataset contains:
# activity_labels.txt
# features_info.txt
# features.txt
# README.txt
# test
# train

## Exercise steps:

## Step 1 : Merges the training and the test set to create one data set
#

# Load activity labels + features, needed to give colnames for train & test data tables
sensorlabels<-read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("id", "activity"), colClasses=c(numeric(), character()) )
features<-read.table("UCI HAR Dataset/features.txt", col.names=c("id", "feature"), colClasses=c(numeric(), character()) )

#First complete train data as one table
train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names=features[,2], colClasses=c(numeric() ) )
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt", col.names=c("activities"))
trainActivities[,1]<- factor(trainActivities[,1], levels = sensorlabels[,1], labels = sensorlabels[,2])
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt",col.names=c("subjects"),colClasses=c(factor() ))
#Merging...
train <- cbind(trainSubjects, trainActivities, train)

#First complete test data as on table
test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names=features[,2], colClasses=c(numeric() ))
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt", col.names=c("activities"))
testActivities[,1]<- factor(testActivities[,1], levels = sensorlabels[,1], labels = sensorlabels[,2])
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt",col.names=c("subjects"),colClasses=c(factor() ))
#Merging...
test <- cbind(testSubjects, testActivities, test)

#Merging all together in one big dataset
completeData <- rbind(train, test)

## Step 2 : Extracts only the measurements on the mean and standard deviation for each measurement

featuresFilter <- grep(".*mean.*|.*std.*", names(completeData))
firstAndSecondAndfeature <- c(1,2,featuresFilter)
completeData<-completeData[firstAndSecondAndfeature]


## Step 3 / 4: Uses descriptive activity names to name the activities in the data set / Appropriately labels the data set with descriptive variable names. 
# Note all labels are already set
# names(completeData) will show all column names

# Step 5 : From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

#allData.melted <- melt(allData, id = c("subject", "activity"))
#allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)
completeDataAveragePerActivityAndSubject <- aggregate(completeData[,3:81], by = list("activity"=completeData$activities, "subject"=completeData$subjects), mean)
write.table(completeDataAveragePerActivityAndSubject, "tidy.txt", row.names = FALSE, quote = FALSE)
