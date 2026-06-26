# Major Revision Response Plan

Review target: the pasted major-revision report on the current dative-alternation manuscript.

Working judgement: accept the review's core diagnosis. The paper's architecture is good, but the empirical spine needs a cleaner evaluation design before the strongest claims are publishable.

## Load-Bearing Assumptions To Test First

1. **BNC2014 grouping identifiers may not be available in the released final CSV.**
   - Current evidence: the released 44-column CSV has rich speaker metadata but no obvious speaker ID, text ID, or conversation ID.
   - Falsification condition: the Figshare scripts or supporting files contain recoverable row-level speaker/text/conversation IDs that can be joined back to the final data.
   - Consequence if false: use grouped folds and cluster bootstrap.
   - Consequence if true: do not pretend to have grouped resampling; use paired same-row comparisons and explicitly state that dependence structure remains a limitation of the released file.

2. **The native BNC2014 comparison can be repaired without changing the paper's central claim.**
   - Current problem: transported predictions are scored on all 1,621 complete rows, while native predictions are scored on a 322-row holdout.
   - Required repair: generate native out-of-fold predictions for the same 1,621 rows and compare paired per-row losses against the fixed source-trained model.
   - Falsification condition: native out-of-fold results no longer clearly beat the transported model or the transported model no longer clearly beats source marginal/verb-only baselines.
   - Consequence: revise the empirical claim downward rather than forcing the old contrast.

3. **"What transports" is not identified by the current full model alone.**
   - Current problem: strong performance may be driven partly by shared six-verb lexical base rates.
   - Required repair: add marginal, verb-only, non-verb, and full source-trained models, plus native analogues scored on the same rows.
   - Falsification condition: non-verb transport performs weakly while verb-only performs most of the work.
   - Consequence: state that lexical base-rate ordering transports more strongly than the broader structural profile.

4. **DAIS item-level repetition changes the mixed-model interpretation.**
   - Current problem: the participant-level model has participant and verb random intercepts but no item random intercept.
   - Required repair: use item as a crossed random intercept, preferably with verb as fixed effect because there are only six verbs.
   - Falsification condition: the production-score coefficient shrinks further or becomes unstable once item is included.
   - Consequence: frame the bridge as marginal rank correspondence plus shared manipulation sensitivity, not incremental validation of production probabilities.

5. **The conceptual argument does not need ontically graded grammaticality.**
   - Current risk: the manuscript makes graded grammaticality sound like an empirical conclusion from graded production/preference evidence.
   - Required repair: shift to graded evidence for licensing while remaining neutral about whether the underlying status is categorical, multidimensional, or graded.

## Revision Sequence

### Phase 1: Repair BNC2014 Evaluation

Create a new analysis script, probably `analysis/10_bnc2014_paired_transport_cv.R`, rather than overloading the existing first-pass transport script.

The script should:

1. Reuse the same validated Figshare download and harmonization decisions.
2. Write a compact model-specification table for all formulas:
   - source marginal;
   - source verb-only;
   - source non-verb;
   - source full core;
   - source full plus recipient-definiteness proxy as sensitivity only;
   - native marginal;
   - native verb-only;
   - native non-verb;
   - native full core.
3. Score all source-trained models on the same BNC2014 complete-case rows.
4. Generate BNC2014-native out-of-fold predictions for every complete-case row using repeated or fixed \(K\)-fold cross-validation.
5. If real speaker/conversation grouping is recoverable, use it. If not, use verb-stratified folds and explicitly label the procedure as row-level because the released file lacks cluster IDs.
6. Compare transported and native predictions with paired per-row loss differences on identical rows.
7. Add paired intervals for log-loss differences and paired AUC comparisons if feasible. At minimum, write paired loss-difference bootstrap intervals.
8. Add calibration intercept/slope checks:
   - intercept-only recalibration of the source full model on BNC2014;
   - intercept-plus-slope recalibration;
   - report whether the source model mainly has a prevalence shift or a slope/calibration-scale problem.

Expected outputs:

- `bnc2014_paired_transport_cv_metrics.csv`
- `bnc2014_paired_transport_cv_loss_differences.csv`
- `bnc2014_paired_transport_cv_calibration.csv`
- `bnc2014_model_specifications.csv`
- revised Figure 1 data with both panels on the same target rows

### Phase 2: Missingness And Harmonization Table

Add a focused missingness/harmonization script or extend `analysis/09_bnc2014_metadata_scope.R`.

Outputs should include:

1. Predictor mapping table:
   - languageR field;
   - BNC2014 field or derivation;
   - recoding;
   - missing rows;
   - whether it enters the headline model or sensitivity model.
