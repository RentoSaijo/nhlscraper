# Access all the players

`players()` retrieves all the players as a `data.frame` where each row
represents player and includes detail on player identity, role,
handedness, and biographical profile.

## Usage

``` r
players()
```

## Value

data.frame with one row per player

## Examples

``` r
# May take >5s, so skip.
all_players <- players()
```
