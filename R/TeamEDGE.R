#' Access the season(s) and game type(s) in which there exists team EDGE 
#' statistics
#'
#' `team_edge_seasons()` retrieves the season(s) and game type(s) in which there exists team EDGE statistics as a `data.frame` where each row represents season and includes detail on date/season filtering windows and chronological context plus NHL EDGE style tracking outputs and relative-performance context.
#'
#' @returns data.frame with one row per season
#' @examples
#' team_EDGE_seasons <- team_edge_seasons()
#' @export

team_edge_seasons <- function() {
  tryCatch(
    expr = {
      seasons <- nhl_api(
        path = sprintf('v1/edge/team-landing/now'),
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

#' Access the team EDGE statistics leaders for a season and game type
#'
#' `team_edge_leaders()` retrieves the team EDGE statistics leaders for a season and game type as a nested `list` that separates summary and detail blocks for NHL EDGE style tracking outputs and relative-performance context.
#'
#' @param season integer in YYYYYYYY (e.g., 20242025); see 
#' [team_edge_seasons()] for reference
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 
#' 'playoff'/'post'; see [team_edge_seasons()] for reference; most functions 
#' will NOT support pre-season
#'
#' @returns list of various items
#' @examples
#' team_EDGE_leaders_regular_20242025 <- team_edge_leaders(
#'   season    = 20242025,
#'   game_type = 2
#' )
#' @export

team_edge_leaders <- function(season = 'now', game_type = '') {
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
      list()
    }
  )
}

#' Access the EDGE summary for a team, season, and game type
#'
#' `team_edge_summary()` retrieves the EDGE summary for a team, season, and game type as a nested `list` that separates summary and detail blocks for team identity, affiliation, and matchup-side context plus NHL EDGE style tracking outputs and relative-performance context.
#'
#' @inheritParams team_seasons
#' @inheritParams team_edge_leaders
#'
#' @returns list of various items
#' @examples
#' COL_EDGE_summary_regular_20242025 <- team_edge_summary(
#'   team      = 21, 
#'   season    = 20242025,
#'   game_type = 2
#' )
#' @export

team_edge_summary <- function(team = 1, season = 'now', game_type = '') {
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
      list()
    }
  )
}

#' Access the EDGE zone time statistics for a team, season, game type, and 
#' category
#'
#' `team_edge_zone_time()` retrieves the EDGE zone time statistics for a team, season, game type, and category as a `data.frame` where each row represents strength state and includes detail on NHL EDGE style tracking outputs and relative-performance context.
#'
#' @inheritParams team_edge_summary
#' @param category character of 'd'/'details' or 
#' 'dS'/'dSOG'/'dShot'/'shot differential'
#'
#' @returns data.frame with one row per strength state 
#' (category = 'details') or list with four items (category = 'shot 
#' differential')
#' @examples
#' COL_dS_regular_20242025 <- team_edge_zone_time(
#'   team      = 21,
#'   season    = 20242025,
#'   game_type = 2,
#'   category  = 'dS'
#' )
#' @export

team_edge_zone_time <- function(
  team      = 1, 
  season    = 'now', 
  game_type = '', 
  category  = 'details'
) {
  tryCatch(
    expr = {
      category <- switch(
        tolower(category),
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
      )[[category]]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the EDGE skating distance statistics for a team, season, game type, 
#' and category
#'
#' `team_edge_skating_distance()` retrieves the EDGE skating distance statistics for a team, season, game type, and category as a `data.frame` where each row represents combination of strength state and position and includes detail on team identity, affiliation, and matchup-side context, ranking movement, points pace, and division/conference position signals, and NHL EDGE style tracking outputs and relative-performance context.
#'
#' @inheritParams team_edge_summary
#' @param category character of 'd'/'details' or 'l'/'l10'/'last 10'
#'
#' @returns data.frame with one row per combination of strength state and 
#' position (category = 'details') or game (category = 'last 10')
#' game
#' @examples
#' COL_L10_skating_distance_regular_20242025 <- team_edge_skating_distance(
#'   team      = 21,
#'   season    = 20242025,
#'   game_type = 2,
#'   category  = 'L'
#' )
#' @export

team_edge_skating_distance <- function(
  team      = 1, 
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
          'v1/edge/team-skating-distance-detail/%s/%s/%s', 
          to_team_id(team), 
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

#' Access the EDGE skating speed statistics for a team, season, game type, and 
#' category
#'
#' `team_edge_skating_speed()` retrieves the EDGE skating speed statistics for a team, season, game type, and category as a `data.frame` where each row represents position and includes detail on team identity, affiliation, and matchup-side context, player identity, role, handedness, and biographical profile, and ranking movement, points pace, and division/conference position signals.
#'
#' @inheritParams team_edge_summary
#' @param category character of 'd'/'details' or 't'/'top'/'top speeds'
#'
#' @returns data.frame with one row per position (category = 'details') or 
#' burst (category = 'top speeds')
#' @examples
#' COL_top_speeds_regular_20242025 <- team_edge_skating_speed(
#'   team      = 21,
#'   season    = 20242025,
#'   game_type = 2,
#'   category  = 'T'
#' )
#' @export

team_edge_skating_speed <- function(
  team      = 1, 
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
          'v1/edge/team-skating-speed-detail/%s/%s/%s', 
          to_team_id(team), 
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

#' Access the EDGE shot location statistics for a team, season, game type, and 
#' category
#'
#' `team_edge_shot_location()` retrieves the EDGE shot location statistics for a team, season, game type, and category as a `data.frame` where each row represents location and includes detail on production, workload, efficiency, and result-level performance outcomes plus NHL EDGE style tracking outputs and relative-performance context.
#'
#' @inheritParams team_edge_summary
#' @param category character of 'd'/details' or 't'/'totals'
#'
#' @returns data.frame with one row per location (category = 'details') or 
#' combination of strength state and position (category = 'totals')
#' @examples
#' COL_shot_location_totals_regular_20242025 <- team_edge_shot_location(
#'   team      = 21,
#'   season    = 20242025,
#'   game_type = 2,
#'   category  = 'T'
#' )
#' @export

team_edge_shot_location <- function(
  team      = 1, 
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
          'v1/edge/team-shot-location-detail/%s/%s/%s', 
          to_team_id(team), 
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

#' Access the EDGE shot speed statistics for a team, season, game type, and 
#' category
#'
#' `team_edge_shot_speed()` retrieves the EDGE shot speed statistics for a team, season, game type, and category as a `data.frame` where each row represents position and includes detail on team identity, affiliation, and matchup-side context, player identity, role, handedness, and biographical profile, and ranking movement, points pace, and division/conference position signals.
#'
#' @inheritParams team_edge_summary
#' @param category character of 'd'/'details' or 'h'/'hardest'
#'
#' @returns data.frame with one row per position (category = 'details') or 
#' shot (category = 'hardest')
#' @examples
#' COL_hardest_shots_regular_20242025 <- team_edge_shot_speed(
#'   team      = 21,
#'   season    = 20242025,
#'   game_type = 2,
#'   category  = 'H'
#' )
#' @export

team_edge_shot_speed <- function(
  team      = 1, 
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
          'v1/edge/team-shot-speed-detail/%s/%s/%s', 
          to_team_id(team), 
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
