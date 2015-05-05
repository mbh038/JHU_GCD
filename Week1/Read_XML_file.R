##Read XML files into R

## First example - a food menu

library(XML)
fileURL<-"http://www.w3schools.com/xml/simple.xml"
doc<-xmlTreeParse(fileURL,useInternal=TRUE)

#get the root node = "wrapper" for whole document
rootNode<-xmlRoot(doc)

#get name of root node
xmlName(rootNode)

#get names of next level elements
names(rootNode)

#get the first element - like getting a list member in R
rootNode[[1]]


#get the first element within the first element
rootNode[[1]][[1]]

#get values of all elements
xmlSApply(rootNode,xmlValue)

#get values of one type of node
xpathSApply(rootNode,"//name",xmlValue)

xpathSApply(rootNode,"//price",xmlValue)


##Second Example - a football team website

fileURL<-"http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
doc<-htmlTreeParse(fileURL,useInternal=TRUE)

sub<-xpathSApply(doc,"//li[@class='sub']",xmlValue)
sub

##try the BBC website

fileURL<-"http://www.bbc.co.uk/sport/0/football/"
bbcdoc<-htmlTreeParse(fileURL,useInternal=TRUE)

teams<-xpathSApply(bbcdoc,"//td[@class='team-name']",xmlValue)
teams
