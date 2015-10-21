#This script is for the Data Science Specialization, the course is Getting 
#and Cleaning data. this is the project for the accelerometer data
library(data.table)
library(plyr)
library(dplyr)
## 1. Merges the training and the test sets to create one data set.

#first get the data
#set the working directory with an absolute path
setwd(""C:/Users/Derik/Documents/R/coursera/accelerometer"")
if (!file.exists("accelerometer_raw.zip"))
{
  url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url,destfile="accelerometer_raw.zip",method="libcurl")
  unzip("accelerometer_raw.zip")
}

#Inside the test set there are three files. 
# 1. subject_train.txt has the id for each subject. 
#    So put as a column of the final data.table
# 2. X_train.txt. has the vectors needed. this is the core of the data.table
# 3. Y_train.txt. has the indications of each activity.
#    put it as another column of the data.table
####################################################################
# this section is for reading the appropriate datasets, and        #
# preparing the column names and the ids. This is preparation for  #
# later tasks                                                      #
####################################################################

#####################################
### work first in the train dataset ##
#####################################
#load the TRAIN dataset
train<-fread("UCI HAR Dataset/train/X_train.txt")

#read the variable names for the train dataset
varnames<-read.table("UCI HAR Dataset/features.txt")
#convert to lower case
varnames<-tolower(varnames[,2])
#to make them readable, expand to abbreviations
varnames<-gsub("acc","acceleration",varnames)
varnames<-gsub("mag","magnitude",varnames)
varnames<-gsub("bodybody","body",varnames)
#assign variable names to the train data.frame.
#thhe first column is the count, the second has the names
names(train)<-varnames

#load the id file
id<-fread("UCI HAR Dataset/train/subject_train.txt")

#load the activity file
activity<-scan("UCI HAR Dataset/train/Y_train.txt")
#recode the values of activity. to do that, read the
#file of activities and their labels
activity.labels<-read.table("UCI HAR Dataset/activity_labels.txt")
#use the function mapvalues, to change the numbers in activty, to
#meaningful names in activity labels
activity<-mapvalues(activity,from=activity.labels[,"V1"],
                    to=as.character(activity.labels[,"V2"]))
#now create a data.table with the ids and the train data
#this assumes the order of the subject train and the
#activity (Y_train) are the same and therefore, they can
#be appended by columns.
train.table<-data.table(id=id,activity=activity,train)

#add the name of two initial variables
names(train.table)[1:2]<-c("id","activity")

####################################
### now work in the test dataset ###
####################################
#load the TEST dataset
test<-fread("UCI HAR Dataset/test/X_test.txt")

#read the variable names
#this is commented out because is the same as in previous dataset
#this ensures they can be rbind'ed
#varnames<-read.table("UCI HAR Dataset/features.txt")

#assign variable names to the TEST data.frame
names(test)<-varnames

#load the id file
id<-fread("UCI HAR Dataset/test/subject_test.txt")

activity<-scan("UCI HAR Dataset/test/Y_test.txt")

#now recode the numbers in activity using the labels 
#in the activity_labels.txt. The file is already
#in memory. just to the recoding
activity<-mapvalues(activity,from=activity.labels[,"V1"], to=as.character(activity.labels[,"V2"]))

#now create a data.table with the ids and the train data
test.table<-data.table(id=id,activity=activity,test)

#add the name of two initial variables
names(test.table)[1:2]<-c("id","activity")
################################################################
# finished preparing datasets                                  #
################################################################
#now join test.table and train.table into a single
#data.table.
accel<-rbind(train.table,test.table)

## 2. Extracts only the measurements on the mean and standard deviation for each 
#measurement. 
#according to the codebook, mean() and std() fit the description
#but meanFreq(): Weighted average of the frequency components to obtain a mean 
#frequency (straight form codebook) and therefore it should be included]
#the last four gravityMean tBodyAccMean tBodyAccJerkMean tBodyGyroMean 
#tBodyGyroJerkMean are averages over a movable window and therefore
#they do not fit the criteria, because they do not average the whole variable.


#Note. The instructions does not mention id or activity. But since this
#data.table is going to be used to summarize the variables, then
#include them
accel.mean.std<-select(accel,id,activity,matches('mean|std',ignore.case=F),-matches('angle'))
## first part finished. Whew!

## 3. Uses descriptive activity names to name the activities in the data set
#this was done by recoding the numbers with the labels in lines 53 and 86

## 4. Appropriately labels the data set with descriptive variable names. 
# only a couple of abbreviations were expanded, namely, acceleration and magnitude
#this enhances the readability. std was assumed to be easily understood

## 5. From the data set in step 4, creates a second, independent 
#tidy data set with the average of each variable for each activity 
#and each subject.

#the strategy is to chain together functions
#first group by both id and activity
#then compute all means using summarise_each
#last, arrange by id and activity so it looks nicer
#problem, the variable names do not reflect they are means of the original one
grouped.means<-accel.mean.std %>%
group_by(id,activity) %>%
summarise_each(funs(mean)) %>%
arrange(id,activity)
  
#finally, write the txt version of the tidy mean data 
write.table(grouped.means,file="grouped.means.txt",row.names = FALSE)
