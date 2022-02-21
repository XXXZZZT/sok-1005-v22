#Mappeoppgave 3

library(tidyverse)
library(rvest)
library(ggplot2)
library(lubridate)
library(janitor)
library(dplyr)


#Oppgave 1


#henter inn nettsiden

rekkevidde_tap <- read_html("https://www.motor.no/aktuelt/motors-store-vintertest-av-rekkevidde-pa-elbiler/217132")

#Ser at jeg kun har objekter, må bruke html_table
print(rekkevidde_tap)

#lager ny vector og tar i bruk html_table
faktisk_rekkevidde <- rekkevidde_tap %>% html_table(fill = TRUE)

#Endrer navn
tabel1 <- faktisk_rekkevidde[[1]]

# Tar vekk første rad
tabel1 = tabel1 [-1]

#Endrer navnene på kolonnene for å kunne bruke dataen 
tabel1 = select(tabel1, Wltp = X2, Stopp = X3, Avvik = X4)

#Bruker slice til og ta vekk radene som irrelevant
tabel1 = slice(tabel1, -c(1, 19, 26))

#Separerer kwh til en egen kolonne for å kunne bruke as.numeric funksjonen
tabel1 <- tabel1 %>%
  separate(Wltp, sep = "/", into=c("Wltp", "kWh"))


#Bruker gsub til å fjerne km slik at jeg kan omgjøre dem, som igjen kan brukes i ggplot
tabel1$Wltp <- gsub("km","",as.character(tabel1$Wltp))

tabel1$Wltp <- as.numeric(as.character(tabel1$Wltp))

tabel1$Stopp <- gsub("km","",as.character(tabel1$Stopp))

tabel1$Stopp <- as.numeric(as.character(tabel1$Stopp))



#Plotter inn for å få det til å se nogenen lunde lik orginalen


tabel1 %>%
  ggplot(aes(x=Wltp, y=Stopp)) +
  geom_point(size = 1, col="black") +
  geom_abline(size = 1.40, col = "red") +
  scale_x_continuous(limits= c(200, 650), breaks = seq(200, 700, by = 120)) +
  scale_y_continuous(limits= c(200, 650), breaks = seq(200, 700, by = 120)) +
  labs(x ="Wltp, Rekkevidde",
       y = "Stopp, Når bilene stopper") +
  theme_bw()






#Opggave 2

#Bruker lm funksjonen for å få opp Regresjonlinje

lm(Stopp ~ Wltp, data = tabel1)


tabel1 %>%
  ggplot(aes(x=Wltp, y=Stopp)) +
  geom_point(size = 1, col="black") +
  geom_abline(size = 1.40, col = "red") +
  scale_x_continuous(limits= c(200, 650), breaks = seq(200, 700, by = 120)) +
  scale_y_continuous(limits= c(200, 650), breaks = seq(200, 700, by = 120)) +
  labs(x = "Wltp, Rekkevidde",
       y = "Stopp, Når bilene stopper") +
  theme_bw() + geom_smooth(method = lm)

#Bruker geom_smoth til få det mer oversiktilig
#Her kan vi se via lm funksjonen at bilene går 0,8679km per oppgitte km



#Kilder

"https://www.youtube.com/watch?v=uQ1PSac9Ef0&list=LL&index=3"
"https://www.youtube.com/watch?v=KCUj7JQKOJA&list=LL&index=2&ab_channel=1littlecoder"
"https://stackoverflow.com/questions/14718203/removing-particular-character-in-a-column-in-r"
"https://datascience.stackexchange.com/questions/15589/remove-part-of-string-in-r"
"https://www.motor.no/aktuelt/motors-store-vintertest-av-rekkevidde-pa-elbiler/217132"
"https://dplyr.tidyverse.org/"
  