#' Internal: call NHL API
#' 
#' @param path String API path
#' @param query list Query parameters
#' @param stats_rest boolean isStatsRest where TRUE=NHL's REST API and FALSE=
#'                   NHL's standard API
#' @return parsed JSON
#' 
#' @keywords internal

nhl_api <- function(path, query=list(), stats_rest=FALSE) {
  if (stats_rest) {
    if (path=='ping') {
      base <- 'https://api.nhle.com/stats/rest/'
    }
    else {
      base <- 'https://api.nhle.com/stats/rest/en/'
    }
  }
  else {
    base <- 'https://api-web.nhle.com/v1/'
  }
  url <- paste0(base, path)
  resp <- httr::GET(url, query=query)
  json <- httr::content(resp, as='text', encoding='UTF-8')
  return(jsonlite::fromJSON(json, simplifyVector=TRUE, flatten=TRUE))
}
