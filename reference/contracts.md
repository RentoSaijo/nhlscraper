# Access all contracts from packaged internal data

`contracts()` loads preprocessed contract records bundled with the
package, resolves each row to an NHL player ID when the player registry
has a clear match, drops unresolved/ambiguous matches, and returns
normalized contract seasons and money fields.

## Usage

``` r
contracts()
```

## Value

data.frame with one row per contract

## Examples

``` r
all_contracts <- contracts()
```
