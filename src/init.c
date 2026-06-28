/* Headers ------------------------------------------------------------- */

#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

/* Native Routine Declarations ---------------------------------------- */

SEXP nhlscraper_on_ice_shift_timings(SEXP data_list);
SEXP nhlscraper_pbp_deltas(SEXP data_list);
SEXP nhlscraper_pbp_shot_context(SEXP data_list);
SEXP nhlscraper_shift_situation_overlaps(SEXP data_list);

/* Native Routine Registration ---------------------------------------- */

static const R_CallMethodDef CallEntries[] = {
  {
    "nhlscraper_on_ice_shift_timings",
    (DL_FUNC) &nhlscraper_on_ice_shift_timings,
    1
  },
  {
    "nhlscraper_pbp_deltas",
    (DL_FUNC) &nhlscraper_pbp_deltas,
    1
  },
  {
    "nhlscraper_pbp_shot_context",
    (DL_FUNC) &nhlscraper_pbp_shot_context,
    1
  },
  {
    "nhlscraper_shift_situation_overlaps",
    (DL_FUNC) &nhlscraper_shift_situation_overlaps,
    1
  },
  {NULL, NULL, 0}
};

/* Package Entry Point ------------------------------------------------- */

void R_init_nhlscraper(DllInfo *dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
