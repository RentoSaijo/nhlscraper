#' Access all the teams
#' 
#' `teams()` scrapes all the teams.
#' 
#' @returns data.frame with one row per team
#' @examples
#' all_teams <- teams()
#' @export

teams <- function() {
  tryCatch({
    teams <- nhl_api(
      path = 'en/team',
      type = 's'
    )$data
    teams <- teams[order(teams$id), ]
    names(teams)[names(teams) == 'id'] <- 'teamId'
    teams
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' Access the season(s) and game type(s) in which a team played
#' 
#' `team_seasons()` scrapes the season(s) and game type(s) in which a team 
#' played in the NHL.
#' 
#' @param team integer ID (e.g., 21), character full name (e.g., 'Colorado 
#' Avalanche'), OR three-letter code (e.g., 'COL'); see [teams()] for 
#' reference; ID is preferable as there now exists duplicate three-letter codes 
#' (i.e., 'UTA' for 'Utah Hockey Club' and 'Utah Mammoth')
#' @returns data.frame with one row per season
#' @examples
#' COL_seasons <- team_seasons(team = 21)
#' @export

team_seasons <- function(team = 1) {
  tryCatch(
    expr = {
      seasons <- nhl_api(
        path = sprintf('v1/club-stats-season/%s', to_team_tri_code(team)),
        type = 'w'
      )
      names(seasons)[names(seasons) == 'season'] <- 'seasonId'
      names(seasons)[names(seasons) == 'gameTypes'] <- 'gameTypeIds'
      seasons
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the configurations for team reports
#' 
#' `team_report_configurations()` scrapes the configurations for 
#' [team_season_report()] and [team_game_report()].
#' 
#' @returns list with various items
#' @examples
#' team_report_configs <- team_report_configurations()
#' @export

team_report_configurations <- function() {
  tryCatch({
    nhl_api(
      path = 'en/config',
      type = 's'
    )$teamReportData
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' @rdname team_report_configurations
#' @export

team_report_configs <- function() {
  team_report_configurations()
}

#' Access various reports for a season, game type, and category for all 
#' the teams by season
#' 
#' `team_season_report()` scrapes various reports for a given set of `season`, 
#' `game_type`, and `category` for all the teams by season.
#' 
#' @inheritParams roster_statistics
#' @param category character (e.g., 'leadingtrailing'); see 
#' [team_report_configurations()] for reference
#' @returns data.frame with one row per team
#' @examples
#' situational_team_season_report_playoffs_20212022 <- team_season_report(
#'   season    = 20212022, 
#'   game_type = 3, 
#'   category  = 'leadingtrailing'
#' )
#' @export

team_season_report <- function(
  season    = season_now(), 
  game_type = game_type_now(), 
  category  = 'summary'
) {
  tryCatch(
    expr = {
      report <- nhl_api(
        path  = sprintf('en/team/%s', category),
        query = list(
          limit       = -1,
          isAggregate = FALSE,
          isGame      = FALSE,
          cayenneExp  = sprintf(
            'seasonId = %s and gameTypeId = %s', 
            season,
            game_type
          )
        ),
        type  = 's'
      )$data
      report[order(report$teamId), ]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access various reports for a season, game type, and category for all 
#' the teams by game
#' 
#' `team_game_report()` scrapes various reports for a given set of `season`, 
#' `game_type`, and `category` for all the teams by game.
#' 
#' @inheritParams team_season_report
#' @returns data.frame with one row per game per team
#' @examples
#' situational_team_game_report_playoffs_20212022 <- team_game_report(
#'   season    = 20212022, 
#'   game_type = 3, 
#'   category  = 'leadingtrailing'
#' )
#' @export

team_game_report <- function(
  season    = season_now(), 
  game_type = game_type_now(), 
  category  = 'summary'
) {
  tryCatch(
    expr = {
      report <- nhl_api(
        path  = sprintf('en/team/%s', category),
        query = list(
          limit       = -1,
          isAggregate = FALSE,
          isGame      = TRUE,
          cayenneExp  = sprintf(
            'seasonId = %s and gameTypeId = %s', 
            season,
            game_type
          )
        ),
        type  = 's'
      )$data
      report[order(report$teamId, report$gameId), ]
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the statistics for all the teams by season and game type
#' 
#' `team_season_statistics()` scrapes the statistics for all the teams by 
#' season and game type.
#' 
#' @returns data.frame with one row per team per season per game type
#' @examples
#' # May take >5s, so skip.
#' \donttest{team_season_statistics <- team_season_statistics()}
#' @export

team_season_statistics <- function() {
  tryCatch({
    stats <- nhl_api(
      path = 'team-stats',
      type = 'r'
    )$data
    stats <- stats[order(
      stats$`id.db:TEAMID`, 
      stats$`id.db:SEASON`, 
      stats$`id.db:GAMETYPE`
    ), ]
    names(stats)[names(stats) == 'id.db:TEAMID']   <- 'teamId'
    names(stats)[names(stats) == 'id.db:SEASON']   <- 'seasonId'
    names(stats)[names(stats) == 'id.db:GAMETYPE'] <- 'gameTypeId'
    stats
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}

#' @rdname team_season_statistics
#' @export

team_season_stats <- function() {
  team_season_statistics()
}

#' Access the roster for a team, season, and position
#' 
#' `roster()` scrapes the roster for a given set of `team`, `season`, and 
#' `position`.
#' 
#' @inheritParams team_seasons
#' @param season integer in YYYYYYYY (e.g., 20242025); see [seasons()] for 
#' reference
#' @param position character of 'f'/'forwards', 'd'/'defensemen', or 
#' 'g'/'goalies'
#' @returns data.frame with one row per player
#' @examples
#' COL_defensemen_20242025 <- roster(
#'   team     = 21,
#'   season   = 20242025,
#'   position = 'D'
#' )
#' @export

roster <- function(
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
      players <- nhl_api(
        path = sprintf('v1/roster/%s/%s', to_team_tri_code(team), season),
        type = 'w'
      )[[position]]
      names(players)[names(players) == 'id'] <- 'playerId'
      players
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the roster statistics for a team, season, game type, and position
#' 
#' `roster_statistics()` scrapes the roster statistics for a given set of 
#' `team`, `season`, `game_type`, and `position`.
#' 
#' @inheritParams roster
#' @param game_type integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 
#' = playoff/post-season) OR character of 'pre', 'regular', or 
#' playoff'/'post'; see [seasons()] for reference; most functions will NOT 
#' support pre-season
#' @param position character of 's'/'skaters' or 'g'/'goalies'
#' @returns data.frame with one row per player
#' @examples
#' COL_goalies_statistics_regular_20242025 <- roster_statistics(
#'   team      = 21,
#'   season    = 20242025,
#'   game_type = 2,
#'   position  = 'G'
#' )
#' @export

roster_statistics <- function(
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

#' @rdname roster_statistics
#' @export
roster_stats <- function(
  team      = 1,
  season    = 'now',
  game_type = '',
  position  = 'skaters'
) {
  roster_statistics(team, season, game_type, position)
}

#' Access the prospects for a team and position
#' 
#' `team_prospects()` scrapes the prospects for a given set of `team` and 
#' `position`.
#' 
#' @inheritParams roster
#' @returns data.frame with one row per player
#' @examples
#' COL_forward_prospects <- team_prospects(
#'   team     = 21,
#'   position = 'F'
#' )
#' @export

team_prospects <- function(team = 1, position = 'forwards') {
  tryCatch(
    expr = {
      position <- switch(
        substring(tolower(position), 1, 1),
        f = 'forwards',
        d = 'defensemen',
        g = 'goalies'
      )
      players <- nhl_api(
        path = sprintf('v1/prospects/%s', to_team_tri_code(team)),
        type = 'w'
      )[[position]]
      names(players)[names(players) == 'id'] <- 'playerId'
      players
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the schedule for a team and season
#' 
#' `team_season_schedule()` scrapes the schedule for a given set of `team` 
#' and `season`.
#' 
#' @inheritParams roster
#' @returns data.frame with one row per game
#' @examples
#' COL_schedule_20252026 <- team_season_schedule(
#'   team   = 21, 
#'   season = 20252026
#' )
#' @export

team_season_schedule <- function(team = 1, season = 'now') {
  tryCatch(
    expr = {
      games <- nhl_api(
        path = sprintf(
          'v1/club-schedule-season/%s/%s', 
          to_team_tri_code(team), 
          season
        ),
        type = 'w'
      )$games
      names(games)[names(games) == 'id']       <- 'gameId'
      names(games)[names(games) == 'season']   <- 'seasonId'
      names(games)[names(games) == 'gameType'] <- 'gameTypeId'
      games
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the schedule for a team and month
#' 
#' `team_month_schedule()` scrapes the schedule for a given set of `team` 
#' and `month`.
#' 
#' @inheritParams team_seasons
#' @param month character in 'YYYY-MM' (e.g., '2025-01'); see [seasons()] 
#' for reference
#' @returns data.frame with one row per game
#' @examples
#' COL_schedule_December_2025 <- team_month_schedule(
#'   team  = 21, 
#'   month = '2025-12'
#' )
#' @export

team_month_schedule <- function(team = 1, month = 'now') {
  tryCatch(
    expr = {
      games <- nhl_api(
        path = sprintf(
          'v1/club-schedule/%s/month/%s', 
          to_team_tri_code(team), 
          month
        ),
        type = 'w'
      )$games
      names(games)[names(games) == 'id']       <- 'gameId'
      names(games)[names(games) == 'season']   <- 'seasonId'
      names(games)[names(games) == 'gameType'] <- 'gameTypeId'
      games
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the schedule for a team and week since a date
#' 
#' `team_week_schedule()` scrapes the schedule for a given set of `team` and 
#' a week since `date`.
#' 
#' @inheritParams team_seasons
#' @inheritParams standings
#' @returns data.frame with one row per game
#' @examples
#' COL_schedule_Family_Week_2025 <- team_week_schedule(
#'   team = 21,
#'   date = '2025-10-06'
#' )
#' @export

team_week_schedule <- function(team = 1, date = 'now') {
  tryCatch(
    expr = {
      games <- nhl_api(
        path = sprintf(
          'v1/club-schedule/%s/week/%s', 
          to_team_tri_code(team), 
          date
        ),
        type = 'w'
      )$games
      names(games)[names(games) == 'id']       <- 'gameId'
      names(games)[names(games) == 'season']   <- 'seasonId'
      names(games)[names(games) == 'gameType'] <- 'gameTypeId'
      games
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access all the team logos
#' 
#' `team_logos()` scrapes all the team logos.
#' 
#' @returns data.frame with one row per logo
#' @examples
#' all_team_logos <- team_logos()
#' @export

team_logos <- function() {
  tryCatch({
    logos <- nhl_api(
      path = 'logo',
      type = 'r'
    )$data
    logos$id <- NULL
    logos    <- logos[order(logos$teamId, logos$startSeason), ]
    names(logos)[names(logos) == 'startSeason'] <- 'startSeasonId'
    names(logos)[names(logos) == 'endSeason']   <- 'endSeasonId'
    logos
  }, error = function(e) {
    message('Unable to create connection; please try again later.')
    data.frame()
  })
}
