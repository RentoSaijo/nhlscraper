# Access the career statistics for all the coaches

`coach_career_statistics()` retrieves the career statistics for all the
coaches as a `data.frame` where each row represents coach and includes
detail on ranking movement, points pace, and division/conference
position signals.

## Usage

``` r
coach_career_statistics()

coach_career_stats()
```

## Value

data.frame with one row per coach

## Examples

``` r
coach_career_stats <- coach_career_statistics()
```
