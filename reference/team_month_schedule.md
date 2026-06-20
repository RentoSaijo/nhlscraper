# Access the schedule for a team and month

`team_month_schedule()` returns the same normalized club-schedule rows
as
[`team_season_schedule()`](https://rentosaijo.github.io/nhlscraper/reference/team_season_schedule.md),
restricted to the requested `YYYY-MM` month.

## Usage

``` r
team_month_schedule(team = 1, month = "now")
```

## Arguments

- team:

  integer ID (e.g., 21), character full name (e.g., 'Colorado
  Avalanche'), OR three-letter code (e.g., 'COL'); see
  [`teams()`](https://rentosaijo.github.io/nhlscraper/reference/teams.md)
  for reference; ID is preferable as there now exists duplicate
  three-letter codes (i.e., 'UTA' for 'Utah Hockey Club' and 'Utah
  Mammoth')

- month:

  character in 'YYYY-MM' (e.g., '2025-01'); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per game

## Examples

``` r
COL_schedule_December_2025 <- team_month_schedule(
  team  = 21, 
  month = '2025-12'
)
```
