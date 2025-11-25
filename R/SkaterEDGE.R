#' Access the season(s) and game type(s) in which there exists skater EDGE 
#' statistics
#' 
#' `skater_edge_seasons` scrapes the season(s) and game type(s) in which the 
#' NHL recorded skater EDGE statistics. 
#'
#' @returns data.frame with one row per season
#' @examples
#' skater_EDGE_seasons <- skater_edge_seasons()
#' @export

skater_edge_seasons <- function() {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/edge/skater-landing/now'),
        type = 'w'
      )$seasonsWithEdgeStats
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the skater EDGE statistics leaders for a season and game type
#' 
#' `skater_edge_leaders()` scrapes the skater EDGE statistics leaders for a 
#' given set of `season` and `game_type`.
#' 
#' @param season integer in YYYYYYYY (e.g., 20242025); see 
#' [skater_edge_seasons()] for reference
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 
#' 'playoff'/'post'; see [skater_edge_seasons()] for reference; most functions 
#' will NOT support pre-season
#' @returns list of various items
#' @examples
#' skater_EDGE_leaders_regular_20242025 <- skater_edge_leaders(
#'   season    = 20242025,
#'   game_type = 2
#' )
#' @export

skater_edge_leaders <- function(season = 'now', game_type = '') {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf(
          'v1/edge/skater-landing/%s/%s', 
          season, 
          to_game_type_id(game_type)
        ),
        type = 'w'
      )$leaders
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the EDGE summary for a skater, season, and game type
#' 
#' `skater_edge_summary()` scrapes the EDGE summary for a given set of 
#' `skater`, `season`, and `game_type`.
#' 
#' @inheritParams player_seasons
#' @inheritParams skater_edge_leaders
#' @returns list of various items
#' @examples
#' Martin_Necas_EDGE_summary_regular_20242025 <- skater_edge_summary(
#'   player    = 8480039, 
#'   season    = 20242025,
#'   game_type = 2
#' )
#' @export

skater_edge_summary <- function(
  player    = 8478402, 
  season    = 'now', 
  game_type = ''
) {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf(
          'v1/edge/skater-detail/%s/%s/%s', 
          player,
          season, 
          to_game_type_id(game_type)
        ),
        type = 'w'
      )
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the EDGE zone time statistics for a skater, season, game type, and 
#' category
#' 
#' `skater_edge_zone_time()` scrapes the EDGE zone time statistics for a given 
#' set of `skater`, `season`, `game_type`, and `category`.
#' 
#' @inheritParams skater_edge_summary
#' @param category character of 'd'/'details' or 's'/'starts'
#' @returns data.frame with one row per strength state (category = 'details') 
#' or list with six items (category = 'starts')
#' @examples
#' Martin_Necas_starts_regular_20242025 <- skater_edge_zone_time(
#'   player    = 8480039,
#'   season    = 20242025,
#'   game_type = 2,
#'   category  = 'S'
#' )
#' @export

