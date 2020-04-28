#define the path where the new folder has been unziped
pathdata<-  file.path("./final_proj", "UCI HAR Dataset")
## We start loading the dataset into R and then make it tidy
# We read the train files first
xtrain <- read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
ytrain <- read.table(file.path(pathdata, "train", "y_train.txt"),header = FALSE)
subject_train <- read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)
# Now we read test files//
xtest<- read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ytest<- read.table(file.path(pathdata, "test", "y_test.txt"),header = FALSE)
subject_test<- read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)
features <- read.table(file.path(pathdata, "features.txt"),header = FALSE)
activityLabels <- read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)

# Giving column names to train data
colnames(xtrain)<- features[,2]
colnames(ytrain)<- "activityId"
colnames(subject_train)<- "subjectId"
#Column names for test data
colnames(xtest)<-  features[,2]
colnames(ytest)<- "activityId"
colnames(subject_test)<- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

# MErging data
mrg_train = cbind(ytrain, subject_train, xtrain)
mrg_test = cbind(ytest, subject_test, xtest)
# combining both
setAllInOne = rbind(mrg_train, mrg_test)


colNames = colnames(setAllInOne)

mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
# creating subset
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

setWithActivityNames = merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)

secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

write.table(secTidySet, "tidydata_final.txt", row.name=FALSE)
