# Data

Do not commit large raw datasets by default.

Expected workflow:

1. Verify the canonical source and licence.
2. Add a script or documented command to fetch/load the dataset.
3. Store small derived metadata tables in `data/derived/` only when useful for
   reproducibility.

Candidate sources are tracked in `../notes/source-verification.md`.

Current derived tables, when generated, are created by
`../analysis/01_inspect_languageR_dative.R`.
