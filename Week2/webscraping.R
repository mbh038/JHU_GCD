## Ways to webscrape

## http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en

##1
## open a connection

con=url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode=readLines(con)
close(con)
htmlCode

## this just gives unstructured output, so use XML package instead

##2 Use XML package
library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes=T)
xpathSApply(html, "//title", xmlValue)
#xpathSApply(html, "//td[@id='col-citedby']", xmlValue)

##3 Use httr package
# This achieves same as ##2
library(httr); html2 = GET(url)
content2 = content(html2,as="text")
parsedHtml = htmlParse(content2,asText=TRUE)
xpathSApply(parsedHtml, "//title", xmlValue)
#xpathSApply(parsedHtml , "//td[@id='col-citedby']", xmlValue)

# but may need to use httr in more complex cases

##4 Accessing websites with passwords

#This does not work becuase we have not been authenticated
pg1 = GET("http://httpbin.org/basic-auth/user/passwd")
pg1

##4 but httr package allows us to authenticate entry if we know the username and password
#http://httpbin.org/basic-auth/user/passwd is test site with user = "user, password = "passwd"
pg2 = GET("http://httpbin.org/basic-auth/user/passwd",
          authenticate("user","passwd"))
pg2
names (pg2)

#then we can use content to get at the content ???? How ????

## 5 use Handles
google = handle("http://google.com")
pg1 = GET(handle=google,path="/")
pg2 = GET(handle=google,path="search")