## Solutions to JHU GCD Quiz 3

## Author: Michael Hunt

## Question One

library(dplyr)

# data file URL
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv

# code book URL
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

# Download data

if(!file.exists("data")){
        dir.create("data")
}

## Question One


# download data if not yet already done so
if(!file.exists("./data/Idaho2006.csv")){
        
        #download a data file as csv into the "data" dir
        
        fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
        download.file(fileURL,destfile="./data/idaho2006.csv")
        #include date of download
        datedownloaded<-date()
        datedownloaded
        
}

# download code file if not already done so
if(!file.exists("./data/idaho2006_code.pdf")){
        
        #- note set mode to "wb" since it is a pdf
        
        codefileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf"
        download.file(codefileURL,destfile="./data/idaho2006_code.pdf",mode="wb")
        
        #include date of download
        datedownloadedq1<-date()
        datedownloadedq1
} 

# read csv file into dataframe
Idaho2006<-read.csv("./data/idaho2006.csv")

# Create a logical vector that identifies the households on greater than 10 acres
# who sold more than $10,000 worth of agriculture products. Assign that logical 
# vector to the variable agricultureLogical. Apply the which() function like this
# to identify the rows of the data frame where the logical vector is TRUE. 
# which(agricultureLogical) 
# What are the first 3 values that result?

# from code book, column ACR is plot zsize, value = 3 => more than 10 acres,
# column AGS is sales of agriculturral products, value = 6 => more than $10,000

agriculturalLogical<-which(Idaho2006$ACR==3 & Idaho2006$AGS==6)
agriculturalLogical[1:3]
str(agriculturalLogical)
Idaho2006[agriculturalLogical[1:3],"ACR"]
Idaho2006[agriculturalLogical[1:3],"AGS"]

## Question Two

# Using the jpeg package read in the following picture of your instructor into R 

# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg 

# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the 
# resulting data?
# (some Linux systems may produce an answer 638 different for the 30th quantile)

# For documentation, see http://cran.r-project.org/web/packages/jpeg/jpeg.pdf

library(jpeg)

# read in the jpeg file
        
if(!file.exists("./data/jeff4.jpg")){
        
        #- note set mode to "wb" since it is a binary file (pdf, jpeg etc)
        
        fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
        download.file(fileURL,destfile="./data/jeff.jpg",mode="wb")
        
        #include date of download
        datedownloadedq2<-date()
        datedownloadedq2
} 
jeff<-readJPEG("./data/jeff.jpg",native=TRUE)
quantile(jeff,probs=c(.30,.80),include.lower=TRUE)

## Question Three

# load the GDP file

# download GDP data if not yet already done so
if(!file.exists("./data/GDP.csv")){
        
        #download a data file as csv into the "data" dir
        
        fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
        download.file(fileURL,destfile="./data/GDP.csv")
        #include date of download
        datedownloaded<-date()
        datedownloaded
        
}

# download EDU data if not yet already done so
if(!file.exists("./data/EDU.csv")){
        
        #download a data file as csv into the "data" dir
        
        fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
        download.file(fileURL,destfile="./data/EDU.csv")
        #include date of download
        datedownloaded<-date()
        datedownloaded
        
}

# load csv files into R
gdp<-read.csv("./data/GDP.csv",stringsAsFactors=FALSE,skip=4)
edu<-read.csv("./data/EDU.csv",stringsAsFactors=FALSE)

# inspect dfs with head, tail, str, summary

# on that basis....

# get df gdp into shape:
# rename the rank and gdp columns
        gdp<-rename(gdp,rank=X.1,country=X.3,gdp=X.4)
# make them both numeric - watch the commas in the gdp column!
        gdp$rank<-as.numeric(gdp$rank)
        gdp$gdp<-as.numeric(gsub(",","",gdp$gdp))

# filter out rows with no rank
        gdp<-gdp[!(is.na(gdp$rank)),]
# keep only the columns we need
        gdp<-select(gdp,X,rank,country,gdp)


#How many ranked countries in gdp are in the edu file?
        in.both<-sum(gdp$X %in% edu$CountryCode)
        in.both

# sort gdp in descending order of gdp
        gdp_sorted<-arrange(gdp,gdp)
        gdp_sorted[13,]

## Question Four

# uses same gdp and edu data frames as last question
# keep only the columns we need in edu
        edu<-select(edu,CountryCode,Income.Group)
# merge gdp and edu, using country code as id.
        gdp.edu<-merge(gdp,edu,by.x="X",by.y="CountryCode")
# find average income of high income groups
gdp.edu %>% group_by(Income.Group) %>% summarise(avg=mean(rank))
ungroup(gdp.edu)

## Question Five

gdp.edu$rankGroups = cut(gdp.edu$rank,breaks=quantile(gdp.edu$rank,
                        probs=c(0,0.2,0.4,0.6,0.8,1.0)),
                        include.lowest=TRUE)
table(gdp.edu$rankGroups)
table(gdp.edu$rankGroups,gdp.edu$Income.Group)

