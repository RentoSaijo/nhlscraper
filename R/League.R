#' Access all the seasons
#' 
#' `seasons()` scrapes all the seasons.
#'
#' @returns data.frame with one row per season
#' @examples
#' all_seasons <- seasons()
#' @export

seasons <- function() {
  tryCatch({
    seasons <- nhl_api(
      path = 'en/season',
      type = 's'
    )$data
    seasons <- seasons[order(seasons$id), ]
    names(seasons)[names(seasons) == 'id'] <- 'seasonId'
    seasons
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the season as of now
#' 
#' `season_now` scrapes the current season.
#' 
#' @returns integer in YYYYYYYY (e.g., 20242025)
#' @examples
#' season_now <- season_now()
#' @export

season_now <- function() {
  tryCatch({
    nhl_api(
      path = 'en/componentSeason',
      type = 's'
    )$data$seasonId
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    -1
  })
}

#' Access the game type as of now
#' 
#' `game_type_now()` scrapes the current game type.
#' 
#' @returns integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season)
#' @examples
#' game_type_now <- game_type_now()
#' @export

game_type_now <- function() {
  tryCatch({
    nhl_api(
      path = 'en/componentSeason',
      type = 's'
    )$data$gameTypeId
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    -1
  })
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
  tryCatch({
    seasons <- nhl_api(
      path = 'v1/standings-season',
      type = 'w'
    )$seasons
    names(seasons)[names(seasons) == 'id'] <- 'seasonId'
    seasons
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
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
      gameWeek <- gameWeek[gameWeek$date == date, ]$games[[1]]
      names(gameWeek)[names(gameWeek) == 'id']       <- 'gameId'
      names(gameWeek)[names(gameWeek) == 'season']   <- 'seasonId'
      names(gameWeek)[names(gameWeek) == 'gameType'] <- 'gameTypeId'
      gameWeek
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access all the venues
#' 
#' `venues()` scrapes all the venues.
#' 
#' @returns data.frame with one row per venue
#' @examples
#' all_venues <- venues()
#' @export

venues <- function() {
  tryCatch({
    venues    <- nhl_api(
      path = 'venue',
      type = 'r'
    )$data
    venues$id <- NULL
    venues[order(venues$venueId), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
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
  tryCatch({
    attendance <- nhl_api(
      path = 'attendance',
      type = 'r'
    )$data
    attendance$id <- NULL
    attendance[order(attendance$seasonId), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}
