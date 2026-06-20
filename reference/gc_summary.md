# Access the GameCenter (GC) summary for a game

`gc_summary()` combines the GameCenter landing and right-rail payloads
for one game. The nested list includes the scoreboard, team records,
scoring summary, three stars, game videos, officials, season/game
identifiers, and related GameCenter metadata when available.

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
