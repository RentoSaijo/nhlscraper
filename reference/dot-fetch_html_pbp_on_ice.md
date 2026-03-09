# Fetch HTML on-ice play-by-play rows

`.fetch_html_pbp_on_ice()` downloads an NHL HTML play-by-play report and
parses its on-ice content into a structured data frame.

## Usage

``` r
.fetch_html_pbp_on_ice(
  game,
  rosters,
  home_team_id,
  away_team_id,
  home_abbrev,
  away_abbrev
)
```

## Arguments

- game:

  game ID

- rosters:

  roster data.frame from play-by-play metadata

- home_team_id:

  home-team ID

- away_team_id:

  away-team ID

- home_abbrev:

  home-team abbreviation

- away_abbrev:

  away-team abbreviation

## Value

data.frame of parsed HTML play-by-play rows
