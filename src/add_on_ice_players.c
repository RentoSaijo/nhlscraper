#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

#include <limits.h>
#include <stdlib.h>
#include <string.h>

#define TYPE_OTHER 0
#define TYPE_FACEOFF 1
#define TYPE_HIT 2
#define TYPE_SHOT_ON_GOAL 3
#define TYPE_GIVEAWAY 4
#define TYPE_MISSED_SHOT 5
#define TYPE_BLOCKED_SHOT 6
#define TYPE_PENALTY 7
#define TYPE_GOAL 8
#define TYPE_DELAYED_PENALTY 9
#define TYPE_TAKEAWAY 10
#define TYPE_FAILED_SHOT_ATTEMPT 11

#define MAX_CANDIDATES 64
#define MAX_REQUIRED 8
#define MAX_ROSTER 16

typedef struct {
  int game_id;
  int period;
  int team_id;
  int player_id;
  int start;
  int end;
  int prev_end;
  int is_goalie;
} Interval;

typedef struct {
  int game_id;
  int period;
  int team_id;
  int start_idx;
  int end_idx;
} Range;

typedef struct {
  int player_id;
  int start;
  int prev_end;
  int has_time;
  int in_pre;
  int in_post;
  int in_prev;
  int required;
  int selected;
} Candidate;

typedef struct {
  int skater_ids[MAX_ROSTER];
  int skater_starts[MAX_ROSTER];
  int skater_prev_ends[MAX_ROSTER];
  int skater_has_time[MAX_ROSTER];
  int n_skaters;
  int goalie_id;
  int goalie_start;
  int goalie_prev_end;
  int goalie_has_time;
} TeamState;

typedef struct {
  int skater_ids[MAX_REQUIRED];
  int n_skaters;
  int goalie_id;
} TeamRequirements;

static int is_na_int(int x) {
  return x == NA_INTEGER;
}

static int max_int(int a, int b) {
  return a > b ? a : b;
}

static void init_team_state(TeamState *state) {
  state->n_skaters = 0;
  state->goalie_id = NA_INTEGER;
  state->goalie_start = NA_INTEGER;
  state->goalie_prev_end = NA_INTEGER;
  state->goalie_has_time = 0;
}

static int team_state_has_player(const TeamState *state, int player_id, int is_goalie) {
  int i;
  if (is_goalie) {
    return !is_na_int(state->goalie_id) && state->goalie_id == player_id;
  }
  for (i = 0; i < state->n_skaters; ++i) {
    if (state->skater_ids[i] == player_id) {
      return 1;
    }
  }
  return 0;
}

static int binary_search_int(const int *arr, int n, int value) {
  int left = 0;
  int right = n - 1;
  while (left <= right) {
    int mid = left + (right - left) / 2;
    if (arr[mid] == value) {
      return 1;
    }
    if (arr[mid] < value) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }
  return 0;
}

static int candidate_find(const Candidate *cand, int n, int player_id) {
  int i;
  for (i = 0; i < n; ++i) {
    if (cand[i].player_id == player_id) {
      return i;
    }
  }
  return -1;
}

static int candidate_keep_score(const Candidate *cand, int prefer_post) {
  int score = 0;
  if (cand->required) {
    score += 100000;
  }
  if (cand->in_pre && cand->in_post) {
    score += 2000;
  }
  if (cand->in_prev) {
    score += 500;
  }
  if (prefer_post) {
    if (cand->in_post) {
      score += 200;
    }
    if (cand->in_pre) {
      score += 50;
    }
  } else {
    if (cand->in_pre) {
      score += 200;
    }
    if (cand->in_post) {
      score += 50;
    }
  }
  if (cand->has_time) {
    score += 10;
  }
  return score;
}

static void sort_team_state(TeamState *state) {
  int i;
  int j;
  for (i = 1; i < state->n_skaters; ++i) {
    int id = state->skater_ids[i];
    int st = state->skater_starts[i];
    int pe = state->skater_prev_ends[i];
    int ht = state->skater_has_time[i];
    j = i - 1;
    while (j >= 0 && state->skater_ids[j] > id) {
      state->skater_ids[j + 1] = state->skater_ids[j];
      state->skater_starts[j + 1] = state->skater_starts[j];
      state->skater_prev_ends[j + 1] = state->skater_prev_ends[j];
      state->skater_has_time[j + 1] = state->skater_has_time[j];
      --j;
    }
    state->skater_ids[j + 1] = id;
    state->skater_starts[j + 1] = st;
    state->skater_prev_ends[j + 1] = pe;
    state->skater_has_time[j + 1] = ht;
  }
}

static int lookup_range(const Range *ranges, int n_ranges, int game_id, int period, int team_id) {
  int left = 0;
  int right = n_ranges - 1;
  while (left <= right) {
    int mid = left + (right - left) / 2;
    const Range *r = &ranges[mid];
    if (r->game_id == game_id && r->period == period && r->team_id == team_id) {
      return mid;
    }
    if (
      r->game_id < game_id ||
      (r->game_id == game_id && r->period < period) ||
      (r->game_id == game_id && r->period == period && r->team_id < team_id)
    ) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }
  return -1;
}

static void add_required_player(
  TeamRequirements *home_req,
  TeamRequirements *away_req,
  const int *goalie_ids,
  int n_goalie_ids,
  int player_id,
  int to_home
) {
  TeamRequirements *req;
  int i;
  if (is_na_int(player_id) || player_id <= 0) {
    return;
  }
  req = to_home ? home_req : away_req;
  if (binary_search_int(goalie_ids, n_goalie_ids, player_id)) {
    req->goalie_id = player_id;
    return;
  }
  for (i = 0; i < req->n_skaters; ++i) {
    if (req->skater_ids[i] == player_id) {
      return;
    }
  }
  if (req->n_skaters < MAX_REQUIRED) {
    req->skater_ids[req->n_skaters++] = player_id;
  }
}

