#' Access all the seasons
#' 
#' `ns_seasons()` scrapes information on all the seasons.
#'
#' @returns data.frame with one row per season
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

#' Access the season as of now
#' 
#' `ns_season` scrapes the current season ID.
#' 
#' @returns integer in YYYYYYYY (e.g., 20242025)
#' @examples
#' season_now <- ns_season()
#' @export

ns_season <- function() {
  nhl_api(
    path = 'en/componentSeason',
    type = 's'
  )$data$seasonId
}

#' Access the game type as of now
#' 
#' `ns_game_type()` scrapes the current game type ID.
#' 
#' @returns integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
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

#' Access the standings rules by season
#' 
#' `ns_standings_rules()` scrapes the standings rules by season.
#' 
#' @returns data.frame with one row per season
#' @examples
#' standings_rules <- ns_standings_rules()
#' @export

ns_standings_rules <- function() {
  nhl_api(
    path = 'v1/standings-season',
    type = 'w'
  )$seasons
}

#' Access the standings for a date
#' 
#' `ns_standings()` scrapes the standings for a given `date`.
#' 
#' @param date character in 'YYYY-MM-DD' (e.g., '2025-01-01'); see 
#' [ns_seasons()] for reference
#' @returns data.frame with one row per team
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
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the schedule for a date
#' 
#' `ns_schedule()` scrapes the schedule for a given `date`.
#' 
#' @inheritParams ns_standings
#' @returns data.frame with one row per game
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
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the attendance by season and game type
#' 
#' `ns_attendance()` scrapes the attendance by season and game type.
#' 
#' @returns data.frame with one row per season
#' @examples
#' all_attendance <- ns_attendance()
#' @export

ns_attendance <- function() {
  attendance <- nhl_api(
    path = 'attendance',
    type = 'r'
  )$data
  attendance$id <- NULL
  attendance[order(attendance$seasonId), ]
}
