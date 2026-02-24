# Access the schedule for a team and week since a date

`team_week_schedule()` retrieves the schedule for a team and week since
a date as a `data.frame` where each row represents game and includes
detail on game timeline state, period/clock progression, and matchup
flow, date/season filtering windows and chronological context, and team
identity, affiliation, and matchup-side context.

## Usage

``` r
team_week_schedule(team = 1, date = "now")
```

## Arguments

- team:

  integer ID (e.g., 21), character full name (e.g., 'Colorado
  Avalanche'), OR three-letter code (e.g., 'COL'); see
  [`teams()`](https://rentosaijo.github.io/nhlscraper/reference/teams.md)
  for reference; ID is preferable as there now exists duplicate
  three-letter codes (i.e., 'UTA' for 'Utah Hockey Club' and 'Utah
  Mammoth')

- date:

  character in 'YYYY-MM-DD' (e.g., '2025-01-01'); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per game

## Examples

``` r
COL_schedule_Family_Week_2025 <- team_week_schedule(
  team = 21,
  date = '2025-10-06'
)
```
