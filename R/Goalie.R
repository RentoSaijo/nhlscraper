# Goalie Functions ---------------------------------------------------------

#' Access the configurations for goalie reports
#'
#' `goalie_report_configurations()` returns the goalie-report configuration
#' block from the stats API, including valid report categories, fields, filters,
#' and split options accepted by [goalie_season_report()] and
#' [goalie_game_report()].
#'
#' @returns list with various items
#' @examples
#' goalie_report_configs <- goalie_report_configurations()
#' @export
goalie_report_configurations <- function() {
  tryCatch({
    .nhl_api(
      path = 'en/config',
      type = 's'
    )$goalieReportData
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    list()
  })
}

#' @rdname goalie_report_configurations
#' @export
goalie_report_configs <- function() {
  goalie_report_configurations()
}

#' Access various reports for a season, game type, and category for all 
#' the goalies by season
#'
#' `goalie_season_report()` returns a season-level goalie report for a selected
#' stats category, with one row per goalie and the metric columns defined by
#' that category.
#'
#' @inheritParams roster_statistics
#' @param category character (e.g., 'advanced'); see 
#' [goalie_report_configurations()] for reference
#'
#' @returns data.frame with one row per player
#' @examples
#' # May take >5s, so skip.
#' \donttest{advanced_goalie_season_report_playoffs_20212022 <- 
#'   goalie_season_report(
#'     season    = 20212022, 
#'     game_type = 3, 
#'     category  = 'advanced'
#'   )}
#' @export
goalie_season_report <- function(
  season    = season_now(), 
  game_type = game_type_now(), 
  category  = 'summary'
) {
  tryCatch(
    expr = {
      report <- .nhl_api(
        path  = sprintf('en/goalie/%s', category),
        query = list(
          limit       = -1,
          isAggregate = FALSE,
          isGame      = FALSE,
          cayenneExp  = sprintf(
            'seasonId = %s and gameTypeId = %s', 
            season,
            game_type
          )
        ),
        type  = 's'
      )$data
      report <- report[order(report$playerId), ]
      names(report)[names(report) == 'lastName'] <- 'goalieLastName'
      names(report) <- .normalize_team_abbrev_cols(names(report))
      report
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access various reports for a season, game type, and category for all 
#' the goalies by game
#'
#' `goalie_game_report()` returns the game-level version of a selected goalie
#' stats report, with one row per goalie per game and category-specific metrics.
#'
#' @inheritParams goalie_season_report
#'
#' @returns data.frame with one row per game per goalie
#' @examples
#' # May take >5s, so skip.
#' \donttest{advanced_goalie_game_report_playoffs_20212022 <- 
#'   goalie_game_report(
#'     season    = 20212022, 
#'     game_type = 3, 
#'     category  = 'advanced'
#'   )}
#' @export
goalie_game_report <- function(
  season    = season_now(),
  game_type = game_type_now(),
  category  = 'summary'
) {
  tryCatch(
    expr = {
      report <- .nhl_api(
        path  = sprintf('en/goalie/%s', category),
        query = list(
          limit       = -1,
          isAggregate = FALSE,
          isGame      = TRUE,
          cayenneExp  = sprintf(
            'seasonId = %s and gameTypeId = %s', 
            season,
            game_type
          )
        ),
        type  = 's'
      )$data
      report <- report[order(report$playerId, report$gameId), ]
      names(report)[names(report) == 'lastName'] <- 'goalieLastName'
      names(report) <- .normalize_team_abbrev_cols(names(report))
      report
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the career statistics for all the goalies
#'
#' `goalie_statistics()` returns records-site regular-season plus playoff career
#' goalie totals, with one row per goalie.
#'
#' @returns data.frame with one row per player
#' @examples
#' goalie_stats <- goalie_statistics()
#' @export
goalie_statistics <- function() {
  tryCatch({
    stats    <- .nhl_api(
      path = 'goalie_career_stats_incl_playoffs',
      type = 'r'
    )$data
    stats$id <- NULL
    names(stats)[names(stats) == 'firstName'] <- 'goalieFirstName'
    names(stats)[names(stats) == 'lastName']  <- 'goalieLastName'
    names(stats) <- .normalize_team_abbrev_cols(names(stats))
    stats[order(stats$playerId), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' @rdname goalie_statistics
#' @export
goalie_stats <- function() {
  goalie_statistics()
}

#' Access the career regular season statistics for all the goalies
#'
#' `goalie_regular_statistics()` returns records-site regular-season career
#' goalie totals, with one row per goalie.
#'
#' @returns data.frame with one row per goalie
#' @examples
#' goalie_career_regular_statistics <- goalie_regular_statistics()
#' @export
goalie_regular_statistics <- function() {
  tryCatch({
    stats    <- .nhl_api(
      path = 'goalie-career-stats',
      type = 'r'
    )$data
    stats$id <- NULL
    names(stats)[names(stats) == 'firstName'] <- 'goalieFirstName'
    names(stats)[names(stats) == 'lastName']  <- 'goalieLastName'
    names(stats) <- .normalize_team_abbrev_cols(names(stats))
    stats[order(stats$playerId), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' @rdname goalie_regular_statistics
#' @export
goalie_regular_stats <- function() {
  goalie_regular_statistics()
}


#' Access the statistics for all the goalies by season, game type, and team.
#'
#' `goalie_season_statistics()` returns records-site goalie stat rows by player,
#' team, season, and game type, preserving separate rows when a goalie changed
#' teams.
#'
#' @returns data.frame with one row per player per season per game type, 
#' separated by team if applicable
#' @examples
#' goalie_season_stats <- goalie_season_statistics()
#' @export
goalie_season_statistics <- function() {
  tryCatch({
    stats    <- .nhl_api(
      path = 'goalie-season-stats',
      type = 'r'
    )$data
    stats$id <- NULL
    stats    <- stats[order(stats$playerId, stats$seasonId, stats$gameType), ]
    names(stats)[names(stats) == 'firstName'] <- 'goalieFirstName'
    names(stats)[names(stats) == 'gameType']  <- 'gameTypeId'
    names(stats)[names(stats) == 'lastName']  <- 'goalieLastName'
    names(stats) <- .normalize_team_abbrev_cols(names(stats))
    stats
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' @rdname goalie_season_statistics
#' @export
goalie_season_stats <- function() {
  goalie_season_statistics()
}

#' Access the statistics for all the goalies by game
#'
#' `goalie_game_statistics()` returns records-site goalie stat rows by player
#' and game, including opponent fields and normalized team abbreviations.
#'
#' @returns data.frame with one row per goalie per game
#' @examples
#' \donttest{goalie_game_stats <- goalie_game_statistics()}
#' @export
goalie_game_statistics <- function() {
  tryCatch({
    stats    <- .nhl_api(
      path = 'goalie-game-stats',
      type = 'r'
    )$data
    stats$id <- NULL
    names(stats)[names(stats) == 'firstName']       <- 'goalieFirstName'
    names(stats)[names(stats) == 'lastName']        <- 'goalieLastName'
    names(stats)[names(stats) == 'triCode']         <- 'teamTriCode'
    names(stats)[names(stats) == 'opponentTriCode'] <- 'opponentTeamTriCode'
    names(stats)[names(stats) == 'opponentName']    <- 'opponentTeamName'
    names(stats) <- .normalize_team_abbrev_cols(names(stats))
    stats[order(stats$playerId, stats$gameId), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' @rdname goalie_game_statistics
#' @export
goalie_game_stats <- function() {
  goalie_game_statistics()
}

#' Access the playoff statistics for all the goalies by series
#'
#' `goalie_series_statistics()` returns records-site playoff goalie totals by
#' player and playoff series.
#'
#' @returns data.frame with one row per player per series
#' @examples
#' goalie_series_stats <- goalie_series_statistics()
#' @export
goalie_series_statistics <- function() {
  tryCatch({
    stats    <- .nhl_api(
      path = 'playoff-goalie-series-stats',
      type = 'r'
    )$data
    stats$id <- NULL
    names(stats)[names(stats) == 'firstName'] <- 'goalieFirstName'
    names(stats)[names(stats) == 'lastName']  <- 'goalieLastName'
    names(stats) <- .normalize_team_abbrev_cols(names(stats))
    stats
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' @rdname goalie_series_statistics
#' @export
goalie_series_stats <- function() {
  goalie_series_statistics()
}

#' Access the career scoring statistics for all the goalies
#'
#' `goalie_scoring()` returns records-site career scoring totals for goalies,
#' with one row per goalie.
#'
#' @returns data.frame with one row per player
#' @examples
#' goalie_scoring <- goalie_scoring()
#' @export
goalie_scoring <- function() {
  tryCatch({
    scoring    <- .nhl_api(
      path = 'goalie-career-scoring',
      type = 'r'
    )$data
    scoring$id <- NULL
    names(scoring)[names(scoring) == 'firstName'] <- 'goalieFirstName'
    names(scoring)[names(scoring) == 'lastName']  <- 'goalieLastName'
    names(scoring) <- .normalize_team_abbrev_cols(names(scoring))
    scoring[order(scoring$playerId), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the scoring statistics for all the goalies by game
#'
#' `goalie_game_scoring()` returns records-site goalie scoring rows by player
#' and game.
#'
#' @returns data.frame with one row per player per game
#' @examples
#' goalie_game_scoring <- goalie_game_scoring()
#' @export
goalie_game_scoring <- function() {
  tryCatch({
    scoring    <- .nhl_api(
      path = 'goalie-game-scoring',
      type = 'r'
    )$data
    scoring$id <- NULL
    names(scoring)[names(scoring) == 'firstName'] <- 'goalieFirstName'
    names(scoring)[names(scoring) == 'lastName']  <- 'goalieLastName'
    names(scoring) <- .normalize_team_abbrev_cols(names(scoring))
    scoring[order(scoring$playerId, scoring$gameId), ]
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the goalie statistics leaders for a season, game type, and category
#'
#' `goalie_leaders()` returns the NHL.com leaders table for one goalie category,
#' season, and game type, with normalized player and team fields.
#'
#' @inheritParams roster_statistics
#' @param category character of 'w'/'wins', 's'/shutouts', 
#' 's%'/'sP'/'save %'/'save percentage', or 'gaa'/'goals against average'
#'
#' @returns data.frame with one row per player
#' @examples
#' GAA_leaders_regular_20242025 <- goalie_leaders(
#'   season    = 20242025,
#'   game_type = 2,
#'   category  = 'GAA'
#' )
#' @export
goalie_leaders <- function(
  season    = 'current',
  game_type = '',
  category  = 'wins'
) {
  tryCatch(
    expr = {
      category <- switch(
        tolower(category),
        w                       = 'wins',
        wins                    = 'wins',
        s                       = 'shutouts',
        shutouts                = 'shutouts',
        `s%`                    = 'savePctg',
        sp                      = 'savePctg',
        `save %`                = 'savePctg',
        `save percentage`       = 'savePctg',
        gaa                     = 'goalsAgainstAverage',
        `goals against average` = 'goalsAgainstAverage'
      )
      goalies <- .nhl_api(
        path  = sprintf('v1/goalie-stats-leaders/%s/%s', season, game_type),
        type  = 'w'
      )[[category]]
      names(goalies)[names(goalies) == 'id']       <- 'playerId'
      names(goalies)[names(goalies) == 'position'] <- 'positionCode'
      names(goalies) <- .normalize_locale_names(names(goalies))
      names(goalies) <- .scope_person_name_cols(names(goalies), 'goalie')
      names(goalies) <- .normalize_team_abbrev_cols(names(goalies))
      goalies
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the goalies on milestone watch
#'
#' `goalie_milestones()` returns NHL.com goalie milestone-watch rows, including
#' goalie/team identifiers and the milestone/countdown fields exposed by the
#' endpoint.
#'
#' @returns data.frame with one row per player
#' @examples
#' goalie_milestones <- goalie_milestones()
#' @export
goalie_milestones <- function() {
  tryCatch({
    milestones    <- .nhl_api(
      path = 'en/milestones/goalies',
      type = 's'
    )$data
    milestones$id <- NULL
    names(milestones)[names(milestones) == 'firstName'] <- 'goalieFirstName'
    names(milestones)[names(milestones) == 'lastName']  <- 'goalieLastName'
    names(milestones) <- .normalize_team_abbrev_cols(names(milestones))
    milestones
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}
