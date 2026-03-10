# Check HTML on-ice state against a late empty-net heuristic

`.html_on_ice_matches_late_empty_net()` accepts late-game 6-on-5 HTML
rows when the trailing team has clearly pulled its goalie and there are
no active reconstructed penalties that would already explain the
manpower mismatch.

## Usage

``` r
.html_on_ice_matches_late_empty_net(
  play_by_play,
  reconstruction,
  idx,
  home_goalie_player_id,
  away_goalie_player_id,
  home_skater_player_ids,
  away_skater_player_ids
)
```

## Arguments

- play_by_play:

  data.frame cleaned internal play-by-play object

- reconstruction:

  data.frame from
  [`.reconstruct_skater_counts_from_penalties()`](https://rentosaijo.github.io/nhlscraper/reference/dot-reconstruct_skater_counts_from_penalties.md)

- idx:

  row index in the play-by-play

- home_goalie_player_id:

  parsed home goalie player ID

- away_goalie_player_id:

  parsed away goalie player ID

- home_skater_player_ids:

  parsed home skater IDs

- away_skater_player_ids:

  parsed away skater IDs

## Value

logical scalar
