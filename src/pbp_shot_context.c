#include <R.h>
#include <Rinternals.h>
#include <limits.h>

static int xlength_as_int(SEXP x, const char *name) {
  R_xlen_t n = XLENGTH(x);
  if (n > INT_MAX) {
    error("%s is too long for native processing.", name);
  }
  return (int) n;
}

static void require_vector_type_and_length(
  SEXP x,
  SEXPTYPE type,
  int expected_len,
  const char *name
) {
  if ((SEXPTYPE) TYPEOF(x) != type) {
    error("%s must have the expected storage mode.", name);
  }
  if (xlength_as_int(x, name) != expected_len) {
    error("%s must have length %d.", name, expected_len);
  }
}

static void reset_team_tracker(int *team_ids, int *team_last_time, int *team_last_idx) {
  int i;
  for (i = 0; i < 2; ++i) {
    team_ids[i] = NA_INTEGER;
    team_last_time[i] = NA_INTEGER;
    team_last_idx[i] = NA_INTEGER;
  }
}

static int lookup_team_slot(int *team_ids, int team_id) {
  int i;
  if (team_id == NA_INTEGER) {
    return -1;
  }
  for (i = 0; i < 2; ++i) {
    if (team_ids[i] == team_id) {
      return i;
    }
  }
  for (i = 0; i < 2; ++i) {
    if (team_ids[i] == NA_INTEGER) {
      team_ids[i] = team_id;
      return i;
    }
  }
  return -1;
}

