---
title: "Coursera3_Assignment"
author: "KH"
date: "21 June 2015"
output: html_document
---
Load in the reshape2 library which will be used later on
```{r}
library(reshape2)
```

###Read in the data:
First of all read in the names of columns, and make them a tiny bit more readable although they are almost irretrievably ugly
```{r}
features <- read.table("./UCI HAR Dataset/features.txt")
Features <- gsub("BodyBody", "body", features[,2])
lower <- tolower(Features)
```
Next read in the test data, subjects, activities, and link them into one dataframe
```{r}
testData <- read.table("./UCI HAR Dataset/test/X_test.txt", 
                   colClasses = "numeric", 
                   col.names = lower)
testSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                           col.names = "subject")
testActivity <- read.table("./UCI HAR Dataset/test/y_test.txt", 
                           col.names = "activity")
test <- cbind(testSubjects, testActivity, testData)
```
Finally read in the training data, subjects, activities, and link them into one dataframe
```{r}
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt", 
                    colClasses = "numeric", 
                    col.names = features[,2])
trainSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                           col.names = "subject")
trainActivity <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                           col.names = "activity")
train <- cbind(trainSubjects, trainActivity, trainData)
```
### Step 1: Merge the test and training datasets
We use r bind for this as the datasets are structured in the same way so can simply be stuck together
```{r}
rawData <- rbind(test, train)
```
### Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.
Extract out columns with means and standard deviation, combine them back together with subject IDs to make a new, smaller dataset
```{r}
s <- rawData[,grep("std", names(rawData))]
m <- rawData[,grep("mean.", names(rawData))]
groups <- rawData[,c(1,2)]
dataMeanSD <- cbind(groups, m, s)
```
### Step 3: Recode activities to readable labels
```{r}
dataMeanSD$Activity <- factor(dataMeanSD[,2], 
                          labels = c("Walking", "Walking_Upstairs", "Walking_Downstairs",
                                     "Sitting", "Standing", "Lying"))
```


### Step 4: Appropriately labels the data set with descriptive variable names. 
This has been addressed by using the features file as column names when loading in data


### Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Exclude the activity variable (the numeric one) as it will prevent the melting function from working properly
```{r}
Data <- subset(dataMeanSD, select=c(1, 3:69))
```
Melt the data by subject and activity
```{r}
dataMelt <- melt(Data, id.vars = c("subject", "Activity"))
```
Recast the data, using the mean aggregate function
```{r}
dataCast <- dcast(dataMelt, subject + Activity ~ variable, fun.aggregate = mean)
```
And finally write the final output to a file
```{r}
finalOutput <- write.table(dataCast, file="Coursera3_Assignment.txt", row.names=FALSE)
```
Et voila.