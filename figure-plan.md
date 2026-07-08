# Figure plan

Date: 2026-07-08. Venue: *Linguistics Vanguard* (short-format, colour free, no
hard figure cap; multimodal platform explicitly encouraged).

## Current figures

| Slot | File | Kind | Section |
|------|------|------|---------|
| Fig 1 | `bnc2014_transport_calibration_by_verb.pdf` | data | §5 |
| Fig 2 | `bnc2014_transport_calibration_curve.pdf` (reliability) | data | §5 |
| Fig 3 | `opportunity_sets_nested.pdf` | conceptual | §6 |
| Supp | `dais_production_preference_bridge.pdf` | data | §8 |

Imbalance: two of the three body figures are calibration plots; none shows the
coefficient-transport result, which is the more linguistically substantive
finding and is currently carried entirely by a dense numeric paragraph (§5).

## Candidate menu (over-proposed; trim before building)

| # | Fig | Kind | Makes clearer | Type | Source | Keep |
|---|-----|------|---------------|------|--------|------|
| 1 | Coefficient transport, source vs BNC-native | data | which predictors travel (length, pronominality) and which flip sign (recipient animacy, theme definiteness) | dumbbell / paired dots per term, marked by `same_direction` | `bnc2014_source_native_coefficient_comparison.csv` | **must** |
| 2 | Transport performance across model families | data | source vs native, marginal→full, the +0.032 AUC gap | grouped dots (log loss, AUC) | `bnc2014_transport_metrics.csv` (built: `bnc2014_transport_metrics_core.pdf`) | nice→skip (Table 2 is exact and compact) |
| 3 | Population shift, source vs BNC core | data | the domain gap transport is tested against (*give* share 0.81→0.45, rec. animacy 0.94→0.84, theme length 3.68→2.43) | small multiples, paired bars | `bnc2014_predictor_distribution_comparison.csv` | nice (fallback if a reviewer asks "against what baseline") |
| 4 | Observed NP rate by verb | data | six-verb base rates, source vs BNC | paired bars | `bnc2014_transport_calibration_by_verb.csv` (built, unused) | skip (Fig 1 already shows observed-by-verb) |
| 5 | Missingness map | data | outcome-skewed missing rows (NP 0.82 complete vs 0.67 incomplete) | small bar / heat strip | `bnc2014_core_missingness_by_variable.csv` | stretch (prose suffices) |
| 6 | Validation ladder as schematic | conceptual | the paper's spine: stage → diagnostic → licensed conclusion | vertical ladder, TikZ | conceptual (Table 3) | stretch (Table 3 already clear; decoration risk) |
| 7 | Projectibility schematic | conceptual | observed conditioning → licensed predictions, with the grammatical-but-unattested region marked out of scope (Goodman) | flow / nested-region, TikZ | conceptual | stretch (may overlap Fig 3) |
| 8 | Interactive reliability + coefficient explorer | data | hover a verb/predictor to compare source vs native | HTML/JS widget | same as #1, #2 | stretch (aligns with Vanguard's multimodal platform) |

## Recommendation (short-format discipline)

- **Build #1.** It is the one genuine gap, it surfaces the most interesting
  result, and it pays for itself: it lets us delete the decimal-heavy paragraph
  in §5 (~60 words), so it *reduces* body length while adding a figure that
  doesn't count toward the word target.
- **Rebalance, don't accumulate.** Rather than a fourth body figure, consider
  demoting Fig 1 (verb-level calibration) to the supplement and keeping Fig 2
  (reliability diagram) as the single body calibration figure. Fig 2 is the
  cleaner one-picture statement of the paper's thesis (discrimination ≠
  calibration). Net body-figure count stays at 3, better balanced.
- **Hold #3 in reserve** for the population-shift point if a reviewer presses on
  the domain gap.
- Everything else is nice-to-have; a short paper should not balloon.

## Build notes

- Data plots: `.house-style/plot_style.py`; colour is free (Mouton sheet), so no
  grayscale constraint. Captions below, sentence case (Mouton sheet). Supply each
  figure as a separate file for typesetting (IfA requirement).
- Conceptual: TikZ, house LaTeX conventions (upright brackets, en-dashes).
- Run `/check-chart-style` on each survivor before finalizing.
