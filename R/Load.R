#' Access the GameCenter (GC) play-by-plays for a season
#' 
#' `gc_play_by_plays()` loads the GC play-by-plays for a given `season`.
#' 
#' @inheritParams roster
#' @returns data.frame with one row per event (play) per game
#' @examples
#' # May take >5s, so skip.
#' \donttest{gc_pbps_20212022 <- gc_play_by_plays(season = 20212022)}
#' @export

gc_play_by_plays <- function(season = 20242025) {
  tryCatch(
    expr = {
      utils::read.csv(paste0(
        'https://media.githubusercontent.com/media/RentoSaijo/NHL_DB/refs/',
        'heads/main/data/game/pbps/gc/NHL_PBPS_GC_',
        season,
        '.csv'
      ))
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' @rdname gc_play_by_plays
#' @export
gc_pbps <- function(season = 20242025) {
  gc_play_by_plays(season)
}

#' Access the World Showcase (WSC) play-by-plays for a season
#' 
#' `wsc_play_by_plays()` loads the WSC play-by-plays for a given `season`.
#' 
#' @inheritParams roster
#' @returns data.frame with one row per event (play) per game
#' @examples
#' # May take >5s, so skip.
#' \donttest{wsc_pbps_20212022 <- wsc_play_by_plays(season = 20212022)}
#' @export

wsc_play_by_plays <- function(season = 20242025) {
  tryCatch(
    expr = {
      utils::read.csv(paste0(
        'https://media.githubusercontent.com/media/RentoSaijo/NHL_DB/refs/',
        'heads/main/data/game/pbps/wsc/NHL_PBPS_WSC_',
        season,
        '.csv'
      ))
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' @rdname wsc_play_by_plays
#' @export
wsc_pbps <- function(season = 20242025) {
  wsc_play_by_plays(season)
}
