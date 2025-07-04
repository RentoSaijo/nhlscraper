% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Game.R
\name{get_gc_play_by_play}
\alias{get_gc_play_by_play}
\title{Get GameCenter (GC) play-by-play by game}
\usage{
get_gc_play_by_play(game = 2024020602)
}
\arguments{
\item{game}{integer Game ID}
}
\value{
tibble with one row per play
}
\description{
Get GameCenter (GC) play-by-play by game
}
\examples{
gc_pbp_2024030411 <- get_gc_play_by_play(game=2024030411)
}
