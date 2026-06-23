# STATUS

**Last updated:** 2026-06-23
**State:** Core source/data records verified; reproducible `languageR::dative` inspection, baseline/null, hierarchical partial-pooling, BNC2014 inspection, harmonization, first BNC2014 transport checks, and a source-grounded results-spine manuscript draft are now in place. No raw data committed.
**Next action:** Do a prose-level polish pass over the draft, then decide whether the transport section needs one compact figure or whether the tables are enough for the first circulation draft.
**Blocker:** None for the current paper stage. DAIS data reuse remains out of scope unless its licensing is clarified.

## Working Title

*Production probability, transport, and grammatical possibility: Reanalysing the
English dative alternation with open data*

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
- Added `notes/pivot-after-languageR.md` after Roughdraft review. Decision: the `languageR` stage is a clean robustness result, not the paper's center of gravity. Stop same-data refinement and move to BNC2014 transport plus an explicit production/possibility distinction.
- Added `notes/next-steps-after-pivot.md` after Roughdraft review. It sets the immediate sequence: inspect BNC2014, write a harmonization note, write the production/possibility-gap note, and only then fit a transport model.
- Softened the title after Roughdraft review: removed the neural-language-model promise and recentered production probability, transport, and grammatical possibility.
- Added `analysis/04_inspect_bnc2014_dative.R`, which validates the public Figshare BNC2014 dative CSV by MD5, parses it from a temporary file, and writes small derived source-file, schema, key-count, and verb-by-pattern summaries. It resolves the apparent row-count issue: the CSV has 1,839 parsed data rows and 44 columns; the raw file has 1,839 newline characters because it lacks a terminal newline.
- Added `notes/bnc2014-harmonization.md`. Decision: BNC `VNN` maps to `languageR` `NP`, BNC `VNPP` maps to `languageR` `PP`; transport should use the six shared verbs, derive word-length proxies in memory, and drop discourse accessibility.
- Added `notes/production-possibility-gap.md` to keep the paper's claims separated across production choice, acceptability preference, and grammatical possibility. DAIS/NLMs remain a possible bridge, not a promised title-level result.
- Added `analysis/05_bnc2014_transport.R` and `notes/bnc2014-transport-results.md`. First result: the spoken six-verb `languageR` core model transports to BNC2014 well above marginal baseline (log loss 0.308 vs 0.473; AUC 0.906 vs 0.500), collapses against a scrambled BNC outcome (log loss 0.885; AUC 0.515), and is still weaker than a BNC-native holdout model (log loss 0.202; AUC 0.960). The recipient-definiteness proxy worsens transport log loss and should remain a sensitivity check.
- Replaced section stubs with first-pass manuscript prose for the problem, original target, data/replication, modern modelling, BNC2014 transport, grammatical possibility, and conclusion sections.
- Added verified local bibliography entries for `languageR`, the Figshare BNC2014 dataset, and the Journal of Open Humanities Data article.
- Added a source-grounding pass over the DAIS/acceptability bridge: Hawkins et al. 2020 is now cited, but DAIS is not fetched, analyzed, or redistributed because the public repository has no explicit licence file. DAIS remains background/future bridge evidence, not part of the current empirical result.
- Imported the useful lesson from the left-branch-extraction paper: make the corpus denominator explicit. The dative models estimate conditional production choice inside attested dative-alternation tokens, not all possible contexts where a transfer event could have been expressed.
- Ran the central LaTeX style linter with strict checks: no violations found.
- Built successfully with XeLaTeX/Biber/XeLaTeX/XeLaTeX; final log scan found no undefined citations, no overfull boxes, and no empty bibliography warnings.
- Applied the first-use initialism policy across the manuscript draft: corpus names, table metrics, pattern codes, licensing shorthand, and project placeholders now spell out their terms before using abbreviated forms.
