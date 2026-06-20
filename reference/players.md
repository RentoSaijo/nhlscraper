# Access all the players

`players()` returns the records-site player registry with one row per
player and normalized IDs, names, position, handedness, and birth
fields.

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
