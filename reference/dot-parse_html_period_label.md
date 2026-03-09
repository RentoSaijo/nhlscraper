# Parse an HTML period label

`.parse_html_period_label()` converts HTML report period labels such as
`OT` and `SO` into integer period numbers.

## Usage

``` r
.parse_html_period_label(x, is_playoffs = FALSE)
```

## Arguments

- x:

  HTML period label

- is_playoffs:

  logical; whether the game is a playoff game

## Value

integer period number or `NA_integer_`
