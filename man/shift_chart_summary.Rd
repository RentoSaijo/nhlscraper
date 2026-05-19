\name{shift_chart_summary}
\alias{shift_chart_summary}
\title{Access the shift chart time-on-ice summary for a game}
\usage{
shift_chart_summary(game = 2023030417)
}
\arguments{
\item{game}{game ID}
}
\value{
data.frame with one row per player per period
}
\description{
\code{shift_chart_summary()} retrieves per-player, per-period time-on-ice splits
from the NHL HTML shift reports.
}
\examples{
shift_summary_2023030417 <- shift_chart_summary(game = 2023030417)
}
