#' Get all the teams
#' 
#' `ns_teams()` returns information on all the teams, including but not limited to each team's ID, name, and three-letter code.
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

#' Get the season(s) and game type(s) in which a team played
#' 
#' `ns_team_seasons()` returns the season(s) and game type(s) in which a team played in the NHL.
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
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get statistics for all the teams by season and game type
#' 
#' `ns_team_season_statistics()` returns statistics for all the teams by season and game type, including but not limited to each team's ID, wins, ties, and losses.
#' 
#' @return data.frame with one row per team per game type per season
#' @examples
#' # This may take >5s, so skip.
#' \donttest{team_season_statistics <- ns_team_season_statistics()}
#' @export

ns_team_season_statistics <- function() {
  nhl_api(
    path = 'team-stats',
    type = 'r'
  )$data
}

#' @rdname ns_team_season_statistics
#' @export
ns_team_season_stats <- function() {
  ns_team_season_statistics()
}

#' Get the roster for a team, season, and position
#' 
#' `ns_roster()` returns the roster for a given set of `team`, `season`, and `position`, including but not limited to each player's ID, name, and bio-metrics. Use [ns_teams()] for `team` reference and [ns_seasons()] for `season` reference.
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param position character of 'f'/'forwards', 'd'/'defensemen', or 
#' 'g'/'goalies'
#' @return data.frame with one row per player
#' @examples
#' COL_defensemen_20242025 <- ns_roster(
#'   team     = 21,
#'   season   = 20242025,
#'   position = 'D'
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
        substring(tolower(position), 1, 1),
        f = 'forwards',
        d = 'defensemen',
        g = 'goalies'
      )
      nhl_api(
        path = sprintf('v1/roster/%s/%s', to_team_tri_code(team), season),
        type = 'w'
      )[[position]]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get the roster statistics for a team, season, game type, and position
#' 
#' `ns_roster_statistics()` returns the roster statistics for a given set of `team`, `season`, `game_type`, and `position`, including but not limited to each player's ID, goals, assists, and points. Use [ns_teams()] for `team` reference and [ns_seasons()] for `season` & `game_type` references.
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 'playoff'/'post'
#' @param position character of 's'/'skaters' or 'g'/'goalies'
#' @return data.frame with one row per player
#' @examples
#' COL_goalies_statistics_regular_20242025 <- ns_roster_statistics(
#'   team      = 21,
#'   season    = 20242025,
#'   game_type = 2,
#'   position  = 'G'
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
        substring(tolower(position), 1, 1),
        s = 'skaters',
        g = 'goalies'
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
      message('Invalid argument(s); refer to help file.')
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

#' Get the prospects for a team and position
#' 
#' `ns_team_prospects()` returns the prospects for a given set of `team` and `position`, including but not limited to each player's ID, name, and bio-metrics. Use [ns_teams()] for `team` reference and [ns_seasons()] for `season` & `game_type` references.
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param position character of 'f'/'forwards', 'd'/'defensemen', or 
#' 'g'/'goalies'
#' @return data.frame with one row per player
#' @examples
#' COL_forward_prospects <- ns_team_prospects(
#'   team     = 21,
#'   position = 'F'
#' )
#' @export

ns_team_prospects <- function(team = 1, position = 'forwards') {
  tryCatch(
    expr = {
      position <- switch(
        substring(tolower(position), 1, 1),
        f = 'forwards',
        d = 'defensemen',
        g = 'goalies'
      )
      nhl_api(
        path = sprintf('v1/prospects/%s', to_team_tri_code(team)),
        type = 'w'
      )[[position]]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get the schedule for a team and season
#' 
#' `ns_team_season_schedule()` returns the schedule for a given set of `team` and `season`, including but not limited to each game's ID, competing teams, start time, and venue. Use [ns_teams()] for `team` reference and [ns_seasons()] for `season` reference.
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param season integer in YYYYYYYY (e.g., 20242025)
#' @return data.frame with one row per game
#' @examples
#' COL_schedule_20252026 <- ns_team_season_schedule(
#'   team   = 21, 
#'   season = 20252026
#' )
#' @export

ns_team_season_schedule <- function(team = 1, season = 'now') {
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
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get the schedule for a team and month
#' 
#' `ns_team_month_schedule()` returns the schedule for a given set of `team` and `month`, including but not limited to each game's ID, competing teams, start time, and venue. Use [ns_teams()] for `team` reference and [ns_seasons()] for `month` reference.
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param month character in 'YYYY-MM' (e.g., '2025-01')
#' @return data.frame with one row per game
#' @examples
#' COL_schedule_December_2025 <- ns_team_month_schedule(
#'   team  = 21, 
#'   month = '2025-12'
#' )
#' @export

ns_team_month_schedule <- function(team = 1, month = 'now') {
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
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Get the schedule for a team and week since a date
#' 
#' `ns_team_week_schedule()` returns the schedule for a given set of `team` and a week since `date`, including but not limited to each game's ID, competing teams, start time, and venue. Use [ns_teams()] for `team` reference and [ns_seasons()] for `date` reference.
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL')
#' @param date character in 'YYYY-MM-DD' (e.g., '2025-01-01')
#' @return data.frame with one row per game
#' @examples
#' COL_schedule_Family_Week_2025 <- ns_team_week_schedule(
#'   team = 21,
#'   date = '2025-10-06'
#' )
#' @export

ns_team_week_schedule <- function(team = 1, date = 'now') {
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
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}
