% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Skater.R
\name{get_skater_statistics}
\alias{get_skater_statistics}
\title{Get skater statistics by season}
\usage{
get_skater_statistics(
  season = get_season_now()$seasonId,
  report = "summary",
  teams = 1:100,
  is_aggregate = FALSE,
  is_game = FALSE,
  dates = c("2025-01-01"),
  game_types = 1:3
)
}
\arguments{
\item{season}{integer Season in YYYYYYYY}

\item{report}{string Report (check \code{get_configuration()} for possible inputs)}

\item{teams}{vector of integers Team ID(s)}

\item{is_aggregate}{boolean isAggregate where TRUE=regular and playoffs
combined (or multiple seasons) from multiple teams, if
applicable}

\item{is_game}{boolean isGame where TRUE=rows by games and FALSE=rows by
skaters}

\item{dates}{vector of strings Date(s) in 'YYYY-MM-DD' (only if paired with
\code{is_game})}

\item{game_types}{vector of integers Game-type(s) where 1=pre-season,
2=regular, and 3=playoffs}
}
\value{
tibble with one row per skater or game
}
\description{
Get skater statistics by season
}
\examples{
regular_skater_shootout_20242025 <- get_skater_statistics(
  season=20242025,
  report='shootout',
  game_types=c(2)
)
}
