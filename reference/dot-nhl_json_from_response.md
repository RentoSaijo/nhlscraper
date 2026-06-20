# Parse an NHL API response as JSON

`.nhl_json_from_response()` converts an `httr2` response object into
parsed JSON using the package's standard UTF-8 and flattening settings.

## Usage

``` r
.nhl_json_from_response(resp)
```

## Arguments

- resp:

  httr2 response object

## Value

parsed JSON (i.e., data.frame or list)
