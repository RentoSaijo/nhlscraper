#' Get the season(s) and game type(s) in which there exists team EDGE statistics
#' 
#' `ns_team_edge_seasons` returns the season(s) and game type(s) in which the NHL recorded team EDGE statistics.
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
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get the team EDGE statistics leaders for a season and game type
#' 
#' `ns_team_edge_leaders()` returns the team EDGE statistics leaders for a given set of `season` and `game_type`, including but not limited to each category's leading team and their statistics. Use [ns_team_edge_seasons()] for `season` and `game_type` references.
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
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get the EDGE summary for a team, season, and game type
#' 
#' `ns_team_edge_summary()` returns the EDGE summary for a given set of `team`, `season`, and `game_type`. Use [ns_teams()] for `team` reference and [ns_team_edge_seasons()] for `season` & `game_type` references.
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
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get the EDGE zone time statistics for a team, season, game type, and report
#' type
#' 
#' `ns_team_edge_zone_time()` returns the EDGE zone time statistics for a given set of `team`, `season`, `game_type`, and `report_type`. Use [ns_teams()] for `team` reference and [ns_team_edge_seasons()] for `season` & `game_type` references.
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type character of 'd'/'details' or 
#' 'dS'/'dSOG'/'dShot'/'shot differential'
#' @return data.frame with one row per strength state (report_type = 'details') 
#' or list with four items (report_type = 'shot differential')
#' @examples
#' COL_dS_regular_20242025 <- ns_team_edge_zone_time(
#'   team        = 21,
#'   season      = 20242025,
#'   game_type   = 2,
#'   report_type = 'dS'
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
        ds                  = 'shotDifferential',
        dsog                = 'shotDifferential',
        dshot               = 'shotDifferential',
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
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get the EDGE skating distance statistics for a team, season, game type, 
#' and report type
#' 
#' `ns_team_edge_skating_distance()` returns the EDGE skating distance statistics for a given set of `team`, `season`, `game_type`, and `report_type`. Use [ns_teams()] for `team` reference and [ns_team_edge_seasons()] for `season` & `game_type` references.
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type character of 'd'/'details' or 'l'/'l10'/'last 10'
#' @return data.frame with one row per combination of strength state and 
#' position (report_type = 'details') or game (report_type = 'last 10')
#' game
#' @examples
#' COL_L10_skating_distance_regular_20242025 <- ns_team_edge_skating_distance(
#'   team        = 21,
#'   season      = 20242025,
#'   game_type   = 2,
#'   report_type = 'L'
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
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get the EDGE skating speed statistics for a team, season, game type, and 
#' report type
#' 
#' `ns_team_edge_skating_speed()` returns the EDGE skating speed statistics for a given set of `team`, `season`, `game_type`, and `report_type`. Use [ns_teams()] for `team` reference and [ns_team_edge_seasons()] for `season` & `game_type` references.
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type character of 'd'/'details' or 't'/'top'/'top speeds'
#' @return data.frame with one row per position (report_type = 'details') or 
#' burst (report_type = 'top speeds')
#' @examples
#' COL_top_speeds_regular_20242025 <- ns_team_edge_skating_speed(
#'   team        = 21,
#'   season      = 20242025,
#'   game_type   = 2,
#'   report_type = 'T'
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
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get the EDGE shot location statistics for a team, season, game type, and 
#' report type
#' 
#' `ns_team_edge_shot_location()` returns the EDGE shot location statistics for a given set of `team`, `season`, `game_type`, and `report_type`. Use [ns_teams()] for `team` reference and [ns_team_edge_seasons()] for `season` & `game_type` references.
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type character of 'd'/details' or 't'/'totals'
#' @return data.frame with one row per location (report_type = 'details') or 
#' combination of strength state and position (report_type = 'totals')
#' @examples
#' COL_shot_location_totals_regular_20242025 <- ns_team_edge_shot_location(
#'   team        = 21,
#'   season      = 20242025,
#'   game_type   = 2,
#'   report_type = 'T'
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
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get the EDGE shot speed statistics for a team, season, game type, and report
#' type
#' 
#' `ns_team_edge_shot_speed()` returns the EDGE shot speed statistics for a given set of `team`, `season`, `game_type`, and `report_type`. Use [ns_teams()] for `team` reference and [ns_team_edge_seasons()] for `season` & `game_type` references.
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param report_type character of 'd'/'details' or 'h'/'hardest'
#' @return data.frame with one row per position (report_type = 'details') or 
#' shot (report_type = 'hardest')
#' @examples
#' COL_hardest_shots_regular_20242025 <- ns_team_edge_shot_speed(
#'   team        = 21,
#'   season      = 20242025,
#'   game_type   = 2,
#'   report_type = 'H'
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
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}
