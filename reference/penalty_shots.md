# Access all the penalty shots

`penalty_shots()` returns historical penalty-shot records with one row
per attempt, including game, season/game type, shooter/goalie, team, and
outcome fields.

## Usage

``` r
penalty_shots()

pss()
```

## Value

data.frame with one row per penalty shot

## Examples

``` r
all_pss <- penalty_shots()
```
