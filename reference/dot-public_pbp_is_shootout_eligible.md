# Identify shootout-eligible games for public play-by-play cleanup

`.public_pbp_is_shootout_eligible()` returns `TRUE` for games whose
overtime rules follow the regular-season shootout path.

## Usage

``` r
.public_pbp_is_shootout_eligible(game_id, game_type_id)
```

## Arguments

- game_id:

  integer game IDs

- game_type_id:

  integer game type IDs

## Value

logical vector
