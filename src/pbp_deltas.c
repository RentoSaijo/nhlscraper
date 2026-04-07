#include <R.h>
#include <Rinternals.h>
#include <limits.h>

static int is_na_or_nan(double x) {
  return ISNA(x) || ISNAN(x);
}

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

static double diff_or_na(double current, double previous) {
  if (is_na_or_nan(current) || is_na_or_nan(previous)) {
    return NA_REAL;
  }
  return current - previous;
}

SEXP nhlscraper_pbp_deltas(SEXP data_list) {
  SEXP order_idx_sexp;
  SEXP game_id_sexp;
  SEXP event_id_sexp;
  SEXP seconds_sexp;
  SEXP x_coord_sexp;
  SEXP y_coord_sexp;
  SEXP x_coord_norm_sexp;
  SEXP y_coord_norm_sexp;
  SEXP distance_sexp;
  SEXP angle_sexp;
  SEXP is_faceoff_sexp;
  SEXP is_ps_so_sexp;

  int n;
  int *order_idx;
  int *game_id;
  int *event_id;
  double *seconds;
  double *x_coord;
  double *y_coord;
  double *x_coord_norm;
  double *y_coord_norm;
  double *distance;
  double *angle;
  int *is_faceoff;
  int *is_ps_so;

  int *prev_idx;
  int *seq_id;
  int *same_second_count;
  int i;
  int protect_n = 0;

  SEXP out;
  SEXP out_names;
  SEXP event_id_prev;
  SEXP seconds_elapsed_in_sequence;
  SEXP d_seconds_elapsed_in_sequence;
  SEXP d_x_coord;
  SEXP d_y_coord;
  SEXP d_x_coord_norm;
  SEXP d_y_coord_norm;
  SEXP d_distance;
  SEXP d_angle;
  SEXP d_x_coord_per_second;
  SEXP d_y_coord_per_second;
  SEXP d_x_coord_norm_per_second;
  SEXP d_y_coord_norm_per_second;
  SEXP d_distance_per_second;
  SEXP d_angle_per_second;

  if (TYPEOF(data_list) != VECSXP || XLENGTH(data_list) < 12) {
    error("Expected a list of prepared play-by-play vectors.");
  }

  order_idx_sexp = VECTOR_ELT(data_list, 0);
  game_id_sexp = VECTOR_ELT(data_list, 1);
  event_id_sexp = VECTOR_ELT(data_list, 2);
  seconds_sexp = VECTOR_ELT(data_list, 3);
  x_coord_sexp = VECTOR_ELT(data_list, 4);
  y_coord_sexp = VECTOR_ELT(data_list, 5);
  x_coord_norm_sexp = VECTOR_ELT(data_list, 6);
  y_coord_norm_sexp = VECTOR_ELT(data_list, 7);
  distance_sexp = VECTOR_ELT(data_list, 8);
  angle_sexp = VECTOR_ELT(data_list, 9);
  is_faceoff_sexp = VECTOR_ELT(data_list, 10);
  is_ps_so_sexp = VECTOR_ELT(data_list, 11);

  n = xlength_as_int(game_id_sexp, "game_id");
  require_vector_type_and_length(order_idx_sexp, INTSXP, n, "order_idx");
  require_vector_type_and_length(game_id_sexp, INTSXP, n, "game_id");
  require_vector_type_and_length(event_id_sexp, INTSXP, n, "event_id");
  require_vector_type_and_length(seconds_sexp, REALSXP, n, "seconds");
  require_vector_type_and_length(x_coord_sexp, REALSXP, n, "x_coord");
  require_vector_type_and_length(y_coord_sexp, REALSXP, n, "y_coord");
  require_vector_type_and_length(x_coord_norm_sexp, REALSXP, n, "x_coord_norm");
  require_vector_type_and_length(y_coord_norm_sexp, REALSXP, n, "y_coord_norm");
  require_vector_type_and_length(distance_sexp, REALSXP, n, "distance");
  require_vector_type_and_length(angle_sexp, REALSXP, n, "angle");
  require_vector_type_and_length(is_faceoff_sexp, LGLSXP, n, "is_faceoff");
  require_vector_type_and_length(is_ps_so_sexp, LGLSXP, n, "is_ps_so");

  order_idx = INTEGER(order_idx_sexp);
  game_id = INTEGER(game_id_sexp);
  event_id = INTEGER(event_id_sexp);
  seconds = REAL(seconds_sexp);
  x_coord = REAL(x_coord_sexp);
  y_coord = REAL(y_coord_sexp);
  x_coord_norm = REAL(x_coord_norm_sexp);
  y_coord_norm = REAL(y_coord_norm_sexp);
  distance = REAL(distance_sexp);
  angle = REAL(angle_sexp);
  is_faceoff = LOGICAL(is_faceoff_sexp);
  is_ps_so = LOGICAL(is_ps_so_sexp);
  prev_idx = (int *) R_alloc((size_t) (n > 0 ? n : 1), sizeof(int));
  seq_id = (int *) R_alloc((size_t) (n > 0 ? n : 1), sizeof(int));
  same_second_count = (int *) R_alloc((size_t) (n > 0 ? n : 1), sizeof(int));

  event_id_prev = PROTECT(allocVector(INTSXP, n)); protect_n++;
  seconds_elapsed_in_sequence = PROTECT(allocVector(REALSXP, n)); protect_n++;
  d_seconds_elapsed_in_sequence = PROTECT(allocVector(REALSXP, n)); protect_n++;
  d_x_coord = PROTECT(allocVector(REALSXP, n)); protect_n++;
  d_y_coord = PROTECT(allocVector(REALSXP, n)); protect_n++;
  d_x_coord_norm = PROTECT(allocVector(REALSXP, n)); protect_n++;
  d_y_coord_norm = PROTECT(allocVector(REALSXP, n)); protect_n++;
  d_distance = PROTECT(allocVector(REALSXP, n)); protect_n++;
  d_angle = PROTECT(allocVector(REALSXP, n)); protect_n++;
  d_x_coord_per_second = PROTECT(allocVector(REALSXP, n)); protect_n++;
  d_y_coord_per_second = PROTECT(allocVector(REALSXP, n)); protect_n++;
  d_x_coord_norm_per_second = PROTECT(allocVector(REALSXP, n)); protect_n++;
  d_y_coord_norm_per_second = PROTECT(allocVector(REALSXP, n)); protect_n++;
  d_distance_per_second = PROTECT(allocVector(REALSXP, n)); protect_n++;
  d_angle_per_second = PROTECT(allocVector(REALSXP, n)); protect_n++;

  for (i = 0; i < n; ++i) {
    INTEGER(event_id_prev)[i] = NA_INTEGER;
    REAL(seconds_elapsed_in_sequence)[i] = NA_REAL;
    REAL(d_seconds_elapsed_in_sequence)[i] = NA_REAL;
    REAL(d_x_coord)[i] = NA_REAL;
    REAL(d_y_coord)[i] = NA_REAL;
    REAL(d_x_coord_norm)[i] = NA_REAL;
    REAL(d_y_coord_norm)[i] = NA_REAL;
    REAL(d_distance)[i] = NA_REAL;
    REAL(d_angle)[i] = NA_REAL;
    REAL(d_x_coord_per_second)[i] = NA_REAL;
    REAL(d_y_coord_per_second)[i] = NA_REAL;
    REAL(d_x_coord_norm_per_second)[i] = NA_REAL;
    REAL(d_y_coord_norm_per_second)[i] = NA_REAL;
    REAL(d_distance_per_second)[i] = NA_REAL;
    REAL(d_angle_per_second)[i] = NA_REAL;
    prev_idx[i] = -1;
    seq_id[i] = NA_INTEGER;
    same_second_count[i] = 0;
    if (order_idx[i] == NA_INTEGER || order_idx[i] < 1 || order_idx[i] > n) {
      error("order_idx contains an out-of-range value at position %d.", i + 1);
    }
  }

  i = 0;
  while (i < n) {
    int game = game_id[order_idx[i] - 1];
    int start = i;
    int current_seq = 0;
    int last_valid_since_faceoff = -1;
    double seq_start_time = NA_REAL;

    while (i < n && game_id[order_idx[i] - 1] == game) {
      int idx = order_idx[i] - 1;
      int valid_spatial =
        !is_na_or_nan(x_coord_norm[idx]) &&
        !is_na_or_nan(y_coord_norm[idx]) &&
        !is_na_or_nan(distance[idx]) &&
        !is_na_or_nan(angle[idx]) &&
        is_ps_so[idx] != 1;

      if (is_faceoff[idx] == 1) {
        current_seq += 1;
        seq_start_time = seconds[idx];
        seq_id[i] = current_seq;
        prev_idx[i] = -1;
        if (is_ps_so[idx] != 1 && !is_na_or_nan(seq_start_time) && !is_na_or_nan(seconds[idx])) {
          REAL(seconds_elapsed_in_sequence)[idx] = seconds[idx] - seq_start_time;
        }
      } else if (current_seq > 0) {
        seq_id[i] = current_seq;
        if (is_ps_so[idx] != 1) {
          prev_idx[i] = last_valid_since_faceoff;
        }
        if (is_ps_so[idx] != 1 && !is_na_or_nan(seq_start_time) && !is_na_or_nan(seconds[idx])) {
          REAL(seconds_elapsed_in_sequence)[idx] = seconds[idx] - seq_start_time;
        }
      }

      if (is_faceoff[idx] == 1) {
        last_valid_since_faceoff = valid_spatial ? idx : -1;
      } else if (valid_spatial) {
        last_valid_since_faceoff = idx;
      }

      ++i;
    }

    {
      int group_start = start;
      while (group_start < i) {
        int idx_start = order_idx[group_start] - 1;
        int seq_value = seq_id[group_start];
        double second_value = seconds[idx_start];
        int group_end = group_start + 1;

        while (group_end < i) {
          int idx_end = order_idx[group_end] - 1;
          int same_seq = seq_id[group_end] == seq_value;
          int same_second =
            (is_na_or_nan(second_value) && is_na_or_nan(seconds[idx_end])) ||
            (!is_na_or_nan(second_value) &&
              !is_na_or_nan(seconds[idx_end]) &&
              seconds[idx_end] == second_value);
          if (!same_seq || !same_second) {
            break;
          }
          ++group_end;
        }

        for (int k = group_start; k < group_end; ++k) {
          same_second_count[k] = group_end - group_start;
        }
        group_start = group_end;
      }
    }

    for (int k = start; k < i; ++k) {
      int idx = order_idx[k] - 1;
      int prev = prev_idx[k];
      double dt;
      double denom;
      double dx_norm;
      double dy_norm;
      double dd;
      double da;

      if (prev < 0) {
        continue;
      }

      dt = diff_or_na(seconds[idx], seconds[prev]);
      dx_norm = diff_or_na(x_coord_norm[idx], x_coord_norm[prev]);
      dy_norm = diff_or_na(y_coord_norm[idx], y_coord_norm[prev]);
      dd = diff_or_na(distance[idx], distance[prev]);
      da = diff_or_na(angle[idx], angle[prev]);

      REAL(d_seconds_elapsed_in_sequence)[idx] = dt;
      REAL(d_x_coord)[idx] = diff_or_na(x_coord[idx], x_coord[prev]);
      REAL(d_y_coord)[idx] = diff_or_na(y_coord[idx], y_coord[prev]);
      REAL(d_x_coord_norm)[idx] = dx_norm;
      REAL(d_y_coord_norm)[idx] = dy_norm;
      REAL(d_distance)[idx] = dd;
      REAL(d_angle)[idx] = da;
      INTEGER(event_id_prev)[idx] = event_id[prev];

      if (is_na_or_nan(dt) || dt < 0) {
        continue;
      }

      denom = dt;
      if (denom == 0.0 && same_second_count[k] > 0) {
        denom = 1.0 / (double) same_second_count[k];
      }
      if (denom == 0.0 || is_na_or_nan(denom)) {
        continue;
      }

      if (!is_na_or_nan(REAL(d_x_coord)[idx])) {
        REAL(d_x_coord_per_second)[idx] = REAL(d_x_coord)[idx] / denom;
      }
      if (!is_na_or_nan(REAL(d_y_coord)[idx])) {
        REAL(d_y_coord_per_second)[idx] = REAL(d_y_coord)[idx] / denom;
      }
      if (!is_na_or_nan(dx_norm)) {
        REAL(d_x_coord_norm_per_second)[idx] = dx_norm / denom;
      }
      if (!is_na_or_nan(dy_norm)) {
        REAL(d_y_coord_norm_per_second)[idx] = dy_norm / denom;
      }
      if (!is_na_or_nan(dd)) {
        REAL(d_distance_per_second)[idx] = dd / denom;
      }
      if (!is_na_or_nan(da)) {
        REAL(d_angle_per_second)[idx] = da / denom;
      }
    }
  }

  out = PROTECT(allocVector(VECSXP, 15)); protect_n++;
  out_names = PROTECT(allocVector(STRSXP, 15)); protect_n++;

  SET_VECTOR_ELT(out, 0, event_id_prev);
  SET_VECTOR_ELT(out, 1, seconds_elapsed_in_sequence);
  SET_VECTOR_ELT(out, 2, d_seconds_elapsed_in_sequence);
  SET_VECTOR_ELT(out, 3, d_x_coord);
  SET_VECTOR_ELT(out, 4, d_y_coord);
  SET_VECTOR_ELT(out, 5, d_x_coord_norm);
  SET_VECTOR_ELT(out, 6, d_y_coord_norm);
  SET_VECTOR_ELT(out, 7, d_distance);
  SET_VECTOR_ELT(out, 8, d_angle);
  SET_VECTOR_ELT(out, 9, d_x_coord_per_second);
  SET_VECTOR_ELT(out, 10, d_y_coord_per_second);
  SET_VECTOR_ELT(out, 11, d_x_coord_norm_per_second);
  SET_VECTOR_ELT(out, 12, d_y_coord_norm_per_second);
  SET_VECTOR_ELT(out, 13, d_distance_per_second);
  SET_VECTOR_ELT(out, 14, d_angle_per_second);

  SET_STRING_ELT(out_names, 0, mkChar("eventIdPrev"));
  SET_STRING_ELT(out_names, 1, mkChar("secondsElapsedInSequence"));
  SET_STRING_ELT(out_names, 2, mkChar("dSecondsElapsedInSequence"));
  SET_STRING_ELT(out_names, 3, mkChar("dXCoord"));
  SET_STRING_ELT(out_names, 4, mkChar("dYCoord"));
  SET_STRING_ELT(out_names, 5, mkChar("dXCoordNorm"));
  SET_STRING_ELT(out_names, 6, mkChar("dYCoordNorm"));
  SET_STRING_ELT(out_names, 7, mkChar("dDistance"));
  SET_STRING_ELT(out_names, 8, mkChar("dAngle"));
  SET_STRING_ELT(out_names, 9, mkChar("dXCoordPerSecond"));
  SET_STRING_ELT(out_names, 10, mkChar("dYCoordPerSecond"));
  SET_STRING_ELT(out_names, 11, mkChar("dXCoordNormPerSecond"));
  SET_STRING_ELT(out_names, 12, mkChar("dYCoordNormPerSecond"));
  SET_STRING_ELT(out_names, 13, mkChar("dDistancePerSecond"));
  SET_STRING_ELT(out_names, 14, mkChar("dAnglePerSecond"));
  setAttrib(out, R_NamesSymbol, out_names);

  UNPROTECT(protect_n);
  return out;
}
