# Access the roster for a game

`game_roster()` returns the roster spots from a GameCenter play-by-play
payload with one row per dressed player. The result includes game, team,
and player IDs alongside sweater number, position, headshot, and
normalized player name fields.

## Usage

``` r
game_roster(game = 2023030417)
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
roster_Martin_Necas_legacy_game <- game_roster(game = 2025020275)
```
