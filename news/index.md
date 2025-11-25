# Changelog

## nhlscraper 0.2.0.9000

- Website now properly includes title and example.

## nhlscraper 0.2.0

CRAN release: 2025-07-17

- Documentation is now standardized.
- Website is now overhauled with dark theme, example, disclosure, etc.
- New functions to access the NHL Records and ESPN APIs are now
  available:
  - [`get_franchise_season_by_season()`](https://rentosaijo.github.io/nhlscraper/reference/get_franchise_season_by_season.md)
  - [`get_players()`](https://rentosaijo.github.io/nhlscraper/reference/get_players.md)
  - [`get_bracket()`](https://rentosaijo.github.io/nhlscraper/reference/get_bracket.md)
  - [`get_series()`](https://rentosaijo.github.io/nhlscraper/reference/get_series.md)
  - [`get_awards()`](https://rentosaijo.github.io/nhlscraper/reference/get_awards.md)
  - [`get_award_winners()`](https://rentosaijo.github.io/nhlscraper/reference/get_award_winners.md)
  - [`get_drafts()`](https://rentosaijo.github.io/nhlscraper/reference/get_drafts.md)
  - [`get_franchise_team_totals()`](https://rentosaijo.github.io/nhlscraper/reference/get_franchise_team_totals.md)
  - [`get_franchise_vs_franchise()`](https://rentosaijo.github.io/nhlscraper/reference/get_franchise_vs_franchise.md)
  - [`get_venues()`](https://rentosaijo.github.io/nhlscraper/reference/get_venues.md)
  - [`get_attendance()`](https://rentosaijo.github.io/nhlscraper/reference/get_attendance.md)
  - [`get_officials()`](https://rentosaijo.github.io/nhlscraper/reference/get_officials.md)
  - [`get_espn_teams()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_teams.md)
  - [`get_espn_team()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_team.md)
  - [`get_espn_athletes()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_athletes.md)
  - [`get_espn_athlete()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_athlete.md)
  - [`get_espn_coaches()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_coaches.md)
  - [`get_espn_coach()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_coach.md)
  - [`get_espn_coach_career()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_coach_career.md)
  - [`get_espn_events()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_events.md)
  - [`get_espn_event()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_event.md)
  - [`get_espn_event_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_event_play_by_play.md)
  - [`get_espn_event_stars()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_event_stars.md)
  - [`get_espn_event_officials()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_event_officials.md)
  - [`get_espn_event_odds()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_event_odds.md)
  - [`get_espn_transactions()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_transactions.md)
  - [`get_espn_injuries()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_injuries.md)
  - [`get_espn_futures()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_futures.md)
- Some functions’ returns are now modified:
  - [`get_franchises()`](https://rentosaijo.github.io/nhlscraper/reference/get_franchises.md)
  - [`get_draft_picks()`](https://rentosaijo.github.io/nhlscraper/reference/get_draft_picks.md)
- Some functions are now replaced :
  - `get_draft_information()` is now
    [`get_drafts()`](https://rentosaijo.github.io/nhlscraper/reference/get_drafts.md).
  - `get_playoff_bracket()` is now
    [`get_bracket()`](https://rentosaijo.github.io/nhlscraper/reference/get_bracket.md).
  - `get_series_carousel()` is now
    [`get_series()`](https://rentosaijo.github.io/nhlscraper/reference/get_series.md).

## nhlscraper 0.1.1

CRAN release: 2025-06-11

- Documentation is now cleaner.
- Some functions are now more optimized.

## nhlscraper 0.1.0

- `News.md` now tracks change-log.
- New functions to access the NHL APIs are now available:
  - [`get_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/get_seasons.md)
  - [`get_schedule()`](https://rentosaijo.github.io/nhlscraper/reference/get_schedule.md)
  - [`get_standings_information()`](https://rentosaijo.github.io/nhlscraper/reference/get_standings_information.md)
  - [`get_standings()`](https://rentosaijo.github.io/nhlscraper/reference/get_standings.md)
  - [`get_teams()`](https://rentosaijo.github.io/nhlscraper/reference/get_teams.md)
  - [`get_franchises()`](https://rentosaijo.github.io/nhlscraper/reference/get_franchises.md)
  - [`get_team_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/get_team_seasons.md)
  - [`get_team_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/get_team_statistics.md)
  - [`get_team_roster()`](https://rentosaijo.github.io/nhlscraper/reference/get_team_roster.md)
  - [`get_team_roster_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/get_team_roster_statistics.md)
  - [`get_team_prospects()`](https://rentosaijo.github.io/nhlscraper/reference/get_team_prospects.md)
  - [`get_team_schedule()`](https://rentosaijo.github.io/nhlscraper/reference/get_team_schedule.md)
  - [`get_team_scoreboard()`](https://rentosaijo.github.io/nhlscraper/reference/get_team_scoreboard.md)
  - [`get_player_game_log()`](https://rentosaijo.github.io/nhlscraper/reference/get_player_game_log.md)
  - [`get_player_landing()`](https://rentosaijo.github.io/nhlscraper/reference/get_player_landing.md)
  - [`get_spotlight_players()`](https://rentosaijo.github.io/nhlscraper/reference/get_spotlight_players.md)
  - [`get_skaters()`](https://rentosaijo.github.io/nhlscraper/reference/get_skaters.md)
  - [`get_skater_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/get_skater_statistics.md)
  - [`get_skater_leaders()`](https://rentosaijo.github.io/nhlscraper/reference/get_skater_leaders.md)
  - [`get_skater_milestones()`](https://rentosaijo.github.io/nhlscraper/reference/get_skater_milestones.md)
  - [`get_goalies()`](https://rentosaijo.github.io/nhlscraper/reference/get_goalies.md)
  - [`get_goalie_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/get_goalie_statistics.md)
  - [`get_goalie_leaders()`](https://rentosaijo.github.io/nhlscraper/reference/get_goalie_leaders.md)
  - [`get_goalie_milestones()`](https://rentosaijo.github.io/nhlscraper/reference/get_goalie_milestones.md)
  - [`get_games()`](https://rentosaijo.github.io/nhlscraper/reference/get_games.md)
  - [`get_scores()`](https://rentosaijo.github.io/nhlscraper/reference/get_scores.md)
  - [`get_scoreboards()`](https://rentosaijo.github.io/nhlscraper/reference/get_scoreboards.md)
  - [`get_game_boxscore()`](https://rentosaijo.github.io/nhlscraper/reference/get_game_boxscore.md)
  - [`get_gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/get_gc_play_by_play.md)
  - [`get_wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/get_wsc_play_by_play.md)
  - [`get_shift_charts()`](https://rentosaijo.github.io/nhlscraper/reference/get_shift_charts.md)
  - [`get_game_landing()`](https://rentosaijo.github.io/nhlscraper/reference/get_game_landing.md)
  - [`get_game_story()`](https://rentosaijo.github.io/nhlscraper/reference/get_game_story.md)
  - `get_playoff_bracket()`
  - [`get_series_schedule()`](https://rentosaijo.github.io/nhlscraper/reference/get_series_schedule.md)
  - `get_series_carousel()`
  - `get_draft_information()`
  - [`get_draft_picks()`](https://rentosaijo.github.io/nhlscraper/reference/get_draft_picks.md)
  - [`get_draft_rankings()`](https://rentosaijo.github.io/nhlscraper/reference/get_draft_rankings.md)
  - [`get_draft_tracker()`](https://rentosaijo.github.io/nhlscraper/reference/get_draft_tracker.md)
  - [`ping()`](https://rentosaijo.github.io/nhlscraper/reference/ping.md)
  - [`get_glossary()`](https://rentosaijo.github.io/nhlscraper/reference/get_glossary.md)
  - [`get_configuration()`](https://rentosaijo.github.io/nhlscraper/reference/get_configuration.md)
  - [`get_countries()`](https://rentosaijo.github.io/nhlscraper/reference/get_countries.md)
  - [`get_streams()`](https://rentosaijo.github.io/nhlscraper/reference/get_streams.md)
  - [`get_tv_schedule()`](https://rentosaijo.github.io/nhlscraper/reference/get_tv_schedule.md)
  - [`get_partner_odds()`](https://rentosaijo.github.io/nhlscraper/reference/get_partner_odds.md)
  - [`get_season_now()`](https://rentosaijo.github.io/nhlscraper/reference/get_season_now.md)
