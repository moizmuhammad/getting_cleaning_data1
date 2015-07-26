
#load required libraries
library(dplyr)
library(reshape2)

#----Goal 1: Merges the training and the test sets to create one data set.

#read training data input x (data/train/X_train.txt)
train_data_x <- read.table(file='data/train/X_train.txt', header=FALSE, sep="", colClasses=rep('numeric',561))

#read training data output y (data/train/y_train.txt)
train_data_y <- read.table(file='data/train/y_train.txt', header=FALSE, sep="", colClasses=c('numeric'))
train_data_y <- rename(train_data_y, activity=V1)

#read training data for subject (data/train/subject_train.txt)
train_data_subject <- read.table(file='data/train/subject_train.txt', header=FALSE, sep="", colClasses='character')
train_data_subject <- rename(train_data_subject, subject=V1)

#combine training data x and y
train_data <- cbind(train_data_x, train_data_y, train_data_subject)


#read test data input x (data/test/X_test.txt)
test_data_x <- read.table(file<-'data/test/X_test.txt', header=FALSE, sep="", colClasses=rep('numeric',561))

#read test data output y (data/test/y_test.txt)
test_data_y <- read.table(file='data/test/y_test.txt', header=FALSE, sep="", colClasses='numeric')
test_data_y <- rename(test_data_y, activity=V1)

#read training data for subject (data/train/subject_train.txt)
test_data_subject <- read.table(file='data/test/subject_test.txt', header=FALSE, sep="", colClasses='character')
test_data_subject <- rename(test_data_subject, subject=V1)


#combine test data x and y
test_data <- cbind(test_data_x, test_data_y, test_data_subject)

#merge training and test data vertically
data <- rbind(train_data, test_data)


#----Goal 2: Extracts only the measurements on the mean and standard deviation for each measurement. 

#read the list of features from file (data/features.txt)
features <- read.table(file='data/features.txt', header=FALSE, sep="", colClasses='character')

#get column indexes and names of features containing '-mean()'
mean_column_indexes <- grep(pattern='mean()', x=features$V2, fixed=TRUE, value=FALSE)
mean_column_names <- grep(pattern='mean()', x=features$V2, fixed=TRUE, value=TRUE)

#get column indexes and names of features containing '-std()'
std_column_indexes <- grep(pattern='std()', x=features$V2, fixed=TRUE, value=FALSE)
std_column_names <- grep(pattern='std()', x=features$V2, fixed=TRUE, value=TRUE)

#combine the column indexes and names of mean and std features
column_indexes <- append(mean_column_indexes, std_column_indexes)
column_names <- append(mean_column_names, std_column_names)

#append activity column
column_indexes <- append(column_indexes,562)
column_indexes <- append(column_indexes,563)

column_names <- append(column_names,'subject')
column_names <- append(column_names,'activity')

#extract data of selected columns
data_selected <- select(data, column_indexes)



#----Goal 3: Uses descriptive activity names to name the activities in the data set

#load activity labels
activity <- read.table(file='data/activity_labels.txt', header=FALSE, sep='')

#rename activity dataframe columns
activity <- rename(activity, id=V1, activity_name=V2)

#merge the data_selected dataframe with activity on basis of activity = id
data_selected <- merge(data_selected, activity, by.x='activity', by.y='id')
data_selected <- data_selected[, -1]

#----Goal 4: Appropriately labels the data set with descriptive variable names.

#define a custom rename function
my_rename <- function(dat, oldnames, newnames) {
  datnames <- colnames(dat)
  datnames[which(datnames %in% oldnames)] <- newnames
  colnames(dat) <- datnames
  dat
}

data_selected_names <- my_rename(data_selected, names(data_selected), column_names )


#----Goal 5: From the data set in step 4, creates a second, independent tidy data set 
#            with the average of each variable for each activity and each subject.

#set activity and subject as factor variable
data_selected_names$activity <- as.factor(data_selected_names$activity)
data_selected_names$subject <- as.factor(data_selected_names$subject)

#reshape data to long format
tidy_data <- melt(data_selected_names, id=c('activity','subject'), measure.vars=column_names[1:66])

#group and summaries the tidy data
tidy_data_grouped <- group_by(tidy_data, activity, subject, variable)
tidy_data_summary <- summarize(tidy_data_grouped, avg_value=mean(value, na.rm=T))

#save
write.table(tidy_data_summary, file='summarized_data.txt', row.name=FALSE)