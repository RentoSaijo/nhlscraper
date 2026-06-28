# Skater EDGE Functions ---------------------------------------------------------

#' Access the season(s) and game type(s) in which there exists skater EDGE 
#' statistics
#'
#' `skater_edge_seasons()` returns the seasons and game type IDs for which the
#' NHL EDGE skater endpoints expose data.
#'
#' @returns data.frame with one row per season
#' @examples
#' skater_EDGE_seasons <- skater_edge_seasons()
#' @export
skater_edge_seasons <- function() {
  tryCatch(
    expr = {
      seasons <- .nhl_api(
        path = sprintf('v1/edge/skater-landing/now'),
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

#' Access the skater EDGE statistics leaders for a season and game type
#'
#' `skater_edge_leaders()` returns the skater EDGE landing-page leader groups
#' for one season and game type, such as speed, distance, shot speed, shot
#' location, and zone-time leader blocks.
#'
#' @param season integer in YYYYYYYY (e.g., 20242025); see 
#' [skater_edge_seasons()] for reference
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 
#' 'playoff'/'post'; see [skater_edge_seasons()] for reference; most functions 
#' will NOT support pre-season
#'
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
      .nhl_api(
        path = sprintf(
          'v1/edge/skater-landing/%s/%s', 
          season, 
          .to_game_type_id(game_type)
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

#' Access the EDGE summary for a skater, season, and game type
#'
#' `skater_edge_summary()` returns the full NHL EDGE detail payload for one
#' skater, season, and game type, including player metadata and the available
#' skating, shot, and zone-time summary blocks.
#'
#' @inheritParams player_seasons
#' @inheritParams skater_edge_leaders
#'
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
      .nhl_api(
        path = sprintf(
          'v1/edge/skater-detail/%s/%s/%s', 
          player,
          season, 
          .to_game_type_id(game_type)
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

#' Access the EDGE zone time statistics for a skater, season, game type, and 
#' category
#'
#' `skater_edge_zone_time()` returns a skater's EDGE zone-time detail table by
#' strength state, or the zone-start split list when `category = 'starts'`.
#'
#' @inheritParams skater_edge_summary
#' @param category character of 'd'/'details' or 's'/'starts'
#'
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
      .nhl_api(
        path = sprintf(
          'v1/edge/skater-zone-time/%s/%s/%s', 
          player,
          season, 
          .to_game_type_id(game_type)
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
#' `skater_edge_skating_distance()` returns a skater's EDGE distance detail by
#' strength state, or recent game rows when `category = 'last 10'`.
#'
#' @inheritParams skater_edge_summary
#' @param category character of 'd'/'details' or 'l'/'l10'/'last 10'
#'
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
      .nhl_api(
        path = sprintf(
          'v1/edge/skater-skating-distance-detail/%s/%s/%s', 
          player,
          season, 
          .to_game_type_id(game_type)
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
#' `skater_edge_skating_speed()` returns a skater's EDGE skating-speed detail
#' list, or top-speed burst rows when `category = 'top speeds'`.
#'
#' @inheritParams skater_edge_summary
#' @param category character of 'd'/'details' or 't'/'top'/'top speeds'
#'
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
      .nhl_api(
        path = sprintf(
          'v1/edge/skater-skating-speed-detail/%s/%s/%s', 
          player,
          season, 
          .to_game_type_id(game_type)
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
#' `skater_edge_shot_location()` returns a skater's EDGE shot-location detail
#' by rink region, or totals by shot-location bucket when `category = 'totals'`.
#'
#' @inheritParams skater_edge_summary
#' @param category character of 'd'/details' or 't'/'totals'
#'
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
      .nhl_api(
        path = sprintf(
          'v1/edge/skater-shot-location-detail/%s/%s/%s', 
          player,
          season, 
          .to_game_type_id(game_type)
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
#' `skater_edge_shot_speed()` returns a skater's EDGE shot-speed detail list, or
#' hardest-shot rows when `category = 'hardest'`.
#'
#' @inheritParams skater_edge_summary
#' @param category character of 'd'/'details' or 'h'/'hardest'
#'
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
      .nhl_api(
        path = sprintf(
          'v1/edge/skater-shot-speed-detail/%s/%s/%s', 
          player,
          season, 
          .to_game_type_id(game_type)
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
