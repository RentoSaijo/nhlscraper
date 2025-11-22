#' Get all the seasons
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

#' Get the real-time season
#' 
#' `ns_season()` retrieves the season as of now.
#' 
#' @return integer in YYYYYYYY (e.g., 20242025)
#' @examples
#' season_now <- ns_season()
#' @export

ns_season <- function() {
  nhl_api(
    path = 'en/componentSeason',
    type = 's'
  )$data$seasonId
}

#' Get the real-time game type
#' 
#' `ns_game_type()` retrieves the game type as of now.
#' 
#' @return integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season)
#' @examples
#' game_type_now <- ns_game_type()
#' @export

ns_game_type <- function() {
  nhl_api(
    path = 'en/componentSeason',
    type = 's'
  )$data$gameTypeId
}

#' Get information about the standings for all the seasons
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

#' @rdname ns_standings_information
#' @export
ns_standings_info <- function() {
  ns_standings_information()
}

#' Get the standings for a date
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
      nhl_api(
        path = sprintf('v1/standings/%s', date),
        type = 'w'
      )$standings
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the schedule for a date
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

#' Get the attendance for all the seasons
#' 
#' `ns_attendance()` retrieves information on each season, including but not 
#' limited to their ID and regular and playoff attendance.
#' 
#' @return data.frame with one row per season
#' @examples
#' all_attendance <- ns_attendance()
#' @export

ns_attendance <- function() {
  nhl_api(
    path = 'attendance',
    type = 'r'
  )$data
}
