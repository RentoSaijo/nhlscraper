# Parse an NHL API response as JSON

`.nhl_json_from_response()` converts an `httr2` response object into a
parsed JSON object using the package's standard flattening settings.

## Usage

``` r
.nhl_json_from_response(resp)
```

## Arguments

- resp:

  httr2 response object

## Value

parsed JSON (i.e., data.frame or list)