static void build_requirements(
  int type_code,
  int is_home_owner,
  const int *goalie_ids,
  int n_goalie_ids,
  int winning_player_id,
  int losing_player_id,
  int hitting_player_id,
  int hittee_player_id,
  int shooting_player_id,
  int scoring_player_id,
  int player_id,
  int blocking_player_id,
  int committed_player_id,
  int drawn_player_id,
  int goalie_in_net_id,
  TeamRequirements *home_req,
  TeamRequirements *away_req
) {
  int owner_home = is_home_owner == 1;
  int shooter_id = !is_na_int(scoring_player_id) ? scoring_player_id : shooting_player_id;

  home_req->n_skaters = 0;
  home_req->goalie_id = NA_INTEGER;
  away_req->n_skaters = 0;
  away_req->goalie_id = NA_INTEGER;

  switch (type_code) {
    case TYPE_FACEOFF:
      add_required_player(home_req, away_req, goalie_ids, n_goalie_ids, winning_player_id, owner_home);
      add_required_player(home_req, away_req, goalie_ids, n_goalie_ids, losing_player_id, !owner_home);
      break;
    case TYPE_HIT:
      add_required_player(home_req, away_req, goalie_ids, n_goalie_ids, hitting_player_id, owner_home);
      add_required_player(home_req, away_req, goalie_ids, n_goalie_ids, hittee_player_id, !owner_home);
      break;
    case TYPE_SHOT_ON_GOAL:
    case TYPE_MISSED_SHOT:
    case TYPE_GOAL:
    case TYPE_FAILED_SHOT_ATTEMPT:
      add_required_player(home_req, away_req, goalie_ids, n_goalie_ids, shooter_id, owner_home);
      add_required_player(home_req, away_req, goalie_ids, n_goalie_ids, goalie_in_net_id, !owner_home);
      break;
    case TYPE_GIVEAWAY:
    case TYPE_TAKEAWAY:
      add_required_player(home_req, away_req, goalie_ids, n_goalie_ids, player_id, owner_home);
      break;
    case TYPE_BLOCKED_SHOT:
    case TYPE_PENALTY:
    case TYPE_DELAYED_PENALTY:
      break;
    default:
      break;
  }
}

static void append_candidate(
  Candidate *cand,
  int *n,
  int player_id,
  int start,
  int prev_end,
  int has_time,
  int in_pre,
  int in_post,
  int in_prev,
  int required
) {
  int idx;
  if (*n >= MAX_CANDIDATES || is_na_int(player_id) || player_id <= 0) {
    return;
  }
  idx = candidate_find(cand, *n, player_id);
  if (idx >= 0) {
    cand[idx].in_pre = cand[idx].in_pre || in_pre;
    cand[idx].in_post = cand[idx].in_post || in_post;
    cand[idx].in_prev = cand[idx].in_prev || in_prev;
    cand[idx].required = cand[idx].required || required;
    if (has_time && !cand[idx].has_time) {
      cand[idx].start = start;
      cand[idx].prev_end = prev_end;
      cand[idx].has_time = 1;
    }
    return;
  }
  cand[*n].player_id = player_id;
  cand[*n].start = start;
  cand[*n].prev_end = prev_end;
  cand[*n].has_time = has_time;
  cand[*n].in_pre = in_pre;
  cand[*n].in_post = in_post;
  cand[*n].in_prev = in_prev;
  cand[*n].required = required;
  cand[*n].selected = 0;
  *n += 1;
}

static void build_touch_candidates(
  const Interval *intervals,
  int start_idx,
  int end_idx,
  int time_sec,
  int prefer_post,
  const TeamRequirements *req,
  const TeamState *prev_state,
  int want_goalie,
  Candidate *cand,
  int *n
) {
  int i;
  int k;
  *n = 0;
  for (i = start_idx; i < end_idx; ++i) {
    const Interval *it = &intervals[i];
    int in_touch = it->start <= time_sec && it->end >= time_sec;
    int in_pre = it->start < time_sec && it->end >= time_sec;
    int in_post = it->start <= time_sec && it->end > time_sec;
    int required = 0;
    if (!in_touch || it->is_goalie != want_goalie) {
      continue;
    }
    if (want_goalie) {
      required = !is_na_int(req->goalie_id) && req->goalie_id == it->player_id;
    } else {
      for (k = 0; k < req->n_skaters; ++k) {
        if (req->skater_ids[k] == it->player_id) {
          required = 1;
          break;
        }
      }
    }
    append_candidate(
      cand,
      n,
      it->player_id,
      it->start,
      it->prev_end,
      1,
      in_pre,
      in_post,
      team_state_has_player(prev_state, it->player_id, want_goalie),
      required
    );
  }
  for (i = 0; i < *n; ++i) {
    cand[i].selected = prefer_post ? cand[i].in_post : cand[i].in_pre;
    if (cand[i].required) {
      cand[i].selected = 1;
    }
  }
}

static int find_best_add(const Candidate *cand, int n, int prefer_post) {
  int i;
  int best = -1;
  int best_score = INT_MIN;
  for (i = 0; i < n; ++i) {
    int score;
    if (cand[i].selected) {
      continue;
    }
    score = candidate_keep_score(&cand[i], prefer_post);
    if (
      best < 0 ||
      score > best_score ||
      (score == best_score && cand[i].player_id < cand[best].player_id)
    ) {
      best = i;
      best_score = score;
    }
  }
  return best;
}

