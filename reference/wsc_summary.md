# Access the World Showcase (WSC) summary for a game

`wsc_summary()` returns the World Showcase game-story payload for one
game, including recap/story blocks, team metadata, scoring state, and
supporting media/link fields when that endpoint provides them.

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
