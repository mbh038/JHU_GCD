##My GCD project

## Ana;lysis of UCI HAR data set.

##Author ; Michael Hunt

#create sub-directory of the working dir called "data" if one does not exist already

setwd("C:/Users/Mike/Rspace/JHU_GCD/Project")


if(file.exists("./data/HAR.csv")){
        print("data set already in ./data directory")
        df.Harus<-read.table("./data/HAR.csv",
                       sep=",",
                       header=T,,
                       stringsAsFactors=FALSE)
}   

if(!file.exists("./data/HAR.csv")){
        ##download data from UCI website into csv file
        print("downloading data from GCD Project site")
        temp<-tempfile()
        fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL,temp, mode="wb")
        unzip(temp, "household_power_consumption.txt")
        #file.rename(from="household_power_consumption.txt",to="./data/household_power_consumption.csv")
        
        ##read data from csv file into data frame DF
        df.HAR<-read.table("./data/household_power_consumption.csv",
                       sep=";",
                       header=T,
                       stringsAsFactors=FALSE)
        