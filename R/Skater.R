#' Access the configurations for skater reports
#' 
#' `skater_report_configurations()` scrapes the configurations for 
#' [skater_season_report()] and [skater_game_report()].
#' 
#' @returns list with various items
#' @examples
#' skater_report_configs <- skater_report_configurations()
#' @export

skater_report_configurations <- function() {
  nhl_api(
    path = 'en/config',
    type = 's'
  )$playerReportData
}

#' @rdname skater_report_configurations
#' @export
skater_report_configs <- function() {
  skater_report_configurations()
}

#' Access various reports for a season, game type, and category for all 
#' the skaters by season
#' 
#' `skater_season_report()` scrapes various reports for a given set of 
#' `season`, `game_type`, and `category` for all the skaters by season.
#' 
#' @inheritParams roster_statistics
#' @param category character (e.g., 'puckPossessions'); see 
#' [skater_report_configurations()] for reference
#' @returns data.frame with one row per player
#' @examples
#' # May take >5s, so skip.
#' \donttest{possession_skater_season_report_playoff_20212022 <- 
#'   skater_season_report(
#'     season    = 20212022, 
#'     game_type = 3, 
#'     category  = 'puckPossessions'
#'   )}
#' @export

skater_season_report <- function(
  season    = season_now(), 
  game_type = game_type_now(), 
  category  = 'summary'
) {
  tryCatch(
    expr = {
      report <- nhl_api(
        path  = sprintf('en/skater/%s', category),
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
      report[order(report$playerId), ]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access various reports for a season, game type, and category for all 
#' the skaters by game
#' 
#' `skater_game_report()` scrapes various reports for a given set of 
#' `season`, `game_type`, and `category` for all the skaters by game.
#' 
#' @inheritParams skater_season_report
#' @returns data.frame with one row per game per player
#' @examples
#' # May take >5s, so skip.
#' \donttest{possession_skater_game_report_playoff_20212022 <- 
#'   skater_game_report(
#'     season    = 20212022, 
#'     game_type = 3, 
#'     category  = 'puckPossessions'
#'   )}
#' @export

skater_game_report <- function(
  season    = season_now(), 
  game_type = game_type_now(), 
  category  = 'summary'
) {
  tryCatch(
    expr = {
      if (game_type != 2) {
        report <- nhl_api(
          path  = sprintf('en/skater/%s', category),
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
      } else {
        seasons_tbl <- seasons()
        season_row  <- seasons_tbl[seasons_tbl$id == season, ]
        if (!nrow(season_row)) {
          stop('No season metadata found for season: ', season)
        }
        start_date <- as.Date(season_row$startDate)
        end_date   <- as.Date(season_row$regularSeasonEndDate)
        all_dates <- seq(start_date, end_date, by = '1 day')
        date_groups <- split(all_dates, format(all_dates, '%Y-%m'))
        pages <- list()
        for (dates in date_groups) {
          dates_chr <- as.character(dates)
          cayenne <- sprintf(
            'seasonId = %s and gameTypeId = %s and gameDate in (%s)',
            season,
            game_type,
            paste0('\'', dates_chr, '\'', collapse = ',')
          )
          page <- nhl_api(
            path  = sprintf('en/skater/%s', category),
            query = list(
              limit       = -1,
              isAggregate = FALSE,
              isGame      = TRUE,
              cayenneExp  = cayenne
            ),
            type  = 's'
          )$data
          if (!is.null(page)) {
            if (!is.data.frame(page)) {
              page <- as.data.frame(page, stringsAsFactors = FALSE)
            }
            if (nrow(page)) {
              pages[[length(pages) + 1]] <- page
            }
          }
        }
        if (!length(pages)) {
          return(data.frame())
        }
        report <- do.call(rbind, pages)
      }
      if (is.null(report)) {
        return(data.frame())
      }
      if (!is.data.frame(report)) {
        report <- as.data.frame(report, stringsAsFactors = FALSE)
      }
      if (!nrow(report)) {
        return(report)
      }
      report[order(report$playerId, report$gameId), ]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the career statistics for all the skaters
#' 
#' `skater_statistics()` scrapes the career statistics for all the skaters.
#' 
#' @returns data.frame with one row per player
#' @examples
#' skater_stats <- skater_statistics()
#' @export

skater_statistics <- function() {
  stats    <- nhl_api(
    path = 'skater-career-scoring-regular-plus-playoffs',
    type = 'r'
  )$data
  stats$id <- NULL
  stats[order(stats$playerId), ]
}

#' @rdname skater_statistics
#' @export
skater_stats <- function() {
  skater_statistics()
}

#' Access the career regular season statistics for all the skaters
#' 
#' `skater_regular_statistics()` scrapes the career regular season statistics 
#' for all the skaters.
#' 
#' @returns data.frame with one row per player
#' @examples
#' skater_regular_stats <- skater_regular_statistics()
#' @export

skater_regular_statistics <- function() {
  nhl_api(
    path = 'skater-career-scoring-regular-season',
    type = 'r'
  )$data
}

#' @rdname skater_regular_statistics
#' @export
skater_regular_stats <- function() {
  skater_regular_statistics()
}

#' Access the career playoff statistics for all the skaters
#' 
#' `skater_playoff_statistics()` scrapes the career playoff statistics for all 
#' the skaters.
#' 
#' @returns data.frame with one row per player
#' @examples
#' skater_playoff_stats <- skater_playoff_statistics()
#' @export

skater_playoff_statistics <- function() {
  nhl_api(
    path = 'skater-career-scoring-playoffs',
    type = 'r'
  )$data
}

#' @rdname skater_playoff_statistics
#' @export
skater_playoff_stats <- function() {
  skater_playoff_statistics()
}

#' Access the statistics for all the skaters by season, game type, and team
#' 
#' `skater_season_statistics()` scrapes the statistics for all the skaters by 
#' season, game type, and team.
#' 
#' @returns data.frame with one row per player per season per game type, 
#' separated by team if applicable
#' @examples
#' # May take >5s, so skip.
#' \donttest{skater_season_stats <- skater_season_statistics()}
#' @export

skater_season_statistics <- function() {
  stats                    <- nhl_api(
    path = 'player-stats',
    type = 'r'
  )$data
  stats$`id.db:SEQUENCENO` <- NULL
  stats[order(stats$`id.db:PLAYERID`, stats$`id.db:SEASON`), ]
}

#' @rdname skater_season_statistics
#' @export
skater_season_stats <- function() {
  skater_season_statistics()
}

#' Access the playoff statistics for all the skaters by series
#' 
#' `skater_series_statistics()` scrapes the playoff statistics for all the 
#' skaters by series.
#' 
#' @returns data.frame with one row per player per series
#' @examples
#' # May take >5s, so skip.
#' \donttest{skater_series_stats <- skater_series_statistics()}
#' @export

skater_series_statistics <- function() {
  stats    <- nhl_api(
    path = 'playoff-skater-series-stats',
    type = 'r'
  )$data
  stats$id <- NULL
  stats
}

#' @rdname skater_series_statistics
#' @export
skater_series_stats <- function() {
  skater_series_statistics()
}

#' Access the skater statistics leaders for a season, game type, and category
#' 
#' `skater_leaders()` scrapes the skater statistics leaders for a given set of 
#' `season`, `game_type`, and `category`.
#' 
#' @inheritParams roster_statistics
#' @param category string of 'a'/'assists', 'g'/goals', 
#' 'shg'/'shorthanded goals', 'ppg'/'powerplay goals', 'p'/'points', 
#' 'pim'/penalty minutes'/'penalty infraction minutes', 'toi'/'time on ice', 
#' 'pm'/'plus minus', or 'f'/'faceoffs'
#' @returns data.frame with one row per player
#' @examples
#' TOI_leaders_regular_20242025 <- skater_leaders(
#'   season    = 20242025,
#'   game_type = 2,
#'   category  = 'TOI'
#' )
#' @export

skater_leaders <- function(
  season    = 'current',
  game_type = '',
  category  = 'points'
) {
  tryCatch(
    expr = {
      category <- switch(
        tolower(category),
        a                            = 'assists',
        assists                      = 'assists',
        g                            = 'goals',
        goals                        = 'goals',
        shg                          = 'goalsSh',
        `shothanded goals`           = 'goalsSh',
        ppg                          = 'goalsPp',
        `powerplay goals`            = 'goalsPp',
        p                            = 'points',
        points                       = 'points',
        pim                          = 'penaltyMins',
        `penalty minutes`            = 'penaltyMins',
        `penalty infraction minutes` = 'penaltyMins',
        toi                          = 'toi',
        `time on ice`                = 'toi',
        pm                           = 'plusMinus',
        `plus minus`                 = 'plusMinus',
        f                            = 'faceoffLeaders',
        faceoffs                     = 'faceoffLeaders'
      )
      nhl_api(
        path  = sprintf('v1/skater-stats-leaders/%s/%s', season, game_type),
        type  = 'w'
      )[[category]]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the skaters on milestone watch
#' 
#' `skater_milestones()` scrapes the skaters on milestone watch.
#' 
#' @returns data.frame with one row per player
#' @examples
#' skater_milestones <- skater_milestones()
#' @export

skater_milestones <- function() {
  nhl_api(
    path = 'en/milestones/skaters',
    type = 's'
  )$data
}
