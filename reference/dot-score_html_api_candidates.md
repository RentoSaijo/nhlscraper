# Score HTML-to-API matching candidates

`.score_html_api_candidates()` scores candidate API rows for a single
HTML row using time, type, team, player, and local sequence agreement.

## Usage

``` r
.score_html_api_candidates(api, html, cand, h_idx, last_api_seq = NULL)
```

## Arguments

- api:

  API-side matching table

- html:

  HTML-side matching table

- cand:

  integer candidate API indices

- h_idx:

  HTML row index being scored

- last_api_seq:

  optional last matched API sequence number

## Value

named numeric vector of candidate scores
