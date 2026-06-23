# Reviewer 2 — Quantitative methods (statistics referee)

Reynolds, "Production probability, transport, and grammatical possibility:
Reanalysing the English dative alternation with open data."

Stance: Baayen/Gelman quantitative hardnose. Inference with honest uncertainty,
cross-validation as inference rather than decoration, and measurement that does
not silently degrade before it travels.

Numbers below were checked against `data/derived/bnc2014_transport_metrics.csv`,
`languageR_dative_baseline_metrics.csv`,
`languageR_dative_hierarchical_metrics.csv`,
`languageR_dative_hierarchical_diagnostics.csv`,
`bnc2014_transport_coefficients.csv`,
`bnc2014_transport_calibration_by_verb.csv`,
`bnc2014_transport_feature_coverage.csv`, `bnc2014_dative_columns.csv`, and
the scripts `02_baseline`, `03_hierarchical`, `05_bnc2014_transport.R`,
`lib_languageR_dative.R`. Every headline figure in the manuscript reconciles
with the source files; I flag explicitly the one place where the prose
description of a procedure does not match the code.

---

## 1. One-sentence summary

A careful, honest, fully reproducible reanalysis whose `languageR` results are
solid, but whose central transport claim (0.308 log loss / 0.906 AUC) rests on a
single un-resampled split, a degraded in-memory length variable, and a six-verb
intersection that bundles verb-set restriction with corpus, variety, and period,
so the inference is suggestive rather than established.

## 2. Strengths

- **Reproducibility and null discipline are genuinely good, not decorative.**
  The scripts fetch from CRAN and Figshare with MD5 validation, fixed seeds, and
  pre-declared null comparisons. The scrambled-outcome control behaves correctly:
  transport AUC collapses from 0.906 to 0.515 and log loss rises from 0.308 to
  0.885 (`bnc2014_transport_metrics.csv`, rows 3-4), and the fake-data
  hierarchical checks recover SD = 0 under a null and SD = 0.826 under a planted
  verb effect (`languageR_dative_hierarchical_diagnostics.csv`). This is the
  Gelman-approved use of nulls: a measuring instrument with a known zero point.
  Most corpus papers never build one.

- **The partial-pooling result is the cleanest contribution.** The hierarchical
  verb-intercept model matches the 92-df fixed-verb model (test log loss 0.233
  vs 0.234, AUC 0.952 vs 0.951) at df 19, with verb random-intercept SD = 2.106
  (`languageR_dative_hierarchical_diagnostics.csv`). That is exactly the right
  demonstration that the lexical signal is large and survives shrinkage. I have
  no quarrel with this part.

- **The interpretive restraint is correct and well-earned.** The paper concedes
  raw accuracy is a weak lens (base rate ~0.82; transport reaches ~0.86,
  confirmed at 0.8587 in the metrics file) and leans on discrimination and
  calibration instead. Section 6's refusal to equate production probability with
  grammaticality is the right call and is argued, not asserted.

## 3. Weaknesses (actionable)

### 3a. The length variable is degraded before it travels, and the paper misdescribes how (most damaging on measurement)

Section 5 says: "BNC2014 releases character lengths, while `languageR` uses
token-like lengths, so the transport script derives BNC2014 word-count proxies
in memory." Two problems, both verifiable in the code.

1. BNC2014 *does* release usable integer length fields. `bnc2014_dative_columns.csv`
   shows `RecLen` (integer, 0 missing, 36 distinct) and `ThemeLen` (integer, 0
   missing, 50 distinct). The harmonization note
   (`notes/bnc2014-harmonization.md`) records that these are character lengths
   from the cleaning script, which is a fair reason not to use them raw. But the
   transport script does not convert them. It ignores them entirely and
   re-tokenizes the surface `Recipient`/`Theme` strings by splitting on
   whitespace (`word_count`, `05_bnc2014_transport.R` lines 64-71, 108-109).

2. That re-tokenization is lossy in a way the prose hides. The derived
   `rec_len_words`/`theme_len_words` collapse to **9 distinct values each** and
   induce **31 and 34 missing rows** (`bnc2014_transport_feature_coverage.csv`),
   versus 13/28 distinct and 0 missing on the `languageR` side. So the predictor
   the paper foregrounds as "what travels" is, on the test corpus, a coarse,
   whitespace-counted, partially-missing reconstruction, while on the training
   corpus it is the native token count. The two `rec_len_words` columns are
   produced by *different procedures on different text*, not a common scale.

