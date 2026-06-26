# Claude-only review-board synthesis

Run directory: `reviews/review-board-20260626-055109`

Reviewers: Bresnan standpoint, Grieve standpoint, Gelman standpoint, Gries
standpoint, Sprouse/acceptability standpoint, and projectibility/contribution
sceptic standpoint. These are simulated standpoint reviews, not claims that the
named scholars reviewed the manuscript.

All six reviewers returned **Revise & Resubmit**. The shared view is that the
paper has a publishable methodological core, but several claims need one more
round of tightening before submission.

## Consensus Strengths

- The board strongly endorsed the estimand discipline. Multiple reviewers
  singled out the explicit quantity
  `P(NP recipient | token entered the annotated NP/PP dative sample)` and the
  opportunity-set figure as the manuscript's strongest contribution.
- The paired same-row BNC2014 evaluation was treated as a real advance over a
  single concordance/AUC report. Reviewers liked the combination of log loss,
  calibration, target-native benchmark, and predictor-group ablation.
- The manuscript's candour about data limitations was repeatedly praised:
  outcome-skewed missingness, lack of recoverable speaker/conversation IDs,
  row-level intervals, and the warning against broad British-English population
  claims.
- The production/judgement separation was seen as methodologically correct.
  Reviewers appreciated that the DAIS bridge does not simply call a production
  model "validated" by acceptability judgements.

## Consensus Weaknesses

- The paper demonstrates prediction transport better than grammar transport.
  Several reviewers asked for coefficient-level or predictor-level evidence:
  do the individual constraints retain direction and rough magnitude in the
  native BNC2014 model, or is the aggregate non-verb performance hiding
  reweighted predictors?
- The source-target contrast still reads too much like American vs. British
  English. Grieve and Gries-style reviews stressed that Switchboard
  telephone-stranger talk and BNC2014 intimate face-to-face conversation bundle
  variety, period, register, annotation, and social composition.
- The row-level native benchmark has an asymmetric bias. Because native BNC2014
  folds can leak conversation- or speaker-homogeneous structure while the
  frozen source model cannot, the native advantage is probably optimistic, not
  merely accompanied by too-narrow intervals.
- AUC reporting is not fully harmonized. The table mixes pooled source AUC with
  fold-averaged native AUC, while the textual AUC gap comes from a matched
  fold-level comparison not shown directly in the table.
- The DAIS bridge is under-controlled for its own calibration logic. The raw
  `offer` gap may not be the largest calibration residual once DAIS preference
  is regressed on production probability; reviewers also asked for response
  format, link function, item uncertainty/reliability, and clearer status for
  the bridge.
- The validation ladder needs positioning. Reviewers flagged that calibration
  intercept/slope and external-validation logic have a prior literature, and
  that the opportunity-set argument should be connected to the envelope of
  variation / principle of accountability tradition.

## Contradictions And Tensions

- Some reviewers want the DAIS bridge promoted because the near-zero
  incremental production-score coefficient directly supports the
  evidence-channel argument. The Sprouse-style review wants the current
  `offer` example weakened or recalibrated before it does any main-text work.
  The resolution is not obvious: either promote DAIS with a stronger model, or
  keep it supplementary and stop leaning on `offer`.
- The non-lexical transport result is simultaneously the paper's strongest
  projectible finding and a dangerous overclaim. It is persuasive within the
  six-verb high-frequency core, but reviewers warned against projecting it to
  lexical conditioning generally or to other alternations without a stated
  conjecture.
- The row-level CV limitation cuts both ways. The manuscript is praised for
  admitting it, but the Gelman-style review argues that the consequence is not
  just interval width: it can bias the native model's point performance upward.
- The board converges strongly on the estimand/opportunity-set contribution.
  Treat that as a useful stress-test signal, not evidence of actual field
  consensus. The slate also omitted full Baayen and Hay seats in order to keep
  the board to six reviewers while adding Grieve.

## Prioritized Revision List

1. **Add constraint-level transport evidence.** Report source and native
   coefficient signs/magnitudes, or individual predictor ablations, for length,
   pronominality, animacy, definiteness, and verb. This is the direct answer to
   "does the grammar/conditioning profile transport, or only the predictions?"

2. **Reframe the target contrast as corpus-to-corpus transport.** Foreground
   Switchboard telephone-stranger talk vs. BNC2014 intimate face-to-face talk,
   and avoid treating the residual gap as American-vs-British grammar. Add a
   brief descriptive check of BNC2014 outcome by available social/contextual
   metadata if feasible.

3. **Tighten the BNC2014 evaluation table.** Show the matched fold-level source
   AUC used for the AUC difference, label pooled vs. fold-averaged AUCs, state
   that repeated OOF averaging mildly favours native predictions, and name the
   asymmetric row-level-CV leakage risk.

4. **Add a compact harmonization/interchangeability audit.** Go beyond outcome
   mapping (`VNN`/`VNPP`) to compare extraction criteria, predictor definitions,
   predictor distributions, and length scale. At minimum, state annotation
   non-equivalence as an alternative source of the native calibration advantage.

5. **Rework the DAIS bridge.** State the response format and link function;
   report calibration residuals rather than only raw production-minus-DAIS
   gaps; add item uncertainty or reliability where possible; and decide whether
   DAIS is a supplementary illustration or part of the main evidence.

6. **Clarify the contribution's ancestry and forward payoff.** Credit the
   external-validation literature for calibration/recalibration tools and the
   variationist envelope-of-variation tradition for denominator discipline.
   Then state exactly what the validation ladder predicts or licenses for
   future alternation studies, without over-projecting from one case.
