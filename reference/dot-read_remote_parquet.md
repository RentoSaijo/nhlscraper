# Download and read a remote parquet file

`.read_remote_parquet()` downloads a parquet file to a temporary path
and returns it as a base data.frame.

## Usage

``` r
.read_remote_parquet(path, timeout = NULL, method = NULL)
```

## Arguments

- path:

  character path inside the NHL_DB repository

- timeout:

  optional download timeout in seconds

- method:

  optional
  [`utils::download.file()`](https://rdrr.io/r/utils/download.file.html)
  method

## Value

data.frame
