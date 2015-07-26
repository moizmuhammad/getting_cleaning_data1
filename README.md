#Getting and Cleaning Data: Course Project

##Goal
The goal of the project is as follows:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Important Files and their Paths

###Script File: run_analysis.R

###Code Book: codebook.md

###Data Files used by run_analysis.R script: 
    * data/features.txt
    * data/activity_labels.txt
    * data/train/subject_train.txt
    * data/train/X_train.txt
    * data/train/y_train.txt
    * data/test/subject_test.txt
    * data/test/X_test.txt
    * data/test/y_test.txt


##How Script Works:

1. Loads training data and test data and combines them with rbind function
2. Using grep function extract the names from features.txt that relates to either 'mean()' or 'std()'. Then using the dplyr:select function it creates a new data frame containing only these variable (66 out of 561 variable) 
3. Loads the activity_labels.txt file and then merges (joins) it with the selected data to replace the activity id with name
4. Renames the generic variable names (V1, V2, ....) to its actual name found in the features.txt file
5. Convert the data to long format using the melt function of reshape2 package. Then
   groups the data on the basis of activity, subject and variable and then summarizes      the data using the mean function

