
library(tidyverse)
library(rjson)
library(ggplot2)

#Oppgave 1

result <- fromJSON(file = "https://static01.nyt.com/newsgraphics/2021/12/20/us-coronavirus-deaths-2021/ff0adde21623e111d8ce103fedecf7ffc7906264/scatter.json")

json_data_frame <- as.data.frame(result)

print(json_data_frame)


df <- do.call(rbind.data.frame, result)


ggplot(df, aes(x=deaths_per_100k, y=fully_vaccinated_pct_of_pop, colour="red", label=name))+
  geom_point() +geom_text(hjust=0, vjust=0)

#Oppgave 2

lm(y-fully_vaccinated_pct_of_pop ~ x-deaths_per_100k, data = df)
