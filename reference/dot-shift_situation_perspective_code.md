# Convert situation codes to player-team perspective

`.shift_situation_perspective_code()` is an internal helper for
[`calculate_shift_times_by_situation()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_shift_times_by_situation.md).

## Usage

``` r
.shift_situation_perspective_code(situation_code, player_is_home)
```

## Arguments

- situation_code:

  integer or character situation codes

- player_is_home:

  logical vector indicating home-team perspective

## Value

Internal helper output.
