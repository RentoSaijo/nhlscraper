#' Access all the ESPN teams
#' 
#' `espn_teams()` scrapes all the ESPN teams.
#' 
#' @returns data.frame with one row per ESPN team
#' @examples
#' all_ESPN_teams <- espn_teams()
#' @export

espn_teams <- function() {
  tryCatch({
    page <- 1
    all_teams <- list()
    repeat {
      teams <- espn_api(
        path  = 'teams',
        query = list(limit = 1000, page = page),
        type  = 'c'
      )
      df   <- as.data.frame(teams$items, stringsAsFactors = FALSE)
      all_teams[[length(all_teams) + 1]] <- df
      if (nrow(df) < 1000) break
      page <- page + 1
    }
    out <- do.call(rbind, all_teams)
    id  <- sub('.*teams/([0-9]+)\\?lang.*', '\\1', out[[1]])
    data.frame(id = id, stringsAsFactors = FALSE)
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the ESPN summary for a team
#' 
#' `espn_team_summary()` scrapes the ESPN summary for a `team`.
#' 
#' @param team integer ID (e.g., 1); see [espn_teams()] for 
#' reference
#' @returns data.frame with one row
#' @examples
#' ESPN_summary_Boston_Bruins <- espn_team_summary(team = 1)
#' @export

espn_team_summary <- function(team = 3988803) {
  get_or_na <- function(x, ...) {
    tryCatch({
      for (nm in list(...)) {
        if (is.null(x)) return(NA)
        x <- x[[nm]]
      }
      if (is.null(x)) NA else x
    }, error = function(e) NA)
  }
  team <- tryCatch(
    espn_api(
      path = sprintf('teams/%s', team),
      type = 'c'
    ),
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      NULL
    }
  )
  if (is.null(team)) {
    return(data.frame())
  }
  data.frame(
    location = get_or_na(team, 'location'),
    name     = get_or_na(team, 'name'),
    fullName = get_or_na(team, 'displayName'),
    triCode  = get_or_na(team, 'abbreviation'),
    isActive = get_or_na(team, 'isActive'),
    stringsAsFactors = FALSE
  )
}
