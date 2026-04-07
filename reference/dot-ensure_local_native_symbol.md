# Ensure a native symbol is available

`.ensure_local_native_symbol()` checks whether a native symbol is
already registered and, if needed, tries to load the installed package
shared object. It does not trust the current working directory.

## Usage

``` r
.ensure_local_native_symbol(symbol)
```

## Arguments

- symbol:

  native symbol name

## Value

logical scalar indicating whether the symbol is available
