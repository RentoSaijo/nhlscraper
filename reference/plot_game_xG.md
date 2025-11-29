# Plot all shot attempts in a game on a full rink

`plot_game_xG()` plots all shot attempts (goal, shot-on-goal,
missed-shot, blocked-shot) for a single game on a full NHL rink, colours
them according to an expected goals (xG) model, and saves the result as
a PNG file.

## Usage

``` r
plot_game_xG(game = 2023030417, model = 1L, team = "home")
```

## Arguments

- game:

  Integer or character game ID understood by
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  and
  [`gc_summary()`](https://rentosaijo.github.io/nhlscraper/reference/gc_summary.md).
  Default is `2023030417`.

- model:

  Integer indicating which expected goals model to use: `1L` for
  `xG_v1`, `2L` for `xG_v2`, `3L` for `xG_v3`. Default is `1L`.

- team:

  Character string indicating which team’s shots to plot, either
  `'home'` or `'away'` (case-insensitive). Default is `'home'`.

## Value

Invisibly returns `NULL`. Called for its side effect of creating a PNG
file in the working directory containing the rink and shot map.

## Details

For the selected team (home or away), the function:

- loads play-by-play data via
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md),

- flags which team is at home using
  [`flag_is_home()`](https://rentosaijo.github.io/nhlscraper/reference/flag_is_home.md),

- normalises coordinates with
  [`normalize_coordinates()`](https://rentosaijo.github.io/nhlscraper/reference/normalize_coordinates.md)
  so all shots attack toward +x,

- computes the chosen xG model via one of
  [`calculate_expected_goals_v1()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_expected_goals_v1.md),
  [`calculate_expected_goals_v2()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_expected_goals_v2.md),
  or
  [`calculate_expected_goals_v3()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_expected_goals_v3.md),

- filters to events with `typeDescKey` equal to `'goal'`,
  `'shot-on-goal'`, `'missed-shot'`, or `'blocked-shot'`,

- jitters shot coordinates slightly to reduce overplotting, and

- draws a full rink via
  [`plot_full_rink()`](https://rentosaijo.github.io/nhlscraper/reference/plot_full_rink.md)
  and overlays the shots.

Shot marker shapes are:

- goal – star (`pch = 8`),

- shot-on-goal – filled circle (`pch = 16`),

- missed-shot – filled triangle (`pch = 17`),

- blocked-shot – filled square (`pch = 15`).

Expected-goals values are binned into up to five game-specific ranges
and mapped to a blue-to-red palette, with low-xG attempts drawn in blue
and high-xG attempts in red. A title is constructed from
[`gc_summary()`](https://rentosaijo.github.io/nhlscraper/reference/gc_summary.md)
using the game date and team abbreviations, e.g.
`"2024-06-24 FLA Shots vs. EDM by Result and xG, jittered"`.

The plot is written to a PNG file of fixed size (approximately 1080 x
566 pixels at 144 dpi) in the working directory. The filename has the
form `shots_{game}_{team}_xG_v{model}.png`, for example
`"shots_2023030417_home_xG_v1.png"`.

## Examples

``` r
# \donttest{
  # Home team, xG_v1
  plot_game_xG(2023030417, model = 1, team = 'home')

  # Away team, xG_v2
  plot_game_xG(2023030417, model = 2, team = 'away')
# }
```
