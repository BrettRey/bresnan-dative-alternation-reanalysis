# DECISIONS

2026-06-23 — Project form: create a standalone paper under `papers/bresnan-dative-alternation-reanalysis/`. Reason: the project is an empirical/methodological update of a classic probabilistic-grammar result, not merely a subchapter of *(Un)grammatical*.

2026-06-23 — Initial working title, later superseded: *Predicting grammatical possibility: The dative alternation after probabilistic grammar, open data, and neural language models*. Reason: this captured the first bridge between usage probability, grammatical possibility, open reanalysis, and later model/acceptability resources before the project pivot.

2026-06-23 — Infrastructure: use central `references.bib` and central `.house-style/` files strictly by symlink, with no local house-style snapshot. Reason: Brett explicitly specified that the house style should be strictly central.

2026-06-23 — Citation discipline: do not add project-local bibliography entries or cite dataset resources in final prose until the source and data locations have been verified against authoritative pages or package documentation. Reason: the project turns on reusability of existing data, so the data trail is load-bearing.

2026-06-23 — Setup scope: scaffold the project and capture the research plan, assumptions, and verification queue; do not download datasets or run analyses during setup. Reason: the first empirical decision should follow source/data verification, not the seed note alone.

2026-06-23 — Repository visibility: create a public GitHub repository at `BrettRey/bresnan-dative-alternation-reanalysis`. Reason: the project is intended as an open, reproducible no-new-data reanalysis.

2026-06-23 — First empirical target: start with `languageR::dative`, not BNC2014 or DAIS. Reason: CRAN verifies a 3,263-row, 15-column production-choice dataset tied directly to Bresnan et al.; BNC2014 is a cross-corpus transport target whose row count was then still unreconciled, and DAIS is an acceptability/preference benchmark rather than production-token evidence.

2026-06-23 — Analysis discipline: write a pre-model analysis plan before baseline fitting. Reason: the project has enough plausible modelling forks that model sequence, null comparisons, robustness grid, and falsification conditions should be fixed before interpreting results. The plan includes marginal, structured, scrambled-label, noise-predictor, and fake-data null checks.

2026-06-23 — Baseline split and nulls: use a fixed seed (`20260623`) and a verb-stratified train/test split for the first baseline script, keeping every verb represented in training. Reason: fixed verb-effect models otherwise risk predictable held-out failures for verbs observed only in the test set. The first baseline comparison reports marginal, modality-only, length-only, verb-only, non-verb, fixed-verb, noise-predictor, scrambled-label, and fake-data checks.

2026-06-23 — First partial-pooling model: fit a logistic GLMM with the non-verb predictors and varying intercepts for `Verb` using `lme4::glmer`. Reason: verb effects are linguistically central but fixed verb effects spend 75 parameters and do not generalize as gracefully; partial pooling tests whether lexical conditioning remains strong under regularized verb-level estimation.

2026-06-23 — Pivot after `languageR`: stop adding further same-data refinements unless a specific diagnostic failure demands it. Reason: the current results show that modern modelling and partial pooling preserve Bresnan et al.'s production-choice conclusion rather than changing it. The paper's contribution must now come from transport across BNC2014 and the production/possibility distinction, not from a sixth model on `languageR::dative`.

2026-06-23 — Softened title: *Production probability, transport, and grammatical possibility: Reanalysing the English dative alternation with open data*. Reason: the previous title overpromised neural language model analysis and made grammatical possibility sound more direct than the current evidence supports. The new title foregrounds the actual spine: production-choice robustness, transport across datasets, and the production/possibility boundary.

2026-06-23 — BNC2014 row count resolved: treat the Figshare CSV as 1,839 parsed data rows and 44 columns. Reason: `analysis/04_inspect_bnc2014_dative.R` validates the public file by MD5 and shows that the raw file has 1,839 newline characters but no terminal newline, giving 1,840 logical text lines including the header. The old `wc -l` discrepancy is not an observation-count discrepancy.

2026-06-23 — BNC2014 transport gate: fit transport only on documented comparable features. Reason: `notes/bnc2014-harmonization.md` shows that outcome and verb are comparable with restrictions, but length fields require in-memory word-count proxies, recipient definiteness is only derivable by proxy, and discourse accessibility is unavailable. The first transport model should not pretend the two schemas are identical.

2026-06-23 — First BNC2014 transport result: treat the core transport model as positive but partial evidence of cross-corpus projectibility. Reason: the spoken six-verb `languageR` model improves substantially over a marginal BNC baseline on BNC2014 (log loss 0.308 vs 0.473; AUC 0.906 vs 0.500) and collapses against a scrambled BNC outcome, but a BNC-native holdout model remains stronger (log loss 0.202; AUC 0.960). Recipient definiteness should stay a sensitivity check because the BNC proxy worsens transport log loss.

2026-06-23 — Manuscript drafting sequence: write the robustness-plus-transport results spine before adding any DAIS or neural-language-model material. Reason: the current evidence already supports a clean claim about production probability and transport, while acceptability data would answer a different question and should enter only as a deliberately scoped bridge.

2026-06-23 — DAIS scope: cite Hawkins et al. 2020 as the acceptability/preference bridge, but do not fetch, analyze, or redistribute DAIS files in this repo. Reason: DAIS answers a judgement-preference question rather than a production-token question, and the public `taka-yamakoshi/neural_constructions` repository has no explicit licence file.

2026-06-23 — Opportunity-set discipline: import the denominator lesson from the left-branch-extraction paper. Reason: `languageR::dative` and BNC2014 estimate conditional choice inside attested dative-alternation tokens; they do not sample all contexts where a transfer event could have been expressed, omitted, paraphrased, or judged acceptable.

2026-06-23 — Initialism policy: spell out initialisms at first use in manuscript prose, including table metrics, pattern codes, corpus names, licence names, and infrastructure labels. Reason: the paper should not assume that readers know project shorthand.
