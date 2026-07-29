# Helpers ---------------------------------------------------------

# Build synthetic shift_chart()-shaped rows. Game-elapsed seconds assume
# 1200-second regulation periods; overtime tests override the game columns
# directly.
mk_shift <- function(
  game_id,
  team_id,
  player_id,
  period,
  start_period,
  end_period
) {
  offset <- (period - 1L) * 1200L
  data.frame(
    gameId                      = as.integer(game_id),
    teamId                      = as.integer(team_id),
    playerId                    = as.integer(player_id),
    shiftNumber                 = NA_integer_,
    periodNumber                = as.integer(period),
    startTime                   = sprintf(
      '%02d:%02d', start_period %/% 60L, start_period %% 60L
    ),
    endTime                     = sprintf(
      '%02d:%02d', end_period %/% 60L, end_period %% 60L
    ),
    startSecondsElapsedInPeriod = as.integer(start_period),
    endSecondsElapsedInPeriod   = as.integer(end_period),
    startSecondsElapsedInGame   = as.integer(start_period + offset),
    endSecondsElapsedInGame     = as.integer(end_period + offset),
    duration                    = as.integer(end_period - start_period),
    stringsAsFactors            = FALSE
  )
}

# Build synthetic shift_chart_summary()-shaped rows (one per player per
# period the player logged ice time in).
mk_summary <- function(
  game_id,
  team_id,
  tri_code,
  player_id,
  first_name,
  last_name,
  sweater_number,
  position_code,
  periods
) {
  data.frame(
    gameId          = as.integer(game_id),
    teamId          = as.integer(team_id),
    teamTriCode     = tri_code,
    playerId        = as.integer(player_id),
    playerFirstName = first_name,
    playerLastName  = last_name,
    sweaterNumber   = as.integer(sweater_number),
    positionCode    = position_code,
    periodNumber    = as.integer(periods),
    shifts          = NA_integer_,
    timeOnIce       = NA_integer_,
    evTimeOnIce     = NA_integer_,
    ppTimeOnIce     = NA_integer_,
    shTimeOnIce     = NA_integer_,
    stringsAsFactors = FALSE
  )
}
