GetCleanData_PA
Stephen Maione
Coursera.com
README.md
===============

#Peer Assessment for Getting and Cleaning Data on Coursera



## Instructions

run_analysis.R contains all of the coded instructions to download, extract, and read data from the "UCI HAR Dataset".  Only an internet connection and an environment capable of executing an R script are required.


## Synopsis

This analysis serves to produce a summarization of selected measurements from Samsung's mobile device motion detectors.  Those measurements are the means and standard deviations provided by the UCI Machine Learning Repository in their Human Activity Recognition data set.  The summarization will be output to "tidy_data.txt" in the working directory.  The summarization will produce means (or "averages") to avoid confusion of the downloaded means and SDs for each signal across every combination of subject and activity.


## Processing the raw data

Lines 11-14 download and extracts the source data set in the working directory.  
Lines 19-38 read the testing and training data files into memory.  Here, the variable names are already applied to the columns of X_test(train) from features.txt  
Lines 41-45 combine all of the files to build a unified table of all the available raw data.  
Lines 50-52 extract only the mean() and std() variables for each of the signals as defined in features_info.txt.  
Lines 55-56 apply the activity names in lower case to the enumerations contained in y_test(train).  
Line 59 removes extraneous '.' from the variable names but leaves single instances.  


## Tidying/summarizing the data

Lines 67-105 copy the pre-processed data into a temporary narrow data frame.  The columns are rearranged so that mean and SD variables are consecutive to each other for their shared signal.  
Lines 109-121 prepare the data for melting by pasting the each mean and SD pair into a single column.  I'm sure this is extremely unorthodox, but paired data needed to be kept on the same row after the upcoming melt.  
Lines 128-129 melt the data leaving subject, activity, variable, and value columns.  variable contains all of the signals, and value contains the concatenated and characterized means and SDs.  
Lines 132-141 separate out the mean and SD data into numeric columns once again and discard the concatenation.  Descriptive column names are also set.
Line 146 splits the narrow data into a list of data frames by the type of signal.  
Lines 150-162 format the signal character values to remove the remaining '.'s and 'mean' strings.  
Lines 176-174 summarize each split of the data by averaging the means and SDs of each signal on every combination of subject and activity.  This results in a list of 33 data frames with 180 rows each--one data frame for each signal composed of single rows for every subject/activity combination.  
Line 178 merges the list of summarized data frames into one tidy data frame.  
Lines 181_184 make the tidied data presentable.  Column names are finalized indicating that the measurements are now averages.  The rows are reordered by signal, activity, and then subject so that comparisons can be easily viewed between subjects on the same statistic.  After reordering, the row numbers are reset to 1 through n.  
Line 187 outputs the tidied summarization to "tidy_data.txt" with the default " " separator.  


## Final thoughts

The narrow format that I decided on did not prove to be as useful as I had initially hoped.  I think it is not as easy to parse visually as a wide set, but given my lack of experience, I could not expect myself to make that judgement beforehand.  I also "hacked" my way through portions of the transition from wide to narrow because I could not figure out how to get means and SDs on the same row as their matching signal via any pre-packaged tools.

I do find conceptual value in the narrow format which is mostly why I pursued it to begin with.  I view the signals as physical entities along with their subjects and activities while the corresponding data exist only as numeric information.  I personally like this distinction emphasized by narrow arrangement of columns.

In the end, my solution executes in an acceptable amount of time, and without any known errors.