

##Answers to GCD, Quiz Two

## Q1
library(httr)
library(httpuv)
library(dplyr)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at at
#    https://github.com/settings/applications. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#    Have registered mbhApp at https://github.com/settings/applications/200176

#    These are key and secret for mbhApp
myapp <- oauth_app("github",
                   key = "5d271b52351635520bd9",
                   secret = "a149c55ab80572469ebe313609845ddf66b62325")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp,cache="FALSE")

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
content(req)

# OR:
#    req <- with_config(gtoken, GET("https://api.github.com/users/jtleek/repos"))
#    stop_for_status(req)
#    content(req)

library(jsonlite)
json1 = content(req)
json2 = jsonlite::fromJSON(toJSON(json1))
names(json2)
df<-select(json2,name,created_at)
df
pos<-match("datasharing",df$name)
time_created<-df$created_at[pos]
print(paste("The datasharing repo was created at",time_created))


## Q2
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

## Q3
#without sqldf
un<-uique(acs$AGEP)
str(un)
summary(un)

#with sqldf
unq<-sqldf("select distinct AGEP from acs")
str(unq)
summary(unq)

## Q4

# How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page: 
# http://biostat.jhsph.edu/~jleek/contact.html
# (Hint: the nchar() function in R may be helpful)

con = url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlcode = readLines(con)
close(con)
nchar(htmlcode[10])
nchar(htmlcode[20])
nchar(htmlcode[30])
nchar(htmlcode[100])

## Q5

#read a fixed width file into R and sum a column
#url is "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"

#download data if not yet already done so and have a look at it in NotePad

# create data folder in working dir, if one is not already there
if(!file.exists("data")){
        dir.create("data")
}

#download data file into data file, unless it is already there.
if(!file.exists("./data/qf.for")){
           
        fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
        download.file(fileURL,destfile="./data/q5.for")
        #include date of download
        datedownloaded<-date()
        datedownloaded      
}

# have a look at file in NotePad++ to determine column widths
# column widths are c(15, 4,4, 9,4, 9,4, 9,4)

df<-read.fwf(file="https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for",
             widths=c(15, 4,4, 9,4, 9,4, 9,4),
             header=FALSE,
             skip=4,
             )
sum(df[,4])