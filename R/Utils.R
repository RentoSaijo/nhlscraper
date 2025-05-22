#' Internal: call NHL API
#' 
#' @param path string API path
#' @param query list Query parameters
#' @return parsed JSON
#' @keywords internal

req_nhl <- function(path, query=list()) {
  base <- 'https://api-web.nhle.com/v1/'
  url <- paste0(base, path)
  resp <- httr::GET(url, query=query)
  json <- httr::content(resp, as='text', encoding='UTF-8')
  return(jsonlite::fromJSON(json, simplifyVector=T, flatten=T))
}