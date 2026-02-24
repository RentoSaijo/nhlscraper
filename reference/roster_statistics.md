# Access the roster statistics for a team, season, game type, and position

`roster_statistics()` retrieves the roster statistics for a team,
season, game type, and position as a `data.frame` where each row
represents player and includes detail on player identity, role,
handedness, and biographical profile plus production, workload,
efficiency, and result-level performance outcomes.

## Usage

``` r
roster_statistics(
  team = 1,
  season = "now",
  game_type = "",
  position = "skaters"
)

roster_stats(team = 1, season = "now", game_type = "", position = "skaters")
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

- game_type:

  integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 =
  playoff/post-season) OR character of 'pre', 'regular', or
  playoff'/'post'; see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference; most functions will NOT support pre-season

- position:

  character of 's'/'skaters' or 'g'/'goalies'

## Value

data.frame with one row per player

## Examples

``` r
COL_goalies_statistics_regular_20242025 <- roster_statistics(
  team      = 21,
  season    = 20242025,
  game_type = 2,
  position  = 'G'
)
```
