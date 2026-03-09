# Build a game-roster lookup table

`.build_game_roster_lookup()` standardizes roster columns and prepares a
lookup table used to resolve HTML sweater numbers to player IDs.

## Usage

``` r
.build_game_roster_lookup(rosters)
```

## Arguments

- rosters:

  roster data.frame from the game play-by-play metadata

## Value

standardized roster lookup data.frame
