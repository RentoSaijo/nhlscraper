#' Get the season(s) and game type(s) of which the NHL recorded team EDGE 
#' statistics
#' 
#' `ns_team_edge_seasons` retrieves information on each 
#'
#' @return data.frame with one row per season
#' @examples
#' team_EDGE_seasons <- ns_team_edge_seasons()
#' @export

ns_team_edge_seasons <- function() {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/edge/team-landing/now'),
        type = 'w'
      )$seasonsWithEdgeStats
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the EDGE summary of a team for a season and game type
#' 
#' `ns_team_edge_summary()` retrieves information on each 
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @return list of various items
#' @examples
#' COL_EDGE_summary_regular_20242025 <- ns_team_edge_summary(
#'   team      = 21, 
#'   season    = 20242025,
#'   game_type = 2
#' )
#' @export

ns_team_edge_summary <- function(team = 1, season = 'now', game_type = '') {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf(
          'v1/edge/team-detail/%s/%s/%s', 
          to_team_id(team), 
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

#' Get the team EDGE statistics leaders for a season and game type
#' 
#' `ns_team_edge_leaders()` retrieves information on each 
#' 
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @return list of various items
#' @examples
#' team_EDGE_leaders_regular_20242025 <- ns_team_edge_leaders(
#'   season    = 20242025,
#'   game_type = 2
#' )
#' @export

ns_team_edge_leaders <- function(season = 'now', game_type = '') {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf(
          'v1/edge/team-landing/%s/%s', 
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

#' Get the EDGE shot location statistics of a team by a season, game type, and 
#' report type
#' 
#' `ns_team_edge_shot_location()` retrieves information on each 
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type character of 'd'/details' or 't'/'totals'
#' @return data.frame with one (details) or three (totals) rows per shot 
#' location
#' @examples
#' COL_shot_location_totals_regular_20242025 <- ns_team_edge_shot_location(
#'   team        = 21,
#'   season      = 20242025,
#'   game_type   = 2,
#'   report_type = 'totals'
#' )
#' @export

ns_team_edge_shot_location <- function(
    team        = 1, 
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
          'v1/edge/team-shot-location-detail/%s/%s/%s', 
          to_team_id(team), 
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

#' Get the EDGE shot speed statistics of a team for a season, game type, and 
#' report type
#' 
#' `ns_team_edge_shot_speed()` retrieves information on each 
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type character of 'd'/'details' or 'h'/'hardest'
#' @return data.frame with one row per position (details) or shot (hardest)
#' @examples
#' COL_hardest_shots_regular_20242025 <- ns_team_edge_shot_speed(
#'   team        = 21,
#'   season      = 20242025,
#'   game_type   = 2,
#'   report_type = 'hardest'
#' )
#' @export

ns_team_edge_shot_speed <- function(
    team        = 1, 
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
          'v1/edge/team-shot-speed-detail/%s/%s/%s', 
          to_team_id(team), 
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

#' Get the EDGE skating distance statistics of a team for a season, game type, 
#' and report type
#' 
#' `ns_team_edge_skating_distance()` retrieves information on each 
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type character of 'd'/'details' or 'l'/'l10'/'last 10'
#' @return data.frame with three rows per position (details) or one row per 
#' game (L10)
#' @examples
#' COL_L10_skating_distance_regular_20242025 <- ns_team_edge_skating_distance(
#'   team        = 21,
#'   season      = 20242025,
#'   game_type   = 2,
#'   report_type = 'L10'
#' )
#' @export

ns_team_edge_skating_distance <- function(
    team        = 1, 
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
          'v1/edge/team-skating-distance-detail/%s/%s/%s', 
          to_team_id(team), 
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

#' Get the EDGE skating speed statistics of a team for a season, game type, and 
#' report type
#' 
#' `ns_team_edge_skating_speed()` retrieves information on each 
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type character of 'd'/'details' or t'/'top'/'top speeds'
#' @return data.frame with one row per position (details) or event (top speeds)
#' @examples
#' COL_top_speeds_regular_20242025 <- ns_team_edge_skating_speed(
#'   team        = 21,
#'   season      = 20242025,
#'   game_type   = 2,
#'   report_type = 'top speeds'
#' )
#' @export

ns_team_edge_skating_speed <- function(
    team        = 1, 
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
          'v1/edge/team-skating-speed-detail/%s/%s/%s', 
          to_team_id(team), 
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

#' Get the EDGE zone time statistics of a team for a season, game type, and 
#' report type
#' 
#' `ns_team_edge_zone_time()` retrieves information on each 
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type character of 'd'/'details' or 
#' 'dS'/'dShot'/'shot differential'
#' @return data.frame with one row per strength state (details) or list with 
#' four items (shot differential)
#' @examples
#' COL_dS_regular_20242025 <- ns_team_edge_zone_time(
#'   team        = 21,
#'   season      = 20242025,
#'   game_type   = 2,
#'   report_type = 'shot differential'
#' )
#' @export

ns_team_edge_zone_time <- function(
    team        = 1, 
    season      = 'now', 
    game_type   = '', 
    report_type = 'details'
) {
  tryCatch(
    expr = {
      report_type <- switch(
        tolower(report_type),
        d                   = 'zoneTimeDetails',
        details             = 'zoneTimeDetails',
        dS                  = 'shotDifferential',
        dShot               = 'shotDifferential',
        `shot differential` = 'shotDifferential'
      )
      nhl_api(
        path = sprintf(
          'v1/edge/team-zone-time-details/%s/%s/%s', 
          to_team_id(team), 
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
