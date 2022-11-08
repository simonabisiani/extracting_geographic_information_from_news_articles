library(rvest)
library(purrr)
library(tidyverse)

# generate urls
url <- "https://www.impress.press/regulated-publications/"

# define the scraping function
scraper_impress <- function(url) {
  read_html(url) %>%
    html_elements(".span-md-8") %>% 
    html_elements("a") %>% 
    html_text() 
}


# iterate over the urls
impress_members <- as.data.frame(scraper_impress(url)) %>%  
  rename("publisher"="scraper_impress(url)")

write.csv(impress_members, paste0("data_raw/impress_members_",make.names(Sys.Date()),".csv"))

