# STATUS

**Last updated:** 2026-06-23
**State:** Core source/data records verified; first reproducible `languageR::dative` inspection, baseline/null, and hierarchical partial-pooling scripts added and run. No raw data committed.
**Next action:** Interpret the stable model contrasts for the manuscript outline, then decide whether to add Bayesian priors or keep the first paper route frequentist-plus-generative-checks.
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
- Added `notes/analysis-plan.md` after Roughdraft review. It predeclares the primary outcome, model sequence, null comparisons, model checks, robustness grid, and falsification conditions before baseline fitting.
- Added shared loader `analysis/lib_languageR_dative.R` and baseline script `analysis/02_baseline_languageR_dative.R`.
- First baseline run uses a fixed seed (`20260623`) and verb-stratified train/test split (2,637 train, 626 test). Test log loss/AUC: marginal null 0.554/0.500; length-only 0.436/0.829; verb-only 0.413/0.791; non-verb main model 0.271/0.932; fixed-verb full model 0.234/0.951. Scrambled fixed-verb null falls to 0.581/0.488. Noise predictor does not improve the non-verb model on held-out log loss.
- Added `analysis/03_hierarchical_languageR_dative.R` using `lme4::glmer` for a varying-verb-intercept logistic model. Test log loss/AUC: hierarchical verb-intercept model 0.233/0.952, essentially matching the fixed-verb full model with far fewer effective parameters. Estimated verb random-intercept SD is 2.106. Scrambled and fake-null hierarchical fits collapse to singular zero-verb-variance models, while the fake verb-effect check recovers a nonzero verb SD (0.826).
- Ran the central LaTeX style linter with strict checks: no violations found.
- Built successfully with XeLaTeX/Biber/XeLaTeX/XeLaTeX; final log scan found no undefined citations, no overfull boxes, and no empty bibliography warnings.
