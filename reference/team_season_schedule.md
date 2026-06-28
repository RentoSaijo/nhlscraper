# Access the schedule for a team and season

`team_season_schedule()` returns one team's season schedule with one row
per game and normalized game, opponent, score/status, venue, broadcast,
and link fields.

## Usage

``` r
team_season_schedule(team = 1, season = "now")
```

## Arguments

- team:

  integer ID (e.g., 21), character full name (e.g., 'Colorado
  Avalanche'), OR three-letter code (e.g., 'COL'); see
  [`teams()`](https://rentosaijo.github.io/nhlscraper/reference/teams.md)
  for reference; ID is preferable as there now exists duplicate
  three-letter codes (i.e., 'UTA' for 'Utah Hockey Club' and 'Utah
  Mammoth')

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per game

## Examples

``` r
COL_schedule_20252026 <- team_season_schedule(
  team   = 21,
  season = 20252026
)
```
