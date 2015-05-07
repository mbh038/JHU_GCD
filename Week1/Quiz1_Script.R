
##install and load required packages, if necessary

install.packages(xlsx)
install.packages(XML)
install.packages(data.table)
install.packages(dplyr)
library(xlsx)
library(XML)
library(data.table)
library(dplyr)



##Set working directory
#to whichever directory has "data" as a sub-directory




##Answers to GCD, Quiz One

#create sub-directory of the working dir called "data" if one does not exist already

if(!file.exists("data")){
        dir.create("data")
}

##Question One


#download data if not yet already done so
if(!file.exists("./data/Idahohousing.csv")){
        
        #download a data file as csv in the "data" dir
                  
        #on Mac, need method="curl" if url starts with https:
                  
        fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
        download.file(fileURL,destfile="./data/idahohousing.csv")
        #include date of download
        datedownloaded<-date()
        datedownloaded
          
}

#download code file if not already done so
if(!file.exists("./data/idahohousing_code.pdf")){
        
        #- note set mode to "wb" since it is a pdf
        
        codefileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf"
        download.file(codefileURL,destfile="./data/idahohousing_code.pdf",mode="wb")
        #list.files("./data")
        
        #include date of download
        datedownloaded<-date()
        datedownloaded
}         

          
#read csv file into dataframe
IdahoData<-read.csv("./data/idahohousing.csv")

# code fles say house value are in column "VAL", which contains integers `1-24
# In that column, value=24=> value exceeds $1,000,000

#look at this column - code book says is integers 1-24
#str(IdahoData$VAL)

# lots of NAs!

#This will return how many houses are worth more than $1m.
#deals with the NAs
q1<-sum(IdahoData$VAL==24,na.rm=TRUE)
q1.answer<-paste("Answer to Question One is",q1,sep=" ")
q1.answer

## Question Three

if(!file.exists("./data/ngap.xlsx")){
        
        #note that mode is set to "wb" for excel files becuase they are binary files.
        fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
        download.file(fileURL,destfile="./data/ngap.xlsx",mode="wb")
        #list.files("./data")
        
        
        datedownloaded<-date()
        datedownloaded      
}



ngap<-read.xlsx("./data/ngap.xlsx",sheetIndex=1,header=TRUE)
#head(ngap)

#reading specific rows and columns
colIndex<-7:15
rowIndex<-18:23
dat<-read.xlsx("./data/ngap.xlsx",sheetIndex=1,colIndex=colIndex,
                            rowIndex=rowIndex)
dat

q3<-sum(dat$Zip*dat$Ext,na.rm=T) 
q3.answer<-paste("Answer to Question Two is",q3,sep=" ")
q3.answer

##Question Four

if(!file.exists("./data/rest.xml")){
        #read xml file into a document
        fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
        download.file(fileURL,destfile="./data/rest.xml")
                
}

doc<-xmlTreeParse("./data/rest.xml",useInternal=TRUE)
#get the root node = "wrapper" for whole document
rootNode<-xmlRoot(doc)
#parse document for zipcodes
zipcodes<-xpathSApply(rootNode,"//zipcode",xmlValue)
#str(zipcodes)
q4<-sum(zipcodes==21231)
q4.answer<-paste("Answer to Question Four is",q4,sep=" ")
q4.answer


##Question Five
#download data if not yet already done so
if(!file.exists("./data/Idaho2006.csv")){
        
        #download a data file as csv in the "data" dir
        
        #on Mac, need method="curl" if url starts with https:
        
        fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
        download.file(fileURL,destfile="./data/Idaho2006.csv")
        #include date of download
        datedownloaded<-date()
        datedownloaded
        
}

DT<-fread("./data/Idaho2006.csv")

#works
a1<-tapply(DT$pwgtp15,DT$SEX,mean)
a1
t1<-system.time(
        for(i in 1:1000){
                a1<-tapply(DT$pwgtp15,DT$SEX,mean)      
        }
)
t1

#does not work
#a2<-rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]
#a2
#t2<-system.time(rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2])
#t2

#works
a3<-sapply(split(DT$pwgtp15,DT$SEX),mean)
a3
t3<-system.time(
        for(i in 1:1000){
                a3<-sapply(split(DT$pwgtp15,DT$SEX),mean)      
        }     
)
t3

#does not calculate two means
#a4<-mean(DT$pwgtp15,by=DT$SEX)
#a4
#t4<-system.time(mean(DT$pwgtp15,by=DT$SEX))
#t4

#works
a5<-mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
a5

t5<-system.time(
        for(i in 1:1000){
                a5<-mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)     
        }
)
t5

#works
a6<-DT[,mean(pwgtp15),by=SEX]
a6
t6<-system.time(
        for(i in 1:1000){
                a6<-DT[,mean(pwgtp15),by=SEX]       
        }
)

calc.times<-data.frame(c("t1","t3","t5","t6"),c(t1[1],t3[1],t5[1],t6[1])
                       ,c(t1[2],t3[2],t5[2],t6[2]))
names(calc.times)<-c("method","user.time","elapsed.time")
arrange(calc.times,user.time)
print(paste("The fasted method is",arrange(calc.times,user.time)[1,1],sep=" "))