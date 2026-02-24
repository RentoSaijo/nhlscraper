# Access all the award winners/finalists

`award_winners()` retrieves all the award winners/finalists as a
`data.frame` where each row represents winner/finalist and includes
detail on date/season filtering windows and chronological context, team
identity, affiliation, and matchup-side context, and player identity,
role, handedness, and biographical profile.

## Usage

``` r
award_winners()
```

## Value

data.frame with one row per winner/finalist

## Examples

``` r
all_award_winners <- award_winners()
```
