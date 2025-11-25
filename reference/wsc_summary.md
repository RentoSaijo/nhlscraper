# Access the World Showcase (WSC) summary for a game

`wsc_summary()` scrapes the WSC summary for a given `game`.

## Usage

``` r
wsc_summary(game = 2023030417)
```

## Arguments

- game:

  integer ID (e.g., 2025020275); see
  [`games()`](https://rentosaijo.github.io/nhlscraper/reference/games.md)
  for reference

## Value

list of various items

## Examples

``` r
wsc_summary_Martin_Necas_legacy_game <- wsc_summary(game = 2025020275)
```
