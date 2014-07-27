###############################################################################
## Stephen Maione
## run_analysis.R
## Course Project
## Getting and Cleaning Data
## Coursera.com
###############################################################################


## Download the data
fileURL <- paste("https://d396qusza40orc.cloudfront.net",
                 "/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", sep="")
download.file(fileURL, "./UCI HAR Dataset.zip")
unzip("./UCI HAR Dataset.zip")

rm(fileURL)

## Load the metadata
features <- read.table('./UCI HAR Dataset/features.txt',
                       col.names=c('row', 'feature'))
activity_labels <- read.table('./UCI HAR Dataset/activity_labels.txt',
                              col.names=c('row', 'labels'))

## Load the test data
X_test <-read.table('./UCI HAR Dataset/test/X_test.txt',
                    col.names=features$feature)
y_test <-read.table('./UCI HAR Dataset/test/y_test.txt',
                    col.names='activity')
subject_test <-read.table('./UCI HAR Dataset/test/subject_test.txt',
                          col.names='subject')

## Load the training data
X_train <-read.table('./UCI HAR Dataset/train/X_train.txt',
                     col.names=features$feature)
y_train <-read.table('./UCI HAR Dataset/train/y_train.txt',
                     col.names='activity')
subject_train <-read.table('./UCI HAR Dataset/train/subject_train.txt',
                          col.names='subject')

## Combine the test and training data respectively
test_data <- cbind(subject_test, y_test, X_test)
train_data <- cbind(subject_train, y_train, X_train)

## Merge the training and the test sets to create one data set.
data <- rbind(train_data, test_data)
# rm(train_data, test_data)

## Extract only the measurements on the mean and standard deviation
##  for each measurement. 
mean_sd_cols <- (grepl('mean', names(data)) | grepl('std', names(data))) &
    !grepl('meanFreq', names(data))
data <- cbind(data[, c('subject', 'activity')], data[, mean_sd_cols])

## Use activity labels to name the activities in the data set
data$activity <- tolower(activity_labels[data$activity[1:nrow(data)],
                                         'labels'])

## Appropriately label the data set with descriptive variable names. 
names(data) <- gsub("\\.\\.", "", names(data))

## Remove temporary objects
rm(test_data, subject_test, y_test, X_test,
   train_data, subject_train, y_train, X_train,
   activity_labels, features, mean_sd_cols)

## Create a second, independent tidy data set
narrow_data <- data

## Re-order columns so that means are followed by SDs
narrow_data <- narrow_data[c("subject", "activity",
                             "tBodyAcc.mean.X", "tBodyAcc.std.X",
                             "tBodyAcc.mean.Y", "tBodyAcc.std.Y",
                             "tBodyAcc.mean.Z", "tBodyAcc.std.Z",
                             "tGravityAcc.mean.X", "tGravityAcc.std.X",
                             "tGravityAcc.mean.Y", "tGravityAcc.std.Y",
                             "tGravityAcc.mean.Z", "tGravityAcc.std.Z",
                             "tBodyAccJerk.mean.X", "tBodyAccJerk.std.X",
                             "tBodyAccJerk.mean.Y", "tBodyAccJerk.std.Y",
                             "tBodyAccJerk.mean.Z", "tBodyAccJerk.std.Z",
                             "tBodyGyro.mean.X", "tBodyGyro.std.X",
                             "tBodyGyro.mean.Y", "tBodyGyro.std.Y",
                             "tBodyGyro.mean.Z", "tBodyGyro.std.Z",
                             "tBodyGyroJerk.mean.X", "tBodyGyroJerk.std.X",
                             "tBodyGyroJerk.mean.Y", "tBodyGyroJerk.std.Y",
                             "tBodyGyroJerk.mean.Z", "tBodyGyroJerk.std.Z",
                             "tBodyAccMag.mean", "tBodyAccMag.std",
                             "tGravityAccMag.mean", "tGravityAccMag.std",
                             "tBodyAccJerkMag.mean", "tBodyAccJerkMag.std",
                             "tBodyGyroMag.mean", "tBodyGyroMag.std",
                             "tBodyGyroJerkMag.mean", "tBodyGyroJerkMag.std",
                             "fBodyAcc.mean.X", "fBodyAcc.std.X",
                             "fBodyAcc.mean.Y", "fBodyAcc.std.Y",
                             "fBodyAcc.mean.Z", "fBodyAcc.std.Z",
                             "fBodyAccJerk.mean.X", "fBodyAccJerk.std.X",
                             "fBodyAccJerk.mean.Y", "fBodyAccJerk.std.Y",
                             "fBodyAccJerk.mean.Z", "fBodyAccJerk.std.Z",
                             "fBodyGyro.mean.X", "fBodyGyro.std.X",
                             "fBodyGyro.mean.Y", "fBodyGyro.std.Y",
                             "fBodyGyro.mean.Z", "fBodyGyro.std.Z",
                             "fBodyAccMag.mean", "fBodyAccMag.std",
                             "fBodyBodyAccJerkMag.mean",
                             "fBodyBodyAccJerkMag.std",
                             "fBodyBodyGyroMag.mean", "fBodyBodyGyroMag.std",
                             "fBodyBodyGyroJerkMag.mean",
                             "fBodyBodyGyroJerkMag.std")]

