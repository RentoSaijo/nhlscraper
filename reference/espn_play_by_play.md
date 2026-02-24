# Access the ESPN play-by-play for a game

`espn_play_by_play()` retrieves the ESPN play-by-play for a game as a
`data.frame` where each row represents event and includes detail on game
timeline state, period/clock progression, and matchup flow, team
identity, affiliation, and matchup-side context, and situational splits
across home/road, strength state, and overtime/shootout states.

## Usage

``` r
espn_play_by_play(game = 401777460)

espn_pbp(game = 401777460)
```

## Arguments

- game:

  integer ID (e.g., 401777460); see
  [`espn_games()`](https://rentosaijo.github.io/nhlscraper/reference/espn_games.md)
  for reference

## Value

data.frame with one row per event (play)

## Examples

``` r
ESPN_pbp_SCF_20242025 <- espn_play_by_play(game = 401777460)
```