skater_edge_zone_time <- function(
  player    = 8478402,
  season    = 'now', 
  game_type = '', 
  category  = 'details'
) {
  tryCatch(
    expr = {
      category <- switch(
        substring(tolower(category), 1, 1),
        d = 'zoneTimeDetails',
        s = 'zoneStarts'
      )
      nhl_api(
        path = sprintf(
          'v1/edge/skater-zone-time/%s/%s/%s', 
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

#' Access the EDGE skating distance statistics for a skater, season, game type, 
#' and category
#' 
#' `skater_edge_skating_distance()` scrapes the EDGE skating distance 
#' statistics for a given set of `skater`, `season`, `game_type`, and 
#' `category`.
#' 
#' @inheritParams skater_edge_summary
#' @param category character of 'd'/'details' or 'l'/'l10'/'last 10'
#' @returns data.frame with one row per strength state (category = 'details') 
#' or game (category = 'last 10')
#' @examples
#' Martin_Necas_L10_skating_distance_regular_20242025 <- 
#'   skater_edge_skating_distance(
#'     player    = 8480039,
#'     season    = 20242025,
#'     game_type = 2,
#'     category  = 'L'
#'   )
#' @export

skater_edge_skating_distance <- function(
  player    = 8478402,
  season    = 'now', 
  game_type = '', 
  category  = 'details'
) {
  tryCatch(
    expr = {
      category <- switch(
        substring(tolower(category), 1, 1),
        d = 'skatingDistanceDetails',
        l = 'skatingDistanceLast10'
      )
      nhl_api(
        path = sprintf(
          'v1/edge/skater-skating-distance-detail/%s/%s/%s', 
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

#' Access the EDGE skating speed statistics for a skater, season, game type, and 
#' category
#' 
#' `skater_edge_skating_speed()` scrapes the EDGE skating speed statistics for 
#' a given set of `skater`, `season`, `game_type`, and `category`.
#' 
#' @inheritParams skater_edge_summary
#' @param category character of 'd'/'details' or 't'/'top'/'top speeds'
#' @returns list with four items (category = 'details') or data.frame with 
#' one row per burst (category = 'top speeds')
#' @examples
#' Martin_Necas_top_speeds_regular_20242025 <- skater_edge_skating_speed(
#'   player    = 8480039,
#'   season    = 20242025,
#'   game_type = 2,
#'   category  = 'T'
#' )
#' @export

skater_edge_skating_speed <- function(
  player    = 8478402,
  season    = 'now', 
  game_type = '', 
  category  = 'details'
) {
  tryCatch(
    expr = {
      category <- switch(
        substring(tolower(category), 1, 1),
        d = 'skatingSpeedDetails',
        t = 'topSkatingSpeeds'
      )
      nhl_api(
        path = sprintf(
          'v1/edge/skater-skating-speed-detail/%s/%s/%s', 
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

#' Access the EDGE shot location statistics for a skater, season, game type, and 
#' category
#' 
#' `skater_edge_shot_location()` scrapes the EDGE shot location statistics for 
#' a given set of `skater`, `season`, `game_type`, and `category`.
#' 
#' @inheritParams skater_edge_summary
#' @param category character of 'd'/details' or 't'/'totals'
#' @returns data.frame with one row per shot location
#' @examples
#' Martin_Necas_shot_location_totals_regular_20242025 <- 
#'   skater_edge_shot_location(
#'     player    = 8480039,
#'     season    = 20242025,
#'     game_type = 2,
#'     category  = 'T'
#'   )
#' @export

skater_edge_shot_location <- function(
  player    = 8478402,
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
          'v1/edge/skater-shot-location-detail/%s/%s/%s', 
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

#' Access the EDGE shot speed statistics for a skater, season, game type, and 
#' category
#' 
#' `skater_edge_shot_speed()` scrapes the EDGE shot speed statistics for a 
#' given set of `skater`, `season`, `game_type`, and `category`.
#' 
#' @inheritParams skater_edge_summary
#' @param category character of 'd'/'details' or 'h'/'hardest'
#' @returns list with six items (category = 'details') or data.frame with one 
#' row per shot (category = 'hardest')
#' @examples
#' Martin_Necas_hardest_shots_regular_20242025 <- skater_edge_shot_speed(
#'   player    = 8480039,
#'   season    = 20242025,
#'   game_type = 2,
#'   category  = 'H'
#' )
#' @export

skater_edge_shot_speed <- function(
    player    = 8478402,
    season    = 'now', 
    game_type = '', 
    category  = 'details'
) {
  tryCatch(
    expr = {
      category <- switch(
        substring(tolower(category), 1, 1),
        d = 'shotSpeedDetails',
        h = 'hardestShots',
      )
      nhl_api(
        path = sprintf(
          'v1/edge/skater-shot-speed-detail/%s/%s/%s', 
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
