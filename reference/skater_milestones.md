# Access the skaters on milestone watch

`skater_milestones()` returns NHL.com skater milestone-watch rows,
including player/team identifiers and the milestone/countdown fields
exposed by the endpoint.

## Usage

``` r
skater_milestones()
```

## Value

data.frame with one row per player

## Examples

``` r
skater_milestones <- skater_milestones()
```
