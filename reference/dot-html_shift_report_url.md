# Build the HTML shift report URL

`.html_shift_report_url()` returns a team-specific NHL HTML shift report
URL for a game. `team_tag` is usually `TH` for the home report or `TV`
for the away report.

## Usage

``` r
.html_shift_report_url(game, team_tag)
```

## Arguments

- game:

  game ID

- team_tag:

  HTML report team tag

## Value

character scalar URL
