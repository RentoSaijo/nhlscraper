# Add one-on-one shooter/goalie assignments

`.add_one_on_one_on_ice_players()` populates on-ice player-ID columns
for penalty-shot and shootout rows whose `situationCode` implies a
one-skater versus one-goalie state (`0101`/`1010`). The raw
`situationCode` remains the source column; this helper only synthesizes
the compatible scalar player-ID assignments when the general HTML on-ice
signature is not usable.

## Usage

``` r
.add_one_on_one_on_ice_players(play_by_play, matched = data.frame())
```

## Arguments

- play_by_play:

  data.frame play-by-play object

- matched:

  optional matched HTML rows from
  [`.match_html_pbp_to_api()`](https://rentosaijo.github.io/nhlscraper/reference/dot-match_html_pbp_to_api.md)

## Value

data.frame enriched with one-on-one shooter/goalie assignments
