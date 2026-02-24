# Access the rosters for a game

`game_rosters()` retrieves the rosters for a game as a `data.frame`
where each row represents player and includes detail on team identity,
affiliation, and matchup-side context plus player identity, role,
handedness, and biographical profile.

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
