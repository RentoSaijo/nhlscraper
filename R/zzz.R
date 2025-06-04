if (getRversion() >= '2.15.1') {
  utils::globalVariables(
    c(
      'playerId',
      'gamesPlayed',
      'wins',
      'losses',
      'otLosses',
      'shutouts',
      'ties',
      'assists',
      'goals',
      'points',
      'max_season_chunk'
    )
  )
}