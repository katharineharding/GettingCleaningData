# Coursera - Data Science Specialisation
# 3 - Getting and Cleaning Data
# Assignment, June 2015
#
#
library(reshape2)
#
#
# Read in the data:
# names of columns
features <- read.table("./UCI HAR Dataset/features.txt")
Features <- gsub("BodyBody", "body", features[,2])
lower <- tolower(Features)
#
# test data
testData <- read.table("./UCI HAR Dataset/test/X_test.txt", 
                   colClasses = "numeric", 
                   col.names = lower)
testSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                           col.names = "subject")
testActivity <- read.table("./UCI HAR Dataset/test/y_test.txt", 
                           col.names = "activity")
test <- cbind(testSubjects, testActivity, testData)
#
# training data
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt", 
                    colClasses = "numeric", 
                    col.names = features[,2])
trainSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                           col.names = "subject")
trainActivity <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                           col.names = "activity")
train <- cbind(trainSubjects, trainActivity, trainData)
#
#
#
#
# step 1
# Merge the test and training datasets
rawData <- rbind(test, train)
#
#
#
#
# step 2
# extract out columns with means and standard deviation, combine them back together with
# subject IDs to make a new, smaller dataset
s <- rawData[,grep("std", names(rawData))]
m <- rawData[,grep("mean.", names(rawData))]
groups <- rawData[,c(1,2)]
dataMeanSD <- cbind(groups, m, s)
#
#
# step 3
# recode activities to readable labels
dataMeanSD$Activity <- factor(dataMeanSD[,2], 
                              labels = c("Walking", "Walking_Upstairs", "Walking_Downstairs",
                                         "Sitting", "Standing", "Lying"))
Data <- subset(dataMeanSD, select=c(1, 3:69))
#
#
#
#
# step 4
# Appropriately labels the data set with descriptive variable names. 
# this has been addressed by using the features file as column names when loading in data
#
#
#
# step 5
# From the data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject.
#
# melt the data by subject and activity
dataMelt <- melt(Data, id.vars = c("subject", "Activity"))
#
# recast the data, using the mean function
dataCast <- dcast(dataMelt, subject + Activity ~ variable, fun.aggregate = mean)
#
# write the final output to a table
finalOutput <- write.table(dataCast, file="Coursera3_Assignment.txt", row.names=FALSE)
#
#
#