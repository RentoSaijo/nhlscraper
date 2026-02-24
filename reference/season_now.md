# Access the season as of now

`season_now()` retrieves the season as of now and returns a scalar
integer used as the current-context default in season/game-type
dependent wrappers.

## Usage

``` r
season_now()
```

## Value

integer in YYYYYYYY (e.g., 20242025)

## Examples

``` r
season_now <- season_now()
```
