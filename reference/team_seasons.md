# Access the season(s) and game type(s) in which a team played

`team_seasons()` returns the seasons and game type IDs available for a
team in the public club-stats API.

## Usage

``` r
team_seasons(team = 1)
```

## Arguments

- team:

  integer ID (e.g., 21), character full name (e.g., 'Colorado
  Avalanche'), OR three-letter code (e.g., 'COL'); see
  [`teams()`](https://rentosaijo.github.io/nhlscraper/reference/teams.md)
  for reference; ID is preferable as there now exists duplicate
  three-letter codes (i.e., 'UTA' for 'Utah Hockey Club' and 'Utah
  Mammoth')

## Value

data.frame with one row per season

## Examples

``` r
COL_seasons <- team_seasons(team = 21)
```