static int find_best_drop(const Candidate *cand, int n, int prefer_post) {
  int i;
  int best = -1;
  int best_score = INT_MAX;
  for (i = 0; i < n; ++i) {
    int score;
    if (!cand[i].selected || cand[i].required) {
      continue;
    }
    score = candidate_keep_score(&cand[i], prefer_post);
    if (
      best < 0 ||
      score < best_score ||
      (score == best_score && cand[i].player_id > cand[best].player_id)
    ) {
      best = i;
      best_score = score;
    }
  }
  return best;
}

static int count_selected(const Candidate *cand, int n) {
  int i;
  int out = 0;
  for (i = 0; i < n; ++i) {
    out += cand[i].selected ? 1 : 0;
  }
  return out;
}

static void add_prev_state_fallback(
  Candidate *cand,
  int *n,
  const TeamState *prev_state,
  int want_goalie
) {
  int i;
  if (want_goalie) {
    if (!is_na_int(prev_state->goalie_id)) {
      append_candidate(
        cand,
        n,
        prev_state->goalie_id,
        prev_state->goalie_start,
        prev_state->goalie_prev_end,
        prev_state->goalie_has_time,
        0,
        0,
        1,
        0
      );
    }
    return;
  }
  for (i = 0; i < prev_state->n_skaters; ++i) {
    append_candidate(
      cand,
      n,
      prev_state->skater_ids[i],
      prev_state->skater_starts[i],
      prev_state->skater_prev_ends[i],
      prev_state->skater_has_time[i],
      0,
      0,
      1,
      0
    );
  }
}

static void add_required_fallback(
  Candidate *cand,
  int *n,
  const TeamRequirements *req,
  int want_goalie
) {
  int i;
  if (want_goalie) {
    if (!is_na_int(req->goalie_id)) {
      append_candidate(cand, n, req->goalie_id, NA_INTEGER, NA_INTEGER, 0, 0, 0, 0, 1);
    }
    return;
  }
  for (i = 0; i < req->n_skaters; ++i) {
    append_candidate(cand, n, req->skater_ids[i], NA_INTEGER, NA_INTEGER, 0, 0, 0, 0, 1);
  }
}

static void add_nearest_interval_fallback(
  Candidate *cand,
  int *n,
  const Interval *intervals,
  int start_idx,
  int end_idx,
  int time_sec,
  int prefer_post,
  int want_goalie
) {
  int i;
  int best_idx = -1;
  int best_dist = INT_MAX;
  int best_pref = INT_MAX;
  int best_player = INT_MAX;

  for (i = start_idx; i < end_idx; ++i) {
    const Interval *it = &intervals[i];
    int dist;
    int pref;
    if (it->is_goalie != want_goalie) {
      continue;
    }
    if (candidate_find(cand, *n, it->player_id) >= 0) {
      continue;
    }
    if (it->start > time_sec) {
      dist = it->start - time_sec;
      pref = prefer_post ? 0 : 1;
    } else if (it->end < time_sec) {
      dist = time_sec - it->end;
      pref = prefer_post ? 1 : 0;
    } else {
      dist = 0;
      pref = 0;
    }
    if (
      best_idx < 0 ||
      dist < best_dist ||
      (dist == best_dist && pref < best_pref) ||
      (dist == best_dist && pref == best_pref && it->player_id < best_player)
    ) {
      best_idx = i;
      best_dist = dist;
      best_pref = pref;
      best_player = it->player_id;
    }
  }

  if (best_idx >= 0) {
    append_candidate(
      cand,
      n,
      intervals[best_idx].player_id,
      NA_INTEGER,
      NA_INTEGER,
      0,
      0,
      0,
      0,
      0
    );
  }
}

static void resolve_candidate_selection(
  Candidate *cand,
  int *n,
  int target,
  int prefer_post,
  const Interval *intervals,
  int start_idx,
  int end_idx,
  int time_sec,
  const TeamRequirements *req,
  const TeamState *prev_state,
  int want_goalie
) {
  int selected_n = count_selected(cand, *n);

  while (selected_n > target) {
    int drop_idx = find_best_drop(cand, *n, prefer_post);
    if (drop_idx < 0) {
      break;
    }
    cand[drop_idx].selected = 0;
    --selected_n;
  }

  if (selected_n < target) {
    add_prev_state_fallback(cand, n, prev_state, want_goalie);
    add_required_fallback(cand, n, req, want_goalie);
    while (selected_n < target) {
      int add_idx = find_best_add(cand, *n, prefer_post);
      if (add_idx >= 0) {
        cand[add_idx].selected = 1;
        ++selected_n;
        continue;
      }
      add_nearest_interval_fallback(
        cand,
        n,
        intervals,
        start_idx,
        end_idx,
        time_sec,
        prefer_post,
        want_goalie
      );
      add_idx = find_best_add(cand, *n, prefer_post);
      if (add_idx < 0) {
        break;
      }
      cand[add_idx].selected = 1;
      ++selected_n;
    }
  }

  while (selected_n > target) {
    int drop_idx = find_best_drop(cand, *n, prefer_post);
    if (drop_idx < 0) {
      break;
    }
    cand[drop_idx].selected = 0;
    --selected_n;
  }
}

