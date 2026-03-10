# Check HTML skater counts against reconstructed penalty state

`.html_on_ice_matches_reconstructed_strength()` validates the HTML
skater counts against the penalty-based reconstruction. Goalie presence
is validated separately when deciding whether the HTML row can override
stale source strength context.

## Usage

``` r
.html_on_ice_matches_reconstructed_strength(
  reconstruction,
  idx,
  home_skater_player_ids,
  away_skater_player_ids
)
```

## Arguments

- reconstruction:

  data.frame from
  [`.reconstruct_skater_counts_from_penalties()`](https://rentosaijo.github.io/nhlscraper/reference/dot-reconstruct_skater_counts_from_penalties.md)

- idx:

  row index in the play-by-play

- home_skater_player_ids:

  parsed home skater IDs

- away_skater_player_ids:

  parsed away skater IDs

## Value

logical scalar
