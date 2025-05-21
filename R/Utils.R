#' Internal: call NHL API
#' 
#' @param path string API path
#' @param query list Query parameters
#' @return parsed JSON
#' @keywords internal

req_nhl <- function(path, query=list()) {
  base <- 'https://api-web.nhle.com/'
  url <- paste0(base, path)
  
  resp <- httr::GET(url, query=query)
  
  if (httr::http_error(resp)) {
    msg <- httr::content(resp, as='text', encoding='UTF-8')
    rlang::abort(paste('NHL API error:', httr::status_code(resp), msg))
  }
  
  json <- httr::content(resp, as='text', encoding='UTF-8')
  return(jsonlite::fromJSON(json, simplifyVector=T))
}