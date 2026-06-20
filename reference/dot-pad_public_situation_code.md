# Pad public situation codes

`.pad_public_situation_code()` preserves missing values and zero-pads
nonempty situation codes to the four-character public play-by-play form.

## Usage

``` r
.pad_public_situation_code(play_by_plays)
```

## Arguments

- play_by_plays:

  data.frame containing `situationCode`

## Value

data.frame
