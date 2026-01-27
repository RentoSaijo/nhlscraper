# Access the shift chart for a game

`shift_chart()` scrapes the shift chart for a given `game`.

## Usage

``` r
shift_chart(game = 2023030417)
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
shifts_Martin_Necas_legacy_game <- shift_chart(game = 2025020275)
#> Invalid argument(s); refer to help file. 
#> Provided game: 2025020275
```