## Compile means and SDs together in one character value sep=" "
## in the respective mean column
num_signals <- (ncol(narrow_data) - 2) / 2
mean_SDs <- matrix(nrow=nrow(narrow_data), ncol=num_signals)

colnames(mean_SDs) <- names(narrow_data)[seq(3, ncol(narrow_data), by=2)]

for (i in seq(3, ncol(narrow_data), by=2)) {
    mean_SDs[, floor(i/2)] <- paste(as.character(narrow_data[, i]),
                                    as.character(narrow_data[, i+1]))
}

## Replace the separated columns with the compiled columns
narrow_data <- cbind(narrow_data[, c('subject', 'activity')],
                     as.data.frame(mean_SDs, stringsAsFactors=F))

rm(mean_SDs, num_signals, i)

## Narrow the data
library(reshape2) # for melt()

narrow_data <- melt(narrow_data, id=c('subject', 'activity'),
                    measure.vars=names(narrow_data)[3:ncol(narrow_data)])

## Unpack the mean and SDs back into separate columns
mean_SDs <- strsplit(narrow_data[, 'value'], split=" ")

means <- sapply(mean_SDs, function(x) as.numeric(x[1]))
SDs <-  sapply(mean_SDs, function(x) as.numeric(x[2]))

narrow_data <- cbind(narrow_data[, c('subject', 'activity', 'variable')],
                     means, SDs)

## Set the column names
names(narrow_data) <- c('subject', 'activity', 'signal', 'means', 'SDs')

rm(mean_SDs, means, SDs)

## Remove the word 'mean' from the signals' character values
split_data <- split(narrow_data, narrow_data$signal)

rm(narrow_data)

split_data <- lapply(split_data, function(group) {

    split_signal <- strsplit(as.character(group[1, 'signal']), split='\\.')
    
    if (length(split_signal[[1]]) == 3)
        signal <- paste(split_signal[[1]][1], split_signal[[1]][3], sep='')
    else
        signal <- split_signal[[1]][1]
    
    group$signal <- rep(signal, nrow(group))
    
    group
})

## Calculate average means and SDs within each split
## by every combination of subject and activity in the split
# aggregate(cbind(means, SDs) ~ subject + activity, split_data[[1]], mean)
tidy_data <- lapply(split_data, function(signal) {
    agg <- aggregate(cbind(means, SDs) ~ subject + activity, signal, mean)

    # Put the signal column in the aggregation
    sig_col <- rep(signal$signal[1], 180)
    agg <- cbind(agg, sig_col)
    agg[c(1, 2, 5, 3, 4)]
})

rm(split_data)

tidy_data <- Reduce(function(x, y) merge(x, y, all=T), tidy_data)

## Fiinalize names and ordering of the tidied data set
names(tidy_data) <- c("subject", "activity", "signal", "avg_means", "avg_SDs")
tidy_data <- tidy_data[order(tidy_data$signal, tidy_data$activity,
                             tidy_data$subject), ]
row.names(tidy_data) <- seq(1:nrow(tidy_data))

## Output tidy data to tidy_data.txt
write.table(tidy_data, "tidy_data.txt", row.names=F)
