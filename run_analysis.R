
## Merge the training and the test data sets to create one data set.
features <- read.table("./UCI HAR Dataset/features.txt")
features$V2 <- gsub("_", ".",features$V2)
features$V2 <- gsub(",", ".",features$V2)
features$V2 <- gsub("-", ".",features$V2)
features$V2 <- gsub("\\(", "",features$V2)
features$V2 <- gsub("\\)", "",features$V2)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names=features[,2])
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names=features[,2])
X <- rbind(X_test, X_train)

## Extract the measurements on the mean and standard deviation for each measurement. 
meanOrStd<- features[grepl("mean", features[,2], ignore.case=TRUE) | grepl("std", features[,2], ignore.case=TRUE) & !grepl("meanFreq", features[,2], ignore.case=TRUE), ]
meanOrStd <- X[,meanOrStd[,1]]

## Set descriptive activity names
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c('activity'))
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c('activity'))
y <- rbind(y_test, y_train)
act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
for (i in 1:nrow(act_labels)) {
     y[y$activity == as.numeric(act_labels[i, 1]), ] <- as.character(act_labels[i, 2])
}
y$activity <-tolower(y[,1])

## Label the data set with descriptive activity names. 
X_with_labels <- cbind(y, X)
mean_and_std_with_labels <- cbind(y, meanOrStd)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c('subject'))
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c('subject'))
subject <- rbind(subject_test, subject_train)
myTidyData1 <- cbind(mean_and_std_with_labels, subject)


## Create first tidy data set
write.csv(myTidyData1, file="myTidyData1.txt", row.names=FALSE)

## Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
myTidyData2 <- aggregate(X, by = list(activity = y[,1], subject = subject[,1]), mean)

write.csv(myTidyData2, file="myTidyData2.txt", row.names=FALSE)