static void build_team_state_from_candidates(
  const Candidate *cand,
  int n,
  int want_goalie,
  TeamState *state
) {
  int i;
  if (want_goalie) {
    init_team_state(state);
    for (i = 0; i < n; ++i) {
      if (!cand[i].selected) {
        continue;
      }
      state->goalie_id = cand[i].player_id;
      state->goalie_start = cand[i].start;
      state->goalie_prev_end = cand[i].prev_end;
      state->goalie_has_time = cand[i].has_time;
      return;
    }
    return;
  }
  init_team_state(state);
  for (i = 0; i < n && state->n_skaters < MAX_ROSTER; ++i) {
    if (!cand[i].selected) {
      continue;
    }
    state->skater_ids[state->n_skaters] = cand[i].player_id;
    state->skater_starts[state->n_skaters] = cand[i].start;
    state->skater_prev_ends[state->n_skaters] = cand[i].prev_end;
    state->skater_has_time[state->n_skaters] = cand[i].has_time;
    state->n_skaters += 1;
  }
  sort_team_state(state);
}

static void resolve_team(
  const Interval *intervals,
  int start_idx,
  int end_idx,
  int time_sec,
  int is_faceoff,
  int target_skaters,
  int target_goalie,
  const TeamRequirements *req,
  const TeamState *prev_state,
  TeamState *out_state
) {
  Candidate skater_cand[MAX_CANDIDATES];
  Candidate goalie_cand[MAX_CANDIDATES];
  TeamState skater_state;
  TeamState goalie_state;
  int n_skater_cand = 0;
  int n_goalie_cand = 0;
  int prefer_post = is_faceoff ? 1 : 0;

  init_team_state(out_state);
  init_team_state(&skater_state);
  init_team_state(&goalie_state);

  build_touch_candidates(
    intervals,
    start_idx,
    end_idx,
    time_sec,
    prefer_post,
    req,
    prev_state,
    0,
    skater_cand,
    &n_skater_cand
  );
  resolve_candidate_selection(
    skater_cand,
    &n_skater_cand,
    max_int(target_skaters, 0),
    prefer_post,
    intervals,
    start_idx,
    end_idx,
    time_sec,
    req,
    prev_state,
    0
  );
  build_team_state_from_candidates(skater_cand, n_skater_cand, 0, &skater_state);

  if (target_goalie > 0) {
    build_touch_candidates(
      intervals,
      start_idx,
      end_idx,
      time_sec,
      prefer_post,
      req,
      prev_state,
      1,
      goalie_cand,
      &n_goalie_cand
    );
    resolve_candidate_selection(
      goalie_cand,
      &n_goalie_cand,
      1,
      prefer_post,
      intervals,
      start_idx,
      end_idx,
      time_sec,
      req,
      prev_state,
      1
    );
    build_team_state_from_candidates(goalie_cand, n_goalie_cand, 1, &goalie_state);
  }

  *out_state = skater_state;
  out_state->goalie_id = goalie_state.goalie_id;
  out_state->goalie_start = goalie_state.goalie_start;
  out_state->goalie_prev_end = goalie_state.goalie_prev_end;
  out_state->goalie_has_time = goalie_state.goalie_has_time;
}

static void resolve_special_state(
  int shooter_id,
  int goalie_id,
  int shooter_is_home,
  TeamState *home_state,
  TeamState *away_state
) {
  init_team_state(home_state);
  init_team_state(away_state);
  if (shooter_is_home) {
    if (!is_na_int(shooter_id) && shooter_id > 0) {
      home_state->skater_ids[0] = shooter_id;
      home_state->skater_starts[0] = NA_INTEGER;
      home_state->skater_prev_ends[0] = NA_INTEGER;
      home_state->skater_has_time[0] = 0;
      home_state->n_skaters = 1;
    }
    if (!is_na_int(goalie_id) && goalie_id > 0) {
      away_state->goalie_id = goalie_id;
    }
  } else {
    if (!is_na_int(shooter_id) && shooter_id > 0) {
      away_state->skater_ids[0] = shooter_id;
      away_state->skater_starts[0] = NA_INTEGER;
      away_state->skater_prev_ends[0] = NA_INTEGER;
      away_state->skater_has_time[0] = 0;
      away_state->n_skaters = 1;
    }
    if (!is_na_int(goalie_id) && goalie_id > 0) {
      home_state->goalie_id = goalie_id;
    }
  }
}

static SEXP make_goalie_list_elt(int goalie_id, SEXP na_int_scalar) {
  SEXP out;
  if (is_na_int(goalie_id) || goalie_id <= 0) {
    return na_int_scalar;
  }
  out = PROTECT(allocVector(INTSXP, 1));
  INTEGER(out)[0] = goalie_id;
  UNPROTECT(1);
  return out;
}

static SEXP make_player_vector(const TeamState *state, int include_goalie) {
  int total = state->n_skaters + (include_goalie && !is_na_int(state->goalie_id) ? 1 : 0);
  int i;
  SEXP out = PROTECT(allocVector(INTSXP, total));
  for (i = 0; i < state->n_skaters; ++i) {
    INTEGER(out)[i] = state->skater_ids[i];
  }
  if (include_goalie && !is_na_int(state->goalie_id)) {
    INTEGER(out)[state->n_skaters] = state->goalie_id;
  }
  UNPROTECT(1);
  return out;
}

