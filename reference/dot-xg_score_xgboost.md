# Score shots with xGBoost

`.xg_score_xgboost()` is an internal helper for
[`calculate_expected_goals()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_expected_goals.md).

## Usage

``` r
.xg_score_xgboost(df, model_key, bundle = .xg_load_bundle())
```

## Arguments

- df:

  data.frame model-frame input

- model_key:

  character xG model key

- bundle:

  xG model bundle

## Value

Internal helper output.
