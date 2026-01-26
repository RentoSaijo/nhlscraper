# Normalize the x and y coordinates for all the events (plays) in a play-by-play

`normalize_coordinates()` normalizes the x and y coordinates for all the
events (plays) in a play-by-play such that they all attack towards +x.
If `homeTeamDefendingSide` is not available, the home defending side in
period 1 is inferred using `zoneCode`, `isHome`, and `xCoord`.

## Usage

``` r
normalize_coordinates(play_by_play)
```

## Arguments

- play_by_play:

  data.frame of play-by-play(s); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  and/or
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
  for reference

## Value

data.frame with one row per event (play) and added columns `xCoordNorm`
and `yCoordNorm`
