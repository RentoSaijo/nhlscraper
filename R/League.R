#' Get all seasons
#' 
#' `ns_seasons()` retrieves information on each season, including but not 
#' limited to their ID; start and end dates; number of regular season and 
#' playoff games; Stanley Cup owner; Olympics participation; entry and 
#' supplemental draft, conference-division, win-tie-loss, and wildcard 
#' regulations.
#' 
#' @return data.frame with one row per season
#' @examples
#' all_seasons <- ns_seasons()
#' @export

ns_seasons <- function() {
  seasons <- nhl_api(
    path = 'en/season',
    type = 's'
  )$data
  seasons[order(seasons$id), ]
}

#' Get standings information for all seasons
#' 
#' `ns_standings_information()` retrieves information on each season, including 
#' but not limited to their ID; start and end dates for standings; and 
#' conference-division, win-tie-loss, and wildcard regulations.
#' 
#' @return data.frame with one row per season
#' @examples
#' standings_info <- ns_standings_information()
#' @export

ns_standings_information <- function() {
  nhl_api(
    path = 'v1/standings-season',
    type = 'w'
  )$seasons
}

#' Get standings by date
#' 
#' `ns_standings()` retrieves information on each team for a given `date`, 
#' including but not limited to their ID; name; conference; division; season, 
#' recent, and home-away statistics; and waiver sequence. Access `ns_seasons()` 
#' for `date` reference.
#' 
#' @param date character in 'YYYY-MM-DD' (e.g., '2025-01-01')
#' @return data.frame with one row per team
#' @examples
#' standings_Halloween_2025 <- ns_standings(date = '2025-10-31')
#' @export

ns_standings <- function(date = 'now') {
  tryCatch(
    expr = {
      standings <- nhl_api(
        path = sprintf('v1/standings/%s', date),
        type = 'w'
      )$standings
      standings$place <- seq_len(nrow(standings))
      standings
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get schedule by date
#' 
#' `ns_schedule()` retrieves information on each game for a given `date`, 
#' including but not limited to their ID; type; venue; start time; tickets 
#' link; and home and away teams' IDs, names, and scores. Access `ns_seasons()` 
#' for `date` reference.
#' 
#' @param date character in 'YYYY-MM-DD' (e.g., '2025-01-01')
#' @return data.frame with one row per game
#' @examples
#' schedule_Halloween_2025 <- ns_schedule(date = '2025-10-31')
#' @export

ns_schedule <- function(date = Sys.Date()) {
  tryCatch(
    expr = {
      gameWeek <- nhl_api(
        path = sprintf('v1/schedule/%s', date),
        type = 'w'
      )$gameWeek
      gameWeek[gameWeek$date == date, ]$games[[1]]
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}
