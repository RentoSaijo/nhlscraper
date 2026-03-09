# Ensure a local native symbol is loaded

`.ensure_local_native_symbol()` tries to load the package shared object
from the local `src/` directory when a native symbol is not yet
registered.

## Usage

``` r
.ensure_local_native_symbol(symbol)
```

## Arguments

- symbol:

  native symbol name

## Value

logical scalar indicating whether the symbol is available
