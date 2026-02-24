# Access various reports for a season, game type, and category for all the teams by game

`team_game_report()` retrieves various reports for a season, game type,
and category for all the teams by game as a `data.frame` where each row
represents game per team and includes detail on game timeline state,
period/clock progression, and matchup flow, team identity, affiliation,
and matchup-side context, and production, workload, efficiency, and
result-level performance outcomes.

## Usage

``` r
team_game_report(
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

  character (e.g., 'leadingtrailing'); see
  [`team_report_configurations()`](https://rentosaijo.github.io/nhlscraper/reference/team_report_configurations.md)
  for reference

## Value

data.frame with one row per game per team

## Examples

``` r
situational_team_game_report_playoffs_20212022 <- team_game_report(
  season    = 20212022, 
  game_type = 3, 
  category  = 'leadingtrailing'
)
```
