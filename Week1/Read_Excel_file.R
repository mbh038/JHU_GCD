if(!file.exists("data")){
        dir.create("data")
}

fileURL<-"https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"
download.file(fileURL,destfile="./data/cameras.xlsx")
list.files("./data")


datedownloaded<-date()
datedownloaded