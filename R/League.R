#' Access all the seasons
#'
#' `seasons()` returns the stats API season catalog with one row per season,
#' including season IDs, date boundaries, and game-type metadata.
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
#' `season_now()` retrieves the season as of now and returns a scalar integer used as the current-context default in season/game-type dependent wrappers.
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
#' `game_type_now()` retrieves the game type as of now and returns a scalar integer used as the current-context default in season/game-type dependent wrappers.
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
#' `standings_rules()` returns the public standings-season catalog with one row
#' per season and the rules/metadata used by standings endpoints.
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
#' `standings()` returns public standings for one date with one row per team,
#' including rank, record, points, streak, division/conference, and normalized
#' team fields.
#'
#' @param date character in 'YYYY-MM-DD' (e.g., '2025-01-01'); see 
#' [seasons()] for reference
#'
#' @returns data.frame with one row per team
#' @examples
#' standings_Halloween_2025 <- standings(date = '2025-10-31')
#' @export

standings <- function(date = 'now') {
  tryCatch(
    expr = {
      standings <- nhl_api(
        path = sprintf('v1/standings/%s', date),
        type = 'w'
      )$standings
      names(standings) <- normalize_locale_names(names(standings))
      names(standings) <- normalize_team_abbrev_cols(names(standings))
      standings
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the schedule for a date
#'
#' `schedule()` returns the public schedule rows for one date, including game
#' IDs, teams, start/status, scores, venue, broadcasts, and links.
#'
#' @inheritParams standings
#'
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
      names(gameWeek) <- normalize_locale_names(names(gameWeek))
      names(gameWeek) <- normalize_team_abbrev_cols(names(gameWeek))
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
#' `venues()` returns the records-site venue catalog with one row per venue and
#' location/name fields.
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
#' `attendance()` returns records-site attendance totals by season and game type.
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
