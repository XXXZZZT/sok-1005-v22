


library(rvest)
library(tidyverse)
library(rlist)
library(janitor)
library(lubridate)
library(dplyr)

#Samler fagene mine i 3 forskjellige url



datav <- "https://timeplan.uit.no/emne_timeplan.php?sem=22v&module%5B%5D=SOK-1005-1&week=1-20&View=list&module[]=BED-3014-1&module[]=SOK-2030-1#week-9"


#bruker så videre list for og merge de til 1

ekte_list <- list(datav)

print(ekte_list)


#Bruker så videre koden vi fikk tildelt

#Brukte stackoverflow til hjelp

timeplan_uit <- function(ekte_list) {
  vi <- read_html(ekte_list)
  tabell <- html_nodes(page, 'table') 
  tabell <- html_table(timeplan_fag, fill=TRUE) 
  fag <- list.stack(tabell)
  colnames(fag) <- fag[1,]
  fag <- fag %>% filter(!Dato=="Dato")
  fag <- fag %>% separate(Dato, 
                          into = c("Dag", "Dato"), 
                          sep = "(?<=[A-Za-z])(?=[0-9])")
  fag <- fag[-length(fag$Dag),]
  fag$Dato <- as.Date(fag$Dato, format="%d.%m.%Y")
  fag$Uke <- strftime(fag$Dato, format = "%V")
  fag <- fag %>% select(Dag,Dato,Uke,Tid,Rom,)
  
  return(fag)
  
}


test <- map(ekte_list, timeplan_uit)




#Kilder:

# https://stackoverflow.com/questions/50109329/web-scraping-in-r-with-loop-from-data-frame-rvest
# https://pluriza.medium.com/web-scraping-with-rstudio-and-rvest-ed0608fb837b
# https://rstudio-pubs-static.s3.amazonaws.com/259139_91a3bb576a514203a9e66d01b4d3992d.html

