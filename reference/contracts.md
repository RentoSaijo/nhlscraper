# Access all contracts from packaged internal data

`contracts()` loads preprocessed contract records bundled with the
package and returns a cleaned `data.frame` with package-consistent
column names, season IDs, numeric money fields, and team/player
identifiers.

## Usage

``` r
contracts()
```

## Value

data.frame with one row per contract

## Examples

``` r
all_contracts <- contracts()
#> Dropped 544 row(s) with unresolved/ambiguous playerId matches.
```