2. Missingness by:
   - variable;
   - verb;
   - pattern;
   - available metadata fields if useful.
3. A reduced all-row transport check using only common predictors that are reliably observed in both corpora. This will likely be a much smaller formula, not a replacement headline model.

Interpretive rule: keep the current imputation checks only as crude sensitivity checks, or remove them if the reduced all-row check is clearer.

### Phase 3: Repair DAIS Mixed Model

Modify `analysis/08_dais_acceptability_bridge.R`.

Preferred model:

```r
DOpreference_01 ~ production_np_prob + recipient_id + theme_type + Verb +
  (1 | participant_id) + (1 | item_id)
```

where `item_id` is the constructed pair identifier.

Also write:

- an item-level calibration regression or paired difference summary;
- uncertainty for the mean production-minus-DAIS difference;
- a table or summary that explicitly names the Table 3 difference as `production_minus_DAIS`;
- model diagnostics and warnings.

Interpretive target:

> DAIS preference and production probability show moderate marginal rank correspondence, much of which is attributable to shared sensitivity to the manipulated recipient and theme conditions; the production score contributes little additional information once those predictors are represented directly.

### Phase 4: Manuscript Revisions

Revise the manuscript after the new outputs exist.

Required changes:

1. Rename direct-replication language to **data reproduction and modern reanalysis**, unless a literal Bresnan et al. specification is added.
2. Add model formulas and preprocessing details:
   - predictors;
   - reference levels;
   - raw/log/centred/scaled lengths;
   - contrasts;
   - interactions, if any;
   - preprocessing learned in source and frozen for target;
   - packages, versions, seeds, and convergence criteria.
3. Replace the current transported-vs-native comparison with the paired same-row comparison.
4. Replace row-bootstrap "lucky split" language.
5. Decompose what transports via the ablation table.
6. Add the harmonization/missingness table.
7. Rewrite the DAIS paragraph around marginal correspondence plus limited incremental production-score contribution.
8. Moderate the graded-grammaticality claim:
   - replace ontic "the status is graded" with "the evidence supplies graded support for licensing";
   - distinguish production-profile projectibility from community licensing.
9. Replace "No amount of additional production data" with:
   > No amount of additional positive-token data collected under the same \(D_0\) design can, by itself, identify the grammatical-but-unattested region.
10. Consider deleting or softening the competence-performance paragraph and reframing the point as observational identification.
11. Add repository URL, release/commit hash placeholder, exact reproduction commands, seeds, checksums, and session info to the data/code statement or appendix note.
12. Replace "working result" in the abstract with a direct result statement.

### Phase 5: Figures And Presentation

Update `analysis/06_denominator_and_figure_candidates.py` after the new CSVs exist.

Figure repairs:

1. Figure 1: same target rows for transported and native panels.
2. Add uncertainty intervals to verb-level observed rates.
3. Avoid interpreting native verb panels with tiny fold counts.
4. Figure 3: relabel arrows as inferential, not causal.
5. Increase figure text/legend sizes if the rebuilt PDF shows readability problems.

### Phase 6: Verification And Ship

Run:

```bash
Rscript analysis/08_dais_acceptability_bridge.R
Rscript analysis/09_bnc2014_metadata_scope.R
Rscript analysis/10_bnc2014_paired_transport_cv.R
python3 analysis/06_denominator_and_figure_candidates.py
python3 /Users/brettreynolds/Documents/LLM-CLI-projects/.house-style/check-style.py main.tex
make
rg -n "undefined|Undefined|Citation .*undefined|Reference .*undefined|There were undefined|Overfull|Underfull|Rerun|Please rerun|Label\\(s\\) may have changed|empty bibliography|Warning:.*empty" main.log main.blg || true
git diff --check
```

Then decide whether to ship immediately or run another review board.

## Triage: What Not To Do Yet

- Do not build a large Bayesian workflow unless the repaired frequentist/CV design still leaves a specific uncertainty gap.
- Do not promise conversation-level BNC2014 resampling unless row-level identifiers are actually recoverable.
- Do not add a full literal Bresnan et al. reproduction unless changing terminology is insufficient for the target venue.
- Do not defend the old native-vs-transport comparison; replace it.
- Do not treat DAIS as validation of the production model.

## Immediate First Action After Approval

Audit the Figshare supporting scripts for recoverable speaker/text/conversation IDs. That determines whether the BNC2014 repair can satisfy the grouped-resampling recommendation or must explicitly state that the released dataset blocks it.
