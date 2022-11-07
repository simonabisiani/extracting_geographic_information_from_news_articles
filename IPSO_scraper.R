library(rvest)
library(purrr)
library(tidyverse)

suffices <- c("0,1,2,3,4,5,6,7,8,9", letters)

# generate urls
urls <-
  paste0("https://www.ipso.co.uk/complain/who-ipso-regulates/?letters=",
         suffices)

# define the scraping function
scraper <- function(urls) {
  read_html(urls) %>%
    html_elements(".pagination-listings") %>% 
    html_elements("li") %>% 
    html_text() %>% 
    as.data.frame() %>% 
    mutate(publication = gsub(" \\(.*", "", .),
           publisher = gsub(".*\\(", "", .),
           publisher = gsub("\\)", "", publisher)) %>% 
    select(-.)
  }

# iterate over the urls
ipso_members <- map_dfr(urls, scraper)
ipso_members$date <- Sys.Date()

write.csv(ipso_members, file = paste0("data-raw/ipso_members_", make.names(Sys.date()), ".csv")

