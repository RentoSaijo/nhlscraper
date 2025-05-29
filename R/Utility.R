#' Internal: call NHL API
#' 
#' @param path String API path
#' @param query list Query parameters
#' @return parsed JSON
#' @keywords internal

nhl_api <- function(path, query=list(), stats_rest=F) {
  if (stats_rest) {
    base <- 'https://api.nhle.com/stats/rest/en/'
  }
  else {
    base <- 'https://api-web.nhle.com/v1/'
  }
  url <- paste0(base, path)
  resp <- httr::GET(url, query=query)
  json <- httr::content(resp, as='text', encoding='UTF-8')
  return(jsonlite::fromJSON(json, simplifyVector=T, flatten=T))
}