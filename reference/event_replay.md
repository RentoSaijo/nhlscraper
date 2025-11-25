# Access the replay for an event

`event_replay()` scrapes the replay for a given `event`.

## Usage

``` r
event_replay(game = 2023030417, event = 866)
```

## Arguments

- game:

  integer ID (e.g., 2025020262); see
  [`games()`](https://rentosaijo.github.io/nhlscraper/reference/games.md)
  for reference

- event:

  integer ID (e.g., 751); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  and/or
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
  for reference; must be a 'goal' event

## Value

data.frame with one row per decisecond

## Examples

``` r
Gabriel_Landeskog_first_regular_goal_back_replay <- event_replay(
  game  = 2025020262,
  event = 751
)
```
