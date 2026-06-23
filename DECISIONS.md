# DECISIONS

2026-06-23 — Project form: create a standalone paper under `papers/bresnan-dative-alternation-reanalysis/`. Reason: the project is an empirical/methodological update of a classic probabilistic-grammar result, not merely a subchapter of *(Un)grammatical*.

2026-06-23 — Working title: *Predicting grammatical possibility: The dative alternation after probabilistic grammar, open data, and neural language models*. Reason: this captures the bridge between usage probability, grammatical possibility, open reanalysis, and later model/acceptability resources.

2026-06-23 — Infrastructure: use central `references.bib` and central `.house-style/` files strictly by symlink, with no local house-style snapshot. Reason: Brett explicitly specified that the house style should be strictly central.

2026-06-23 — Citation discipline: do not add project-local bibliography entries or cite dataset resources in final prose until the source and data locations have been verified against authoritative pages or package documentation. Reason: the project turns on reusability of existing data, so the data trail is load-bearing.

2026-06-23 — Setup scope: scaffold the project and capture the research plan, assumptions, and verification queue; do not download datasets or run analyses during setup. Reason: the first empirical decision should follow source/data verification, not the seed note alone.

2026-06-23 — Repository visibility: create a public GitHub repository at `BrettRey/bresnan-dative-alternation-reanalysis`. Reason: the project is intended as an open, reproducible no-new-data reanalysis.

2026-06-23 — First empirical target: start with `languageR::dative`, not BNC2014 or DAIS. Reason: CRAN verifies a 3,263-row, 15-column production-choice dataset tied directly to Bresnan et al.; BNC2014 is a cross-corpus transport target with a row-count discrepancy to reconcile, and DAIS is an acceptability/preference benchmark rather than production-token evidence.

2026-06-23 — Analysis discipline: write a pre-model analysis plan before baseline fitting. Reason: the project has enough plausible modelling forks that model sequence, null comparisons, robustness grid, and falsification conditions should be fixed before interpreting results. The plan includes marginal, structured, scrambled-label, noise-predictor, and fake-data null checks.

2026-06-23 — Baseline split and nulls: use a fixed seed (`20260623`) and a verb-stratified train/test split for the first baseline script, keeping every verb represented in training. Reason: fixed verb-effect models otherwise risk predictable held-out failures for verbs observed only in the test set. The first baseline comparison reports marginal, modality-only, length-only, verb-only, non-verb, fixed-verb, noise-predictor, scrambled-label, and fake-data checks.
