# Build previous event type key

`.xg_make_type_desc_key_prev()` is an internal helper for
[`calculate_expected_goals()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_expected_goals.md).

## Usage

``` r
.xg_make_type_desc_key_prev(
  type_desc_key_prev,
  reason_prev,
  shot_type_prev,
  event_owner_team_id_prev,
  event_owner_team_id
)
```

## Arguments

- type_desc_key_prev:

  character previous event type keys

- reason_prev:

  character previous missed-shot reasons

- shot_type_prev:

  character previous shot types

- event_owner_team_id_prev:

  integer previous event owner team IDs

- event_owner_team_id:

  integer current event owner team IDs

## Value

Internal helper output.
