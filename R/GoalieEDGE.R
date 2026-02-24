#' Access the season(s) and game type(s) in which there exists goalie EDGE 
#' statistics
#'
#' `goalie_edge_seasons()` retrieves the season(s) and game type(s) in which there exists goalie EDGE statistics as a `data.frame` where each row represents season and includes detail on date/season filtering windows and chronological context plus NHL EDGE style tracking outputs and relative-performance context.
#'
#' @returns data.frame with one row per season
#' @examples
#' goalie_EDGE_seasons <- goalie_edge_seasons()
#' @export

goalie_edge_seasons <- function() {
  tryCatch(
    expr = {
      seasons <- nhl_api(
        path = sprintf('v1/edge/goalie-landing/now'),
        type = 'w'
      )$seasonsWithEdgeStats
      names(seasons)[names(seasons) == 'id']        <- 'seasonId'
      names(seasons)[names(seasons) == 'gameTypes'] <- 'gameTypeIds'
      seasons
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the goalie EDGE statistics leaders for a season and game type
#'
#' `goalie_edge_leaders()` retrieves the goalie EDGE statistics leaders for a season and game type as a nested `list` that separates summary and detail blocks for NHL EDGE style tracking outputs and relative-performance context.
#'
#' @param season integer in YYYYYYYY (e.g., 20242025); see 
#' [goalie_edge_seasons()] for reference
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 
#' 'playoff'/'post'; see [goalie_edge_seasons()] for reference; most functions 
#' will NOT support pre-season
#'
#' @returns list of various items
#' @examples
#' goalie_EDGE_leaders_regular_20242025 <- goalie_edge_leaders(
#'   season    = 20242025,
#'   game_type = 2
#' )
#' @export

goalie_edge_leaders <- function(season = 'now', game_type = '') {
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
      message('Invalid argument(s); refer to help file.')
      list()
    }
  )
}

#' Access the EDGE summary for a goalie, season, and game type
#'
#' `goalie_edge_summary()` retrieves the EDGE summary for a goalie, season, and game type as a nested `list` that separates summary and detail blocks for player identity, role, handedness, and biographical profile plus NHL EDGE style tracking outputs and relative-performance context.
#'
#' @inheritParams goalie_edge_leaders
#' @param player integer ID (e.g., 8478406)
#'
#' @returns list of various items
#' @examples
#' Mackenzie_Blackwood_EDGE_summary_regular_20242025 <- goalie_edge_summary(
#'   player    = 8478406, 
#'   season    = 20242025,
#'   game_type = 2
#' )
#' @export

goalie_edge_summary <- function(
    player    = 8476945, 
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
      message('Invalid argument(s); refer to help file.')
      list()
    }
  )
}

#' Access the EDGE save percentage statistics for a goalie, season, game type, 
#' and category
#'
#' `goalie_edge_save_percentage()` retrieves the EDGE save percentage statistics for a goalie, season, game type, and category as a nested `list` that separates summary and detail blocks for NHL EDGE style tracking outputs and relative-performance context.
#'
#' @inheritParams goalie_edge_summary
#' @param category character of 'd'/'details' or 'l'/'l10'/'last 10'
#'
#' @returns list with two items (category = 'details') or data.frame with one 
#' row per game (category = 'last 10')
#' @examples
#' Mackenzie_Blackwood_L10_sP_regular_20242025 <- 
#'   goalie_edge_save_percentage(
#'     player    = 8478406,
#'     season    = 20242025,
#'     game_type = 2,
#'     category  = 'L'
#'   )
#' @export

goalie_edge_save_percentage <- function(
  player    = 8476945,
  season    = 'now', 
  game_type = '', 
  category  = 'details'
) {
  tryCatch(
    expr = {
      category <- switch(
        substring(tolower(category), 1, 1),
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
      )[[category]]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the EDGE 5 vs. 5 statistics for a goalie, season, game type, and 
#' category
#'
#' `goalie_edge_five_versus_five()` retrieves the EDGE 5 vs. 5 statistics for a goalie, season, game type, and category as a nested `list` that separates summary and detail blocks for production, workload, efficiency, and result-level performance outcomes plus NHL EDGE style tracking outputs and relative-performance context.
#'
#' @inheritParams goalie_edge_summary
#' @param category character of 'd'/'details' or 'l'/'l10'/'last 10'
#'
#' @returns list with four items (category = 'details') or data.frame with 
#' one row per game (category = 'last 10')
#' @examples
#' Mackenzie_Blackwood_L10_5_vs_5_regular_20242025 <- goalie_edge_five_versus_five(
#'   player    = 8478406,
#'   season    = 20242025,
#'   game_type = 2,
#'   category  = 'L'
#'  )
#' @export

goalie_edge_five_versus_five <- function(
  player    = 8476945,
  season    = 'now', 
  game_type = '', 
  category  = 'details'
) {
  tryCatch(
    expr = {
      category <- switch(
        substring(tolower(category), 1, 1),
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
      )[[category]]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' @rdname goalie_edge_five_versus_five
#' @export
goalie_edge_5_vs_5 <- function(
  player    = 8476945,
  season    = 'now', 
  game_type = '', 
  category  = 'details'
) {
  goalie_edge_five_versus_five(player, season, game_type, category)
}

#' Access the EDGE shot location statistics for a goalie, season, game type, 
#' and category
#'
#' `goalie_edge_shot_location()` retrieves the EDGE shot location statistics for a goalie, season, game type, and category as a `data.frame` where each row represents shot location and includes detail on production, workload, efficiency, and result-level performance outcomes plus NHL EDGE style tracking outputs and relative-performance context.
#'
#' @inheritParams goalie_edge_summary
#' @param category character of 'd'/details' or 't'/'totals'
#'
#' @returns data.frame with one row per shot location
#' @examples
#' Mackenzie_Blackwood_shot_location_totals_regular_20242025 <- 
#'   goalie_edge_shot_location(
#'     player    = 8478406,
#'     season    = 20242025,
#'     game_type = 2,
#'     category  = 'T'
#'   )
#' @export

goalie_edge_shot_location <- function(
    player    = 8476945,
    season    = 'now', 
    game_type = '', 
    category  = 'details'
) {
  tryCatch(
    expr = {
      category <- switch(
        substring(tolower(category), 1, 1),
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
      )[[category]]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}
