# nhlscraper <a href="https://rentosaijo.github.io/nhlscraper/"><img src="man/figures/logo.png" align="right" height="138" alt="nhlscraper website" /></a>
[![CRAN Status](https://www.r-pkg.org/badges/version/nhlscraper)](https://CRAN.R-project.org/package=nhlscraper)
[![Dev Version](https://img.shields.io/badge/dev%20ver-0.2.0.9000-red.svg)](https://github.com/RentoSaijo/nhlscraper)
![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/nhlscraper)

### Overview

nhlscraper is a CRAN-approved minimum-dependency R package for scraping and cleaning NHL data via the NHL and ESPN APIs. It primarily wraps 500+ endpoints documented [here](https://github.com/RentoSaijo/nhlscraper/wiki) from high-level multi-season summaries and award winners to low-level play-by-plays and bookmakers' odds, making them significantly more accessible. It also features cleaning functions, primarily for play-by-play logs, to help analyze the data. Since the NHL API endpoints got reworked in 2023, many of the earlier scrapers became defunct; this one should be updated for the new endpoints.

### History

Prior to the NHL API rework in 2023, Drew Hynes documented a rather comprehensive [list](https://gitlab.com/dword4/nhlapi/) of all the endpoints. In fact, there were several R packages to access these endpoints such as [nhlapi](https://github.com/jozefhajnala/nhlapi) and [hockeyR](https://github.com/danmorse314/hockeyR). However, since the rework, many of these packages became defunct as the maintainers (understandably) did not want to continue the development, especially since the NHL completely transformed its API structure. The community gathered around Zachary Maludzinski to discover and share new [endpoints](https://github.com/Zmalski/NHL-API-Reference) as they were found, but progress stagnated after all the "main" endpoints were discovered. Over the summer of 2025, I began reverse-engineering many undiscovered endpoints as I was looking to access more data for future research, primarily the NHL EDGE and Records data. Once I shared these endpoints, the hunt for more details surrounding them began, and we eventually found 500+ new endpoints to access all the ins and outs of the NHL. I also discovered many new endpoints for the ESPN API in addition to what's [documented](https://github.com/pseudo-r/Public-ESPN-API) by Joseph Wilson.

### Prerequisite

- R/RStudio; you can check out my [tutorial](https://youtu.be/hGM1t6usDQ8) if you are not familiar!

### Installation
Install the official version from [CRAN](https://cran.r-project.org) with:
```r
install.packages('nhlscraper')
```

Install the development version from [GitHub](https://github.com/) with:
```r
install.packages('devtools')
devtools::install_github('RentoSaijo/nhlscraper')
```

### Disclosure
1. The ESPN API functions (all starts with `get_espn_`) uses different sets of IDs and terminologies than the NHL API functions. For example, seasons are encoded in YYYY, the last 4 numbers in the YYYY-YYYY format; athletes refer to players; and events refer to games. These functions exist to help you access information that may not be available solely with the NHL API functions; therefore, I purposely ignored endpoints like those to access basic statistics as they're redundant if they co-exist with the NHL API functions.
2. Most, if not, all of these endpoints are unofficially documented (i.e. hidden); therefore, it is all of our responsibilities to hit these endpoints with care. For example, endpoints that contain historical data and other mostly static data should only be hit once and stored in a database (e.g. MySQL) for further query. We do not know the exact rate limits for these APIs; don't ruin the fun for all of us!
