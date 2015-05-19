---
title: "ReadMe"
author: "Michael Hunt"
date: "Tuesday, May 19, 2015"
output: html_document
---

## Introduction

The script run_analysis.R uses data from the UCI HAR data set, as required on the JHU_GCD Project rubric.

The data can be found at

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

and a description of the data can be found at

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Goal
The goal of the code is to write to the same repo as this README file a tidy data set that shows for each combination of subject and activity the mean value of all measurements that were of a mean of some variable or a standard deviation of a variable. There were 561 measurements altogether in the original data sets, and our subset of mean and standard deviation types picks out 83 of these.

##Where is the tidy data file?

This can be found in  the same repo as this README, and can be read into R using

        setwd("pathname/JHU_GCD/Project")

## How does the run_analysis code work?

### Set the working directory, clean the workspace and load packages as required.

(the working directory is set up)

        rm(list=ls()) - the workspace is cleaned up
        library(dplyr) - the dplyr library is loaded

### Read in test and train data

All relevant data files are read into R objects

        Xtest<-read.table("./data/test/X_test.txt")
        testLab<-read.table("./data/test/y_test.txt")
        testSub<-read.table("./data/test/subject_test.txt")

        Xtrain<-read.table("./data/train/X_train.txt")
        trainLab<-read.table("./data/train/y_train.txt")
        trainSub<-read.table("./data/train/subject_train.txt")

        activity_labels<-read.table("./data/activity_labels.txt",stringsAsFactors=FALSE)
        features<-read.table("./data/features.txt",stringsAsFactors=FALSE)

### Merge test and train subjects and activity labels
The subject and activity labels for the train and test sets are merged.

        subjects<-rbind(testSub,trainSub)
        activity<-rbind(testLab,trainLab)

### Give names to the Activity and Subject vectors.
        colnames(activity)<-c("Activity")
        colnames(subjects)<-c("Subject")

### Check for NAs in Xtest
There are none, but we had to check.

        sum(!complete.cases(Xtest)) # there are none

### Check for NAs in Xtrain
Same again for the train set.

        sum(!complete.cases(Xtrain)) # there are none

### Merge data sets by row, test set on top
Merge the test and train sets, by row, test set on top

        Xall<-rbind(Xtest,Xtrain)

### Extract the mean and standard deviation columns
Here we identify those columns that report a mean or a standard deviation.

        fmean<-function(x){grepl("mean",x,ignore.case=TRUE)}
        fstd<-function(x){grepl("std",x)}

        means<-sapply(features,fmean)
        means<-data.frame(means)

        stds<-sapply(features,fstd)
        stds<-data.frame(stds)

        select<-means+stds
### Reduce this to a vector of 1s (keep) and 0s (reject)
        select<-select$V2 

### Now use "select" to select those columns of the data set that we need
Finally, we have it. Xselect is a merger of the test and train sets, keeping only those measurements (columns) taht report a mean or of a standard deviation.

        Xselect<-Xall[,which(select==1)]

### Name the columns with the descriptive names of the selected features
Give the actual, descriptive names as given in the features file to the 
selected measurement columns.

        colnames(Xselect)<-c(features[which(select==1),2])

### Include subject and activity columns on LHS of  Xselect
On the left, add two columns, the subjects (1-30), and the activities (1-6).
Hence each row of X test reports an individual measurement of either a mean or a standard devation, for a given combination of subject and test.

        Xselect<-data.frame(subjects,activity,Xselect)

### Give descriptive labels to the activities
Replace the number codes for the activities (1-60) with their descriptive equivalents

        desclab<-function(x){
                activity_labels[x,2]
        }
        Xselect$Activity<-sapply(Xselect$Activity,desclab)

### Calculate means for each activity and each subject

        xmeans<-aggregate(Xselect[,3:86],by=list(Xselect$Subject,Xselect$Activity       ),FUN="mean")

This data set is tidy, with one variable in each column and one observation in each row. The data set itself refers to a single group of measurements


### Make Sure the subject and activity column names are correct

        names(xmeans)[names(xmeans)=="Group.1"] <- "Subject"
        names(xmeans)[names(xmeans)=="Group.2"] <- "Activity"

### Write the data out to a txt file in the working directory.

        write.table(xmeans,file="JHU_GCD_Project_Means.txt",row.names=FALSE,sep=",")

### To read the file back into R, use
        readback<-read.table("./pathname/JHU_GCD_Project_Means.txt",header=TRUE,sep=",",stringsAsFactors=FALSE)
