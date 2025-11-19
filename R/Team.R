#' Get all the teams
#' 
#' `ns_teams()` retrieves information on each team, including but not limited to 
#' their ID, name, and 3-letter code.
#' 
#' @return data.frame with one row per team
#' @examples
#' all_teams <- ns_teams()
#' @export

ns_teams <- function() {
  teams <- nhl_api(
    path = 'en/team',
    type = 's'
  )$data
  teams[order(teams$id), ]
}

#' Get the season(s) and game type(s) of which a team played in
#' 
#' `ns_team_seasons()` retrieves information on each season for a given `team`, 
#' including but not limited to their ID and game-type(s). Access `ns_teams()` 
#' for `team` reference.
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @return data.frame with one row per season
#' @examples
#' COL_seasons <- ns_team_seasons(team = 21)
#' @export

ns_team_seasons <- function(team = 1) {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf('v1/club-stats-season/%s', to_team_tri_code(team)),
        type = 'w'
      )
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the roster of a team for a season and position
#' 
#' `ns_roster()` retrieves information on each player for a given set of 
#' `team`, `season`, and `position`, including but not limited to their ID, 
#' name, bio-metrics, and birth date and location. Access `ns_teams()` for 
#' `team` and `ns_team_seasons()` for `season` references.
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param position string of 'f'/'forward'/'forwards', 
#' 'd'/'defense'/'defensemen', or 'g'/goalie'/goalies'
#' @return data.frame with one row per player
#' @examples
#' COL_defensemen_20242025 <- ns_roster(
#'   team        = 1,
#'   season      = 20242025,
#'   position = 'defensemen'
#' )
#' @export

ns_roster <- function(
    team     = 1,
    season   = 'current',
    position = 'forwards'
) {
  tryCatch(
    expr = {
      position <- switch(
        tolower(position),
        f          = 'forwards',
        forward    = 'forwards',
        forwards   = 'forwards',
        d          = 'defensemen',
        defense    = 'defensemen',
        defensemen = 'defensemen',
        g          = 'goalies',
        goalie     = 'goalies',
        goalies    = 'goalies'
      )
      nhl_api(
        path = sprintf('v1/roster/%s/%s', to_team_tri_code(team), season),
        type = 'w'
      )[[position]]
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the statistics of a roster for a season, game type, and position
#' 
#' `ns_roster_statistics()` retrieves information on each player for a given set 
#' of `team`, `season`, `game_type` and `position`, including but not 
#' limited to their ID, name, and statistics. Access `ns_teams()` for `team` 
#' and `ns_team_seasons()` for `season` and `game_type` references.
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param position string of 's'/'skater'/'skaters' or 'g'/'goalie'/goalies'
#' @return data.frame with one row per player
#' @examples
#' COL_goalies_statistics_regular_20242025 <- ns_roster_statistics(
#'   team      = 21,
#'   season    = 20242025,
#'   game_type = 2,
#'   position  = 'goalies'
#' )
#' @export

ns_roster_statistics <- function(
    team      = 1,
    season    = 'now',
    game_type = '',
    position  = 'skaters'
) {
  tryCatch(
    expr = {
      position <- switch(
        tolower(position),
        s       = 'skaters',
        skater  = 'skaters',
        skaters = 'skaters',
        g       = 'goalies',
        goalie  = 'goalies',
        goalies = 'goalies'
      )
      nhl_api(
        path = sprintf(
          'v1/club-stats/%s/%s/%s', 
          to_team_tri_code(team), 
          season, 
          to_game_type_id(game_type)
        ),
        type = 'w'
      )[[position]]
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' @rdname ns_roster_statistics
#' @export
ns_roster_stats <- function(
    team      = 1,
    season    = 'now',
    game_type = '',
    position  = 'skaters'
) {
  ns_roster_statistics(team, season, game_type, position)
}

#' Get the prospects of a team for a position
#' 
#' `ns_team_prospects()` retrieves information on each prospect for a given set 
#' of `team` and `position`, including but not limited to their ID, name, 
#' bio-metrics, and birth date and location. Access `ns_teams()` for `team` 
#' reference.
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param position string of 'f'/'forward'/'forwards', 
#' 'd'/'defense'/'defensemen', or 'g'/goalie'/goalies'
#' @return data.frame with one row per player
#' @examples
#' COL_defensemen_prospects <- ns_team_prospects(
#'   team     = 21,
#'   position = 'defensemen'
#' )
#' @export

ns_team_prospects <- function(team = 1, position = 'forwards') {
  tryCatch(
    expr = {
      position <- switch(
        tolower(position),
        f          = 'forwards',
        forward    = 'forwards',
        forwards   = 'forwards',
        d          = 'defensemen',
        defense    = 'defensemen',
        defensemen = 'defensemen',
        g          = 'goalies',
        goalie     = 'goalies',
        goalies    = 'goalies'
      )
      nhl_api(
        path = sprintf('v1/prospects/%s', to_team_tri_code(team)),
        type = 'w'
      )[[position]]
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the schedule of a team for a season
#' 
#' `ns_team_schedule_season()` retrieves information on each 
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @return data.frame with one row per game
#' @examples
#' COL_schedule_20252026 <- ns_team_schedule_season(
#'   team   = 21, 
#'   season = 20252026
#' )
#' @export

ns_team_schedule_season <- function(team = 1, season = 'now') {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf(
          'v1/club-schedule-season/%s/%s', 
          to_team_tri_code(team), 
          season
        ),
        type = 'w'
      )$games
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the schedule of a team for a month
#' 
#' `ns_team_schedule_month()` retrieves information on each ...
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param month character in 'YYYY-MM' (e.g., '2025-12')
#' @return data.frame with one row per game
#' @examples
#' COL_schedule_December_2025 <- ns_team_schedule_month(
#'   team  = 21, 
#'   month = '2025-12'
#' )
#' @export

ns_team_schedule_month <- function(team = 1, month = 'now') {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf(
          'v1/club-schedule/%s/month/%s', 
          to_team_tri_code(team), 
          month
        ),
        type = 'w'
      )$games
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}

#' Get the schedule of a team for a week since a date
#' 
#' `ns_team_schedule_week()` retrieves information on each ...
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param date character in 'YYYY-MM-DD' (e.g., '2025-01-01')
#' @return data.frame with one row per game
#' @examples
#' COL_schedule_Family_Week_2025 <- ns_team_schedule_week(
#'   team = 21,
#'   date = '2025-10-06'
#' )
#' @export

ns_team_schedule_week <- function(team = 1, date = 'now') {
  tryCatch(
    expr = {
      nhl_api(
        path = sprintf(
          'v1/club-schedule/%s/week/%s', 
          to_team_tri_code(team), 
          date
        ),
        type = 'w'
      )$games
    },
    error = function(e) {
      message("Invalid argument(s); refer to help file.")
      data.frame()
    }
  )
}
