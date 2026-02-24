# Access the roster for a team, season, and position

`roster()` retrieves the roster for a team, season, and position as a
`data.frame` where each row represents player and includes detail on
player identity, role, handedness, and biographical profile.

## Usage

``` r
roster(team = 1, season = "current", position = "forwards")
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

- position:

  character of 'f'/'forwards', 'd'/'defensemen', or 'g'/'goalies'

## Value

data.frame with one row per player

## Examples

``` r
COL_defensemen_20242025 <- roster(
  team     = 21,
  season   = 20242025,
  position = 'D'
)
```
