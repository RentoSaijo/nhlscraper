# Access all the penalty shots

`penalty_shots()` retrieves all the penalty shots as a `data.frame`
where each row represents penalty shot and includes detail on game
timeline state, period/clock progression, and matchup flow plus
date/season filtering windows and chronological context.

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
