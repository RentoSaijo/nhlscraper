#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

SEXP nhlscraper_on_ice_shift_timings(SEXP data_list);
SEXP nhlscraper_pbp_deltas(SEXP data_list);
SEXP nhlscraper_pbp_shot_context(SEXP data_list);

static const R_CallMethodDef CallEntries[] = {
  {"nhlscraper_on_ice_shift_timings", (DL_FUNC) &nhlscraper_on_ice_shift_timings, 1},
  {"nhlscraper_pbp_deltas", (DL_FUNC) &nhlscraper_pbp_deltas, 1},
  {"nhlscraper_pbp_shot_context", (DL_FUNC) &nhlscraper_pbp_shot_context, 1},
  {NULL, NULL, 0}
};

void R_init_nhlscraper(DllInfo *dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
