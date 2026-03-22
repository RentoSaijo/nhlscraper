# Derive the legal period length in seconds

`.public_pbp_legal_period_seconds()` returns the nominal legal length
for each play-by-play row's period under the relevant game context.

## Usage

``` r
.public_pbp_legal_period_seconds(game_id, game_type_id, period)
```

## Arguments

- game_id:

  integer game IDs

- game_type_id:

  integer game type IDs

- period:

  integer period numbers

## Value

integer vector of legal period lengths in seconds
