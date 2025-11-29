# Package index

## High-level

Functions that call the NHL APIs for high-level data

### League

Functions to access data about the entire league

- [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  : Access all the seasons
- [`season_now()`](https://rentosaijo.github.io/nhlscraper/reference/season_now.md)
  : Access the season as of now
- [`game_type_now()`](https://rentosaijo.github.io/nhlscraper/reference/game_type_now.md)
  : Access the game type as of now
- [`standings_rules()`](https://rentosaijo.github.io/nhlscraper/reference/standings_rules.md)
  : Access the standings rules by season
- [`standings()`](https://rentosaijo.github.io/nhlscraper/reference/standings.md)
  : Access the standings for a date
- [`schedule()`](https://rentosaijo.github.io/nhlscraper/reference/schedule.md)
  : Access the schedule for a date
- [`venues()`](https://rentosaijo.github.io/nhlscraper/reference/venues.md)
  : Access all the venues
- [`attendance()`](https://rentosaijo.github.io/nhlscraper/reference/attendance.md)
  : Access the attendance by season and game type

### Franchise

Functions to access data about the franchises and teams

- [`franchises()`](https://rentosaijo.github.io/nhlscraper/reference/franchises.md)
  : Access all the franchises
- [`franchise_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/franchise_statistics.md)
  [`franchise_stats()`](https://rentosaijo.github.io/nhlscraper/reference/franchise_statistics.md)
  : Access the all-time statistics for all the franchises by game type
- [`franchise_team_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/franchise_team_statistics.md)
  [`franchise_team_stats()`](https://rentosaijo.github.io/nhlscraper/reference/franchise_team_statistics.md)
  : Access the all-time statistics for all the franchises by team and
  game type
- [`franchise_season_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/franchise_season_statistics.md)
  [`franchise_season_stats()`](https://rentosaijo.github.io/nhlscraper/reference/franchise_season_statistics.md)
  : Access the statistics for all the franchises by season and game type
- [`franchise_versus_franchise()`](https://rentosaijo.github.io/nhlscraper/reference/franchise_versus_franchise.md)
  [`franchise_vs_franchise()`](https://rentosaijo.github.io/nhlscraper/reference/franchise_versus_franchise.md)
  : Access the all-time statistics versus other franchises for all the
  franchises by game type
- [`franchise_playoff_situational_results()`](https://rentosaijo.github.io/nhlscraper/reference/franchise_playoff_situational_results.md)
  : Access the playoff series results for all the franchises by
  situation
- [`teams()`](https://rentosaijo.github.io/nhlscraper/reference/teams.md)
  : Access all the teams
- [`team_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/team_seasons.md)
  : Access the season(s) and game type(s) in which a team played
- [`team_report_configurations()`](https://rentosaijo.github.io/nhlscraper/reference/team_report_configurations.md)
  [`team_report_configs()`](https://rentosaijo.github.io/nhlscraper/reference/team_report_configurations.md)
  : Access the configurations for team reports
- [`team_season_report()`](https://rentosaijo.github.io/nhlscraper/reference/team_season_report.md)
  : Access various reports for a season, game type, and category for all
  the teams by season
- [`team_game_report()`](https://rentosaijo.github.io/nhlscraper/reference/team_game_report.md)
  : Access various reports for a season, game type, and category for all
  the teams by game
- [`team_season_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/team_season_statistics.md)
  [`team_season_stats()`](https://rentosaijo.github.io/nhlscraper/reference/team_season_statistics.md)
  : Access the statistics for all the teams by season and game type
- [`roster()`](https://rentosaijo.github.io/nhlscraper/reference/roster.md)
  : Access the roster for a team, season, and position
- [`roster_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/roster_statistics.md)
  [`roster_stats()`](https://rentosaijo.github.io/nhlscraper/reference/roster_statistics.md)
  : Access the roster statistics for a team, season, game type, and
  position
- [`team_prospects()`](https://rentosaijo.github.io/nhlscraper/reference/team_prospects.md)
  : Access the prospects for a team and position
- [`team_season_schedule()`](https://rentosaijo.github.io/nhlscraper/reference/team_season_schedule.md)
  : Access the schedule for a team and season
- [`team_month_schedule()`](https://rentosaijo.github.io/nhlscraper/reference/team_month_schedule.md)
  : Access the schedule for a team and month
- [`team_week_schedule()`](https://rentosaijo.github.io/nhlscraper/reference/team_week_schedule.md)
  : Access the schedule for a team and week since a date
- [`team_logos()`](https://rentosaijo.github.io/nhlscraper/reference/team_logos.md)
  : Access all the team logos
- [`team_edge_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/team_edge_seasons.md)
  : Access the season(s) and game type(s) in which there exists team
  EDGE statistics
- [`team_edge_leaders()`](https://rentosaijo.github.io/nhlscraper/reference/team_edge_leaders.md)
  : Access the team EDGE statistics leaders for a season and game type
- [`team_edge_summary()`](https://rentosaijo.github.io/nhlscraper/reference/team_edge_summary.md)
  : Access the EDGE summary for a team, season, and game type
- [`team_edge_zone_time()`](https://rentosaijo.github.io/nhlscraper/reference/team_edge_zone_time.md)
  : Access the EDGE zone time statistics for a team, season, game type,
  and category
- [`team_edge_skating_distance()`](https://rentosaijo.github.io/nhlscraper/reference/team_edge_skating_distance.md)
  : Access the EDGE skating distance statistics for a team, season, game
  type, and category
- [`team_edge_skating_speed()`](https://rentosaijo.github.io/nhlscraper/reference/team_edge_skating_speed.md)
  : Access the EDGE skating speed statistics for a team, season, game
  type, and category
- [`team_edge_shot_location()`](https://rentosaijo.github.io/nhlscraper/reference/team_edge_shot_location.md)
  : Access the EDGE shot location statistics for a team, season, game
  type, and category
- [`team_edge_shot_speed()`](https://rentosaijo.github.io/nhlscraper/reference/team_edge_shot_speed.md)
  : Access the EDGE shot speed statistics for a team, season, game type,
  and category

### Postseason

Functions to access data about the playoffs, awards, and drafts

- [`series()`](https://rentosaijo.github.io/nhlscraper/reference/series.md)
  : Access all the playoff series by game
- [`playoff_season_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/playoff_season_statistics.md)
  [`playoff_season_stats()`](https://rentosaijo.github.io/nhlscraper/reference/playoff_season_statistics.md)
  : Access the playoff statistics by season
- [`bracket()`](https://rentosaijo.github.io/nhlscraper/reference/bracket.md)
  : Access the playoff bracket for a season
- [`series_schedule()`](https://rentosaijo.github.io/nhlscraper/reference/series_schedule.md)
  : Access the playoff schedule for a season and series
- [`awards()`](https://rentosaijo.github.io/nhlscraper/reference/awards.md)
  : Access all the awards
- [`award_winners()`](https://rentosaijo.github.io/nhlscraper/reference/award_winners.md)
  : Access all the award winners/finalists
- [`drafts()`](https://rentosaijo.github.io/nhlscraper/reference/drafts.md)
  : Access all the drafts
- [`draft_picks()`](https://rentosaijo.github.io/nhlscraper/reference/draft_picks.md)
  : Access all the draft picks
- [`draft_prospects()`](https://rentosaijo.github.io/nhlscraper/reference/draft_prospects.md)
  : Access all the draft prospects
- [`draft_rankings()`](https://rentosaijo.github.io/nhlscraper/reference/draft_rankings.md)
  : Access the draft rankings for a class and category
- [`combine_reports()`](https://rentosaijo.github.io/nhlscraper/reference/combine_reports.md)
  : Access the draft combine reports
- [`lottery_odds()`](https://rentosaijo.github.io/nhlscraper/reference/lottery_odds.md)
  : Access the draft lottery odds
- [`draft_tracker()`](https://rentosaijo.github.io/nhlscraper/reference/draft_tracker.md)
  : Access the real-time draft tracker
- [`expansion_drafts()`](https://rentosaijo.github.io/nhlscraper/reference/expansion_drafts.md)
  : Access all the expansion drafts
- [`expansion_draft_picks()`](https://rentosaijo.github.io/nhlscraper/reference/expansion_draft_picks.md)
  : Access all the expansion draft picks

### Management

Functions to access data about the GMs, coaches, and officials

- [`general_managers()`](https://rentosaijo.github.io/nhlscraper/reference/general_managers.md)
  [`gms()`](https://rentosaijo.github.io/nhlscraper/reference/general_managers.md)
  : Access all the general managers
- [`coaches()`](https://rentosaijo.github.io/nhlscraper/reference/coaches.md)
  : Access all the coaches
- [`coach_career_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/coach_career_statistics.md)
  [`coach_career_stats()`](https://rentosaijo.github.io/nhlscraper/reference/coach_career_statistics.md)
  : Access the career statistics for all the coaches
- [`coach_franchise_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/coach_franchise_statistics.md)
  [`coach_franchise_stats()`](https://rentosaijo.github.io/nhlscraper/reference/coach_franchise_statistics.md)
  : Access the statistics for all the coaches by franchise and game type
- [`officials()`](https://rentosaijo.github.io/nhlscraper/reference/officials.md)
  : Access all the officials

### Other

Functions to acccess any other data

- [`glossary()`](https://rentosaijo.github.io/nhlscraper/reference/glossary.md)
  : Access the glossary
- [`countries()`](https://rentosaijo.github.io/nhlscraper/reference/countries.md)
  : Access all the countries
- [`location()`](https://rentosaijo.github.io/nhlscraper/reference/location.md)
  : Access the location for a zip code
- [`streams()`](https://rentosaijo.github.io/nhlscraper/reference/streams.md)
  : Access all the streams
- [`tv_schedule()`](https://rentosaijo.github.io/nhlscraper/reference/tv_schedule.md)
  : Access the NHL Network TV schedule for a date

## Mid-level

Functions that call the NHL APIs for mid-level data

### Player

Functions to access data about the players at large

- [`players()`](https://rentosaijo.github.io/nhlscraper/reference/players.md)
  : Access all the players
- [`player_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/player_seasons.md)
  : Access the season(s) and game type(s) in which a player played
- [`player_summary()`](https://rentosaijo.github.io/nhlscraper/reference/player_summary.md)
  : Access the summary for a player
- [`player_game_log()`](https://rentosaijo.github.io/nhlscraper/reference/player_game_log.md)
  : Access the game log for a player, season, and game type
- [`spotlight_players()`](https://rentosaijo.github.io/nhlscraper/reference/spotlight_players.md)
  : Access the spotlight players

### Skater

Functions to access data about the skaters

- [`skater_report_configurations()`](https://rentosaijo.github.io/nhlscraper/reference/skater_report_configurations.md)
  [`skater_report_configs()`](https://rentosaijo.github.io/nhlscraper/reference/skater_report_configurations.md)
  : Access the configurations for skater reports
- [`skater_season_report()`](https://rentosaijo.github.io/nhlscraper/reference/skater_season_report.md)
  : Access various reports for a season, game type, and category for all
  the skaters by season
- [`skater_game_report()`](https://rentosaijo.github.io/nhlscraper/reference/skater_game_report.md)
  : Access various reports for a season, game type, and category for all
  the skaters by game
- [`skater_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/skater_statistics.md)
  [`skater_stats()`](https://rentosaijo.github.io/nhlscraper/reference/skater_statistics.md)
  : Access the career statistics for all the skaters
- [`skater_regular_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/skater_regular_statistics.md)
  [`skater_regular_stats()`](https://rentosaijo.github.io/nhlscraper/reference/skater_regular_statistics.md)
  : Access the career regular season statistics for all the skaters
- [`skater_playoff_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/skater_playoff_statistics.md)
  [`skater_playoff_stats()`](https://rentosaijo.github.io/nhlscraper/reference/skater_playoff_statistics.md)
  : Access the career playoff statistics for all the skaters
- [`skater_season_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/skater_season_statistics.md)
  [`skater_season_stats()`](https://rentosaijo.github.io/nhlscraper/reference/skater_season_statistics.md)
  : Access the statistics for all the skaters by season, game type, and
  team
- [`skater_series_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/skater_series_statistics.md)
  [`skater_series_stats()`](https://rentosaijo.github.io/nhlscraper/reference/skater_series_statistics.md)
  : Access the playoff statistics for all the skaters by series
- [`skater_leaders()`](https://rentosaijo.github.io/nhlscraper/reference/skater_leaders.md)
  : Access the skater statistics leaders for a season, game type, and
  category
- [`skater_milestones()`](https://rentosaijo.github.io/nhlscraper/reference/skater_milestones.md)
  : Access the skaters on milestone watch
- [`skater_edge_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/skater_edge_seasons.md)
  : Access the season(s) and game type(s) in which there exists skater
  EDGE statistics
- [`skater_edge_leaders()`](https://rentosaijo.github.io/nhlscraper/reference/skater_edge_leaders.md)
  : Access the skater EDGE statistics leaders for a season and game type
- [`skater_edge_summary()`](https://rentosaijo.github.io/nhlscraper/reference/skater_edge_summary.md)
  : Access the EDGE summary for a skater, season, and game type
- [`skater_edge_zone_time()`](https://rentosaijo.github.io/nhlscraper/reference/skater_edge_zone_time.md)
  : Access the EDGE zone time statistics for a skater, season, game
  type, and category
- [`skater_edge_skating_distance()`](https://rentosaijo.github.io/nhlscraper/reference/skater_edge_skating_distance.md)
  : Access the EDGE skating distance statistics for a skater, season,
  game type, and category
- [`skater_edge_skating_speed()`](https://rentosaijo.github.io/nhlscraper/reference/skater_edge_skating_speed.md)
  : Access the EDGE skating speed statistics for a skater, season, game
  type, and category
- [`skater_edge_shot_location()`](https://rentosaijo.github.io/nhlscraper/reference/skater_edge_shot_location.md)
  : Access the EDGE shot location statistics for a skater, season, game
  type, and category
- [`skater_edge_shot_speed()`](https://rentosaijo.github.io/nhlscraper/reference/skater_edge_shot_speed.md)
  : Access the EDGE shot speed statistics for a skater, season, game
  type, and category

### Goalie

Functions to access data about the goalies

- [`goalie_report_configurations()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_report_configurations.md)
  [`goalie_report_configs()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_report_configurations.md)
  : Access the configurations for goalie reports
- [`goalie_season_report()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_season_report.md)
  : Access various reports for a season, game type, and category for all
  the goalies by season
- [`goalie_game_report()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_game_report.md)
  : Access various reports for a season, game type, and category for all
  the goalies by game
- [`goalie_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_statistics.md)
  [`goalie_stats()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_statistics.md)
  : Access the career statistics for all the goalies
- [`goalie_regular_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_regular_statistics.md)
  [`goalie_regular_stats()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_regular_statistics.md)
  : Access the career regular season statistics for all the goalies
- [`goalie_season_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_season_statistics.md)
  [`goalie_season_stats()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_season_statistics.md)
  : Access the statistics for all the goalies by season, game type, and
  team.
- [`goalie_game_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_game_statistics.md)
  [`goalie_game_stats()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_game_statistics.md)
  : Access the statistics for all the goalies by game
- [`goalie_series_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_series_statistics.md)
  [`goalie_series_stats()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_series_statistics.md)
  : Access the playoff statistics for all the goalies by series
- [`goalie_scoring()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_scoring.md)
  : Access the career scoring statistics for all the goalies
- [`goalie_game_scoring()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_game_scoring.md)
  : Access the scoring statistics for all the goalies by game
- [`goalie_leaders()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_leaders.md)
  : Access the goalie statistics leaders for a season, game type, and
  category
- [`goalie_milestones()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_milestones.md)
  : Access the goalies on milestone watch
- [`goalie_edge_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_edge_seasons.md)
  : Access the season(s) and game type(s) in which there exists goalie
  EDGE statistics
- [`goalie_edge_leaders()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_edge_leaders.md)
  : Access the goalie EDGE statistics leaders for a season and game type
- [`goalie_edge_summary()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_edge_summary.md)
  : Access the EDGE summary for a goalie, season, and game type
- [`goalie_edge_save_percentage()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_edge_save_percentage.md)
  : Access the EDGE save percentage statistics for a goalie, season,
  game type, and category
- [`goalie_edge_five_versus_five()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_edge_five_versus_five.md)
  [`goalie_edge_5_vs_5()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_edge_five_versus_five.md)
  : Access the EDGE 5 vs. 5 statistics for a goalie, season, game type,
  and category
- [`goalie_edge_shot_location()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_edge_shot_location.md)
  : Access the EDGE shot location statistics for a goalie, season, game
  type, and category

## Low-level

Functions that call the NHL APIs for low-level data

### Game

Functions to access data about the games

- [`games()`](https://rentosaijo.github.io/nhlscraper/reference/games.md)
  : Access all the games
- [`scores()`](https://rentosaijo.github.io/nhlscraper/reference/scores.md)
  : Access the scores for a date
- [`gc_summary()`](https://rentosaijo.github.io/nhlscraper/reference/gc_summary.md)
  : Access the GameCenter (GC) summary for a game
- [`wsc_summary()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_summary.md)
  : Access the World Showcase (WSC) summary for a game
- [`boxscore()`](https://rentosaijo.github.io/nhlscraper/reference/boxscore.md)
  : Access the boxscore for a game, team, and position
- [`game_rosters()`](https://rentosaijo.github.io/nhlscraper/reference/game_rosters.md)
  : Access the rosters for a game
- [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  [`gc_pbp()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  : Access the GameCenter (GC) play-by-play for a game
- [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
  [`wsc_pbp()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
  : Access the World Showcase (WSC) play-by-play for a game
- [`shifts()`](https://rentosaijo.github.io/nhlscraper/reference/shifts.md)
  : Access the shift charts for a game
- [`game_odds()`](https://rentosaijo.github.io/nhlscraper/reference/game_odds.md)
  : Access the real-time game odds for a country by partnered bookmaker

### Event

Functions to access data about the events (plays)

- [`replay()`](https://rentosaijo.github.io/nhlscraper/reference/replay.md)
  : Access the replay for an event
- [`penalty_shots()`](https://rentosaijo.github.io/nhlscraper/reference/penalty_shots.md)
  [`ps()`](https://rentosaijo.github.io/nhlscraper/reference/penalty_shots.md)
  : Access all the penalty shots

## Load

Functions that load pre-scraped data from GitHub

- [`gc_play_by_plays()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_plays.md)
  [`gc_pbps()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_plays.md)
  : Access the GameCenter (GC) play-by-plays for a season
- [`wsc_play_by_plays()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_plays.md)
  [`wsc_pbps()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_plays.md)
  : Access the World Showcase (WSC) play-by-plays for a season

## Clean

Functions that clean the acquired data

- [`strip_game_id()`](https://rentosaijo.github.io/nhlscraper/reference/strip_game_id.md)
  : Strip the game ID into the season ID, game type ID, and game number
  for all the events (plays) in a play-by-play
- [`strip_time_period()`](https://rentosaijo.github.io/nhlscraper/reference/strip_time_period.md)
  : Strip the timestamp and period number into the time elapsed in the
  period and game for all the events (plays) in a play-by-play
- [`strip_situation_code()`](https://rentosaijo.github.io/nhlscraper/reference/strip_situation_code.md)
  : Strip the situation code into goalie and skater counts, man
  differential, and strength state for all the events (plays) in a
  play-by-play by perspective
- [`flag_is_home()`](https://rentosaijo.github.io/nhlscraper/reference/flag_is_home.md)
  : Flag if the event belongs to the home team or not for all the events
  (plays) in a play-by-play
- [`flag_is_rebound()`](https://rentosaijo.github.io/nhlscraper/reference/flag_is_rebound.md)
  : Flag if the shot attempt is a rebound attempt or not for all the
  shots in a play-by-play
- [`flag_is_rush()`](https://rentosaijo.github.io/nhlscraper/reference/flag_is_rush.md)
  : Flag if the shot attempt is a rush attempt or not for all the shots
  in a play-by-play
- [`count_goals_shots()`](https://rentosaijo.github.io/nhlscraper/reference/count_goals_shots.md)
  : Count the as-of-event goal, shots on goal, Fenwick, and Corsi
  attempts and differentials for all the events (plays) in a
  play-by-play by perspective
- [`normalize_coordinates()`](https://rentosaijo.github.io/nhlscraper/reference/normalize_coordinates.md)
  : Normalize the x and y coordinates for all the events (plays) in a
  play-by-play
- [`calculate_distance()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_distance.md)
  : Calculate the Euclidean distance from the attacking net for all the
  events (plays) in a play-by-play
- [`calculate_angle()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_angle.md)
  : Calculate the Euclidean angle from the attacking net for all the
  events (plays) in a play-by-play

## Model

Functions that run built-in models

- [`calculate_expected_goals_v1()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_expected_goals_v1.md)
  [`calculate_xG_v1()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_expected_goals_v1.md)
  : Calculate version 1 of the expected goals for all the events (plays)
  in a play-by-play
- [`calculate_expected_goals_v2()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_expected_goals_v2.md)
  [`calculate_xG_v2()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_expected_goals_v2.md)
  : Calculate version 2 of the expected goals for all the events (plays)
  in a play-by-play
- [`calculate_expected_goals_v3()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_expected_goals_v3.md)
  [`calculate_xG_v3()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_expected_goals_v3.md)
  : Calculate version 3 of the expected goals for all the events (plays)
  in a play-by-play

## Plot

Functions that plot the acquired data (WIP)

- [`plot_game_xG()`](https://rentosaijo.github.io/nhlscraper/reference/plot_game_xG.md)
  : Plot all shot attempts in a game on a full rink
- [`plot_full_rink()`](https://rentosaijo.github.io/nhlscraper/reference/plot_full_rink.md)
  : Draw a full NHL rink using base graphics

## ESPN API

Functions that call the ESPN APIs

- [`espn_teams()`](https://rentosaijo.github.io/nhlscraper/reference/espn_teams.md)
  : Access all the ESPN teams
- [`espn_team_summary()`](https://rentosaijo.github.io/nhlscraper/reference/espn_team_summary.md)
  : Access the ESPN summary for a team
- [`espn_players()`](https://rentosaijo.github.io/nhlscraper/reference/espn_players.md)
  : Access all the ESPN players
- [`espn_player_summary()`](https://rentosaijo.github.io/nhlscraper/reference/espn_player_summary.md)
  : Access the ESPN summary for a player
- [`espn_games()`](https://rentosaijo.github.io/nhlscraper/reference/espn_games.md)
  : Access the ESPN games for a season
- [`espn_game_summary()`](https://rentosaijo.github.io/nhlscraper/reference/espn_game_summary.md)
  : Access the ESPN summary for a game
- [`espn_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/espn_play_by_play.md)
  [`espn_pbp()`](https://rentosaijo.github.io/nhlscraper/reference/espn_play_by_play.md)
  : Access the ESPN play-by-play for a game
- [`espn_game_odds()`](https://rentosaijo.github.io/nhlscraper/reference/espn_game_odds.md)
  : Access the ESPN odds for a game
- [`espn_transactions()`](https://rentosaijo.github.io/nhlscraper/reference/espn_transactions.md)
  : Access the ESPN transactions for a season
- [`espn_futures()`](https://rentosaijo.github.io/nhlscraper/reference/espn_futures.md)
  : Access the ESPN futures for a season
- [`espn_injuries()`](https://rentosaijo.github.io/nhlscraper/reference/espn_injuries.md)
  : Access the real-time ESPN injury reports

## Outdated

Functions that are outdated.

### Deprecated

Functions that are deprecated.

- [`get_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/get_seasons.md)
  : Access all the seasons
- [`get_standings_information()`](https://rentosaijo.github.io/nhlscraper/reference/get_standings_information.md)
  : Access the standings rules by season
- [`get_standings()`](https://rentosaijo.github.io/nhlscraper/reference/get_standings.md)
  : Access the standings for a date
- [`get_schedule()`](https://rentosaijo.github.io/nhlscraper/reference/get_schedule.md)
  : Access the schedule for a date
- [`get_venues()`](https://rentosaijo.github.io/nhlscraper/reference/get_venues.md)
  : Access all the venues
- [`get_attendance()`](https://rentosaijo.github.io/nhlscraper/reference/get_attendance.md)
  : Access the attendance by season and game type
- [`get_franchises()`](https://rentosaijo.github.io/nhlscraper/reference/get_franchises.md)
  : Access all the franchises
- [`get_franchise_team_totals()`](https://rentosaijo.github.io/nhlscraper/reference/get_franchise_team_totals.md)
  : Access the all-time statistics for all the franchises by team and
  game type
- [`get_franchise_season_by_season()`](https://rentosaijo.github.io/nhlscraper/reference/get_franchise_season_by_season.md)
  : Access the statistics for all the franchises by season and game type
- [`get_franchise_vs_franchise()`](https://rentosaijo.github.io/nhlscraper/reference/get_franchise_vs_franchise.md)
  : Access the all-time statistics versus other franchises for all the
  franchises by game type
- [`get_teams()`](https://rentosaijo.github.io/nhlscraper/reference/get_teams.md)
  : Access all the teams
- [`get_team_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/get_team_seasons.md)
  : Access the season(s) and game type(s) in which a team played
- [`get_team_roster()`](https://rentosaijo.github.io/nhlscraper/reference/get_team_roster.md)
  : Access the roster for a team, season, and player type
- [`get_team_roster_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/get_team_roster_statistics.md)
  : Access the roster statistics for a team, season, game type, and
  player type
- [`get_team_prospects()`](https://rentosaijo.github.io/nhlscraper/reference/get_team_prospects.md)
  : Access the prospects for a team and position
- [`get_team_schedule()`](https://rentosaijo.github.io/nhlscraper/reference/get_team_schedule.md)
  : Access the schedule for a team and season
- [`get_players()`](https://rentosaijo.github.io/nhlscraper/reference/get_players.md)
  : Access all the players
- [`get_player_landing()`](https://rentosaijo.github.io/nhlscraper/reference/get_player_landing.md)
  : Access the summary for a player
- [`get_player_game_log()`](https://rentosaijo.github.io/nhlscraper/reference/get_player_game_log.md)
  : Access the game log for a player, season, and game type
- [`get_spotlight_players()`](https://rentosaijo.github.io/nhlscraper/reference/get_spotlight_players.md)
  : Access the spotlight players
- [`get_skater_leaders()`](https://rentosaijo.github.io/nhlscraper/reference/get_skater_leaders.md)
  : Access the skater statistics leaders for a season, game type, and
  category
- [`get_skater_milestones()`](https://rentosaijo.github.io/nhlscraper/reference/get_skater_milestones.md)
  : Access the skaters on milestone watch
- [`get_goalie_leaders()`](https://rentosaijo.github.io/nhlscraper/reference/get_goalie_leaders.md)
  : Access the goalie statistics leaders for a season, game type, and
  category
- [`get_goalie_milestones()`](https://rentosaijo.github.io/nhlscraper/reference/get_goalie_milestones.md)
  : Access the goalies on milestone watch
- [`get_games()`](https://rentosaijo.github.io/nhlscraper/reference/get_games.md)
  : Access all the games
- [`get_scores()`](https://rentosaijo.github.io/nhlscraper/reference/get_scores.md)
  : Access the scores for a date
- [`get_scoreboards()`](https://rentosaijo.github.io/nhlscraper/reference/get_scoreboards.md)
  : Access the scoreboards for a date
- [`get_game_landing()`](https://rentosaijo.github.io/nhlscraper/reference/get_game_landing.md)
  : Access the GameCenter (GC) summary for a game
- [`get_game_story()`](https://rentosaijo.github.io/nhlscraper/reference/get_game_story.md)
  : Access the World Showcase (WSC) summary for a game
- [`get_game_boxscore()`](https://rentosaijo.github.io/nhlscraper/reference/get_game_boxscore.md)
  : Access the boxscore for a game, team, and player type
- [`get_gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/get_gc_play_by_play.md)
  : Access the GameCenter (GC) play-by-play for a game
- [`get_wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/get_wsc_play_by_play.md)
  : Access the World Showcase (WSC) play-by-play for a game
- [`get_shift_charts()`](https://rentosaijo.github.io/nhlscraper/reference/get_shift_charts.md)
  : Access the shift charts for a game
- [`get_bracket()`](https://rentosaijo.github.io/nhlscraper/reference/get_bracket.md)
  : Access the playoff bracket for a season
- [`get_series_schedule()`](https://rentosaijo.github.io/nhlscraper/reference/get_series_schedule.md)
  : Access the playoff schedule for a season and series
- [`get_awards()`](https://rentosaijo.github.io/nhlscraper/reference/get_awards.md)
  : Access all the awards
- [`get_award_winners()`](https://rentosaijo.github.io/nhlscraper/reference/get_award_winners.md)
  : Access all the award winners/finalists
- [`get_drafts()`](https://rentosaijo.github.io/nhlscraper/reference/get_drafts.md)
  : Access all the drafts
- [`get_draft_picks()`](https://rentosaijo.github.io/nhlscraper/reference/get_draft_picks.md)
  : Access all the draft picks
- [`get_draft_rankings()`](https://rentosaijo.github.io/nhlscraper/reference/get_draft_rankings.md)
  : Access the draft rankings for a year and player type
- [`get_draft_tracker()`](https://rentosaijo.github.io/nhlscraper/reference/get_draft_tracker.md)
  : Access the real-time draft tracker
- [`get_officials()`](https://rentosaijo.github.io/nhlscraper/reference/get_officials.md)
  : Access all the officials
- [`get_glossary()`](https://rentosaijo.github.io/nhlscraper/reference/get_glossary.md)
  : Access the glossary
- [`get_countries()`](https://rentosaijo.github.io/nhlscraper/reference/get_countries.md)
  : Access all the countries
- [`get_streams()`](https://rentosaijo.github.io/nhlscraper/reference/get_streams.md)
  : Access all the streams
- [`get_tv_schedule()`](https://rentosaijo.github.io/nhlscraper/reference/get_tv_schedule.md)
  : Access the NHL Network TV schedule for a date
- [`get_partner_odds()`](https://rentosaijo.github.io/nhlscraper/reference/get_partner_odds.md)
  : Access the real-time game odds for a country by partnered bookmaker
- [`get_espn_athletes()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_athletes.md)
  : Access all the ESPN athletes (players)
- [`get_espn_athlete()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_athlete.md)
  : Access the ESPN summary for an athlete (player) and season
- [`get_espn_event()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_event.md)
  : Access the ESPN summary for an event (game)
- [`get_espn_event_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_event_play_by_play.md)
  : Access the ESPN play-by-play for an event (game)
- [`get_espn_event_odds()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_event_odds.md)
  : Access the ESPN odds for an event (game)
- [`get_espn_injuries()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_injuries.md)
  : Access the real-time ESPN injury reports

### Defunct

Functions that are defunct

- [`get_season_now()`](https://rentosaijo.github.io/nhlscraper/reference/get_season_now.md)
  : Access the season and game type as of now
- [`get_team_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/get_team_statistics.md)
  : Access various reports for all the teams by season or game
- [`get_team_scoreboard()`](https://rentosaijo.github.io/nhlscraper/reference/get_team_scoreboard.md)
  : Access the team scoreboard as of now
- [`get_skaters()`](https://rentosaijo.github.io/nhlscraper/reference/get_skaters.md)
  : Access all the skaters for a range of seasons
- [`get_skater_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/get_skater_statistics.md)
  : Access various reports for all the skaters by season or game
- [`get_goalies()`](https://rentosaijo.github.io/nhlscraper/reference/get_goalies.md)
  : Access all the goalies for a range of seasons
- [`get_goalie_statistics()`](https://rentosaijo.github.io/nhlscraper/reference/get_goalie_statistics.md)
  : Access various reports for all the goalies by season or game
- [`get_series()`](https://rentosaijo.github.io/nhlscraper/reference/get_series.md)
  : Access the playoff series for a season and round
- [`ping()`](https://rentosaijo.github.io/nhlscraper/reference/ping.md)
  : Ping
- [`get_configuration()`](https://rentosaijo.github.io/nhlscraper/reference/get_configuration.md)
  : Access the configurations for team, skater, and goalie reports
- [`get_espn_teams()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_teams.md)
  : Access all the ESPN teams for a season
- [`get_espn_team()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_team.md)
  : Access the ESPN summary for a team and season
- [`get_espn_athlete()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_athlete.md)
  : Access the ESPN summary for an athlete (player) and season
- [`get_espn_events()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_events.md)
  : Access the ESPN events (games) by start and end dates
- [`get_espn_event_stars()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_event_stars.md)
  : Access the three stars for an ESPN event (game)
- [`get_espn_event_officials()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_event_officials.md)
  : Access the officials for an ESPN event (game)
- [`get_espn_coaches()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_coaches.md)
  : Access the ESPN coaches for a season
- [`get_espn_coach()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_coach.md)
  : Access the ESPN statistics for a coach and (multiple) season(s)
- [`get_espn_coach_career()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_coach_career.md)
  : Access the career ESPN statistics for a coach
- [`get_espn_transactions()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_transactions.md)
  : Access the ESPN transactions by start and end dates
- [`get_espn_futures()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_futures.md)
  : Access the ESPN futures for a season