This matters because length is load-bearing in the transport story (Section 5:
"Recipient length is negative for NP realization; theme length is positive...
the strongest signs that the Bresnan profile is projectible"). Differential
measurement error in a predictor attenuates and can distort its coefficient.
The transport length coefficients (rec_len -0.434, theme_len +0.251,
`bnc2014_transport_coefficients.csv`) are estimated from `languageR` training and
the *sign* survival is what's claimed, so the immediate damage is bounded. But
the native-BNC coefficients are roughly twice as large (rec_len -0.861, theme_len
+0.907), which is consistent with the BNC length variable being on a different,
compressed scale rather than with a real effect-size difference. The paper reads
that gap as substance; some of it is units.

Actionable: (i) Correct the prose so it states what the code does (re-tokenize
surface strings, not convert character lengths). (ii) Run a sensitivity analysis
using `RecLen`/`ThemeLen` directly, ideally z-scored within corpus, and report
whether the transport metrics and length-coefficient signs are stable. If they
are, the claim is stronger and the misdescription is moot; if they move, the
length-as-travels claim needs softening. (iii) Report the dropped-row count from
length missingness explicitly (1621 of 1839 BNC rows survive the core formula;
that 12% loss is currently invisible in the main text).

### 3b. A single split with no resampled uncertainty cannot carry 0.308-vs-0.202 (Gelman lens)

Every metric in both tables is a single fixed-seed train/test split. There is no
cross-validation, no bootstrap, no interval on any AUC or log loss. The paper's
own planning note (`notes/analysis-plan.md`, line 121) lists "random train/test
split versus grouped or stratified cross-validation" as an open choice, then the
manuscript reports only the single split. The headline comparisons are stated as
point contrasts: transport 0.308 vs native holdout 0.202, "about half again the
native model's." That is a difference between two numbers with no error bars, and
worse, **the two numbers come from different test sets of very different size**:
the transport metric is computed on 1621 BNC rows, the native holdout on 322 rows
(`bnc2014_transport_metrics.csv`, rows 3 and 6). Within that 322-row native test
set, `lend` has n = 5, `offer` n = 12, `sell` n = 15
(`bnc2014_transport_calibration_by_verb.csv`). A 0.960 AUC on 322 rows with three
verbs in single digits has a wide sampling interval that the paper never shows.

From a Gelman standpoint the model comparison is currently framed as decoration,
not inference: the reader cannot tell whether 0.308 vs 0.202 is a reliable gap or
split noise. The fix is cheap and standard. Bootstrap the test predictions (or
do 10x repeated stratified CV) and report a CrI/CI on each AUC and log loss, and
on the transport-minus-native difference. Until that interval exists, "the gap is
not small" is an assertion, not a result. This is the single change most likely
to change my recommendation.

### 3c. The six-verb intersection conflates verb-set restriction with the corpus shift, and the admission does not fully repair the inference

The paper is admirably explicit that variety, period, register, annotation, and
the six-verb restriction "are bundled in this comparison" (Section 5) and that
failure would not be attributable to any one cause. Two things keep this from
being enough.

First, the six shared verbs (give/send/show/sell/offer/lend) are not a random
sample of the alternation; they are its highest-frequency canonical core, which
the paper acknowledges. So the test is run precisely where transport is *most*
likely to succeed by construction. A positive result here is weak evidence for
"the Bresnan profile is projectible" in general and the paper should not let the
title's "transport" claim quietly generalize past the core. The current Section 5
scope paragraph is good; the abstract and conclusion are looser ("the profile
partly transports") and should inherit the same restriction.

Second, the bundling is not merely a limitation to be confessed; it interacts
with 3a and 3b. Because verb is one of only ~13 model terms and three of the six
verbs are sparse in the test data, the verb-specific transport failures the paper
reports (underpredicts NP for send/offer/lend, overpredicts for sell, Section 5)
are estimated on n = 486/62/26 (transport) and n = 97/12/5 (native). The sell
reversal (observed NP rate 0.32 transport, 0.13 native;
`bnc2014_transport_calibration_by_verb.csv`) is the kind of finding that needs an
interval before it bears interpretive weight. As it stands, the confound
admission is honest but does not rescue the per-verb conclusions, which are
presented as if estimated, not as if noisy.

Actionable: state in the abstract/conclusion that transport is established only
for the high-frequency core; add per-verb sample sizes and intervals to any
per-verb claim; and, if feasible, a leave-one-verb-out transport check to show
whether the aggregate result depends on `give` (which is 729 of 1621 transport
rows and dominates everything).

## 4. Question for the Q&A

You report transport log loss 0.308 on 1621 BNC rows and native-holdout 0.202 on
322 rows, and read the gap as real local structure the `languageR` fit misses.
But the length predictor is re-tokenized differently in the two corpora (9 vs
13/28 distinct values, 31-34 induced missing), and the two metrics sit on
different-sized test sets. If you bootstrap the test predictions and instead feed
both models the released `RecLen`/`ThemeLen` (z-scored within corpus), does the
transport-minus-native gap survive with a CrI that excludes zero, or does it
shrink into measurement and sampling noise?

## 5. Verdict

**Revise & Resubmit.** The `languageR` reproduction and partial-pooling results
are publishable as they stand; the transport claim that gives the paper its title
is not yet supported at the level of evidence a statistics referee requires
(single un-resampled split, mismatched and degraded length measurement, sparse
per-verb cells), and all three defects are fixable without new data.
