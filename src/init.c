#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

SEXP nhlscraper_add_on_ice_players_resolve(SEXP data_list);

static const R_CallMethodDef CallEntries[] = {
  {"nhlscraper_add_on_ice_players_resolve", (DL_FUNC) &nhlscraper_add_on_ice_players_resolve, 1},
  {NULL, NULL, 0}
};

void R_init_nhlscraper(DllInfo *dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
