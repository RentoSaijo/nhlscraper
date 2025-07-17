#' Get ESPN events (games) by start and end dates
#' 
#' `get_espn_events()` retrieves ESPN hyperlinks for each event; the hyperlinks are formatted in `base/events/{ESPN Event ID}?query`. Access `get_seasons()` for `start_season` and `end_season` references. May soon be reworked to only return the ESPN Event IDs.
#' 
#' @param start_date integer Start Date in YYYYMMDD
#' @param end_date integer End Date in YYYYMMDD
#' @return tibble with one row per event (game)
#' @examples
#' ESPN_events_20242025 <- get_espn_events(start_date=20241004, end_date=20250624)
#' @export

get_espn_events <- function(start_date=20241004, end_date=20250624) {
  page <- 1
  all_events <- list()
  repeat {
    out <- espn_api(
      path='events',
      query=list(
        lang='en',
        region='us',
        limit=1000, 
        page=page,
        dates=sprintf('%s-%s', start_date, end_date)
      ),
      type=2
    )
    df <- tibble::as_tibble(out$items)
    all_events[[page+1]] <- df
    if (nrow(df)<1000) {
      break
    }
    page <- page+1
  }
  return(dplyr::bind_rows(all_events))
}

#' Get event (game) by ESPN ID
#' 
#' `get_espn_event()` retrieves information on an `event`, including but not limited to its competitors, date, venue, and attendance.
#' 
#' @param event integer ESPN Event (Game) ID
#' @return list with various items
#' @examples
#' NJD_BUF_2024_10_04 <- get_espn_event(event=401687600)
#' @export

get_espn_event <- function(event=401687600) {
  out <- espn_api(
    path=sprintf('events/%s/competitions/%s', event, event),
    query=list(lang='en', region='us', limit=1000),
    type=2
  )
  keeps <- setdiff(names(out), c(
    'situation',
    'odds',
    'status',
    'broadcasts',
    'officials',
    'details'
  ))
  return(out[keeps])
}

#' Get event (game) play-by-play by ESPN Event (Game) ID
#' 
#' `get_espn_event_play_by_play()` retrieves ESPN-provided information on each play for a given `event`, including but not limited to their ID, type, time of occurrence, strength-state, participants, and X and Y coordinates. Access `get_espn_events()` for `event` reference.
#' 
#' @param event integer ESPN Event (Game) ID
#' @return tibble with one row per play
#' @examples
#' NJD_BUF_2024_10_04_pbp <- get_espn_event_play_by_play(event=401687600)
#' @export

get_espn_event_play_by_play <- function(event=401687600) {
  out <- espn_api(
    path=sprintf('events/%s/competitions/%s/plays', event, event),
    query=list(lang='en', region='us', limit=1000),
    type=2
  )
  return(tibble::as_tibble(out$items))
}

#' Get event (game) stars by ESPN Event (Game) ID
#' 
#' `get_espn_event_stars()` retrieves information on each star for a given `event`, including but not limited to its name, description, and the athlete's ESPN ID. Access `get_espn_events()` for `event` reference.
#' 
#' @param event integer ESPN Event (Game) ID
#' @return tibble with one row per athlete
#' @examples
#' NJD_BUF_2024_10_04_stars <- get_espn_event_stars(event=401687600)
#' @export

get_espn_event_stars <- function(event=401687600) {
  out <- espn_api(
    path=sprintf('events/%s/competitions/%s/status', event, event),
    query=list(lang='en', region='us', limit=1000),
    type=2
  )
  df <- tibble::as_tibble(out$featuredAthletes)
  if ('statistics.$ref' %in% names(df)) {
    df <- df %>% 
      dplyr::select(-`statistics.$ref`)
  }
  return(df)
}

#' Get event (game) officials by ESPN Event (Game) ID
#' 
#' `get_espn_event_officials()` retrieves information on each official for a given `event`, including but not limited to its ESPN ID, name, and position. Access `get_espn_events()` for `event` reference.
#' 
#' @param event integer ESPN Event (Game) ID
#' @return tibble with one row per official
#' @examples
#' NJD_BUF_2024_10_04_officials <- get_espn_event_officials(event=401687600)
#' @export

get_espn_event_officials <- function(event=401687600) {
  out <- espn_api(
    path=sprintf('events/%s/competitions/%s/officials', event, event),
    query=list(lang='en', region='us', limit=1000),
    type=2
  )
  return(tibble::as_tibble(out$items))
}

#' Get event (game) odds by ESPN Event (Game) ID
#' 
#' `get_espn_event_odds()` retrieves information on each provider for a given `event`, including but not limited to its name, favorite and underdog teams, and money-line and spread odds. Access `get_espn_events()` for `event` reference.
#'
#' @param event integer ESPN Event (Game) ID
#' @return tibble with one row per provider
#' @examples
#' NJD_BUF_2024_10_04_odds <- get_espn_event_odds(event=401687600)
#' @export

get_espn_event_odds <- function(event=401687600) {
  out <- espn_api(
    path=sprintf('events/%s/competitions/%s/odds', event, event),
    query=list(lang='en', region='us', limit=1000),
    type=2
  )
  return(tibble::as_tibble(out$items))
}
