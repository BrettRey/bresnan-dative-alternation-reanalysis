# Analysis

This directory is for reproducible analysis scripts or notebooks after source
verification.

Modelling commitments and null comparisons are predeclared in
`../notes/analysis-plan.md`.

Analysis sequence:

1. Load and audit `languageR::dative`.
2. Reproduce the original-style model.
3. Fit modern comparison and hierarchical models.
4. Treat the `languageR` result as robustness evidence, not the final
   contribution.
5. Inspect and harmonize BNC2014 before any transport model.
6. Test generalization to later datasets only after schema comparability is
   documented.

## Scripts

- `lib_languageR_dative.R`: shared helper for fetching the CRAN `languageR`
  source tarball and loading `dative.rda`.
- `01_inspect_languageR_dative.R`: downloads the CRAN `languageR` source
  tarball to a temporary directory, loads `dative.rda`, validates the expected
  dimensions, and writes small derived summary/schema tables to `data/derived/`.
- `02_baseline_languageR_dative.R`: fits marginal, structured, scrambled-label,
  noise-predictor, and fake-data baseline checks for `RealizationOfRecipient`;
  writes metrics, coefficient, warning, calibration, and diagnostic-figure
  outputs to `data/derived/`.
- `03_hierarchical_languageR_dative.R`: fits the first partial-pooling logistic
  model with varying verb intercepts using `lme4::glmer`; writes model metrics,
  fixed effects, verb effects, singular-fit diagnostics, predictive-check
  summaries, and diagnostic figures to `data/derived/`.

Run scripts from the repository root with `Rscript`.
