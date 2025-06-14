% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Game.R
\name{get_scoreboards}
\alias{get_scoreboards}
\title{Get scoreboard(s) by date}
\usage{
get_scoreboards(date = "2025-01-01")
}
\arguments{
\item{date}{string Date in 'YYYY-MM-DD'}
}
\value{
tibble with one row per game
}
\description{
Get scoreboard(s) by date
}
\examples{
scoreboards_2025_01_02 <- get_scoreboards(date='2025-01-02')
}
