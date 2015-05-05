if(!file.exists("data")){
        dir.create("data")
}
#note that mode is set to "wb" for excel files becuase they are binary files.
#same applies for other binary files .pdf and .jpeg
fileURL<-"https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"
download.file(fileURL,destfile="./data/cameras.xlsx",mode="wb")
list.files("./data")


datedownloaded<-date()
datedownloaded

#use xlsx package. Could also use others.eg Excel connect
library(xlsx)
cameraData<-read.xlsx("./data/cameras.xlsx",sheetIndex=1,header=TRUE)
head(cameraData)

#reading specific rows and columns
colIndex<-2:3
rowIndex<-1:4
cameraDataSubset<-read.xlsx("./data/cameras.xlsx",sheetIndex=1,colIndex=colIndex,
                            rowIndex=rowIndex)
cameraDataSubset

#writing files to excel
write.xlsx(cameraDataSubset,"./data/cameras_subset.xlsx")