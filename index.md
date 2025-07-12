[![CRAN Status](https://www.r-pkg.org/badges/version/nhlscraper)](https://CRAN.R-project.org/package=nhlscraper)
[![Dev Version](https://img.shields.io/badge/dev%20ver-0.1.1.9000-red.svg)](https://github.com/nhlscraper)
![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/nhlscraper)

<br>

<div style="text-align:left">
<span><a href="https://rentosaijo.github.io/nhlscraper/">
<img src="man/figures/logo.png" width=100 alt="nhlscraper Logo"/> </a><h2><strong>nhlscraper</strong></h2>
</div>

nhlscraper is a CRAN-approved R-package for scraping NHL data using the NHL and ESPN APIs. It primarily wraps [endpoints documented by Zachary Maludzinski](https://github.com/Zmalski/NHL-API-Reference), [Drew Hynes](https://gitlab.com/dword4/nhlapi/), and [Joseph Wilson](https://github.com/pseudo-r/Public-ESPN-API); it also includes newly discovered endpoints by myself. It covers data from high-level multi-season summaries and award winners to low-level play-by-play logs and sports books' odds. Since the NHL API endpoints got reworked in 2023, many of the earlier scrapers became deprecated; this one should be updated for the new endpoints.

## Prerequisite

- R/RStudio; you can check out my [tutorial](https://youtu.be/hGM1t6usDQ8) if you are not familiar!

## Installation
Install the official version from [CRAN](https://cran.r-project.org) with:
```r
install.packages('nhlscraper')
```

Install the development version from [GitHub](https://github.com/) with:
```r
install.packages('devtools')
devtools::install_github('RentoSaijo/nhlscraper')
```

### Example
Create `ggplot2` line graphs for total attendance and attendance per game across all the seasons:
```r
# Load libraries.
library(nhlscraper)
library(tidyverse)

# Set colors.
charcoal <- '#202A35'
n_cyan <- '#1EE6FF'
m_purple <- '#D443FF'

# Clean data.
all_seasons <- get_seasons() %>% 
  mutate(seasonId=id)
all_attendance <- get_attendance() %>%
  mutate(seasonStart=seasonId%/%10000) %>%
  select(
    seasonId, 
    seasonStart, 
    Regular=regularAttendance, 
    Playoffs=playoffAttendance
  ) %>% 
  left_join(all_seasons, by='seasonId') %>% 
  mutate(
    `Regular per Game`=Regular/totalRegularSeasonGames, 
    `Playoffs per Game`=Playoffs/totalPlayoffGames
  ) %>% 
  select(
    seasonStart, 
    Regular, 
    Playoffs, 
    `Regular per Game`, 
    `Playoffs per Game`
  )
all_attendance_long <- all_attendance %>%
  pivot_longer(c(Regular, Playoffs), names_to='type', values_to='attendance')
attendance_pg_long <- all_attendance %>% 
  select(
    seasonStart, 
    Regular=`Regular per Game`, 
    Playoffs=`Playoffs per Game`
  ) %>% 
  pivot_longer(
    c(Regular, Playoffs), 
    names_to='type', 
    values_to='attendance'
  )

# Total Attendance
ggplot(all_attendance_long, aes(x=seasonStart, y=attendance, color=type)) +
  geom_line(linewidth=3) +
  scale_color_manual(values=c(Regular=n_cyan, Playoffs=m_purple)) +
  scale_y_continuous(labels=comma_format()) +
  labs(
    title='Total Attendance by Season',
    subtitle='Data collected via `nhlscraper` R-package',
    caption='Source: NHL API',
    x='Season',
    y='Attendance (People)',
    color=NULL
  ) +
  theme_minimal(base_family='') +
  theme(
    panel.grid=element_blank(),
    plot.background=element_rect(fill=charcoal, color=NA),
    panel.background=element_rect(fill=charcoal, color=NA),
    legend.background=element_rect(fill=charcoal, color=NA),
    legend.key=element_rect(fill=charcoal, color=NA),
    text=element_text(color='white'),
    plot.title=element_text(color='white', face='bold', size=24, hjust=0.5),
    plot.subtitle=element_text(color='white', face='bold', size=12, hjust=0.5),
    plot.caption=element_text(color='white', face='bold', size=12),
    axis.text=element_text(color='white', face='bold', size=12),
    axis.title=element_text(color='white', face='bold', size=18),
    legend.text=element_text(color='white', face='bold', size=12)
  )

# Attendance per Game
ggplot(attendance_pg_long, aes(x=seasonStart, y=attendance, color=type)) +
  geom_line(linewidth=3) +
  scale_color_manual(values=c(Regular=n_cyan, Playoffs=m_purple)) +
  scale_y_continuous(labels=comma_format()) +
  labs(
    title='Attendance per Game by Season',
    subtitle='Data collected via `nhlscraper` R-package',
    caption='Source: NHL API',
    x='Season',
    y='Attendance (People)',
    color=NULL
  ) +
  theme_minimal(base_family='') +
  theme(
    panel.grid=element_blank(),
    plot.background=element_rect(fill=charcoal, color=NA),
    panel.background=element_rect(fill=charcoal, color=NA),
    legend.background=element_rect(fill=charcoal, color=NA),
    legend.key=element_rect(fill=charcoal, color=NA),
    text=element_text(color='white'),
    plot.title=element_text(color='white', face='bold', size=24, hjust=0.5),
    plot.subtitle=element_text(color='white', face='bold', size=12, hjust=0.5),
    plot.caption=element_text(color='white', face='bold', size=12),
    axis.text=element_text(color='white', face='bold', size=12),
    axis.title=element_text(color='white', face='bold', size=18),
    legend.text=element_text(color='white', face='bold', size=12)
  )
```
