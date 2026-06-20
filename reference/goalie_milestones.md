# Access the goalies on milestone watch

`goalie_milestones()` returns NHL.com goalie milestone-watch rows,
including goalie/team identifiers and the milestone/countdown fields
exposed by the endpoint.

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
