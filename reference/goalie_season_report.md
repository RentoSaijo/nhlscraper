# Access various reports for a season, game type, and category for all the goalies by season

`goalie_season_report()` retrieves various reports for a season, game
type, and category for all the goalies by season as a `data.frame` where
each row represents player and includes detail on date/season filtering
windows and chronological context, player identity, role, handedness,
and biographical profile, and production, workload, efficiency, and
result-level performance outcomes.

## Usage

``` r
goalie_season_report(
  season = season_now(),
  game_type = game_type_now(),
  category = "summary"
)
```

## Arguments

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

- game_type:

  integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 =
  playoff/post-season) OR character of 'pre', 'regular', or
  playoff'/'post'; see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference; most functions will NOT support pre-season

- category:

  character (e.g., 'advanced'); see
  [`goalie_report_configurations()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_report_configurations.md)
  for reference

## Value

data.frame with one row per player

## Examples

``` r
# May take >5s, so skip.
advanced_goalie_season_report_playoffs_20212022 <- 
  goalie_season_report(
    season    = 20212022, 
    game_type = 3, 
    category  = 'advanced'
  )
```
