# Map HTML event codes to event type keys

`.html_event_code_to_type_desc()` converts HTML report event codes and
select description fallbacks into internal play-by-play event type keys.

## Usage

``` r
.html_event_code_to_type_desc(event_code, description = NA_character_)
```

## Arguments

- event_code:

  HTML event code

- description:

  optional HTML event description

## Value

event type key or `NA_character_`
