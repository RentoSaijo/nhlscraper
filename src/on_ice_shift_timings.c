#include <R.h>
#include <Rinternals.h>

typedef struct {
  int game_id;
  int period;
  int player_id;
  int start_idx;
  int end_idx;
} PlayerRange;

static int is_na_int(int x) {
  return x == NA_INTEGER;
}

static int lookup_range(
  const PlayerRange *ranges,
  int n_ranges,
  int game_id,
  int period,
  int player_id
) {
  int left = 0;
  int right = n_ranges - 1;
  while (left <= right) {
    int mid = left + (right - left) / 2;
    const PlayerRange *range = &ranges[mid];
    if (
      range->game_id == game_id &&
      range->period == period &&
      range->player_id == player_id
    ) {
      return mid;
    }
    if (
      range->game_id < game_id ||
      (range->game_id == game_id && range->period < period) ||
      (range->game_id == game_id &&
        range->period == period &&
        range->player_id < player_id)
    ) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }
  return -1;
}

static void fill_slot_matrix(
  SEXP out_elapsed,
  SEXP out_since,
  int slot_col,
  int n_events,
  const int *event_game,
  const int *event_period,
  const int *event_seconds,
  const int *request_mat,
  const int *shift_start,
  const int *shift_end,
  const int *shift_prev_end,
  const PlayerRange *ranges,
  int n_ranges
) {
  double *elapsed_ptr = REAL(out_elapsed);
  double *since_ptr = REAL(out_since);
  int i;
  for (i = 0; i < n_events; ++i) {
    int player_id = request_mat[i + n_events * slot_col];
    int range_idx;
    int k;
    elapsed_ptr[i + n_events * slot_col] = NA_REAL;
    since_ptr[i + n_events * slot_col] = NA_REAL;
    if (
      is_na_int(player_id) ||
      is_na_int(event_game[i]) ||
      is_na_int(event_period[i]) ||
      is_na_int(event_seconds[i])
    ) {
      continue;
    }
    range_idx = lookup_range(
      ranges,
      n_ranges,
      event_game[i],
      event_period[i],
      player_id
    );
    if (range_idx < 0) {
      continue;
    }
    for (k = ranges[range_idx].start_idx; k <= ranges[range_idx].end_idx; ++k) {
      if (
        shift_start[k] <= event_seconds[i] &&
        event_seconds[i] <= shift_end[k]
      ) {
        elapsed_ptr[i + n_events * slot_col] =
          (double) (event_seconds[i] - shift_start[k]);
        since_ptr[i + n_events * slot_col] = is_na_int(shift_prev_end[k]) ?
          (double) (300 + event_seconds[i]) :
          (double) (event_seconds[i] - shift_prev_end[k]);
        break;
      }
      if (shift_start[k] > event_seconds[i]) {
        break;
      }
    }
  }
}

