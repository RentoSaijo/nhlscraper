# Test for ESPN endpoints.

library(httr)
library(jsonlite)

url <- "https://records.nhl.com/site/api/draft-master"
resp <- httr::GET(url)
json <- httr::content(resp, as='text', encoding='UTF-8')
out <- jsonlite::fromJSON(json, simplifyVector=TRUE, flatten=TRUE)