static SEXP make_time_vector(
  const TeamState *state,
  int include_goalie,
  int time_sec,
  int want_since_last
) {
  int total = state->n_skaters + (include_goalie && !is_na_int(state->goalie_id) ? 1 : 0);
  int i;
  SEXP out = PROTECT(allocVector(REALSXP, total));
  for (i = 0; i < state->n_skaters; ++i) {
    if (!state->skater_has_time[i] || is_na_int(state->skater_starts[i])) {
      REAL(out)[i] = NA_REAL;
    } else if (want_since_last) {
      if (is_na_int(state->skater_prev_ends[i])) {
        REAL(out)[i] = 300.0 + (double) time_sec;
      } else {
        REAL(out)[i] = (double) (time_sec - state->skater_prev_ends[i]);
      }
    } else {
      REAL(out)[i] = (double) (time_sec - state->skater_starts[i]);
    }
  }
  if (include_goalie && !is_na_int(state->goalie_id)) {
    int idx = state->n_skaters;
    if (!state->goalie_has_time || is_na_int(state->goalie_start)) {
      REAL(out)[idx] = NA_REAL;
    } else if (want_since_last) {
      if (is_na_int(state->goalie_prev_end)) {
        REAL(out)[idx] = 300.0 + (double) time_sec;
      } else {
        REAL(out)[idx] = (double) (time_sec - state->goalie_prev_end);
      }
    } else {
      REAL(out)[idx] = (double) (time_sec - state->goalie_start);
    }
  }
  UNPROTECT(1);
  return out;
}

