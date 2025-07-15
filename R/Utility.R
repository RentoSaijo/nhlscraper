#' Call NHL API
#' 
#' @param path String
#' @param query list
#' @param type integer where 1=api-web, 2=api.nhle, and 3=records.nhl
#' @return parsed JSON
#' @keywords internal

nhl_api <- function(path, query=list(), type) {
  if (type==1) {
    base <- 'https://api-web.nhle.com/v1/'
  } else if (type==2) {
    base <- 'https://api.nhle.com/stats/rest/'
    if (path!='ping') {
      base <- paste0(base, 'en/')
    }
  } else {
    base <- 'https://records.nhl.com/site/api/'
  }
  url <- paste0(base, path)
  resp <- httr::GET(url, query=query)
  json <- httr::content(resp, as='text', encoding='UTF-8')
  return(jsonlite::fromJSON(json, simplifyVector=TRUE, flatten=TRUE))
}

#' Call ESPN API
#' 
#' @param path String
#' @param query list
#' @param type integer where 1=site.api and 2=sports.core
#' @return parsed JSON
#' @keywords internal

espn_api <- function(path, query=list(), type) {
  if (type==1) {
    base <- 'https://site.api.espn.com/apis/site/v2/sports/hockey/nhl/'
  }
  else {
    base <- 'https://sports.core.api.espn.com/v2/sports/hockey/leagues/nhl/'
  }
  url <- paste0(base, path)
  resp <- httr::GET(url, query=query)
  json <- httr::content(resp, as='text', encoding='UTF-8')
  return(jsonlite::fromJSON(json, simplifyVector=TRUE, flatten=TRUE))
}
