## My JHU_GCD project

## Analysis of UCI HAR data set.

## Author:  Michael Hunt

## Purpose and outcome of the script

# The outcome of this script is a tidy data file derived from the UCI HAR data
# set, which shows the mean value (for each of the 83 combinations of activity and 
# subject) of each measured value that was either a mean value or a standard deviation.
# All measurements that included the work mean/Mean in the descriptor have been
# included.

#There are 30 subjects and six activities, so 180 different combinations of these.

## Initial administrative tasks

## Set the working directory, clean the workspacce and load packages as required.

# at home? do this
setwd("C:/Users/Mike/Rspace/JHU_GCD/Project")
#at work? do this
# setwd("H:/Rspace/JHU_Data_Science/JHU_GCD/Project")
# anywhere else?
#setwd(as appropriate0)

rm(list=ls())
library(dplyr)


## Read in test and train data
Xtest<-read.table("./data/test/X_test.txt")
testLab<-read.table("./data/test/y_test.txt")
testSub<-read.table("./data/test/subject_test.txt")

Xtrain<-read.table("./data/train/X_train.txt")
trainLab<-read.table("./data/train/y_train.txt")
trainSub<-read.table("./data/train/subject_train.txt")

activity_labels<-read.table("./data/activity_labels.txt",stringsAsFactors=FALSE)
features<-read.table("./data/features.txt",stringsAsFactors=FALSE)

# Merge test and train subjects and activity labels
subjects<-rbind(testSub,trainSub)
activity<-rbind(testLab,trainLab)

# Give names to the Activity and Subject vectors.
colnames(activity)<-c("Activity")
colnames(subjects)<-c("Subject")

# check for NAs in Xtest
sum(!complete.cases(Xtest)) # there are none

# check for NAs in Xtrain
sum(!complete.cases(Xtrain)) # thee are none

# merge data sets by row, test set on top
Xall<-rbind(Xtest,Xtrain)

# Extract the mean and standard deviation columns

fmean<-function(x){grepl("mean",x,ignore.case=TRUE)}
fstd<-function(x){grepl("std",x)}

means<-sapply(features,fmean)
means<-data.frame(means)

stds<-sapply(features,fstd)
stds<-data.frame(stds)

select<-means+stds
# reduce this to a vector of 1s (keep) and 0s (reject)
select<-select$V2 

# now use "select" to select those columns of the data set that we need
Xselect<-Xall[,which(select==1)]


# name the columns with the descriptive names of the selected features
colnames(Xselect)<-c(features[which(select==1),2])

# Include subject and activity columns on LHS of  Xselect
Xselect<-data.frame(subjects,activity,Xselect)

# give descriptive labels to the activities
desclab<-function(x){
        activity_labels[x,2]
}
Xselect$Activity<-sapply(Xselect$Activity,desclab)

## Calculate means for each activity and each subject
# this data set is tidy, with one variable in each column and one observation in each
# row. The data set itself refers to a single group of measurements

xmeans<-aggregate(Xselect[,3:86],by=list(Xselect$Subject,Xselect$Activity),FUN="mean")

# rename(xmeans,"Group.1"="Activity","Group.2"="Subject")
names(xmeans)[names(xmeans)=="Group.1"] <- "Subject"
names(xmeans)[names(xmeans)=="Group.2"] <- "Activity"

# Write ths file out to a txt file in the working directory.

write.table(xmeans,file="JHU_GCD_Project_Means.txt",row.names=FALSE,sep=",")

