#' Access all the games
#' 
#' `games()` scrapes all the games.
#' 
#' @returns data.frame with one row per game
#' @examples
#' # May take >5s, so skip.
#' \donttest{all_games <- games()}
#' @export

games <- function() {
  tryCatch({
    games <- nhl_api(
      path = 'en/game',
      type = 's'
    )$data
    names(games)[names(games) == 'id']       <- 'gameId'
    names(games)[names(games) == 'gameType'] <- 'gameTypeId'
    games[order(games$gameId), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the scores for a date
#' 
#' `scores()` scrapes the scores for a given `date`.
#' 
#' @inheritParams standings
#' @returns data.frame with one row per game
#' @examples
#' scores_Halloween_2025 <- scores(date = '2025-10-31')
#' @export

scores <- function(date = 'now') {
  tryCatch(
    expr = {
      games <- nhl_api(
        path = sprintf('v1/score/%s', date),
        type = 'w'
      )$games
      names(games)[names(games) == 'id']       <- 'gameId'
      names(games)[names(games) == 'season']   <- 'seasonId'
      names(games)[names(games) == 'gameType'] <- 'gameTypeId'
      games[order(games$gameId), ]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the GameCenter (GC) summary for a game
#' 
#' `gc_summary()` scrapes the GC summary for a given `game`.
#' 
#' @param game integer ID (e.g., 2025020275); see [games()] for reference
#' @returns list of various items
#' @examples
#' gc_summary_Martin_Necas_legacy_game <- gc_summary(game = 2025020275)
#' @export

gc_summary <- function(game = 2023030417) {
  tryCatch(
    expr = {
      landing    <- nhl_api(
        path = sprintf('v1/gamecenter/%s/landing', game),
        type = 'w'
      )
      right_rail <- nhl_api(
        path = sprintf('v1/gamecenter/%s/right-rail', game),
        type = 'w'
      )
      summary <- c(landing, right_rail)
      names(summary)[names(summary) == 'id']       <- 'gameId'
      names(summary)[names(summary) == 'season']   <- 'seasonId'
      names(summary)[names(summary) == 'gameType'] <- 'gameTypeId'
      summary
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      list()
    }
  )
}

#' Access the World Showcase (WSC) summary for a game
#' 
#' `wsc_summary()` scrapes the WSC summary for a given `game`.
#' 
#' @inheritParams gc_summary
#' @returns list of various items
#' @examples
#' wsc_summary_Martin_Necas_legacy_game <- wsc_summary(game = 2025020275)
#' @export

wsc_summary <- function(game = 2023030417) {
  tryCatch(
    expr = {
      summary <- nhl_api(
        path = sprintf('v1/wsc/game-story/%s', game),
        type = 'w'
      )
      names(summary)[names(summary) == 'id']       <- 'gameId'
      names(summary)[names(summary) == 'season']   <- 'seasonId'
      names(summary)[names(summary) == 'gameType'] <- 'gameTypeId'
      summary
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      list()
    }
  )
}

#' Access the boxscore for a game, team, and position
#' 
#' `boxscore()` scrapes the boxscore for a given set of `game`, `team`, and `position`.
#' 
#' @inheritParams gc_summary
#' @inheritParams roster
#' @param team character of 'h'/'home' or 'a'/'away'
#' @returns data.frame with one row per player
#' @examples
#' boxscore_COL_forwards_Martin_Necas_legacy_game <- boxscore(
#'   game     = 2025020275,
#'   team     = 'H',
#'   position = 'F'
#' )
#' @export

boxscore <- function(
  game     = 2023030417,
  team     = 'home',
  position = 'forwards'
) {
  tryCatch(
    expr = {
      team <- switch(
        substring(tolower(team), 1, 1),
        h = 'home',
        a = 'away'
      )
      position <- switch(
        substring(tolower(position), 1, 1),
        f = 'forwards',
        d = 'defense',
        g = 'goalies'
      )
      boxscore <- nhl_api(
        path = sprintf('v1/gamecenter/%s/boxscore', game),
        type = 'w'
      )$playerByGameStats
      boxscore <- boxscore[[paste0(team, 'Team')]][[position]]
      names(boxscore)[names(boxscore) == 'position'] <- 'positionCode'
      boxscore
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the rosters for a game
#' 
#' `game_rosters()` scrapes the rosters for a given `game`.
#' 
#' @inheritParams gc_summary
#' @returns data.frame with one row per player
#' @examples
#' rosters_Martin_Necas_legacy_game <- game_rosters(game = 2025020275)
#' @export

game_rosters <- function(game = 2023030417) {
  tryCatch(
    expr = {
      rosters <- nhl_api(
        path = sprintf('v1/gamecenter/%s/play-by-play', game),
        type = 'w'
      )$rosterSpots
      rosters <- rosters[order(rosters$sweaterNumber), ]
      rosters[order(rosters$teamId), ]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the GameCenter (GC) play-by-play for a game
#' 
#' `gc_play_by_play()` scrapes the GC play-by-play for a given `game`.
#' 
#' @inheritParams gc_summary
#' @returns data.frame with one row per event (play)
#' @examples
#' gc_pbp_Martin_Necas_legacy_game <- gc_play_by_play(game = 2025020275)
#' @export

gc_play_by_play <- function(game = 2023030417) {
  tryCatch(
    expr  = {
      game  <- as.integer(game)
      plays <- nhl_api(
        path = sprintf('v1/gamecenter/%s/play-by-play', game),
        type = 'w'
      )$plays

      # Rename columns.
      plays$gameId <- game
      plays        <- plays[, c('gameId', setdiff(names(plays), 'gameId'))]
      nms <- names(plays)
      nms[nms == 'details.typeCode'] <- 'penaltyTypeCode'
      idx          <- grepl('\\.', nms)
      nms[idx]     <- sub('^[^.]*\\.', '', nms[idx])
      nms[nms == 'number'] <- 'period'
      names(plays) <- nms

      # Fix zoneCode for blocked shots.
      idx <- plays$typeDescKey == 'blocked-shot' &
        plays$zoneCode %in% c('O', 'D')
      plays$zoneCode[idx] <- ifelse(
        plays$zoneCode[idx] == 'O',
        'D',
        'O'
      )

      # Remove inconsistent columns.
      plays$timeRemaining <- NULL

      # Clean.
      plays <- strip_game_id(plays) |>
        strip_time_period() |>
        flag_is_home() |>
        strip_situation_code() |>
        normalize_coordinates() |>
        calculate_distance() |>
        calculate_angle() |>
        flag_is_rush() |>
        flag_is_rebound() |>
        count_goals_shots()

      # Remove redundant columns.
      plays$awayScore <- NULL
      plays$homeScore <- NULL
      plays
    },
    error = function(e) {
      message(paste(
        'Invalid argument(s); refer to help file.',
        '\nProvided game:',
        game
      ))
      data.frame()
    }
  )
}

#' @rdname gc_play_by_play
#' @export

gc_pbp <- function(game = 2023030417) {
  gc_play_by_play(game)
}

#' Access the World Showcase (WSC) play-by-play for a game
#' 
#' `wsc_play_by_play()` scrapes the WSC play-by-play for given `game`.
#' 
#' @inheritParams gc_summary
#' @returns data.frame with one row per event (play)
#' @examples
#' wsc_pbp_Martin_Necas_legacy_game <- wsc_play_by_play(game = 2025020275)
#' @export

wsc_play_by_play <- function(game = 2023030417) {
  tryCatch(
    expr = {
      plays        <- nhl_api(
        path = sprintf('v1/wsc/play-by-play/%s', game),
        type = 'w'
      )
      # Rename column.
      plays$id     <- NULL
      plays$gameId <- game
      plays        <- plays[, c('gameId', setdiff(names(plays), 'gameId'))]
      
      # Fix zoneCode for blocked shots.
      idx <- plays$typeDescKey == 'blocked-shot' &
        plays$zoneCode %in% c('O', 'D')
      plays$zoneCode[idx] <- ifelse(
        plays$zoneCode[idx] == 'O',
        'D',
        'O'
      )

      # Remove inconsistent columns.
      plays$goalModifier     <- NULL
      plays$strength         <- NULL
      plays$strengthCode     <- NULL
      plays$goalCode         <- NULL
      plays$secondsRemaining <- NULL

      # Clean.
      plays <- strip_game_id(plays) |>
        strip_time_period() |>
        flag_is_home() |>
        strip_situation_code() |>
        normalize_coordinates() |>
        calculate_distance() |>
        calculate_angle() |>
        flag_is_rush() |>
        flag_is_rebound() |>
        count_goals_shots()

      # Remove redundant columns.
      plays$awayScore <- NULL
      plays$homeScore <- NULL
      plays
    },
    error = function(e) {
      message(paste(
        'Invalid argument(s); refer to help file.',
        '\nProvided game:',
        game
      ))
      data.frame()
    }
  )
}

#' @rdname wsc_play_by_play
#' @export

wsc_pbp <- function(game = 2023030417) {
  wsc_play_by_play(game)
}

#' Access the shift chart for a game
#' 
#' `shift_chart()` scrapes the shift chart for a given `game`.
#' 
#' @inheritParams gc_summary
#' @returns data.frame with one row per shift
#' @examples
#' shifts_Martin_Necas_legacy_game <- shift_chart(game = 2025020275)
#' @export

shift_chart <- function(game = 2023030417) {
  tryCatch(
    expr = {
      shifts <- nhl_api(
        path  = 'en/shiftcharts',
        query = list(cayenneExp = sprintf('gameId = %s', game)),
        type  = 's'
      )$data
      shifts <- shifts[order(shifts$teamId), ]
      shifts <- shifts[is.na(shifts$eventDescription), ]
      shifts <- shifts[, c('id', 'gameId', 'teamId', 'playerId', 'eventNumber', 'shiftNumber', 'period', 'startTime', 'endTime')]
      is_playoffs <- game %/% 1e4 %% 1e2 == 3
      base        <- ifelse(
        shifts$period <= 3L,
        (shifts$period - 1L) * 1200L,
        ifelse(
          is_playoffs,
          3600L + (shifts$period - 4L) * 1200L,
          3600L + (shifts$period - 4L) * 300L
        )
      )
      tp_s  <- strsplit(shifts$startTime, ':', fixed = TRUE)
      s_min <- as.integer(vapply(tp_s, `[`, '', 1L))
      s_sec <- as.integer(vapply(tp_s, `[`, '', 2L))
      s_elp <- 60L * s_min + s_sec
      tp_e  <- strsplit(shifts$endTime, ':', fixed = TRUE)
      e_min <- as.integer(vapply(tp_e, `[`, '', 1L))
      e_sec <- as.integer(vapply(tp_e, `[`, '', 2L))
      e_elp <- 60L * e_min + e_sec
      shifts$startSecondsElapsedInPeriod <- s_elp
      shifts$endSecondsElapsedInPeriod   <- e_elp
      shifts$startSecondsElapsedInGame   <- base + s_elp
      shifts$endSecondsElapsedInGame     <- base + e_elp
      shifts$duration                    <- shifts$endSecondsElapsedInGame - shifts$startSecondsElapsedInGame
      shifts$id <- NULL
      shifts
    },
    error = function(e) {
      message(paste(
        'Invalid argument(s); refer to help file.',
        '\nProvided game:',
        game
      ))
      data.frame()
    }
  )
}

#' Access the real-time game odds for a country by partnered bookmaker
#' 
#' `game_odds()` scrapes the real-time game odds for a given `country` by 
#' partnered bookmaker.
#' 
#' @param country two-letter code (e.g., 'CA'); see [countries()] for 
#' reference
#' @returns data.frame with one row per game
#' @examples
#' game_odds_CA <- game_odds(country = 'CA')
#' @export

game_odds <- function(country = 'US') {
  tryCatch(
    expr = {
      games <- nhl_api(
        path = sprintf('v1/partner-game/%s/now', country),
        type = 'w'
      )$games
      names(games)[names(games) == 'gameType'] <- 'gameTypeId'
      games
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}
