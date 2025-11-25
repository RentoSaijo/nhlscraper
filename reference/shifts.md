# Access the shift charts for a game

`shifts()` scrapes the shift charts for a given `game`.

## Usage

``` r
shifts(game = 2023030417)
```

## Arguments

- game:

  integer ID (e.g., 2025020275); see
  [`games()`](https://rentosaijo.github.io/nhlscraper/reference/games.md)
  for reference

## Value

data.frame with one row per shift

## Examples

``` r
shifts_Martin_Necas_legacy_game <- shifts(game = 2025020275)
```
