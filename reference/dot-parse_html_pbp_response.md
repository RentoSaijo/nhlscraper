# Parse an HTML on-ice play-by-play response

`.parse_html_pbp_response()` converts an already-fetched HTML
play-by-play response into parsed on-ice rows.

## Usage

``` r
.parse_html_pbp_response(
  resp,
  game,
  rosters,
  home_team_id,
  away_team_id,
  home_abbrev,
  away_abbrev
)
```

## Arguments

- resp:

  httr2 response object for the HTML report

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
