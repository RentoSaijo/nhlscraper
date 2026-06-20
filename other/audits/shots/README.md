# 2025-26 5v5 Shot Count Audit

Audited on 2026-06-20.

This audit investigates the 2025-26 regular-season 5v5 shot count differences between `nhlscraper::gc_play_by_plays(20252026)`, NHL official stats, Evolving Hockey, Natural Stat Trick, and HockeyStats.com.

## Short answer

The reported Evolving Hockey discrepancy is real and exactly reproducible from the files in `data/`.

Using `gc_play_by_plays(20252026)` and normal 5v5 rows (`gameTypeId == 2`, `situationCode == "1551"`, shot attempt event types only), nhlscraper has:

| Source | G | Saved SOG | iSF | Missed | iFF / Fenwick | Blocked | iCF / Corsi |
|---|---:|---:|---:|---:|---:|---:|---:|
| nhlscraper `1551` | 5,362 | 51,066 | 56,428 | 31,024 | 87,452 | 33,621 | 121,073 |
| Evolving Hockey export | 5,362 | 50,806 | 56,168 | 31,151 | 87,319 | 33,598 | 120,917 |
| Difference, EH - scraper | 0 | -260 | -260 | +127 | -133 | -23 | -156 |
| Natural Stat Trick export | 5,361 | 50,997 | 56,358 | 31,083 | 87,441 | 33,621 | 121,062 |
| HockeyStats export | 5,365 | 51,018 | 56,383 | 30,135 | 86,518 | NA | NA |

The most important finding: NHL official team `summaryshooting` has `shots5v5 = 56,428`, exactly matching nhlscraper's `goal + shot-on-goal` count. So the 260-shot EH SOG gap does **not** appear to be because nhlscraper is ahead of or behind NHL's official SOG total.

## What was compared

Local source files:

- `data/EvolvingHockey.xlsx`
- `data/NaturalStatTrick.csv`
- `data/HockeyStats.csv`

NHL / package sources:

- `nhlscraper::gc_play_by_plays(20252026)`
- NHL Stats `team/summaryshooting` season and game reports via `team_season_report()` / `team_game_report()`
- NHL HTML play-by-play reports, e.g. `https://www.nhl.com/scores/htmlreports/20252026/PL020001.HTM`

External definitions checked:

- Evolving Hockey glossary: `iSF` is goals + saved shots, `iFF` is goals + saved shots + missed shots, and `iCF` adds blocked shots: https://evolving-hockey.com/glossary/standard-skater-tables/
- HockeyStats methodology says short missed shots are no longer counted in Corsi, Fenwick, and expected-goals metrics: https://hockeystats.com/methodology/expected-goals
- Natural Stat Trick was not scraped directly because the site blocks automated access; the downloaded CSV in `data/` was used.

## Reproduction files

Supporting scripts and outputs were added under this audit folder:

- `scripts/audit_shot_counts.R`
- `scripts/fetch_html_5v5_counts.py`
- `outputs/site_total_comparison.csv`
- `outputs/pbp_filter_totals.csv`
- `outputs/official_team_summaryshooting_totals.csv`
- `outputs/nhl_html_5v5_totals.csv`
- `outputs/pbp_1551_reason_totals.csv`

Run from the repo root:

```sh
Rscript other/audits/shots/scripts/audit_shot_counts.R
python3 other/audits/shots/scripts/fetch_html_5v5_counts.py
```

The Python script only needs the standard library plus `lxml`.

## 5v5 definition findings

Do **not** use `strengthState == "even-strength"` if the goal is site-style 5v5. In nhlscraper that includes equal total men after goalie status is included, so it captures 4v4, 3v3, and some empty-net even-strength cases.

PBP filter comparison:

| nhlscraper filter | G | Saved | Missed | iFF | iCF |
|---|---:|---:|---:|---:|---:|
| `strengthState == "even-strength"` | 6,552 | 54,369 | 33,233 | 94,154 | 129,802 |
| `skaterCountFor == 5 & skaterCountAgainst == 5` | 5,372 | 51,075 | 31,040 | 87,487 | 121,121 |
| `situationCode == "1551"` | 5,362 | 51,066 | 31,024 | 87,452 | 121,073 |

The fact that Evolving Hockey and nhlscraper both have 5,362 goals strongly indicates that the user's comparison was already using the normal `1551` 5v5 definition, not broad even-strength or skater-count-only filtering. Empty nets are not the explanation: `1551` has both goalies present.

