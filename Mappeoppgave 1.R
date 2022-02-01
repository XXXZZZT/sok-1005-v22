library(janitor)
library(tidyverse)
library(lubridate)
library(zoo)
library(ggplot2)



#oppgave 1

lower <- 
  read_table("https://www.nsstc.uah.edu/data/msu/v6.0/tlt/uahncdc_lt_6.0.txt") %>% 
  .[1:which(.$Year %in% "Year")-1, ] %>% 
  clean_names() %>% 
  .[ , 1:3] %>%  
  mutate(dato = ymd(paste(.$year, .$mo, 1, sep = "-"))) %>% 
  mutate_if(is.character, ~as.numeric(.)) %>% 
  select(dato, globe) %>% 
  mutate(glidende_snitt = rollmean(globe, 13, fill = NA, align = "center"))

lower %>% 
  ggplot(aes(x=dato, y=globe)) + geom_line(col="blue") + theme_bw() +
  geom_point(shape=1, col="blue") +
  geom_line(aes(y=glidende_snitt), col="red", lwd=1.2) + 
  labs(x = "Latest Global Average Tropospheric Tempratures", 
       y = "T Depature from 91-20 Avg. (deg.C)") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))







#Oppgave 2

scrape_bake <- function(url, location) {
  return(read_table(url) %>% 
           .[1:which(.$Year %in% "Year")-1, ] %>% 
           clean_names() %>% 
           mutate(dato = ymd(paste(.$year, .$mo, 1, sep = "-"))) %>% 
           mutate_if(is.character, ~as.numeric(.)) %>% 
           mutate(nivå = paste0(location)))
}
url_list <- list("http://vortex.nsstc.uah.edu/data/msu/v6.0/tlt/uahncdc_lt_6.0.txt",
                 "http://vortex.nsstc.uah.edu/data/msu/v6.0/tmt/uahncdc_mt_6.0.txt",
                 "http://vortex.nsstc.uah.edu/data/msu/v6.0/ttp/uahncdc_tp_6.0.txt",
                 "http://vortex.nsstc.uah.edu/data/msu/v6.0/tls/uahncdc_ls_6.0.txt")
location_list <- list("Lower Troposphere","Mid-Troposphere", "Tropopause", "Lower Stratosphere")

d.frame <- map2(url_list, location_list, scrape_bake)
d.frame <- ldply(d.frame, data.frame)
d.frame <- d.frame %>%  
  select(dato, no_pol, nivå) %>% 
  as_tibble() %>% 
  mutate(gj.snitt.alle = mean(no_pol))

ggplot(d.frame, aes(x = dato, y = no_pol, color = nivå)) + geom_line(linetype = "dashed") + 
  theme_bw() + geom_point(shape = 1)


df %>%
  ggplot(aes(x=deaths_per_100k, y=fully_vaccinated_pct_of_pop)) +
  geom_point(shape=21, fill="Blue", size=2, label=name) + geom_text(hjust=0, vjust=0)