SEXP nhlscraper_pbp_shot_context(SEXP data_list) {
  SEXP order_time_sexp;
  SEXP order_sort_sexp;
  SEXP game_id_sexp;
  SEXP seconds_sexp;
  SEXP event_owner_team_id_sexp;
  SEXP is_home_sexp;
  SEXP is_attempt_sexp;
  SEXP is_source_sexp;
  SEXP is_goal_sexp;
  SEXP is_sog_sexp;
  SEXP is_fenwick_sexp;
  SEXP is_corsi_sexp;
  SEXP is_stop_sexp;
  SEXP is_nz_dz_sexp;
  SEXP is_ps_so_sexp;
  int *order_time;
  int *order_sort;
  int *game_id;
  int *seconds;
  int *event_owner_team_id;
  int *is_home;
  int *is_attempt;
  int *is_source;
  int *is_goal;
  int *is_sog;
  int *is_fenwick;
  int *is_corsi;
  int *is_stop;
  int *is_nz_dz;
  int *is_ps_so;
  int n_events;
  int i;
  int protect_n = 0;
  int last_game = NA_INTEGER;
  int last_nz_dz_time = NA_INTEGER;
  int team_ids[2];
  int team_last_time[2];
  int team_last_idx[2];
  int home_goals = 0;
  int away_goals = 0;
  int home_sog = 0;
  int away_sog = 0;
  int home_fenwick = 0;
  int away_fenwick = 0;
  int home_corsi = 0;
  int away_corsi = 0;
  SEXP is_rush;
  SEXP is_rebound;
  SEXP created_rebound;
  SEXP home_goals_out;
  SEXP away_goals_out;
  SEXP home_sog_out;
  SEXP away_sog_out;
  SEXP home_fenwick_out;
  SEXP away_fenwick_out;
  SEXP home_corsi_out;
  SEXP away_corsi_out;
  SEXP out;
  SEXP out_names;

  if (TYPEOF(data_list) != VECSXP || XLENGTH(data_list) < 15) {
    error("Expected a list of prepared play-by-play vectors.");
  }

  order_time_sexp = VECTOR_ELT(data_list, 0);
  order_sort_sexp = VECTOR_ELT(data_list, 1);
  game_id_sexp = VECTOR_ELT(data_list, 2);
  seconds_sexp = VECTOR_ELT(data_list, 3);
  event_owner_team_id_sexp = VECTOR_ELT(data_list, 4);
  is_home_sexp = VECTOR_ELT(data_list, 5);
  is_attempt_sexp = VECTOR_ELT(data_list, 6);
  is_source_sexp = VECTOR_ELT(data_list, 7);
  is_goal_sexp = VECTOR_ELT(data_list, 8);
  is_sog_sexp = VECTOR_ELT(data_list, 9);
  is_fenwick_sexp = VECTOR_ELT(data_list, 10);
  is_corsi_sexp = VECTOR_ELT(data_list, 11);
  is_stop_sexp = VECTOR_ELT(data_list, 12);
  is_nz_dz_sexp = VECTOR_ELT(data_list, 13);
  is_ps_so_sexp = VECTOR_ELT(data_list, 14);

  n_events = xlength_as_int(game_id_sexp, "game_id");
  require_vector_type_and_length(order_time_sexp, INTSXP, n_events, "order_time");
  require_vector_type_and_length(order_sort_sexp, INTSXP, n_events, "order_sort");
  require_vector_type_and_length(game_id_sexp, INTSXP, n_events, "game_id");
  require_vector_type_and_length(seconds_sexp, INTSXP, n_events, "seconds");
  require_vector_type_and_length(event_owner_team_id_sexp, INTSXP, n_events, "event_owner_team_id");
  require_vector_type_and_length(is_home_sexp, INTSXP, n_events, "is_home");
  require_vector_type_and_length(is_attempt_sexp, LGLSXP, n_events, "is_attempt");
  require_vector_type_and_length(is_source_sexp, LGLSXP, n_events, "is_source");
  require_vector_type_and_length(is_goal_sexp, LGLSXP, n_events, "is_goal");
  require_vector_type_and_length(is_sog_sexp, LGLSXP, n_events, "is_sog");
  require_vector_type_and_length(is_fenwick_sexp, LGLSXP, n_events, "is_fenwick");
  require_vector_type_and_length(is_corsi_sexp, LGLSXP, n_events, "is_corsi");
  require_vector_type_and_length(is_stop_sexp, LGLSXP, n_events, "is_stop");
  require_vector_type_and_length(is_nz_dz_sexp, LGLSXP, n_events, "is_nz_dz");
  require_vector_type_and_length(is_ps_so_sexp, LGLSXP, n_events, "is_ps_so");

  order_time = INTEGER(order_time_sexp);
  order_sort = INTEGER(order_sort_sexp);
  game_id = INTEGER(game_id_sexp);
  seconds = INTEGER(seconds_sexp);
  event_owner_team_id = INTEGER(event_owner_team_id_sexp);
  is_home = INTEGER(is_home_sexp);
  is_attempt = LOGICAL(is_attempt_sexp);
  is_source = LOGICAL(is_source_sexp);
  is_goal = LOGICAL(is_goal_sexp);
  is_sog = LOGICAL(is_sog_sexp);
  is_fenwick = LOGICAL(is_fenwick_sexp);
  is_corsi = LOGICAL(is_corsi_sexp);
  is_stop = LOGICAL(is_stop_sexp);
  is_nz_dz = LOGICAL(is_nz_dz_sexp);
  is_ps_so = LOGICAL(is_ps_so_sexp);

  is_rush = PROTECT(allocVector(LGLSXP, n_events)); protect_n++;
  is_rebound = PROTECT(allocVector(LGLSXP, n_events)); protect_n++;
  created_rebound = PROTECT(allocVector(LGLSXP, n_events)); protect_n++;
  home_goals_out = PROTECT(allocVector(INTSXP, n_events)); protect_n++;
  away_goals_out = PROTECT(allocVector(INTSXP, n_events)); protect_n++;
  home_sog_out = PROTECT(allocVector(INTSXP, n_events)); protect_n++;
  away_sog_out = PROTECT(allocVector(INTSXP, n_events)); protect_n++;
  home_fenwick_out = PROTECT(allocVector(INTSXP, n_events)); protect_n++;
  away_fenwick_out = PROTECT(allocVector(INTSXP, n_events)); protect_n++;
  home_corsi_out = PROTECT(allocVector(INTSXP, n_events)); protect_n++;
  away_corsi_out = PROTECT(allocVector(INTSXP, n_events)); protect_n++;

  for (i = 0; i < n_events; ++i) {
    if (order_time[i] == NA_INTEGER || order_time[i] < 1 || order_time[i] > n_events) {
      error("order_time contains an out-of-range value at position %d.", i + 1);
    }
    if (order_sort[i] == NA_INTEGER || order_sort[i] < 1 || order_sort[i] > n_events) {
      error("order_sort contains an out-of-range value at position %d.", i + 1);
    }
    LOGICAL(is_rush)[i] = is_attempt[i] == 1 ? 0 : NA_LOGICAL;
    LOGICAL(is_rebound)[i] = is_attempt[i] == 1 ? 0 : NA_LOGICAL;
    LOGICAL(created_rebound)[i] = is_attempt[i] == 1 ? 0 : NA_LOGICAL;
    INTEGER(home_goals_out)[i] = 0;
    INTEGER(away_goals_out)[i] = 0;
    INTEGER(home_sog_out)[i] = 0;
    INTEGER(away_sog_out)[i] = 0;
    INTEGER(home_fenwick_out)[i] = 0;
    INTEGER(away_fenwick_out)[i] = 0;
    INTEGER(home_corsi_out)[i] = 0;
    INTEGER(away_corsi_out)[i] = 0;
  }

  reset_team_tracker(team_ids, team_last_time, team_last_idx);

  for (i = 0; i < n_events; ++i) {
    int idx = order_time[i] - 1;
    int game;
    int time_sec;
    int team_slot;
    int delta;

    if (idx < 0 || idx >= n_events) {
      continue;
    }

    game = game_id[idx];
    if (game != last_game) {
      last_game = game;
      last_nz_dz_time = NA_INTEGER;
      reset_team_tracker(team_ids, team_last_time, team_last_idx);
    }

    if (is_stop[idx] == 1) {
      last_nz_dz_time = NA_INTEGER;
      reset_team_tracker(team_ids, team_last_time, team_last_idx);
      continue;
    }

    time_sec = seconds[idx];
    if (time_sec == NA_INTEGER) {
      continue;
    }

    if (is_attempt[idx] == 1 && last_nz_dz_time != NA_INTEGER) {
      delta = time_sec - last_nz_dz_time;
      if (delta >= 0 && delta <= 4) {
        LOGICAL(is_rush)[idx] = 1;
      }
    }

    team_slot = lookup_team_slot(team_ids, event_owner_team_id[idx]);
    if (is_attempt[idx] == 1 && team_slot >= 0 && team_last_time[team_slot] != NA_INTEGER) {
      delta = time_sec - team_last_time[team_slot];
      if (delta >= 0 && delta <= 3) {
        LOGICAL(is_rebound)[idx] = 1;
        if (team_last_idx[team_slot] >= 0 && team_last_idx[team_slot] < n_events) {
          LOGICAL(created_rebound)[team_last_idx[team_slot]] = 1;
        }
      }
    }

    if (is_nz_dz[idx] == 1) {
      last_nz_dz_time = time_sec;
    }

    if (is_source[idx] == 1 && team_slot >= 0) {
      team_last_time[team_slot] = time_sec;
      team_last_idx[team_slot] = idx;
    }
  }

  for (i = 0; i < n_events; ++i) {
    if (is_attempt[i] == 1 && is_ps_so[i] == 1) {
      LOGICAL(is_rush)[i] = 0;
      LOGICAL(is_rebound)[i] = 0;
      LOGICAL(created_rebound)[i] = 0;
    }
  }

  last_game = NA_INTEGER;
  for (i = 0; i < n_events; ++i) {
    int idx = order_sort[i] - 1;

    if (idx < 0 || idx >= n_events) {
      continue;
    }

    if (game_id[idx] != last_game) {
      last_game = game_id[idx];
      home_goals = 0;
      away_goals = 0;
      home_sog = 0;
      away_sog = 0;
      home_fenwick = 0;
      away_fenwick = 0;
      home_corsi = 0;
      away_corsi = 0;
    }

    INTEGER(home_goals_out)[idx] = home_goals;
    INTEGER(away_goals_out)[idx] = away_goals;
    INTEGER(home_sog_out)[idx] = home_sog;
    INTEGER(away_sog_out)[idx] = away_sog;
    INTEGER(home_fenwick_out)[idx] = home_fenwick;
    INTEGER(away_fenwick_out)[idx] = away_fenwick;
    INTEGER(home_corsi_out)[idx] = home_corsi;
    INTEGER(away_corsi_out)[idx] = away_corsi;

    if (is_home[idx] == 1) {
      if (is_goal[idx] == 1) {
        ++home_goals;
      }
      if (is_sog[idx] == 1) {
        ++home_sog;
      }
      if (is_fenwick[idx] == 1) {
        ++home_fenwick;
      }
      if (is_corsi[idx] == 1) {
        ++home_corsi;
      }
    } else if (is_home[idx] == 0) {
      if (is_goal[idx] == 1) {
        ++away_goals;
      }
      if (is_sog[idx] == 1) {
        ++away_sog;
      }
      if (is_fenwick[idx] == 1) {
        ++away_fenwick;
      }
      if (is_corsi[idx] == 1) {
        ++away_corsi;
      }
    }
  }

  out = PROTECT(allocVector(VECSXP, 11)); protect_n++;
  out_names = PROTECT(allocVector(STRSXP, 11)); protect_n++;

  SET_VECTOR_ELT(out, 0, is_rush);
  SET_VECTOR_ELT(out, 1, is_rebound);
  SET_VECTOR_ELT(out, 2, created_rebound);
  SET_VECTOR_ELT(out, 3, home_goals_out);
  SET_VECTOR_ELT(out, 4, away_goals_out);
  SET_VECTOR_ELT(out, 5, home_sog_out);
  SET_VECTOR_ELT(out, 6, away_sog_out);
  SET_VECTOR_ELT(out, 7, home_fenwick_out);
  SET_VECTOR_ELT(out, 8, away_fenwick_out);
  SET_VECTOR_ELT(out, 9, home_corsi_out);
  SET_VECTOR_ELT(out, 10, away_corsi_out);

  SET_STRING_ELT(out_names, 0, mkChar("isRush"));
  SET_STRING_ELT(out_names, 1, mkChar("isRebound"));
  SET_STRING_ELT(out_names, 2, mkChar("createdRebound"));
  SET_STRING_ELT(out_names, 3, mkChar("homeGoals"));
  SET_STRING_ELT(out_names, 4, mkChar("awayGoals"));
  SET_STRING_ELT(out_names, 5, mkChar("homeSOG"));
  SET_STRING_ELT(out_names, 6, mkChar("awaySOG"));
  SET_STRING_ELT(out_names, 7, mkChar("homeFenwick"));
  SET_STRING_ELT(out_names, 8, mkChar("awayFenwick"));
  SET_STRING_ELT(out_names, 9, mkChar("homeCorsi"));
  SET_STRING_ELT(out_names, 10, mkChar("awayCorsi"));
  setAttrib(out, R_NamesSymbol, out_names);

  UNPROTECT(protect_n);
  return out;
}