SEXP nhlscraper_on_ice_shift_timings(SEXP data_list) {
  SEXP event_game_sexp = VECTOR_ELT(data_list, 0);
  SEXP event_period_sexp = VECTOR_ELT(data_list, 1);
  SEXP event_seconds_sexp = VECTOR_ELT(data_list, 2);
  SEXP home_request_sexp = VECTOR_ELT(data_list, 3);
  SEXP away_request_sexp = VECTOR_ELT(data_list, 4);
  SEXP shift_game_sexp = VECTOR_ELT(data_list, 5);
  SEXP shift_period_sexp = VECTOR_ELT(data_list, 6);
  SEXP shift_player_sexp = VECTOR_ELT(data_list, 7);
  SEXP shift_start_sexp = VECTOR_ELT(data_list, 8);
  SEXP shift_end_sexp = VECTOR_ELT(data_list, 9);

  const int *event_game = INTEGER(event_game_sexp);
  const int *event_period = INTEGER(event_period_sexp);
  const int *event_seconds = INTEGER(event_seconds_sexp);
  const int *home_request = INTEGER(home_request_sexp);
  const int *away_request = INTEGER(away_request_sexp);
  const int *shift_game = INTEGER(shift_game_sexp);
  const int *shift_period = INTEGER(shift_period_sexp);
  const int *shift_player = INTEGER(shift_player_sexp);
  const int *shift_start = INTEGER(shift_start_sexp);
  const int *shift_end = INTEGER(shift_end_sexp);

  int n_events = LENGTH(event_game_sexp);
  int n_shifts = LENGTH(shift_game_sexp);
  SEXP home_dim = getAttrib(home_request_sexp, R_DimSymbol);
  int n_rows = INTEGER(home_dim)[0];
  int n_slots = INTEGER(home_dim)[1];
  int *shift_prev_end;
  PlayerRange *ranges;
  int n_ranges = 0;
  int i;

  SEXP out = PROTECT(allocVector(VECSXP, 4));
  SEXP out_names = PROTECT(allocVector(STRSXP, 4));
  SEXP home_elapsed = PROTECT(allocMatrix(REALSXP, n_events, n_slots));
  SEXP away_elapsed = PROTECT(allocMatrix(REALSXP, n_events, n_slots));
  SEXP home_since = PROTECT(allocMatrix(REALSXP, n_events, n_slots));
  SEXP away_since = PROTECT(allocMatrix(REALSXP, n_events, n_slots));

  if (
    n_rows != n_events ||
    INTEGER(getAttrib(away_request_sexp, R_DimSymbol))[0] != n_events ||
    INTEGER(getAttrib(away_request_sexp, R_DimSymbol))[1] != n_slots
  ) {
    UNPROTECT(6);
    error("Requested player matrices have incompatible dimensions.");
  }

  shift_prev_end = (int *) R_alloc((size_t) n_shifts, sizeof(int));
  ranges = (PlayerRange *) R_alloc((size_t) (n_shifts > 0 ? n_shifts : 1), sizeof(PlayerRange));

  for (i = 0; i < n_shifts; ++i) {
    if (
      i > 0 &&
      shift_game[i] == shift_game[i - 1] &&
      shift_period[i] == shift_period[i - 1] &&
      shift_player[i] == shift_player[i - 1]
    ) {
      shift_prev_end[i] = shift_end[i - 1];
    } else {
      shift_prev_end[i] = NA_INTEGER;
    }
    if (
      i == 0 ||
      shift_game[i] != shift_game[i - 1] ||
      shift_period[i] != shift_period[i - 1] ||
      shift_player[i] != shift_player[i - 1]
    ) {
      ranges[n_ranges].game_id = shift_game[i];
      ranges[n_ranges].period = shift_period[i];
      ranges[n_ranges].player_id = shift_player[i];
      ranges[n_ranges].start_idx = i;
      ranges[n_ranges].end_idx = i;
      ++n_ranges;
    } else {
      ranges[n_ranges - 1].end_idx = i;
    }
  }

  for (i = 0; i < n_slots; ++i) {
    fill_slot_matrix(
      home_elapsed,
      home_since,
      i,
      n_events,
      event_game,
      event_period,
      event_seconds,
      home_request,
      shift_start,
      shift_end,
      shift_prev_end,
      ranges,
      n_ranges
    );
    fill_slot_matrix(
      away_elapsed,
      away_since,
      i,
      n_events,
      event_game,
      event_period,
      event_seconds,
      away_request,
      shift_start,
      shift_end,
      shift_prev_end,
      ranges,
      n_ranges
    );
  }

  SET_VECTOR_ELT(out, 0, home_elapsed);
  SET_VECTOR_ELT(out, 1, away_elapsed);
  SET_VECTOR_ELT(out, 2, home_since);
  SET_VECTOR_ELT(out, 3, away_since);
  SET_STRING_ELT(out_names, 0, mkChar("homeElapsed"));
  SET_STRING_ELT(out_names, 1, mkChar("awayElapsed"));
  SET_STRING_ELT(out_names, 2, mkChar("homeSinceLast"));
  SET_STRING_ELT(out_names, 3, mkChar("awaySinceLast"));
  setAttrib(out, R_NamesSymbol, out_names);

  UNPROTECT(6);
  return out;
}
