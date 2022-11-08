library(rvest)
library(tidyverse)
library(purrr)

root_url <- "https://www.holdthefrontpage.co.uk/directory/"
suffices <- c("newspaperwebsites/",
              "dailynewspapers/",
              "weeklynewspapers/",
              "mediacompanies/")

# generate urls
urls <- paste0(root_url,
               suffices)

pager <- function(page) {
  doc <- read_html(url(page))
  data.frame(
    Publication = doc %>% html_elements(".pf-content") %>% html_elements("li") %>% html_text(),
    Website = doc %>% html_elements(".pf-content") %>% html_elements("li") %>% html_element("a") %>% html_attr("href"),
    Type = doc %>% html_elements(".entry-title") %>% html_text()
  )
}

htfp <- do.call(rbind, lapply(urls, pager))


############### HYPERLOCALS

hyperlocals <-
  "https://www.holdthefrontpage.co.uk/directory/hyperlocal-publications/"

hl <-
  data.frame(
    Publication <-
      read_html(hyperlocals) %>% html_elements("td:nth-child(1)") %>% html_text(),
    Website <-
      read_html(hyperlocals) %>% html_elements("td:nth-child(2)") %>% html_element("a") %>% html_attr("href"),
    Type <- "Hyperlocal publications"
  )

names(hl) <- c("Publication", "Website", "Type")
hl <- hl[-c(1:2), ]

htfp_database <- rbind(htfp, hl)

write.csv(htfp_database, paste0("data_raw/htfp_directory_",make.names(Sys.Date()),".csv"))
