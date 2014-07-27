GetCleanData_PA
Stephen Maione
Coursera.com
CodeBook.md
===============

#Peer Assessment for Getting and Cleaning Data on Coursera



## Overview

"tidy_data.txt" contains a table of 5 variables conceptually grouped into ID and measurement variables.  The ID variables can be thought of as representing physical real-world entities, while the measurement variables exist as numeric information derived from their physical identifiers.


## ID Variables

### subject

This ID variable contains anonymized integer values for the 30 total participants in the collection of the Human Activity Recognition (HAR) data set.


### activity

This ID variable contains 6 different activities the subject was engaged in while the data was collected.

walking  
walking_upstairs  
walking_downstairs  
sitting  
standing  
laying  


### signal

This final ID variable contains 17 different signals gathered from the smartphones' motion sensors.  Signals represented by 3D vectors are broken apart into separate values bringing the total signal count to 33.  The prefix 't' denotes time domain signals, while the 'f' indicates if a Fast Fourier Transform was applied to it's corresponding time domain cohort.

tBodyAccX  
tBodyAccY  
tBodyAccZ  
tGravityAccX  
tGravityAccY  
tGravityAccY  
tBodyAccJerkX  
tBodyAccJerkY  
tBodyAccJerkZ  
tBodyGyroX  
tBodyGyroY  
tBodyGyroZ  
tBodyGyroJerkX  
tBodyGyroJerkY  
tBodyGyroJerkZ  
tBodyAccMag  
tGravityAccMag  
tBodyAccJerkMag  
tBodyGyroMag  
tBodyGyroJerkMag  
fBodyAccX  
fBodyAccY  
fBodyAccZ  
fBodyAccJerkX  
fBodyAccJerkY  
fBodyAccJerkZ  
fBodyGyroX  
fBodyGyroY  
fBodyGyroZ  
fBodyAccMag  
fBodyAccJerkMag  
fBodyGyroMag  
fBodyGyroJerkMag  


## Measurement Variables

### avg_means

This measurement variable contains evenly weighted averages of the estimated mean values presented in the HAR data set.  The means were averaged for each signal grouped by every subject/activity combination.


### avg_SDs

This measurement variable contains evenly weighted averages of the estimated standard deviation values presented in the HAR data set.  The SDs were averaged for each signal grouped by every subject/activity combination.
