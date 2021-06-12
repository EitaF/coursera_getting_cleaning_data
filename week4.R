# set path and confirm files saved in the folder.
path = file.path(".", "UCI HAR Dataset")
files <- list.files(path, recursive = TRUE)
files

#Read training data
xtrain <- read.table(file.path(path, "train", "X_train.txt"), header = FALSE)
ytrain <- read.table(file.path(path, "train", "y_train.txt"), header = FALSE)
subject_train <- read.table(file.path(path, "train", "subject_train.txt"), header = FALSE)

#Read test data
xtest <- read.table(file.path(path, "test", "X_test.txt"), header = FALSE)
ytest <- read.table(file.path(path, "test", "y_test.txt"), header = FALSE)
subject_test <- read.table(file.path(path, "test", "subject_test.txt"), header = FALSE)

#Read features data
features <- read.table(file.path(path, "features.txt"), header=FALSE)

#Read activity labels
activityLabels <- read.table(file.path(path, "activity_labels.txt"), header = FALSE)

#Create tag names for training data
colnames(xtrain) <- features[,2]
colnames(ytrain) <- "activityId"
colnames(subject_train) <- "subjectId"

#Create tag names for test data
colnames(xtest) <-  features[,2]
colnames(ytest) <-  "activityId"
colnames(subject_test) <-  "subjectId"

#Create activity label's values
colnames(activityLabels) <- c("activityId", "activityType")

#1. Merge train and test data
merged_train <- cbind(ytrain, subject_train, xtrain)
merged_test <- cbind(ytest, subject_test, xtest)
#Put together all data
alldata <- rbind(merged_train, merged_test)

#2. Extract only measurements on the mean and std deviation
colNames <- colnames(alldata)
#Get mean and std
mean_and_std <- (grepl("activityId", colNames)|grepl("subjectId", colNames)|grepl("mean..", colNames)|grepl("std..", colNames))
#Make required dataset
data_mean_and_std <- alldata[, mean_and_std == TRUE]

#3. Uses descriptive activity names to name the activities in the data set
ActivityNames <- merge(data_mean_and_std, activityLabels, by='activityId', all.x=TRUE)

#4. Appropriately labels the data set with descriptive variable names. 
tidydata <- aggregate(.~subjectId + activityId, ActivityNames, mean)
tidydata <- tidydata[order(tidydata$subjectId, tidydata$activityId),]

#5. Save data
write.table(tidydata, "Tidydata.txt", row.names = TRUE)