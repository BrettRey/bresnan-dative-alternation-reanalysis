# Data

Do not commit large raw datasets by default. Local raw-data staging directories
such as `data/raw/` and `data/external/` are ignored.

Expected workflow:

1. Verify the canonical source and licence.
2. Add a script or documented command to fetch/load the dataset.
3. Store small derived metadata tables in `data/derived/` only when useful for
   reproducibility.

Candidate sources are tracked in `../notes/source-verification.md`.

Current derived tables and figures, when generated, are created by:

- `../analysis/01_inspect_languageR_dative.R`
- `../analysis/02_baseline_languageR_dative.R`
- `../analysis/03_hierarchical_languageR_dative.R`
- `../analysis/04_inspect_bnc2014_dative.R`
- `../analysis/05_bnc2014_transport.R`
- `../analysis/06_denominator_and_figure_candidates.py`
- `../analysis/07_sampling_tilt_sensitivity.R`
- `../analysis/08_dais_acceptability_bridge.R`
- `../analysis/09_bnc2014_metadata_scope.R`

These are small summaries, diagnostics, and model outputs. They are not raw data
downloads.
