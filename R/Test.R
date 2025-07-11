# Test for ESPN endpoints.

library(httr)
library(jsonlite)

url <- 'http://sports.core.api.espn.com/v2/sports/hockey/leagues/nhl/seasons/2025/teams?lang=en&region=us&limit=1000'
resp <- httr::GET(url)
json <- httr::content(resp, as='text', encoding='UTF-8')
out <- jsonlite::fromJSON(json, simplifyVector=TRUE, flatten=TRUE)

