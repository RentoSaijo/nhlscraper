#' Get all ESPN athletes
#' 
#' `get_espn_athletes()` retrieves ESPN hyperlinks for each athlete; the hyperlinks are formatted in `base/athletes/{ESPN Athlete ID}?query`. May soon be reworked to only return the ESPN Athlete IDs.
#' 
#' @return tibble with one row per athlete
#' @examples
#' all_ESPN_athletes <- get_espn_athletes()
#' @export

get_espn_athletes <- function() {
  page <- 1
  all_athletes <- list()
  repeat {
    out <- espn_api(
      path='athletes',
      query=list(
        limit=1000,
        page=page
      ),
      type=2
    )
    df <- tibble::as_tibble(out$items)
    all_athletes[[page+1]] <- df
    if (nrow(df)<1000) {
      break
    }
    page <- page+1
  }
  return(dplyr::bind_rows(all_athletes))
}

#' Get athlete (player) by season and ESPN Athlete (Player) ID
#' 
#' `get_espn_athlete()` retrieves information on an `athlete` for a given `season`, including but not limited to his name, bio-metrics, birth date and location, position, team(s), and jersey number. Access `get_espn_athletes()` for `athlete` and `get_seasons()` for `season` references.
#' 
#' @param athlete integer ESPN Athlete (Player) ID
#' @param season integer Season in YYYY
#' @return list with various items
#' @examples
#' ESPN_Charlie_McAvoy_20242025 <- get_espn_athlete(athlete=3988803, season=2025)
#' @export

get_espn_athlete <- function(
    athlete=3988803,
    season=get_season_now()$seasonId%%10000
) {
  out <- espn_api(
    path=sprintf('seasons/%s/athletes/%s', season, athlete),
    query=list(lang='en', region='us', limit=1000),
    type=2
  )
  keeps <- setdiff(names(out), c(
    'injuries',
    'statistics',
    'notes',
    'contracts',
    'eventLog',
    'college'
  ))
  return(out[keeps])
}
