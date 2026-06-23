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
6. Fit the first BNC2014 transport model on documented shared features.
7. Test generalization to later datasets only after schema comparability is
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
- `04_inspect_bnc2014_dative.R`: downloads the public Figshare BNC2014 dative
  CSV to a temporary file, validates the Figshare MD5, resolves the line-count
  ambiguity, and writes source-file, schema, key-count, and verb-by-pattern
  summaries to `data/derived/`.
- `05_bnc2014_transport.R`: fits the first cross-corpus transport checks from
  spoken six-verb `languageR::dative` data to harmonized BNC2014 data, with
  BNC-native and scrambled-label comparisons.
- `06_denominator_and_figure_candidates.py`: generates house-style candidate
  figures for BNC2014 transport diagnostics and denominator framing from
  existing derived summaries.

Run scripts from the repository root with `Rscript`.
Run the figure-candidate script from the repository root with `python3`.