## NHL official checks

NHL official team `summaryshooting`, season-level:

| Official field | Total |
|---|---:|
| `shots5v5` | 56,428 |
| `usatFor` | 87,453 |
| `satFor` | 121,062 |

Interpretation:

- Official NHL `shots5v5` exactly matches nhlscraper's `iSF` from `1551` PBP rows.
- Official `usatFor` is only 1 higher than nhlscraper's `iFF`.
- Official `satFor` is 11 lower than nhlscraper's `iCF` and matches the Natural Stat Trick `iCF` export total.

The NHL HTML PL reports, parsed by on-ice 5v5 counts, were also very close:

| HTML PL 5v5 | Total |
|---|---:|
| G | 5,361 |
| Saved | 51,063 |
| iSF | 56,424 |
| Missed | 31,024 |
| iFF | 87,448 |
| Blocked | 33,621 |
| iCF | 121,069 |

That is close enough to rule out a broad JSON-vs-HTML `SHOT`/`MISS` mismatch as the EH explanation.

## Likely explanations by site

### Evolving Hockey

The EH gap looks like site-side event filtering or event outcome correction.

Arithmetic decomposition of the EH vs nhlscraper Fenwick gap:

- EH has 260 fewer saved shots.
- EH has 127 more missed shots.
- EH has 133 fewer total Fenwick attempts.

One simple way to produce that exact shape is:

- reclassify 127 nhlscraper/NHL `shot-on-goal` rows as missed shots; and
- drop or otherwise exclude 133 additional nhlscraper/NHL saved-shot rows.

That decomposition is not proof of EH's implementation, but it matches the signs and totals. The current data files are player-season aggregates, not event-level EH rows, so the exact 260/127/133 events cannot be identified from the provided EH export alone.

I checked common simple filters and they do **not** explain EH:

- All nhlscraper `1551` shot attempt rows have x/y coordinates.
- All saved/missed/goals have a shooter and goalie ID.
- Only 8 saved shots look duplicate-like by same game/time/team/player/type/location.
- Excluding neutral/defensive-zone SOG would remove 2,762 SOG, far too many.
- Excluding `reason == "short"` misses affects HockeyStats, not EH.

Because NHL official `shots5v5` agrees with nhlscraper, the most defensible conclusion is that EH is applying corrections or filters beyond the public NHL official shot count.

### Natural Stat Trick

NST is very close to nhlscraper and NHL official totals:

- NST `iCF = 121,062`, exactly matching official NHL `satFor`.
- NST `iFF = 87,441`, 11 below nhlscraper.
- NST goals are 1 below the other sources in the downloaded CSV.

This looks like small event-level correction drift, not a definition problem.

### HockeyStats.com

HockeyStats is much lower on `iFF`. This appears to be mostly explained by its published short-miss methodology.

In nhlscraper `1551`, there are 935 `missed-shot` rows with `reason == "short"`.

```text
nhlscraper iFF:              87,452
minus short missed shots:       935
result:                      86,517
HockeyStats iFF:             86,518
```

The remaining one-event difference is small enough to be a later correction, different goal/shot inclusion edge case, or a CSV timing mismatch.

## Corsi-specific caution

For SOG and Fenwick, nhlscraper's `1551` counts are close to NHL official summaries. Corsi is a little messier:

- nhlscraper `iCF` is 121,073.
- NHL official `satFor` is 121,062.
- NST `iCF` is 121,062.
- EH `iCF` is 120,917.

At the team-game level, NHL official `shots5v5` matches nhlscraper, but `satFor` differs in many games while mostly canceling out league-wide. That suggests blocked-shot accounting or official SAT event ownership has small corrections not captured by a naive `blocked-shot` row sum.

## Bottom line

For a nhlscraper comparison to public sites, the closest base filter is:

```r
pbp |>
  filter(
    gameTypeId == 2,
    situationCode == "1551",
    eventTypeDescKey %in% c("goal", "shot-on-goal", "missed-shot", "blocked-shot")
  )
```

The reported EH discrepancy is not caused by broad even-strength filtering, empty nets, missing coordinates, missing shooter/goalie IDs, duplicated PBP rows, or NHL official SOG changing away from nhlscraper. The most likely cause is that EH applies proprietary event-level shot outcome corrections and/or filters after ingesting NHL data. To identify the exact events, an event-level EH export would be needed; the current EH file is only a player-season aggregate.