SEXP nhlscraper_add_on_ice_players_resolve(SEXP data_list) {
  SEXP event_order_sexp;
  SEXP game_id_sexp;
  SEXP period_sexp;
  SEXP seconds_sexp;
  SEXP type_code_sexp;
  SEXP special_sexp;
  SEXP is_home_owner_sexp;
  SEXP home_team_id_sexp;
  SEXP away_team_id_sexp;
  SEXP home_skaters_sexp;
  SEXP away_skaters_sexp;
  SEXP home_goalies_sexp;
  SEXP away_goalies_sexp;
  SEXP winning_player_id_sexp;
  SEXP losing_player_id_sexp;
  SEXP hitting_player_id_sexp;
  SEXP hittee_player_id_sexp;
  SEXP shooting_player_id_sexp;
  SEXP scoring_player_id_sexp;
  SEXP player_id_sexp;
  SEXP blocking_player_id_sexp;
  SEXP committed_player_id_sexp;
  SEXP drawn_player_id_sexp;
  SEXP goalie_in_net_id_sexp;
  SEXP shift_game_id_sexp;
  SEXP shift_period_sexp;
  SEXP shift_team_id_sexp;
  SEXP shift_player_id_sexp;
  SEXP shift_start_sexp;
  SEXP shift_end_sexp;
  SEXP shift_is_goalie_sexp;
  SEXP goalie_ids_sexp;
  int *event_order;
  int *game_id;
  int *period;
  int *seconds;
  int *type_code;
  int *special;
  int *is_home_owner;
  int *home_team_id;
  int *away_team_id;
  int *home_skaters;
  int *away_skaters;
  int *home_goalies;
  int *away_goalies;
  int *winning_player_id;
  int *losing_player_id;
  int *hitting_player_id;
  int *hittee_player_id;
  int *shooting_player_id;
  int *scoring_player_id;
  int *player_id;
  int *blocking_player_id;
  int *committed_player_id;
  int *drawn_player_id;
  int *goalie_in_net_id;
  int *shift_game_id;
  int *shift_period;
  int *shift_team_id;
  int *shift_player_id;
  int *shift_start;
  int *shift_end;
  int *shift_is_goalie;
  int *goalie_ids;
  int n_events;
  int n_shifts;
  int n_goalie_ids;
  Interval *merged = NULL;
  Range *ranges = NULL;
  int n_merged = 0;
  int n_ranges = 0;
  int i;
  int protect_n = 0;
  SEXP home_player_ids;
  SEXP away_player_ids;
  SEXP home_skater_ids;
  SEXP away_skater_ids;
  SEXP home_goalie_ids;
  SEXP away_goalie_ids;
  SEXP home_elapsed_shift;
  SEXP away_elapsed_shift;
  SEXP home_since_last;
  SEXP away_since_last;
  SEXP out;
  SEXP out_names;
  SEXP na_int_scalar;
  SEXP na_real_scalar;
  SEXP empty_int;
  SEXP empty_real;
  TeamState prev_home;
  TeamState prev_away;
  int last_game = NA_INTEGER;
  int last_period = NA_INTEGER;

  if (TYPEOF(data_list) != VECSXP || XLENGTH(data_list) < 32) {
    error("Expected a list of prepared event and shift vectors.");
  }

  event_order_sexp = VECTOR_ELT(data_list, 0);
  game_id_sexp = VECTOR_ELT(data_list, 1);
  period_sexp = VECTOR_ELT(data_list, 2);
  seconds_sexp = VECTOR_ELT(data_list, 3);
  type_code_sexp = VECTOR_ELT(data_list, 4);
  special_sexp = VECTOR_ELT(data_list, 5);
  is_home_owner_sexp = VECTOR_ELT(data_list, 6);
  home_team_id_sexp = VECTOR_ELT(data_list, 7);
  away_team_id_sexp = VECTOR_ELT(data_list, 8);
  home_skaters_sexp = VECTOR_ELT(data_list, 9);
  away_skaters_sexp = VECTOR_ELT(data_list, 10);
  home_goalies_sexp = VECTOR_ELT(data_list, 11);
  away_goalies_sexp = VECTOR_ELT(data_list, 12);
  winning_player_id_sexp = VECTOR_ELT(data_list, 13);
  losing_player_id_sexp = VECTOR_ELT(data_list, 14);
  hitting_player_id_sexp = VECTOR_ELT(data_list, 15);
  hittee_player_id_sexp = VECTOR_ELT(data_list, 16);
  shooting_player_id_sexp = VECTOR_ELT(data_list, 17);
  scoring_player_id_sexp = VECTOR_ELT(data_list, 18);
  player_id_sexp = VECTOR_ELT(data_list, 19);
  blocking_player_id_sexp = VECTOR_ELT(data_list, 20);
  committed_player_id_sexp = VECTOR_ELT(data_list, 21);
  drawn_player_id_sexp = VECTOR_ELT(data_list, 22);
  goalie_in_net_id_sexp = VECTOR_ELT(data_list, 23);
  shift_game_id_sexp = VECTOR_ELT(data_list, 24);
  shift_period_sexp = VECTOR_ELT(data_list, 25);
  shift_team_id_sexp = VECTOR_ELT(data_list, 26);
  shift_player_id_sexp = VECTOR_ELT(data_list, 27);
  shift_start_sexp = VECTOR_ELT(data_list, 28);
  shift_end_sexp = VECTOR_ELT(data_list, 29);
  shift_is_goalie_sexp = VECTOR_ELT(data_list, 30);
  goalie_ids_sexp = VECTOR_ELT(data_list, 31);

  n_events = (int) XLENGTH(game_id_sexp);
  n_shifts = (int) XLENGTH(shift_game_id_sexp);
  n_goalie_ids = (int) XLENGTH(goalie_ids_sexp);

  event_order = INTEGER(event_order_sexp);
  game_id = INTEGER(game_id_sexp);
  period = INTEGER(period_sexp);
  seconds = INTEGER(seconds_sexp);
  type_code = INTEGER(type_code_sexp);
  special = LOGICAL(special_sexp);
  is_home_owner = INTEGER(is_home_owner_sexp);
  home_team_id = INTEGER(home_team_id_sexp);
  away_team_id = INTEGER(away_team_id_sexp);
  home_skaters = INTEGER(home_skaters_sexp);
  away_skaters = INTEGER(away_skaters_sexp);
  home_goalies = INTEGER(home_goalies_sexp);
  away_goalies = INTEGER(away_goalies_sexp);
  winning_player_id = INTEGER(winning_player_id_sexp);
  losing_player_id = INTEGER(losing_player_id_sexp);
  hitting_player_id = INTEGER(hitting_player_id_sexp);
  hittee_player_id = INTEGER(hittee_player_id_sexp);
  shooting_player_id = INTEGER(shooting_player_id_sexp);
  scoring_player_id = INTEGER(scoring_player_id_sexp);
  player_id = INTEGER(player_id_sexp);
  blocking_player_id = INTEGER(blocking_player_id_sexp);
  committed_player_id = INTEGER(committed_player_id_sexp);
  drawn_player_id = INTEGER(drawn_player_id_sexp);
  goalie_in_net_id = INTEGER(goalie_in_net_id_sexp);
  shift_game_id = INTEGER(shift_game_id_sexp);
  shift_period = INTEGER(shift_period_sexp);
  shift_team_id = INTEGER(shift_team_id_sexp);
  shift_player_id = INTEGER(shift_player_id_sexp);
  shift_start = INTEGER(shift_start_sexp);
  shift_end = INTEGER(shift_end_sexp);
  shift_is_goalie = LOGICAL(shift_is_goalie_sexp);
  goalie_ids = INTEGER(goalie_ids_sexp);

  merged = (Interval *) R_alloc((size_t) n_shifts, sizeof(Interval));
  if (n_shifts > 0) {
    int cur_game = shift_game_id[0];
    int cur_period = shift_period[0];
    int cur_team = shift_team_id[0];
    int cur_player = shift_player_id[0];
    int cur_start = shift_start[0];
    int cur_end = shift_end[0];
    int cur_is_goalie = shift_is_goalie[0];
    int prev_end_same_player = NA_INTEGER;
    for (i = 1; i < n_shifts; ++i) {
      if (
        shift_game_id[i] == cur_game &&
        shift_period[i] == cur_period &&
        shift_team_id[i] == cur_team &&
        shift_player_id[i] == cur_player &&
        shift_start[i] <= cur_end
      ) {
        cur_end = max_int(cur_end, shift_end[i]);
      } else {
        merged[n_merged].game_id = cur_game;
        merged[n_merged].period = cur_period;
        merged[n_merged].team_id = cur_team;
        merged[n_merged].player_id = cur_player;
        merged[n_merged].start = cur_start;
        merged[n_merged].end = cur_end;
        merged[n_merged].prev_end = prev_end_same_player;
        merged[n_merged].is_goalie = cur_is_goalie;
        ++n_merged;
        if (
          shift_game_id[i] == cur_game &&
          shift_period[i] == cur_period &&
          shift_team_id[i] == cur_team &&
          shift_player_id[i] == cur_player
        ) {
          prev_end_same_player = cur_end;
        } else {
          prev_end_same_player = NA_INTEGER;
        }
        cur_game = shift_game_id[i];
        cur_period = shift_period[i];
        cur_team = shift_team_id[i];
        cur_player = shift_player_id[i];
        cur_start = shift_start[i];
        cur_end = shift_end[i];
        cur_is_goalie = shift_is_goalie[i];
      }
    }
    merged[n_merged].game_id = cur_game;
    merged[n_merged].period = cur_period;
    merged[n_merged].team_id = cur_team;
    merged[n_merged].player_id = cur_player;
    merged[n_merged].start = cur_start;
    merged[n_merged].end = cur_end;
    merged[n_merged].prev_end = prev_end_same_player;
    merged[n_merged].is_goalie = cur_is_goalie;
    ++n_merged;
  }

  ranges = (Range *) R_alloc((size_t) max_int(n_merged, 1), sizeof(Range));
  if (n_merged > 0) {
    int cur_game = merged[0].game_id;
    int cur_period = merged[0].period;
    int cur_team = merged[0].team_id;
    int start_idx = 0;
    for (i = 1; i < n_merged; ++i) {
      if (
        merged[i].game_id != cur_game ||
        merged[i].period != cur_period ||
        merged[i].team_id != cur_team
      ) {
        ranges[n_ranges].game_id = cur_game;
        ranges[n_ranges].period = cur_period;
        ranges[n_ranges].team_id = cur_team;
        ranges[n_ranges].start_idx = start_idx;
        ranges[n_ranges].end_idx = i;
        ++n_ranges;
        cur_game = merged[i].game_id;
        cur_period = merged[i].period;
        cur_team = merged[i].team_id;
        start_idx = i;
      }
    }
    ranges[n_ranges].game_id = cur_game;
    ranges[n_ranges].period = cur_period;
    ranges[n_ranges].team_id = cur_team;
    ranges[n_ranges].start_idx = start_idx;
    ranges[n_ranges].end_idx = n_merged;
    ++n_ranges;
  }

  home_player_ids = PROTECT(allocVector(VECSXP, n_events)); protect_n++;
  away_player_ids = PROTECT(allocVector(VECSXP, n_events)); protect_n++;
  home_skater_ids = PROTECT(allocVector(VECSXP, n_events)); protect_n++;
  away_skater_ids = PROTECT(allocVector(VECSXP, n_events)); protect_n++;
  home_goalie_ids = PROTECT(allocVector(VECSXP, n_events)); protect_n++;
  away_goalie_ids = PROTECT(allocVector(VECSXP, n_events)); protect_n++;
  home_elapsed_shift = PROTECT(allocVector(VECSXP, n_events)); protect_n++;
  away_elapsed_shift = PROTECT(allocVector(VECSXP, n_events)); protect_n++;
  home_since_last = PROTECT(allocVector(VECSXP, n_events)); protect_n++;
  away_since_last = PROTECT(allocVector(VECSXP, n_events)); protect_n++;

  na_int_scalar = PROTECT(allocVector(INTSXP, 1)); protect_n++;
  INTEGER(na_int_scalar)[0] = NA_INTEGER;
  na_real_scalar = PROTECT(allocVector(REALSXP, 1)); protect_n++;
  REAL(na_real_scalar)[0] = NA_REAL;
  empty_int = PROTECT(allocVector(INTSXP, 0)); protect_n++;
  empty_real = PROTECT(allocVector(REALSXP, 0)); protect_n++;

  for (i = 0; i < n_events; ++i) {
    SET_VECTOR_ELT(home_player_ids, i, na_int_scalar);
    SET_VECTOR_ELT(away_player_ids, i, na_int_scalar);
    SET_VECTOR_ELT(home_skater_ids, i, na_int_scalar);
    SET_VECTOR_ELT(away_skater_ids, i, na_int_scalar);
    SET_VECTOR_ELT(home_goalie_ids, i, na_int_scalar);
    SET_VECTOR_ELT(away_goalie_ids, i, na_int_scalar);
    SET_VECTOR_ELT(home_elapsed_shift, i, na_real_scalar);
    SET_VECTOR_ELT(away_elapsed_shift, i, na_real_scalar);
    SET_VECTOR_ELT(home_since_last, i, na_real_scalar);
    SET_VECTOR_ELT(away_since_last, i, na_real_scalar);
  }

  init_team_state(&prev_home);
  init_team_state(&prev_away);

  for (i = 0; i < n_events; ++i) {
    int idx = event_order[i] - 1;
    int g = game_id[idx];
    int p = period[idx];
    int t = seconds[idx];
    int type = type_code[idx];
    int is_special = special[idx] == 1;
    TeamState cur_home;
    TeamState cur_away;
    int home_range_idx;
    int away_range_idx;
    TeamRequirements home_req;
    TeamRequirements away_req;

    if (g != last_game || p != last_period) {
      init_team_state(&prev_home);
      init_team_state(&prev_away);
      last_game = g;
      last_period = p;
    }

    if (type == TYPE_OTHER) {
      continue;
    }

    if (type == TYPE_FACEOFF) {
      init_team_state(&prev_home);
      init_team_state(&prev_away);
    }

    if (is_special) {
      int shooter_id = !is_na_int(scoring_player_id[idx]) ? scoring_player_id[idx] : shooting_player_id[idx];
      int shooter_is_home = home_skaters[idx] == 1 && away_skaters[idx] == 0;
      resolve_special_state(shooter_id, goalie_in_net_id[idx], shooter_is_home, &cur_home, &cur_away);
      SET_VECTOR_ELT(home_skater_ids, idx, make_player_vector(&cur_home, 0));
      SET_VECTOR_ELT(away_skater_ids, idx, make_player_vector(&cur_away, 0));
      SET_VECTOR_ELT(home_player_ids, idx, make_player_vector(&cur_home, 1));
      SET_VECTOR_ELT(away_player_ids, idx, make_player_vector(&cur_away, 1));
      SET_VECTOR_ELT(home_goalie_ids, idx, make_goalie_list_elt(cur_home.goalie_id, na_int_scalar));
      SET_VECTOR_ELT(away_goalie_ids, idx, make_goalie_list_elt(cur_away.goalie_id, na_int_scalar));
      SET_VECTOR_ELT(home_elapsed_shift, idx, na_real_scalar);
      SET_VECTOR_ELT(away_elapsed_shift, idx, na_real_scalar);
      SET_VECTOR_ELT(home_since_last, idx, na_real_scalar);
      SET_VECTOR_ELT(away_since_last, idx, na_real_scalar);
      continue;
    }

    home_range_idx = lookup_range(ranges, n_ranges, g, p, home_team_id[idx]);
    away_range_idx = lookup_range(ranges, n_ranges, g, p, away_team_id[idx]);
    build_requirements(
      type,
      is_home_owner[idx],
      goalie_ids,
      n_goalie_ids,
      winning_player_id[idx],
      losing_player_id[idx],
      hitting_player_id[idx],
      hittee_player_id[idx],
      shooting_player_id[idx],
      scoring_player_id[idx],
      player_id[idx],
      blocking_player_id[idx],
      committed_player_id[idx],
      drawn_player_id[idx],
      goalie_in_net_id[idx],
      &home_req,
      &away_req
    );

    init_team_state(&cur_home);
    init_team_state(&cur_away);

    if (home_range_idx >= 0) {
      resolve_team(
        merged,
        ranges[home_range_idx].start_idx,
        ranges[home_range_idx].end_idx,
        t,
        type == TYPE_FACEOFF,
        home_skaters[idx],
        home_goalies[idx],
        &home_req,
        &prev_home,
        &cur_home
      );
    } else {
      resolve_special_state(NA_INTEGER, NA_INTEGER, 1, &cur_home, &cur_away);
      cur_home.n_skaters = 0;
      cur_home.goalie_id = NA_INTEGER;
    }
    if (away_range_idx >= 0) {
      resolve_team(
        merged,
        ranges[away_range_idx].start_idx,
        ranges[away_range_idx].end_idx,
        t,
        type == TYPE_FACEOFF,
        away_skaters[idx],
        away_goalies[idx],
        &away_req,
        &prev_away,
        &cur_away
      );
    } else {
      cur_away.n_skaters = 0;
      cur_away.goalie_id = NA_INTEGER;
    }

    SET_VECTOR_ELT(home_skater_ids, idx, cur_home.n_skaters ? make_player_vector(&cur_home, 0) : empty_int);
    SET_VECTOR_ELT(away_skater_ids, idx, cur_away.n_skaters ? make_player_vector(&cur_away, 0) : empty_int);
    SET_VECTOR_ELT(home_player_ids, idx, make_player_vector(&cur_home, 1));
    SET_VECTOR_ELT(away_player_ids, idx, make_player_vector(&cur_away, 1));
    SET_VECTOR_ELT(home_goalie_ids, idx, make_goalie_list_elt(cur_home.goalie_id, na_int_scalar));
    SET_VECTOR_ELT(away_goalie_ids, idx, make_goalie_list_elt(cur_away.goalie_id, na_int_scalar));
    SET_VECTOR_ELT(
      home_elapsed_shift,
      idx,
      (cur_home.n_skaters || !is_na_int(cur_home.goalie_id)) ? make_time_vector(&cur_home, 1, t, 0) : empty_real
    );
    SET_VECTOR_ELT(
      away_elapsed_shift,
      idx,
      (cur_away.n_skaters || !is_na_int(cur_away.goalie_id)) ? make_time_vector(&cur_away, 1, t, 0) : empty_real
    );
    SET_VECTOR_ELT(
      home_since_last,
      idx,
      (cur_home.n_skaters || !is_na_int(cur_home.goalie_id)) ? make_time_vector(&cur_home, 1, t, 1) : empty_real
    );
    SET_VECTOR_ELT(
      away_since_last,
      idx,
      (cur_away.n_skaters || !is_na_int(cur_away.goalie_id)) ? make_time_vector(&cur_away, 1, t, 1) : empty_real
    );

    prev_home = cur_home;
    prev_away = cur_away;
  }

  out = PROTECT(allocVector(VECSXP, 10)); protect_n++;
  out_names = PROTECT(allocVector(STRSXP, 10)); protect_n++;
  SET_VECTOR_ELT(out, 0, home_player_ids);
  SET_VECTOR_ELT(out, 1, away_player_ids);
  SET_VECTOR_ELT(out, 2, home_skater_ids);
  SET_VECTOR_ELT(out, 3, away_skater_ids);
  SET_VECTOR_ELT(out, 4, home_goalie_ids);
  SET_VECTOR_ELT(out, 5, away_goalie_ids);
  SET_VECTOR_ELT(out, 6, home_elapsed_shift);
  SET_VECTOR_ELT(out, 7, away_elapsed_shift);
  SET_VECTOR_ELT(out, 8, home_since_last);
  SET_VECTOR_ELT(out, 9, away_since_last);
  SET_STRING_ELT(out_names, 0, mkChar("homePlayerIds"));
  SET_STRING_ELT(out_names, 1, mkChar("awayPlayerIds"));
  SET_STRING_ELT(out_names, 2, mkChar("homeSkaterPlayerIds"));
  SET_STRING_ELT(out_names, 3, mkChar("awaySkaterPlayerIds"));
  SET_STRING_ELT(out_names, 4, mkChar("homeGoaliePlayerId"));
  SET_STRING_ELT(out_names, 5, mkChar("awayGoaliePlayerId"));
  SET_STRING_ELT(out_names, 6, mkChar("homeSecondsElapsedInShift"));
  SET_STRING_ELT(out_names, 7, mkChar("awaySecondsElapsedInShift"));
  SET_STRING_ELT(out_names, 8, mkChar("homeSecondsElapsedInPeriodSinceLastShift"));
  SET_STRING_ELT(out_names, 9, mkChar("awaySecondsElapsedInPeriodSinceLastShift"));
  setAttrib(out, R_NamesSymbol, out_names);

  UNPROTECT(protect_n);
  return out;
}
