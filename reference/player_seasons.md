# Access the season(s) and game type(s) in which a player played

`player_seasons()` retrieves the season(s) and game type(s) in which a
player played as a `data.frame` where each row represents season and
includes detail on date/season filtering windows and chronological
context.

## Usage

``` r
player_seasons(player = 8478402)
```

## Arguments

- player:

  integer ID (e.g., 8480039); see
  [`players()`](https://rentosaijo.github.io/nhlscraper/reference/players.md)
  for reference

## Value

data.frame with one row per season

## Examples

``` r
Martin_Necas_seasons <- player_seasons(player = 8480039)
```
