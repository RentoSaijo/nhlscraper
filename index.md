[![CRAN Status](https://www.r-pkg.org/badges/version/nhlscraper)](https://CRAN.R-project.org/package=nhlscraper)

<br>

<div style="text-align:left">
<span><a href="https://rentosaijo.github.io/nhlscraper/">
<img src="man/figures/logo.png" width=100 alt="nhlscraper Logo"/> </a><h2><strong>nhlscraper</strong></h2>
</div>

nhlscraper is a CRAN-approved R-package for scraping NHL data using the NHL and ESPN APIs. It primarily wraps [endpoints documented by Zachary Maludzinski](https://github.com/Zmalski/NHL-API-Reference), [Drew Hynes](https://gitlab.com/dword4/nhlapi/), and [Joseph Wilson](https://github.com/pseudo-r/Public-ESPN-API); it also includes newly discovered endpoints by myself. It covers data from high-level multi-season summaries and award winners to low-level play-by-play logs and sports books' odds. Since the NHL API endpoints got reworked in 2023, many of the earlier scrapers became defunct; this one should be updated for the new endpoints.

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
