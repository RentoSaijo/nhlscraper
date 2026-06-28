# ESPNTeam Functions ---------------------------------------------------------

#' Access all the ESPN teams
#'
#' `espn_teams()` pages ESPN's team index and returns one row per team
#' containing the ESPN team ID used by [espn_team_summary()].
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
      teams <- .espn_api(
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
    data.frame(espnTeamId = id, stringsAsFactors = FALSE)
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the ESPN summary for a team
#'
#' `espn_team_summary()` returns a compact one-row ESPN team profile with
#' location, display names, abbreviation, and active status.
#'
#' @param team integer ID (e.g., 1); see [espn_teams()] for 
#' reference
#'
#' @returns data.frame with one row
#' @examples
#' ESPN_summary_Boston_Bruins <- espn_team_summary(team = 1)
#' @export
espn_team_summary <- function(team = 1) {
  get_or_na <- function(x, ...) {
    tryCatch({
      for (nm in list(...)) {
        if (is.null(x)) return(NA)
        x <- x[[nm]]
      }
      if (is.null(x)) NA else x
    }, error = function(e) NA)
  }
  tryCatch(
    expr = {
      team <- as.integer(team[[1]])
      if (is.na(team)) {
        stop('Invalid team.')
      }
      team <- .espn_api(
        path = sprintf('teams/%s', team),
        type = 'c'
      )
      data.frame(
        location      = get_or_na(team, 'location'),
        teamName      = get_or_na(team, 'name'),
        teamFullName  = get_or_na(team, 'displayName'),
        teamTriCode   = get_or_na(team, 'abbreviation'),
        isActive      = get_or_na(team, 'isActive'),
        stringsAsFactors = FALSE
      )
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}
