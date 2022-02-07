
#Av Martin Smedstad, Samarbeidet med Andre Ydstebø Langvik og Mathias Hetland.

#Laster først inn de essensielle pakkene jeg trenger

library(tidyverse)
library(rjson)
library(ggplot2)
library(dplyr)
library(ggrepel)
library(grid)

#Oppgave 1

#Laster inn html filen fra New york times

result <- fromJSON(file = "https://static01.nyt.com/newsgraphics/2021/12/20/us-coronavirus-deaths-2021/ff0adde21623e111d8ce103fedecf7ffc7906264/scatter.json")

#Bruker så rjson til og endre til en ny dataframe

json_data_frame <- as.data.frame(result)

#Printer for å få oversikt 
print(json_data_frame)

#Gir dataframen et nytt navn (covid)

covid <- do.call(rbind.data.frame, result)

#Plotter inn de variablene jeg trenger for og svare/vise oppgave svaret
#bruker theme for gjøre plotet litt mer mitt eget
#Bruker også theme og panel.background, for og bytte bakgrunn 


covid %>%
ggplot(aes(x=deaths_per_100k, y=fully_vaccinated_pct_of_pop, colour="blue", label=name))+
  geom_point() +geom_text(hjust=0.2, vjust=0) +ggtitle("Covid-19 deaths since universal adult vaccine eligibility compared with vaccination rates") +
  theme(panel.background = element_rect(fill = "skyblue", color = "red"))
          
  



#Oppgave 2

#Bruker (geom_smooth) får og få en regresjon linje

covid %>%
ggplot(aes(x=deaths_per_100k, y=fully_vaccinated_pct_of_pop, colour="red", label=name))+
  geom_point() +geom_text(hjust=0, vjust=0) + geom_smooth(method = lm) +ggtitle("Covid-19 deaths since universal adult vaccine eligibility compared with vaccination rates") +
  theme(panel.background = element_rect(fill = "skyblue", color = "red")) 
          


lm(fully_vaccinated_pct_of_pop ~ deaths_per_100k, data = covid)

#Her blir vi presentert med 2 variabler (intercept 0.75211 og deaths_per_100k -0.01665)
#Disse to variablene forteller oss at dødsraten går nedover etter man har blitt vaksinert.
#Dette kan man også se når grafen at den er synkende

#PS, Prøvde og få geom_text + annotate for og få til samme text som på New York times. men fikk ikke det helt til







#Hentet inspirasjon/kilder

#https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/lm

#https://www.json.org/json-en.html

#https://www.nytimes.com/interactive/2021/12/28/us/covid-deaths.html?referrer=masthead

#https://www.youtube.com/watch?v=SbwknglKv7k&ab_channel=StatisticsGlobe

#https://www.rdocumentation.org/packages/plotrix/versions/3.8-2/topics/textbox

#https://ggplot2.tidyverse.org/reference/geom_text.html









