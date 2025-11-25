#' Get all the ESPN athletes
#' 
#' `get_espn_athletes()` retrieves the ESPN ID for each athlete. Temporarily 
#' deprecated while we re-evaluate the practicality of ESPN API information. 
#' Use [players()] instead.
#' 
#' @returns data.frame with one row per athlete
#' @examples
#' all_ESPN_athletes <- get_espn_athletes()
#' @export

get_espn_athletes <- function() {
  .Deprecated(
    new     = 'players()',
    package = 'nhlscraper',
    msg     = paste(
      '`get_espn_athletes()` is temporarily deprecated.',
      'Re-evaluating the practicality of ESPN API inforamtion.',
      'Use `players()` instead.'
    )
  )
  page <- 1
  all_athletes <- list()
  repeat {
    athletes <- espn_api(
      path  = 'athletes',
      query = list(limit = 1000, page = page),
      type  = 'c'
    )
    df <- as.data.frame(athletes$items, stringsAsFactors = FALSE)
    all_athletes[[length(all_athletes) + 1]] <- df
    if (nrow(df) < 1000) break
    page <- page + 1
  }
  out <- do.call(rbind, all_athletes)
  id  <- sub('.*athletes/([0-9]+)\\?lang.*', '\\1', out[[1]])
  data.frame(id = id, stringsAsFactors = FALSE)
}

#' Get the ESPN information on an athlete for a season
#' 
#' `get_espn_athlete()` is temporarily defunct while we re-evaluate the 
#' practicality of ESPN API information.
#'
#' @export

get_espn_athlete <- function(
  athlete = 3988803,
  season  = season() %% 1e4
) {
  .Defunct(
    msg = paste(
      '`get_espn_athlete()` is temporarily defunct.',
      'Re-evaluating the practicality of ESPN API inforamtion.'
    )
  )
}
