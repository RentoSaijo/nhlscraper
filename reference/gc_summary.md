# Access the GameCenter (GC) summary for a game

`gc_summary()` scrapes the GC summary for a given `game`.

## Usage

``` r
gc_summary(game = 2023030417)
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
gc_summary_Martin_Necas_legacy_game <- gc_summary(game = 2025020275)
```
