# nhlscraper <a href="https://rentosaijo.github.io/nhlscraper/"><img src="man/figures/logo.png" align="right" height="138" alt="nhlscraper website" /></a>
[![CRAN Status](https://www.r-pkg.org/badges/version/nhlscraper)](https://CRAN.R-project.org/package=nhlscraper)
[![Dev Version](https://img.shields.io/badge/dev%20ver-0.2.0.9000-red.svg)](https://github.com/RentoSaijo/nhlscraper)
![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/nhlscraper)

### Overview

nhlscraper is a CRAN-approved minimum-dependency R package for scraping and cleaning NHL data via the NHL and ESPN APIs. It primarily wraps 500+ [endpoints](https://github.com/RentoSaijo/nhlscraper/wiki) from high-level multi-season summaries and award winners to low-level decisecond replays and bookmakers' odds, making them significantly more accessible. It also features cleaning functions, primarily for play-by-plays, to help analyze the data.

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

You will see that a lot of the documentation for scraping functions contain the phrase "including but not limited to"; this is because there is so much information packed into each of these endpoints that it is unfeasible to list them all. I recommend playing around with some of the provided examples to see what you can find! Also, most, if not, all of the endpoints you are accessing with this package are unofficially documented (i.e., hidden); therefore, it is all of our responsibilities to hit these endpoints with care and respect for the NHL data servers. For example, endpoints that contain historical data and other mostly static data should only be hit once and stored in a database (e.g., MySQL) for further query. We do not know the exact rate limits for these APIs, so please don't ruin the fun for all of us!

### History

Prior to the NHL API rework in 2023, Drew Hynes documented a rather comprehensive list of the known [endpoints](https://gitlab.com/dword4/nhlapi/); in fact, there were several R packages to access these endpoints like [nhlapi](https://github.com/jozefhajnala/nhlapi) and [hockeyR](https://github.com/danmorse314/hockeyR). However, since the NHL completely transformed its API structure, many of these packages became defunct as the authors understandably did not want to continue maintaining. The community gathered around Zachary Maludzinski to discover and share new [endpoints](https://github.com/Zmalski/NHL-API-Reference) as they were found, but progress stagnated after all the "main" endpoints were discovered. Over the summer of 2025, I began reverse-engineering many undiscovered endpoints as I was looking to access more data for future research, primarily the NHL EDGE and Records data. Once I shared these endpoints, the hunt for more details surrounding them began, and we eventually found 500+ new endpoints to access all the ins and outs of the NHL. I also discovered many new endpoints for the ESPN API in addition to what Joseph Wilson [compiled](https://github.com/pseudo-r/Public-ESPN-API).
