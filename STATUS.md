# STATUS

**Last updated:** 2026-06-23
**State:** Core source/data records verified; first reproducible `languageR::dative` inspection script added and run. No raw data committed.
**Next action:** Fit the first baseline production-choice model for `RealizationOfRecipient`.
**Blocker:** DAIS repository licensing and BNC2014 row-count discrepancy need closer checks before those data are reused directly.

## Working Title

*Predicting grammatical possibility: The dative alternation after probabilistic grammar, open data, and neural language models*

## Working Thesis

Bresnan et al. made a durable methodological claim: probabilistic usage data can reveal grammatical possibilities that informal intuitions may miss. The update asks how stable that claim is under modern modelling, open-data replication, cross-corpus generalization, and the newer split between production probability and acceptability preference.

## Infrastructure

- Project path: `papers/bresnan-dative-alternation-reanalysis/`.
- `references.bib` is a symlink to the central `.house-style/references.bib`.
- `.house-style/preamble.tex` and `.house-style/style-rules.yaml` are symlinks to the central house-style files.
- There is no local house-style snapshot.
- Project-specific verified references belong in `references-local.bib`.
- Source-verification notes live in `notes/source-verification.md`.

## Session Notes

### 2026-06-23

- Created project scaffold from scratch rather than using `create-paper.sh`, because the template copies house-style files and Brett specified that this project must use the central house style strictly.
- Renamed the project folder to lower-case hyphenated form: `papers/bresnan-dative-alternation-reanalysis/`.
- Added section stubs, notes, data/analysis directories, Makefile, and project guidance.
- Seeded a pressure-test note around the load-bearing no-new-data assumptions.
- Created and pushed the public GitHub repository: <https://github.com/BrettRey/bresnan-dative-alternation-reanalysis>.
- Verified the core source/data trail in `notes/source-verification.md`: Bresnan et al. 2007, `languageR::dative`, Spoken BNC2014 dative data, DAIS/Hawkins et al. 2020, Bard et al. 1996, and later acceptability benchmarks.
- Chose `languageR::dative` as the first empirical target because it is the cleanest production-choice reanalysis path.
- Added `analysis/01_inspect_languageR_dative.R`, which fetches the CRAN source tarball to a temporary directory, loads `dative.rda`, validates dimensions, and writes derived summary/schema CSVs under `data/derived/`.
- First inspection output: 3,263 rows, 15 columns, 75 verb levels; NP = 2,414, PP = 849; spoken = 2,360, written = 903; `Speaker` is missing only for the 903 written rows.
- Ran the central LaTeX style linter with strict checks: no violations found.
- Built successfully with XeLaTeX/Biber/XeLaTeX/XeLaTeX; final log scan found no undefined citations, no overfull boxes, and no empty bibliography warnings.
