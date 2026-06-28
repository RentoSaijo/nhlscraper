# Resolve xG booster file path

`.xg_resolve_booster_path()` is an internal helper for
[`calculate_expected_goals()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_expected_goals.md).

## Usage

``` r
.xg_resolve_booster_path(
  model_key,
  bundle = .xg_load_bundle(),
  download = TRUE
)
```

## Arguments

- model_key:

  character xG model key

- bundle:

  xG model bundle

- download:

  logical whether downloading is allowed

## Value

Internal helper output.
