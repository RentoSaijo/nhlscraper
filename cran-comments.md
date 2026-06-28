## R CMD check results

0 errors | 0 warnings | 0 notes

## Resubmission

This resubmission reduces the source tarball by removing large XGBoost booster
files from `inst/extdata`. The package now ships only the small frozen xG
metadata/preprocessing bundle and downloads required versioned boosters from the
companion NHLxG model store (on HuggingFace) into the user's R cache on first use.
