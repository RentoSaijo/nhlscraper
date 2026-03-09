# Parse an HTML on-ice cell

`.parse_html_on_ice_cell()` resolves a goalie and skater player-ID list
from a single team on-ice HTML cell.

## Usage

``` r
.parse_html_on_ice_cell(text, team_id, roster_lookup)
```

## Arguments

- text:

  on-ice cell text

- team_id:

  team ID for the cell

- roster_lookup:

  standardized roster lookup data.frame

## Value

named list containing goalie and skater player IDs
