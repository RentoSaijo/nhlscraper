# Reconstruct skater counts from active penalties

`.reconstruct_skater_counts_from_penalties()` walks a cleaned
play-by-play in event order and reconstructs home/away skater counts
from active strength- affecting penalties. The reconstruction
intentionally targets regulation and playoff-strength states;
regular-season overtime is left unsupported because its 3-on-3 penalty
rules require a separate ruleset.

## Usage

``` r
.reconstruct_skater_counts_from_penalties(play_by_play)
```

## Arguments

- play_by_play:

  data.frame cleaned internal play-by-play object

## Value

data.frame with reconstructed home/away skater counts and metadata
