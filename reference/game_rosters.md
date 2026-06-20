# Access the rosters for a game

`game_rosters()` returns the roster spots from a GameCenter play-by-play
payload with one row per dressed player, including team ID, sweater
number, position, and normalized player name fields.

## Usage

``` r
game_rosters(game = 2023030417)
```

## Arguments

- game:

  integer ID (e.g., 2025020275); see
  [`games()`](https://rentosaijo.github.io/nhlscraper/reference/games.md)
  for reference

## Value

data.frame with one row per player

## Examples

``` r
rosters_Martin_Necas_legacy_game <- game_rosters(game = 2025020275)
```
