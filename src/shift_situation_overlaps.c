/* Headers ------------------------------------------------------------- */

#include <R.h>
#include <Rinternals.h>
#include <limits.h>
#include <stdlib.h>
#include <string.h>

/* Validation Helpers -------------------------------------------------- */

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

static int is_na_int(int x) {
  return x == NA_INTEGER;
}

/* Interval Helpers ---------------------------------------------------- */

static int key_less(int game_a, int period_a, int game_b, int period_b) {
  return game_a < game_b || (game_a == game_b && period_a < period_b);
}

static int key_equal(int game_a, int period_a, int game_b, int period_b) {
  return game_a == game_b && period_a == period_b;
}

static int perspective_situation_code(int situation_code, int player_is_home) {
  if (is_na_int(situation_code)) {
    return NA_INTEGER;
  }
  if (!player_is_home) {
    return situation_code;
  }
  {
    int away_goalie = situation_code / 1000;
    int away_skaters = (situation_code / 100) % 10;
    int home_skaters = (situation_code / 10) % 10;
    int home_goalie = situation_code % 10;
    return home_goalie * 1000 + home_skaters * 100 +
      away_skaters * 10 + away_goalie;
  }
}

/* Shift-Situation Overlap Interface ---------------------------------- */

SEXP nhlscraper_shift_situation_overlaps(SEXP data_list) {
  SEXP shift_game_sexp;
  SEXP shift_team_sexp;
  SEXP shift_period_sexp;
  SEXP shift_start_sexp;
  SEXP shift_end_sexp;
  SEXP interval_game_sexp;
  SEXP interval_period_sexp;
  SEXP interval_home_sexp;
  SEXP interval_away_sexp;
  SEXP interval_start_sexp;
  SEXP interval_end_sexp;
  SEXP interval_situation_sexp;

  const int *shift_game;
  const int *shift_team;
  const int *shift_period;
  const int *shift_start;
  const int *shift_end;
  const int *interval_game;
  const int *interval_period;
  const int *interval_home;
  const int *interval_away;
  const int *interval_start;
  const int *interval_end;
  const int *interval_situation;

  int n_shifts;
  int n_intervals;
  int i;
  int interval_pos = 0;
  int *out_shift_idx;
  int *out_situation;
  int *out_seconds;
  int n_out = 0;
  int capacity;

  SEXP out;
  SEXP out_names;
  SEXP shift_idx_out;
  SEXP situation_out;
  SEXP seconds_out;

  if (TYPEOF(data_list) != VECSXP || XLENGTH(data_list) < 12) {
    error("Expected a list of prepared shift-situation vectors.");
  }

  shift_game_sexp = VECTOR_ELT(data_list, 0);
  shift_team_sexp = VECTOR_ELT(data_list, 1);
  shift_period_sexp = VECTOR_ELT(data_list, 2);
  shift_start_sexp = VECTOR_ELT(data_list, 3);
  shift_end_sexp = VECTOR_ELT(data_list, 4);
  interval_game_sexp = VECTOR_ELT(data_list, 5);
  interval_period_sexp = VECTOR_ELT(data_list, 6);
  interval_home_sexp = VECTOR_ELT(data_list, 7);
  interval_away_sexp = VECTOR_ELT(data_list, 8);
  interval_start_sexp = VECTOR_ELT(data_list, 9);
  interval_end_sexp = VECTOR_ELT(data_list, 10);
  interval_situation_sexp = VECTOR_ELT(data_list, 11);

  n_shifts = xlength_as_int(shift_game_sexp, "shift_game");
  n_intervals = xlength_as_int(interval_game_sexp, "interval_game");

  require_vector_type_and_length(shift_game_sexp, INTSXP, n_shifts, "shift_game");
  require_vector_type_and_length(shift_team_sexp, INTSXP, n_shifts, "shift_team");
  require_vector_type_and_length(shift_period_sexp, INTSXP, n_shifts, "shift_period");
  require_vector_type_and_length(shift_start_sexp, INTSXP, n_shifts, "shift_start");
  require_vector_type_and_length(shift_end_sexp, INTSXP, n_shifts, "shift_end");
  require_vector_type_and_length(interval_game_sexp, INTSXP, n_intervals, "interval_game");
  require_vector_type_and_length(interval_period_sexp, INTSXP, n_intervals, "interval_period");
  require_vector_type_and_length(interval_home_sexp, INTSXP, n_intervals, "interval_home");
  require_vector_type_and_length(interval_away_sexp, INTSXP, n_intervals, "interval_away");
  require_vector_type_and_length(interval_start_sexp, INTSXP, n_intervals, "interval_start");
  require_vector_type_and_length(interval_end_sexp, INTSXP, n_intervals, "interval_end");
  require_vector_type_and_length(
    interval_situation_sexp,
    INTSXP,
    n_intervals,
    "interval_situation"
  );

  shift_game = INTEGER(shift_game_sexp);
  shift_team = INTEGER(shift_team_sexp);
  shift_period = INTEGER(shift_period_sexp);
  shift_start = INTEGER(shift_start_sexp);
  shift_end = INTEGER(shift_end_sexp);
  interval_game = INTEGER(interval_game_sexp);
  interval_period = INTEGER(interval_period_sexp);
  interval_home = INTEGER(interval_home_sexp);
  interval_away = INTEGER(interval_away_sexp);
  interval_start = INTEGER(interval_start_sexp);
  interval_end = INTEGER(interval_end_sexp);
  interval_situation = INTEGER(interval_situation_sexp);

  capacity = n_shifts > 0 ? n_shifts * 2 : 1;
  if (capacity < 1 || capacity < n_shifts) {
    capacity = n_shifts;
  }
  out_shift_idx = (int *) malloc((size_t) capacity * sizeof(int));
  out_situation = (int *) malloc((size_t) capacity * sizeof(int));
  out_seconds = (int *) malloc((size_t) capacity * sizeof(int));
  if (out_shift_idx == NULL || out_situation == NULL || out_seconds == NULL) {
    free(out_shift_idx);
    free(out_situation);
    free(out_seconds);
    error("Unable to allocate shift-situation overlap buffers.");
  }

  for (i = 0; i < n_shifts; ++i) {
    int j;
    int game = shift_game[i];
    int period = shift_period[i];
    int team = shift_team[i];
    int start = shift_start[i];
    int end = shift_end[i];
    if (
      is_na_int(game) ||
      is_na_int(period) ||
      is_na_int(team) ||
      is_na_int(start) ||
      is_na_int(end) ||
      end <= start
    ) {
      continue;
    }
    while (
      interval_pos < n_intervals &&
      key_less(interval_game[interval_pos], interval_period[interval_pos], game, period)
    ) {
      ++interval_pos;
    }
    j = interval_pos;
    while (
      j < n_intervals &&
      key_equal(interval_game[j], interval_period[j], game, period) &&
      interval_end[j] <= start
    ) {
      ++j;
    }
    while (
      j < n_intervals &&
      key_equal(interval_game[j], interval_period[j], game, period) &&
      interval_start[j] < end
    ) {
      int player_is_home;
      int overlap_start;
      int overlap_end;
      int overlap;
      int code;
      if (team == interval_home[j]) {
        player_is_home = 1;
      } else if (team == interval_away[j]) {
        player_is_home = 0;
      } else {
        ++j;
        continue;
      }
      overlap_start = start > interval_start[j] ? start : interval_start[j];
      overlap_end = end < interval_end[j] ? end : interval_end[j];
      overlap = overlap_end - overlap_start;
      if (overlap <= 0) {
        ++j;
        continue;
      }
      code = perspective_situation_code(interval_situation[j], player_is_home);
      if (is_na_int(code)) {
        ++j;
        continue;
      }
      if (n_out >= capacity) {
        if (capacity > INT_MAX / 2) {
          free(out_shift_idx);
          free(out_situation);
          free(out_seconds);
          error("Too many shift-situation overlaps.");
        }
        capacity *= 2;
        if (capacity <= n_out) {
          free(out_shift_idx);
          free(out_situation);
          free(out_seconds);
          error("Too many shift-situation overlaps.");
        }
        {
          int *new_shift_idx = (int *) malloc((size_t) capacity * sizeof(int));
          int *new_situation = (int *) malloc((size_t) capacity * sizeof(int));
          int *new_seconds = (int *) malloc((size_t) capacity * sizeof(int));
          if (new_shift_idx == NULL || new_situation == NULL || new_seconds == NULL) {
            free(new_shift_idx);
            free(new_situation);
            free(new_seconds);
            free(out_shift_idx);
            free(out_situation);
            free(out_seconds);
            error("Unable to grow shift-situation overlap buffers.");
          }
          memcpy(new_shift_idx, out_shift_idx, (size_t) n_out * sizeof(int));
          memcpy(new_situation, out_situation, (size_t) n_out * sizeof(int));
          memcpy(new_seconds, out_seconds, (size_t) n_out * sizeof(int));
          free(out_shift_idx);
          free(out_situation);
          free(out_seconds);
          out_shift_idx = new_shift_idx;
          out_situation = new_situation;
          out_seconds = new_seconds;
        }
      }
      out_shift_idx[n_out] = i + 1;
      out_situation[n_out] = code;
      out_seconds[n_out] = overlap;
      ++n_out;
      ++j;
    }
  }

  out = PROTECT(allocVector(VECSXP, 3));
  out_names = PROTECT(allocVector(STRSXP, 3));
  shift_idx_out = PROTECT(allocVector(INTSXP, n_out));
  situation_out = PROTECT(allocVector(INTSXP, n_out));
  seconds_out = PROTECT(allocVector(INTSXP, n_out));

  for (i = 0; i < n_out; ++i) {
    INTEGER(shift_idx_out)[i] = out_shift_idx[i];
    INTEGER(situation_out)[i] = out_situation[i];
    INTEGER(seconds_out)[i] = out_seconds[i];
  }

  SET_VECTOR_ELT(out, 0, shift_idx_out);
  SET_VECTOR_ELT(out, 1, situation_out);
  SET_VECTOR_ELT(out, 2, seconds_out);
  SET_STRING_ELT(out_names, 0, mkChar("shiftIndex"));
  SET_STRING_ELT(out_names, 1, mkChar("situationCode"));
  SET_STRING_ELT(out_names, 2, mkChar("seconds"));
  setAttrib(out, R_NamesSymbol, out_names);

  free(out_shift_idx);
  free(out_situation);
  free(out_seconds);
  UNPROTECT(5);
  return out;
}
