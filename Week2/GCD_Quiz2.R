

##Answers to GCD, Quiz Two

#Q2
#create sub-directory of the working dir called "data" if one does not exist already

library(sqldf)
#library(RMySQL) #DONT load this package!!!!

if(!file.exists("data")){
        dir.create("data")
}


#download data if not yet already done so
if(!file.exists("./data/acs.csv")){
        
        #download a data file as csv in the "data" dir
        
        #on Mac, need method="curl" if url starts with https:
        
        fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
        download.file(fileURL,destfile="./data/acs.csv")
        #include date of download
        datedownloaded<-date()
        datedownloaded
        
}

#load data into R df
acs<-read.csv("./data/acs.csv")

#try to get pwgtp1 for which AGEP<50
# without using sqldf
dat<-select(acs,AGEP,pwgtp1)
dat50<-filter(dat,AGEP<50)
str(dat50)

#now do it using sqldf
sdat50<-sqldf("select pwgtp1 from acs where AGEP < 50")
str(dat50)

#Q3
#without sqldf
un<-uique(acs$AGEP)
str(un)
summary(un)

#with sqldf
unq<-sqldf("select distinct AGEP from acs")
str(unq)
summary(unq)


