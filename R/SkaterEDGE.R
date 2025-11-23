#' Get the season(s) and game type(s) for which the NHL recorded skater EDGE 
#' statistics
#' 
#' `ns_skater_edge_seasons` retrieves information on each 
#'
#' @return data.frame with one row per season
#' @examples
#' skater_EDGE_seasons <- ns_skater_edge_seasons()
#' @export

ns_skater_edge_seasons <- function() {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/edge/skater-landing/now'),
        type = 'w'
      )$seasonsWithEdgeStats
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the skater EDGE statistics leaders for a season and game type
#' 
#' `ns_skater_edge_leaders()` retrieves information on each 
#' 
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @return list of various items
#' @examples
#' skater_EDGE_leaders_regular_20242025 <- ns_skater_edge_leaders(
#'   season    = 20242025,
#'   game_type = 2
#' )
#' @export

ns_skater_edge_leaders <- function(season = 'now', game_type = '') {
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
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the EDGE summary of a skater for a season and game type
#' 
#' `ns_skater_edge_summary()` retrieves information on each 
#' 
#' @param player integer ID (e.g., 8480039)
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @return list of various items
#' @examples
#' Martin_Necas_EDGE_summary_regular_20242025 <- ns_skater_edge_summary(
#'   player    = 8480039, 
#'   season    = 20242025,
#'   game_type = 2
#' )
#' @export

ns_skater_edge_summary <- function(
  player    = 8480039, 
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
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the EDGE zone time statistics of a skater for a season, game type, and 
#' report type
#' 
#' `ns_skater_edge_zone_time()` retrieves information on each 
#' 
#' @param player integer ID (e.g., 8480039)
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type character of 'd'/'details' or 's'/'starts'
#' @return data.frame with one row per strength state (report_type = 'details') 
#' or list with six items (report_type = 'starts')
#' @examples
#' Martin_Necas_starts_regular_20242025 <- ns_skater_edge_zone_time(
#'   player      = 8480039,
#'   season      = 20242025,
#'   game_type   = 2,
#'   report_type = 'S'
#' )
#' @export

ns_skater_edge_zone_time <- function(
    player      = 8480039,
    season      = 'now', 
    game_type   = '', 
    report_type = 'details'
) {
  tryCatch(
    expr = {
      report_type <- switch(
        substring(tolower(report_type), 1, 1),
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
      )[[report_type]]
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the EDGE skating distance statistics of a skater for a season, game 
#' type, and report type
#' 
#' `ns_skater_edge_skating_distance()` retrieves information on each 
#' 
#' @param player integer ID (e.g., 8480039)
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type character of 'd'/'details' or 'l'/'l10'/'last 10'
#' @return data.frame with one row per strength state (report_type = 'details') 
#' or game (report_type = 'last 10')
#' @examples
#' Martin_Necas_L10_skating_distance_regular_20242025 <- 
#'   ns_skater_edge_skating_distance(
#'     player      = 8480039,
#'     season      = 20242025,
#'     game_type   = 2,
#'     report_type = 'L'
#'   )
#' @export

ns_skater_edge_skating_distance <- function(
    player      = 8480039,
    season      = 'now', 
    game_type   = '', 
    report_type = 'details'
) {
  tryCatch(
    expr = {
      report_type <- switch(
        substring(tolower(report_type), 1, 1),
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
      )[[report_type]]
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the EDGE skating speed statistics of a skater for a season, game type, 
#' and report type
#' 
#' `ns_skater_edge_skating_speed()` retrieves information on each 
#' 
#' @param player integer ID (e.g., 8480039)
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type character of 'd'/'details' or 't'/'top'/'top speeds'
#' @return list with four items (report_type = 'details') or data.frame with 
#' one row per burst (report_type = 'top speeds')
#' @examples
#' Martin_Necas_top_speeds_regular_20242025 <- ns_skater_edge_skating_speed(
#'   player      = 8480039,
#'   season      = 20242025,
#'   game_type   = 2,
#'   report_type = 'T'
#' )
#' @export

ns_skater_edge_skating_speed <- function(
    player      = 8480039,
    season      = 'now', 
    game_type   = '', 
    report_type = 'details'
) {
  tryCatch(
    expr = {
      report_type <- switch(
        substring(tolower(report_type), 1, 1),
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
      )[[report_type]]
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the EDGE shot location statistics of a skater for a season, game type, 
#' and report type
#' 
#' `ns_skater_edge_shot_location()` retrieves information on each 
#' 
#' @param player integer ID (e.g., 8480039)
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type character of 'd'/details' or 't'/'totals'
#' @return data.frame with one row per shot location
#' @examples
#' Martin_Necas_shot_location_totals_regular_20242025 <- 
#'   ns_skater_edge_shot_location(
#'     player      = 8480039,
#'     season      = 20242025,
#'     game_type   = 2,
#'     report_type = 'T'
#'   )
#' @export

ns_skater_edge_shot_location <- function(
    player      = 8480039,
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
          'v1/edge/skater-shot-location-detail/%s/%s/%s', 
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

#' Get the EDGE shot speed statistics of a skater for a season, game type, and 
#' report type
#' 
#' `ns_skater_edge_shot_speed()` retrieves information on each 
#' 
#' @param player integer ID (e.g., 8480039)
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type character of 'd'/'details' or 'h'/'hardest'
#' @return list with six items (report_type = 'details') or data.frame with one 
#' row per shot (report_type = 'hardest')
#' @examples
#' Martin_Necas_hardest_shots_regular_20242025 <- ns_skater_edge_shot_speed(
#'   player      = 8480039,
#'   season      = 20242025,
#'   game_type   = 2,
#'   report_type = 'H'
#' )
#' @export

ns_skater_edge_shot_speed <- function(
    player      = 8480039,
    season      = 'now', 
    game_type   = '', 
    report_type = 'details'
) {
  tryCatch(
    expr = {
      report_type <- switch(
        substring(tolower(report_type), 1, 1),
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
      )[[report_type]]
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}
