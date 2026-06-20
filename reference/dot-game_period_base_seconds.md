# Compute period base seconds for a game

`.game_period_base_seconds()` returns elapsed-game seconds at the start
of each period under regular-season or playoff overtime rules.

## Usage

``` r
.game_period_base_seconds(game, period_number)
```

## Arguments

- game:

  game ID

- period_number:

  integer vector of period numbers

## Value

integer vector
