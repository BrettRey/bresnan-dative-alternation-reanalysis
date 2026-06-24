# STATUS

**Last updated:** 2026-06-24
**State:** Results-spine draft complete and stress-tested. A 5-referee review board ran and its findings were actioned: transport now positioned against Bresnan & Ford 2010 and Röthlisberger et al. 2017, bootstrap test-set CIs added (transport complete-case 0.308 [0.277, 0.337]; native complete-case 0.202 [0.154, 0.254], non-overlapping), projectibility cashed out (Boyd "for a purpose"), grammaticality construct cited (Pullum, Nefdt) instead of stipulated, structural-blindness named against competence/performance (Chomsky 1965, Miller 1963). Full numbers audit: 60/60 PASS against source. Sampling-scope audit now narrows the transport claim to the six-verb high-frequency core and labels the BNC2014 headline metrics as complete-case rows; all-row imputation sensitivity is reproducible in `analysis/07_sampling_tilt_sensitivity.R`. Abstract reframed through scoped projectibility. No raw data committed.
**Next action:** On Hawkins's DAIS licensing reply, add one production/acceptability divergence case (or reframe §6 explicitly as a position section); until then, polish only. Optional later: re-run the board on the revised draft.
**Blocker:** DAIS acceptability leg blocked on Robert Hawkins's licensing reply (email sent 2026-06-23, cc Goldberg). The repo has no licence file, so DAIS stays uncited-for-reuse until clarified.

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
- Clarified source provenance: `languageR::dative` is rooted in American Switchboard telephone data and Wall Street Journal Treebank data, while the BNC2014 dative target is British spoken Early-Access Subset data from 2012-2014. The manuscript now treats the comparison as out-of-domain transport, not direct replication.
- Imported two framing lessons from Brett's grammaticality/homeostatic property cluster (HPC) and difference-in-differences (DiD) work: treat judgements as detector-channel evidence rather than grammaticality itself, and treat transport diagnostics as bounded disqualification checks rather than identification of a single variety, period, register, or annotation effect.
- Filed Cai et al. (2026), Nature, as background only. Central note: `../../literature/cai_etal_2026_neuronal_language_models.notes.md`. It supports the broader cross-level projectibility vocabulary, but it should not enter the current dative draft unless a reviewer asks for neural/model-grounding context. This paper remains about production-choice probabilities, cross-corpus transport, and grammatical possibility, not neural encoding or acceptability.
- Added `notes/denominator-recovery-and-figures.md` after Roughdraft review. Decision: the missing denominator is estimable only after nesting the denominators (released NP/PP rows, six-verb candidate tokens, transfer-event expressions, constructed judgement alternatives); the BNC2014 D1 denominator is probably recoverable only if source queries or prefiltered concordance files can be reconstructed.
- Added `analysis/06_denominator_and_figure_candidates.py`, which imports the central house-style matplotlib settings and writes PDF/PNG candidate figures from existing derived summaries. Inserted the verb-level BNC2014 calibration figure and the nested opportunity-set figure into the manuscript.
- Revised the grammaticality section to use Brett's current target definition: grammaticality is a community-conditioned licensing status for form-value/form-meaning relations, stabilized by cognitive and social mechanisms. Judgements are noisy, role-dependent instruments; corpus frequency and acceptability are evidence channels rather than the target.

### 2026-06-23 Session Notes (evening)

- Ran an iteration checkpoint, then a 5-referee review board (Claude/Opus): cross-variety probabilistic-grammar, quantitative-methods, acceptability, projectibility, and contribution-sceptic seats. Outputs in `reviews/review-board-20260623-174025/`. Verdicts: 4 R&R, 1 reject-and-reframe. Brett chose "one paper, fix the spine."
- Refuted the board's most confident finding by source-checking: Reviewer 2's "length harmonization bug" is not a bug. The Journal of Open Humanities Data data dictionary defines `RecLen`/`ThemeLen` as character counts, so re-tokenizing to words is the correct harmonization. Clarified section 05 prose and cited the data dictionary; left the working code unchanged.
- Positioned the transport result against prior cross-variety work: added source-verified entries `BresnanFord2010` (Language 86(1):168--213; start page confirmed off the printed PDF, author's webpage 186--213 is a typo) and `RothlisbergerGrafmillerSzmrecsanyi2017` (Cognitive Linguistics 28(4):673--710). Section 05 now concedes the stability echoes them and locates the contribution in the transport test plus the production/possibility framing.
- Added percentile-bootstrap test-set CIs (`bootstrap_metric_ci` in the loader; output `bnc2014_transport_bootstrap.csv`): transport 0.308 [0.277, 0.337] / AUC 0.906 [0.890, 0.922]; native 0.202 [0.154, 0.254] / AUC 0.960 [0.938, 0.979]. Non-overlapping, so the gap is beyond split noise. Point estimates reproduced exactly.
- Made projectibility do real work in section 06 (Boyd's "projectible for a purpose"; cited Goodman 1955, boyd1999), cited the grammaticality construct (pullum2019-normativity, nefdt2023) instead of stipulating it, and named what "structural blindness" adds beyond competence/performance (chomsky1965, Miller1963: a measurable, channel-specific boundary). `/check-hpc` now GREEN where it was decorative. NB: the bib's Miller entries are George Miller (1963) and J.T.M. Miller (2021), not Philip Miller.
- Corrected the DAIS figure to 50,000 judgements over 5,000 pairs. Reframed the abstract through projectibility-for-a-purpose and synced the keyword lines (added projectibility).
- Independent numbers audit: 60/60 claims PASS against source CSVs, 0 mismatch, 0 unverifiable (`reviews/review-board-20260623-174025/numbers-audit.md`).
- Sent the DAIS licensing email to Robert Hawkins (Stanford Linguistics), cc Goldberg; draft kept local and gitignored. The DAIS acceptability leg is now the sole open blocker.

### 2026-06-24

- Added `notes/sampling-tilt-audit-2026-06-24.md` after Roughdraft review. Finding: the result should be treated as a complete-case high-frequency-core transport result, not an all-row BNC2014 or whole-alternation result.
- Added `analysis/07_sampling_tilt_sensitivity.R`, writing `data/derived/sampling_tilt_scope_summary.csv` and `data/derived/sampling_tilt_sensitivity_metrics.csv`. The script fetches public data to temp files only.
- Revised the abstract, Section 05, Section 06, and conclusion to state the six-verb scope, the 1,621/1,839 BNC2014 complete-case frame, the PP-heavy missing-row imbalance, and all-row imputation sensitivity.
- Verification: `Rscript analysis/07_sampling_tilt_sensitivity.R`, central `check-style.py main.tex`, and `make` all ran successfully. Final log scan found no overfull/underfull boxes or undefined references; only the pre-existing `fancyhdr` headheight warning remains.
