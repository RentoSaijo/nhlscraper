# Access the goalies on milestone watch

`goalie_milestones()` retrieves the goalies on milestone watch as a
`data.frame` where each row represents player and includes detail on
date/season filtering windows and chronological context, player
identity, role, handedness, and biographical profile, and ranking
movement, points pace, and division/conference position signals.

## Usage

``` r
goalie_milestones()
```

## Value

data.frame with one row per player

## Examples

``` r
goalie_milestones <- goalie_milestones()
```
