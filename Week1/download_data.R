
#create sub-directory of the working dir called "data" if one does not exist already

if(!file.exists("data")){
        dir.create("data")
}

#download a data file as csv in the "data" dir

#on Mac, need method="curl" if url starts with https:

fileURL<-"https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileURL,destfile="./data/cameras.csv")
list.files("./data")

#include date of download
datedownloaded<-date()
datedownloaded