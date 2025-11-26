#' Access all the ESPN players
#' 
#' `espn_players()` scrapes all the ESPN players.
#' 
#' @returns data.frame with one row per ESPN player
#' @examples
#' all_ESPN_players <- espn_players()
#' @export

espn_players <- function() {
  page <- 1
  all_players <- list()
  repeat {
    players <- espn_api(
      path  = 'players',
      query = list(limit = 1000, page = page),
      type  = 'c'
    )
    df   <- as.data.frame(players$items, stringsAsFactors = FALSE)
    all_players[[length(all_players) + 1]] <- df
    if (nrow(df) < 1000) break
    page <- page + 1
  }
  out <- do.call(rbind, all_players)
  id  <- sub('.*players/([0-9]+)\\?lang.*', '\\1', out[[1]])
  data.frame(id = id, stringsAsFactors = FALSE)
}

#' Access the ESPN summary for a player
#' 
#' `espn_player_summary()` scrapes the ESPN summary for a `player`.
#' 
#' @param player integer ID (e.g., 3988803); see [espn_players()] for 
#' reference
#' @returns data.frame with one row
#' @examples
#' ESPN_summary_Charlie_McAvoy <- espn_player_summary(player = 3988803)
#' @export

espn_player_summary <- function(player = 3988803) {
  get_or_na <- function(x, ...) {
    tryCatch({
      for (nm in list(...)) {
        if (is.null(x)) return(NA)
        x <- x[[nm]]
      }
      if (is.null(x)) NA else x
    }, error = function(e) NA)
  }
  player <- tryCatch(
    espn_api(
      path = sprintf('players/%s', player),
      type = 'c'
    ),
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      return(NULL)
    }
  )
  if (is.null(player)) {
    return(data.frame())
  }
  data.frame(
    firstName    = get_or_na(player, 'firstName'),
    lastName     = get_or_na(player, 'lastName'),
    fullName     = get_or_na(player, 'fullName'),
    dateOfBirth  = get_or_na(player, 'dateOfBirth'),
    birthCountry = get_or_na(player, 'birthPlace', 'country'),
    birthCity    = get_or_na(player, 'birthPlace', 'city'),
    age          = get_or_na(player, 'age'),
    height       = get_or_na(player, 'height'),
    weight       = get_or_na(player, 'weight'),
    hand         = get_or_na(player, 'hand', 'abbreviation'),
    draftYear    = get_or_na(player, 'draft', 'year'),
    draftRound   = get_or_na(player, 'draft', 'round'),
    draftPick    = get_or_na(player, 'draft', 'selection'),
    debutYear    = get_or_na(player, 'debutYear'),
    position     = get_or_na(player, 'position', 'abbreviation'),
    experience   = get_or_na(player, 'experience', 'years'),
    isActive     = get_or_na(player, 'active'),
    stringsAsFactors = FALSE
  )
}
