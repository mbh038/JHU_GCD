## Solutions to JHU GCD Quiz 4

## Author: Michael Hunt

## Question One

# Apply strsplit() to split all the names of the data frame on the characters
# "wgtp". What is the value of the 123 element of the resulting list?

# "wgt" "15"
# "" "15"
# "w" "15"
# "15"


# data file URL
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv

# code book URL
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

# Set working directory
setwd("C:/Users/Mike/Rspace/JHU_GCD/Week4")
# Download data

if(!file.exists("data")){
        dir.create("data")
}

## Question One

# Apply strsplit() to split all the names of the data frame on the
# characters "wgtp". 
# What is the value of the 123 element of the resulting list?

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
idaho2006<-read.csv("./data/idaho2006.csv")

# Apply strsplit() to split all the names of the data frame on the characters
# "wgtp".

idanames<-names(idaho2006)
str(idanames)

idasplit<-strsplit(idanames,split="wgtp",fixed=TRUE)

# What is the value of the 123 element of the resulting list?

idasplit[[123]]

## Question Two

# Load the Gross Domestic Product data for the 190 ranked countries in this data set: 
        
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 

# Remove the commas from the GDP numbers in millions of dollars and average them.

# What is the average? 

# Original data sources: http://data.worldbank.org/data-catalog/GDP-ranking-table

# The answer is one of these...
answers<-c(387854.4,377652.4,381668.9,379596.5)

# download data if not yet already done so
if(!file.exists("./data/gdp.csv")){
        
        #download a data file as csv into the "data" dir
        
        fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
        download.file(fileURL,destfile="./data/gdp.csv")
        #include date of download
        datedownloaded<-date()
        datedownloaded
        
}

# read csv file into dataframe
gdp<-read.csv("./data/GDP.csv",stringsAsFactors=FALSE,skip=4)

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

gdpmean<-mean(gdp$gdp)
gdpmean

## Question Three

# In the data set from Question 2 what is a regular expression that would allow
# you to count the number of countries whose name begins with "United"?
# Assume that the variable with the country names in it is named countryNames.
# How many countries begin with United?

# grep("^United",countryNames), 4
# grep("*United",countryNames), 5
# grep("^United",countryNames), 3
# grep("*United",countryNames), 2

library(dplyr)
arrange(gdp,country)

# inspection shows that the answer is 3.

# Now try the grep expressions.

a1<-grep("^United",gdp$country)#, 4
a1
a2<-grep("*United",gdp$country)#, 5
a2
a3<-grep("^United",gdp$country)#, 3
a3
a4<-grep("*United",gdp$country)#, 2
a4


## Question Four

# Load the Gross Domestic Product data for the 190 ranked countries in this data set: 
        
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 

# Load the educational data from this data set: 
        
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv 

# Match the data based on the country shortcode. Of the countries for which the
# end of the fiscal year is available.

# how many end in June? 

# Original data sources: 
# http://data.worldbank.org/data-catalog/GDP-ranking-table 
# http://data.worldbank.org/data-catalog/ed-stats

# 16
# 7
# 8
# 13

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

#filter edu coutries down to only those with a GDP rank

edugdp<-edu %>% filter(CountryCode %in% gdp$X)

# which column of edu wqould have end of fiscal year info in it?
regexpr('June',edugdp,ignore.case=TRUE)
regexpr('Fiscal year end',edugdp,ignore.case=TRUE)

# which suggests column 10 : Special.Notes

#which rows have each word?
fiscal<-grep("Fiscal year end",edugdp$Special.Notes,ignore.case=TRUE)
fiscal
#fiscal<data.frame(fiscal)
june<-grep("June",edugdp$Special.Notes,ignore.case=TRUE)
june
#There are 16 of these. 


#Which rows have both words?
library(dplyr)
in.both<-intersect(june,fiscal)
in.both

#check the rows found to contain both "June" and "Fiscal year end"
edugdp$Special.Notes[in.both]

#There are 13 correct answers

# check the rows found to contain June but not "Fiscal year end"
onlyinjune<-june[!(june %in% fiscal)]
onlyinjune
edugdp$Special.Notes[onlyinjune]

# There were 3 of these, but the word June is not todo wit the fiscal year.

# answer is 13

## Question Five

# You can use the quantmod (http://www.quantmod.com/) package to get historical
# stock prices for publicly traded companies on the NASDAQ and NYSE.
# Use the following code to download data on Amazon's 
# stock price and get the times the data was sampled.

# How many values were collected in 2012?
# How many values were collected on Mondays in 2012?

# 250, 47
# 252, 50
# 365, 52
# 251, 47

# get the data
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn) 

# inspect the data
head(amzn)
str(amzn)

head(sampleTimes)
str(sampleTimes)

#extract year and day columns from sampleTimes
year<-as.POSIXlt(sampleTimes)$year+1900
day<-as.POSIXlt(sampleTimes)$wday

# convert xct object to data.frame, so we can use dplyr on it
amzndf<-data.frame(amzn)

# include year and day in the main data set
amzndf<-cbind(year,day,amzndf)

names(amzndf)

# find number of updates in 2012
n2007<-nrow(filter(amzndf,year==2012))
n2007

# find number of update on Mondays in 2012
mon2007<-nrow(filter(amzndf,year==2012 & day==1))
mon2007