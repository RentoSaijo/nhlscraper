#' Get all the seasons
#' 
#' `ns_seasons()` returns information on all the seasons, including but not limited to each season's ID, start & end dates, and rules.
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

#' Get the season as of now
#' 
#' `ns_season()` returns the ID of the current season.
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

#' Get the game type as of now
#' 
#' `ns_game_type()` returns the ID of the current game type (i.e., whether we are in pre-season, regular season, or the playoffs).
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

#' Get the standings rules for all the seasons
#' 
#' `ns_standings_rules()` returns information on the standings for all the seasons, including but not limited to each season's ID and each standing's start & end dates and rules.
#' 
#' @return data.frame with one row per season
#' @examples
#' standings_rules <- ns_standings_rules()
#' @export

ns_standings_rules <- function() {
  nhl_api(
    path = 'v1/standings-season',
    type = 'w'
  )$seasons
}

#' Get the standings for a date
#' 
#' `ns_standings()` returns information on the standings for a given `date`, including but not limited to each team's ID, record, and statistics. Use [ns_season()] for `date` reference.
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
#' `ns_schedule()` returns information on the schedule for a given `date`, including but not limited to each game's ID, competing teams, start time, and venue. Use [ns_season()] for `date` reference.
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
#' `ns_attendance()` returns information on the attendance for all the seasons, including but not limited to each season's ID and regular season & playoff attendance.
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
