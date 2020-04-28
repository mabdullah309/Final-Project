---
title: "Final Project"
author: "Muhammad Abdullah"
date: "4/29/2020"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

I unzipped the dataset in a directory "final_proj". Then set the pathdata varibale to that directory. using following code.

```{r}
pathdata<-  file.path("./final_proj", "UCI HAR Dataset")
```

Then I started reading the train and test data into R using following code.
```{r}
xtrain <- read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
ytrain <- read.table(file.path(pathdata, "train", "y_train.txt"),header = FALSE)
subject_train <- read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)
xtest<- read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ytest<- read.table(file.path(pathdata, "test", "y_test.txt"),header = FALSE)
subject_test<- read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)
features <- read.table(file.path(pathdata, "features.txt"),header = FALSE)
activityLabels <- read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)
```

The problem is that data has no column names. So, give it column names
### Accordin to third objective of assignment we name the activities using following code
```{r}
colnames(xtrain)<- features[,2]
colnames(ytrain)<- "activityId"
colnames(subject_train)<- "subjectId"
colnames(xtest)<-  features[,2]
colnames(ytest)<- "activityId"
colnames(subject_test)<- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

```

### Now we merge the tables of test and train data by following code
```{r}
# MErging data
mrg_train = cbind(ytrain, subject_train, xtrain)
mrg_test = cbind(ytest, subject_test, xtest)
# combining both
setAllInOne = rbind(mrg_train, mrg_test)
```
### We now extract the mean and standard deviation measurements as required using grepl fuunction
```{r}
colNames = colnames(setAllInOne)
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]
```
### Create descriptive names to name activities in the dataset
```{r}
setWithActivityNames = merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)
```
### To create a tidy datset required in the assignment we need to average of each variable and use aggregae funcion
```{r}
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
```
### Finally we save the tidy dataset
```{r}
write.table(secTidySet, "tidydata_final.txt", row.name=FALSE)
```
### The names of varibales are:
```{r setup, include=FALSE}
names(secTidySet)
```
