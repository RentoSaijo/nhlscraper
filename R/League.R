#' Access all the seasons
#' 
#' `seasons()` scrapes information on all the seasons.
#'
#' @returns data.frame with one row per season
#' @examples
#' all_seasons <- seasons()
#' @export

seasons <- function() {
  seasons <- nhl_api(
    path = 'en/season',
    type = 's'
  )$data
  seasons[order(seasons$id), ]
}

#' Access the season as of now
#' 
#' `season` scrapes the current season ID.
#' 
#' @returns integer in YYYYYYYY (e.g., 20242025)
#' @examples
#' season_now <- season()
#' @export

season <- function() {
  nhl_api(
    path = 'en/componentSeason',
    type = 's'
  )$data$seasonId
}

#' Access the game type as of now
#' 
#' `game_type()` scrapes the current game type ID.
#' 
#' @returns integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season)
#' @examples
#' game_type_now <- game_type()
#' @export

game_type <- function() {
  nhl_api(
    path = 'en/componentSeason',
    type = 's'
  )$data$gameTypeId
}

#' Access the standings rules by season
#' 
#' `standings_rules()` scrapes the standings rules by season.
#' 
#' @returns data.frame with one row per season
#' @examples
#' standings_rules <- standings_rules()
#' @export

standings_rules <- function() {
  nhl_api(
    path = 'v1/standings-season',
    type = 'w'
  )$seasons
}

#' Access the standings for a date
#' 
#' `standings()` scrapes the standings for a given `date`.
#' 
#' @param date character in 'YYYY-MM-DD' (e.g., '2025-01-01'); see 
#' [seasons()] for reference
#' @returns data.frame with one row per team
#' @examples
#' standings_Halloween_2025 <- standings(date = '2025-10-31')
#' @export

standings <- function(date = 'now') {
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
#' `schedule()` scrapes the schedule for a given `date`.
#' 
#' @inheritParams standings
#' @returns data.frame with one row per game
#' @examples
#' schedule_Halloween_2025 <- schedule(date = '2025-10-31')
#' @export

schedule <- function(date = Sys.Date()) {
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

#' Access all the venues
#' 
#' `venues()` scrapes information on all the venues.
#' 
#' @returns data.frame with one row per venue
#' @examples
#' all_venues <- venues()
#' @export

venues <- function() {
  venues    <- nhl_api(
    path = 'venue',
    type = 'r'
  )$data
  venues$id <- NULL
  venues[order(venues$venueId), ]
}

#' Access the attendance by season and game type
#' 
#' `attendance()` scrapes the attendance by season and game type.
#' 
#' @returns data.frame with one row per season
#' @examples
#' all_attendance <- attendance()
#' @export

attendance <- function() {
  attendance <- nhl_api(
    path = 'attendance',
    type = 'r'
  )$data
  attendance$id <- NULL
  attendance[order(attendance$seasonId), ]
}
