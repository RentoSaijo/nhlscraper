#' Get the season(s) and game type(s) for which the NHL recorded goalie EDGE 
#' statistics
#' 
#' `ns_goalie_edge_seasons` retrieves information on each 
#'
#' @return data.frame with one row per season
#' @examples
#' goalie_EDGE_seasons <- ns_goalie_edge_seasons()
#' @export

ns_goalie_edge_seasons <- function() {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/edge/goalie-landing/now'),
        type = 'w'
      )$seasonsWithEdgeStats
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the goalie EDGE statistics leaders for a season and game type
#' 
#' `ns_goalie_edge_leaders()` retrieves information on each 
#' 
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @return list of various items
#' @examples
#' goalie_EDGE_leaders_regular_20242025 <- ns_goalie_edge_leaders(
#'   season    = 20242025,
#'   game_type = 2
#' )
#' @export

ns_goalie_edge_leaders <- function(season = 'now', game_type = '') {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf(
          'v1/edge/goalie-landing/%s/%s', 
          season, 
          to_game_type_id(game_type)
        ),
        type = 'w'
      )$leaders
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the EDGE summary of a goalie for a season and game type
#' 
#' `ns_goalie_edge_summary()` retrieves information on each 
#' 
#' @param player integer ID (e.g., 8478406)
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @return list of various items
#' @examples
#' Mackenzie_Blackwood_EDGE_summary_regular_20242025 <- ns_goalie_edge_summary(
#'   player    = 8478406, 
#'   season    = 20242025,
#'   game_type = 2
#' )
#' @export

ns_goalie_edge_summary <- function(
    player    = 8478406, 
    season    = 'now', 
    game_type = ''
) {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf(
          'v1/edge/goalie-detail/%s/%s/%s', 
          player,
          season, 
          to_game_type_id(game_type)
        ),
        type = 'w'
      )
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the EDGE save percentage statistics of a goalie for a season, game type, 
#' and report type
#' 
#' `ns_goalie_edge_save_percentage()` retrieves information on each 
#' 
#' @param player integer ID (e.g., 8478406)
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type character of 'd'/'details' or 'l'/'l10'/'last 10'
#' @return list with two items (report_type = 'details') or data.frame with one 
#' row per game (report_type = 'last 10')
#' @examples
#' Mackenzie_Blackwood_L10_sP_regular_20242025 <- 
#'   ns_goalie_edge_save_percentage(
#'     player      = 8478406,
#'     season      = 20242025,
#'     game_type   = 2,
#'     report_type = 'L'
#'   )
#' @export

ns_goalie_edge_save_percentage <- function(
    player      = 8478406,
    season      = 'now', 
    game_type   = '', 
    report_type = 'details'
) {
  tryCatch(
    expr = {
      report_type <- switch(
        substring(tolower(report_type), 1, 1),
        d = 'savePctgDetails',
        l = 'savePctgLast10'
      )
      nhl_api(
        path = sprintf(
          'v1/edge/goalie-save-percentage-detail/%s/%s/%s', 
          player,
          season, 
          to_game_type_id(game_type)
        ),
        type = 'w'
      )[[report_type]]
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the EDGE 5 vs. 5 statistics of a goalie for a season, game type, and 
#' report type
#' 
#' `ns_goalie_edge_5_vs_5()` retrieves information on each 
#' 
#' @param player integer ID (e.g., 8478406)
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type character of 'd'/'details' or 'l'/'l10'/'last 10'
#' @return list with four items (report_type = 'details') or data.frame with 
#' one row per game (report_type = 'last 10')
#' @examples
#' Mackenzie_Blackwood_L10_5_vs_5_regular_20242025 <- ns_goalie_edge_5_vs_5(
#'   player      = 8478406,
#'   season      = 20242025,
#'   game_type   = 2,
#'   report_type = 'L'
#'  )
#' @export

ns_goalie_edge_5_vs_5 <- function(
    player      = 8478406,
    season      = 'now', 
    game_type   = '', 
    report_type = 'details'
) {
  tryCatch(
    expr = {
      report_type <- switch(
        substring(tolower(report_type), 1, 1),
        d = 'savePctg5v5Details',
        l = 'savePctg5v5Last10'
      )
      nhl_api(
        path = sprintf(
          'v1/edge/goalie-5v5-detail/%s/%s/%s', 
          player,
          season, 
          to_game_type_id(game_type)
        ),
        type = 'w'
      )[[report_type]]
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the EDGE shot location statistics of a goalie for a season, game type, 
#' and report type
#' 
#' `ns_goalie_edge_shot_location()` retrieves information on each 
#' 
#' @param player integer ID (e.g., 8478406)
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type character of 'd'/details' or 't'/'totals'
#' @return data.frame with one row per shot location
#' @examples
#' Mackenzie_Blackwood_shot_location_totals_regular_20242025 <- 
#'   ns_goalie_edge_shot_location(
#'     player      = 8478406,
#'     season      = 20242025,
#'     game_type   = 2,
#'     report_type = 'T'
#'   )
#' @export

ns_goalie_edge_shot_location <- function(
    player      = 8478406,
    season      = 'now', 
    game_type   = '', 
    report_type = 'details'
) {
  tryCatch(
    expr = {
      report_type <- switch(
        substring(tolower(report_type), 1, 1),
        d = 'shotLocationDetails',
        t = 'shotLocationTotals'
      )
      nhl_api(
        path = sprintf(
          'v1/edge/goalie-shot-location-detail/%s/%s/%s', 
          player,
          season, 
          to_game_type_id(game_type)
        ),
        type = 'w'
      )[[report_type]]
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}
