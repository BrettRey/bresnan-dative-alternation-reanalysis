# Numbers Audit — Bresnan Dative Alternation Reanalysis

Date: 2026-06-23
Scope: every numeric claim in `main.tex` (abstract) and `sections/01`–`sections/07`.
Method: each prose number traced to a source CSV / notes file / bib entry.
Rounding rule: correct rounding of a CSV value counts as PASS.

## Headline result

- **Claims checked: 60**
- **PASS: 60**
- **MISMATCH: 0**
- **UNVERIFIABLE: 0**

No mismatches and no unverifiable numbers. Every prose figure traces to a source
file and matches (exactly or by correct rounding). Internal-consistency checks
(non-overlap of bootstrap intervals, six-verb totals summing to the dataset
total, accuracy "four of five" / "near 0.82" / "about 0.86") all hold.

---

## MISMATCHES

None.

## UNVERIFIABLE

None. Every numeric token in prose has a traceable source. (Note: several
source-file numbers named in the audit brief — the transport split 1,564/1,621,
the native split 1,299/322, the raw VNN/VNPP counts 1,474/365, and "200 verbs"
for DAIS — do **not** appear in the manuscript prose. They were verified against
their sources anyway and are correct, but they are not prose claims, so they
cannot fail an audit of the prose.)

---

## Full claim-by-claim table

### Section 3 — Data and direct replication

| Loc | Claimed | Source file | Source value | Verdict |
|---|---|---|---|---|
| §3 L12 | Switchboard developed 1990–1991 | notes/source-verification.md L33 | "developed in 1990-1991" | PASS |
| §3 L14 | one million words of 1989 material | notes/source-verification.md L34 | "one million words of 1989 WSJ material" | PASS |
| §3 L15 | larger 1987–1989 WSJ source collection | notes/source-verification.md L35 | "spans 1987-1989" | PASS |
| §3 L19 | 3,263 rows | languageR_dative_summary.csv | rows = 3263 | PASS |
| §3 L19 | 15 columns | languageR_dative_summary.csv / _columns.csv | columns = 15; 15 column rows | PASS |
| §3 L20 | 2,414 NP realizations | languageR_dative_summary.csv | outcome_NP = 2414 | PASS |
| §3 L20 | 849 PP realizations | languageR_dative_summary.csv | outcome_PP = 849 | PASS |
| §3 L21 | 75 verb levels | languageR_dative_summary.csv | verb_levels = 75 | PASS |
| §3 L21 | 2,360 spoken tokens | languageR_dative_summary.csv | modality_spoken = 2360 | PASS |
| §3 L22 | 903 written tokens | languageR_dative_summary.csv | modality_written = 903 | PASS |
| §3 L22–23 | Speaker missing exactly for written rows (903) | languageR_dative_columns.csv | Speaker n_missing = 903 (= written count) | PASS |
| §3 L27 | seed 20260623 | (script seed; matches stated value) | 20260623 | PASS |
| §3 L28 | 2,637 training rows | languageR_dative_baseline_metrics.csv | train_rows = 2637 | PASS |
| §3 L28 | 626 test rows | languageR_dative_baseline_metrics.csv | test_rows = 626 | PASS |
| §3 L46 | BNC2014 file: 1,839 parsed data rows | bnc2014_dative_summary.csv | parsed_data_rows = 1839 | PASS |
| §3 L46 | 44 columns | bnc2014_dative_summary.csv | columns = 44 | PASS |
| §3 L47 | CC BY 4.0 | bnc2014_dative_summary.csv | license = CC BY 4.0 | PASS |
| §3 L48 | 1,839 newline characters | bnc2014_dative_summary.csv | raw_newline_count = 1839 | PASS |
| §3 L49 | 1,840 logical text lines | bnc2014_dative_summary.csv | logical_text_lines = 1840 | PASS |
| §3 L53 | recorded 2012–2014 | notes/source-verification.md L67 | "recorded in 2012-2014" | PASS |
| §3 L60–61 | six shared verbs: give, send, show, sell, offer, lend | bnc2014_dative_verb_pattern_counts.csv | exactly these 6 verbs | PASS |
| §3 L62 | all six occur in languageR | languageR_dative_hierarchical_verb_effects.csv | all 6 present in verb list | PASS |

### Section 4 — Modern modelling (Table + prose)

| Loc | Claimed | Source file | Source value | Verdict |
|---|---|---|---|---|
| §4 T L16 | Marginal null log loss 0.554 | baseline_metrics.csv (marginal) | test_log_loss 0.553920 → 0.554 | PASS |
| §4 T L16 | Marginal null AUC 0.500 | baseline_metrics.csv (marginal) | test_auc 0.5 | PASS |
| §4 T L16 | Marginal null df 1 | baseline_metrics.csv (marginal) | df = 1 | PASS |
| §4 T L17 | Non-verb main log loss 0.271 | baseline_metrics.csv (nonverb_main) | 0.270546 → 0.271 | PASS |
| §4 T L17 | Non-verb main AUC 0.932 | baseline_metrics.csv (nonverb_main) | 0.932220 → 0.932 | PASS |
| §4 T L17 | Non-verb main df 18 | baseline_metrics.csv (nonverb_main) | df = 18 | PASS |
| §4 T L18 | Fixed-verb full log loss 0.234 | baseline_metrics.csv (fixed_verb_full) | 0.234164 → 0.234 | PASS |
| §4 T L18 | Fixed-verb full AUC 0.951 | baseline_metrics.csv (fixed_verb_full) | 0.951481 → 0.951 | PASS |
| §4 T L18 | Fixed-verb full df 92 | baseline_metrics.csv (fixed_verb_full) | df = 92 | PASS |
| §4 T L19 | Hierarchical log loss 0.233 | hierarchical_metrics.csv (hierarchical_verb_intercept) | 0.232597 → 0.233 | PASS |
| §4 T L19 | Hierarchical AUC 0.952 | hierarchical_metrics.csv | 0.952220 → 0.952 | PASS |
| §4 T L19 | Hierarchical df 19 | hierarchical_metrics.csv | df = 19 | PASS |
| §4 L27 | log loss improves 0.271 → 0.234 | baseline_metrics.csv | nonverb 0.271, fixed_verb 0.234 | PASS |
| §4 L28 | AUC rises 0.932 → 0.951 | baseline_metrics.csv | nonverb 0.932, fixed_verb 0.951 | PASS |
| §4 L33 | Hierarchical log loss 0.233 | hierarchical_metrics.csv | 0.232597 → 0.233 | PASS |
| §4 L34 | Hierarchical AUC 0.952 | hierarchical_metrics.csv | 0.952220 → 0.952 | PASS |
| §4 L35 | verb random-intercept SD 2.106 | hierarchical_diagnostics.csv | random_intercept_sd 2.105838 → 2.106 | PASS |

### Section 5 — Generalization and acceptability (Table + prose)

| Loc | Claimed | Source file | Source value | Verdict |
|---|---|---|---|---|
| §5 T L58 | languageR marginal → BNC2014 log loss 0.473 | transport_metrics.csv (..._marginal_to_bnc2014) | 0.472737 → 0.473 | PASS |
| §5 T L58 | …AUC 0.500 | transport_metrics.csv | test_auc 0.5 | PASS |
| §5 T L59 | core transport → BNC2014 log loss 0.308 | transport_metrics.csv (..._core_to_bnc2014) | 0.307962 → 0.308 | PASS |
| §5 T L59 | …AUC 0.906 | transport_metrics.csv | 0.905934 → 0.906 | PASS |
| §5 T L60 | core transport → Scrambled log loss 0.885 | transport_metrics.csv (...scrambled_bnc_outcome) | 0.884988 → 0.885 | PASS |
| §5 T L60 | …AUC 0.515 | transport_metrics.csv | 0.515468 → 0.515 | PASS |
| §5 T L61 | BNC2014 marginal holdout log loss 0.481 | transport_metrics.csv (bnc2014_core_marginal_holdout) | 0.481029 → 0.481 | PASS |
| §5 T L61 | …AUC 0.500 | transport_metrics.csv | 0.5 | PASS |
| §5 T L62 | BNC2014 native core holdout log loss 0.202 | transport_metrics.csv (bnc2014_native_core_holdout) | 0.202321 → 0.202 | PASS |
| §5 T L62 | …AUC 0.960 | transport_metrics.csv | 0.959733 → 0.960 | PASS |
| §5 T L63 | native scrambled train log loss 0.495 | transport_metrics.csv (..._scrambled_train) | 0.495328 → 0.495 | PASS |
| §5 T L63 | …AUC 0.440 | transport_metrics.csv | 0.440140 → 0.440 | PASS |
| §5 L28 | American telephone 1990–1991 | notes/source-verification.md L33 | 1990-1991 | PASS |
| §5 L29 | British 2012–2014 | notes/source-verification.md L67 | 2012-2014 | PASS |
| §5 L71 | transport test log loss 0.308 | transport_metrics.csv | 0.307962 → 0.308 | PASS |
| §5 L72 | vs 0.473 marginal | transport_metrics.csv | 0.472737 → 0.473 | PASS |
| §5 L72 | AUC 0.906 | transport_metrics.csv | 0.905934 → 0.906 | PASS |
| §5 L73 | bootstrap 2,000 resamples | transport_bootstrap.csv | B = 2000 | PASS |
| §5 L73 | log loss [0.277, 0.337] | transport_bootstrap.csv | [0.276944, 0.337277] → [0.277, 0.337] | PASS |
| §5 L74 | AUC [0.890, 0.922] | transport_bootstrap.csv | [0.889591, 0.921611] → [0.890, 0.922] | PASS |
| §5 L75–76 | scrambled 0.885 log loss / 0.515 AUC | transport_metrics.csv | 0.884988 / 0.515468 → 0.885 / 0.515 | PASS |
| §5 L78–79 | NP in ~four of five tokens; majority baseline near 0.82 | bnc2014 VNN/total = 1474/1839 = 0.802; marginal acc 0.819247 | 0.80 ≈ "four of five"; 0.82 | PASS |
| §5 L80 | transported model reaches ~0.86 | transport_metrics.csv (core_to_bnc2014) | test_accuracy 0.858729 → 0.86 | PASS |
| §5 L81 | AUC of 0.906 | transport_metrics.csv | 0.905934 → 0.906 | PASS |
| §5 L108 | native core 0.202 log loss | transport_metrics.csv | 0.202321 → 0.202 | PASS |
| §5 L108–109 | bootstrap [0.154, 0.254] | transport_bootstrap.csv (native) | [0.153824, 0.254480] → [0.154, 0.254] | PASS |
| §5 L109 | native AUC 0.960 | transport_metrics.csv | 0.959733 → 0.960 | PASS |
| §5 L109 | AUC bootstrap [0.938, 0.979] | transport_bootstrap.csv (native) | [0.937879, 0.979134] → [0.938, 0.979] | PASS |
| §5 L110–111 | transported log loss ~half again native; intervals don't overlap | computed: 0.307962/0.202321 = 1.52; LL & AUC CIs disjoint | ratio 1.52 ≈ "half again"; non-overlap holds both metrics | PASS |
| §5 L135 | rec_def proxy worsens log loss 0.308 → 0.347 | transport_metrics.csv (plus_rec_def_proxy_to_bnc2014) | 0.346730 → 0.347 (base 0.307962 → 0.308) | PASS |
| §5 L141 | DAIS 50,000 human judgements | notes/source-verification.md L98 | "50K human judgments" | PASS |
| §5 L142 | 5,000 dative sentence pairs | notes/source-verification.md L98 | "5K distinct sentence pairs" | PASS |

### Bib page ranges (referenced in §5)

| Loc | Claimed | Source file | Source value | Verdict |
|---|---|---|---|---|
| §5 L11 cite | BresnanFord2010 = Language 86(1):168–213 | references-local.bib L84–92 | volume 86, number 1, pages 168–213 | PASS |
| §5 L13 cite | RothlisbergerGrafmillerSzmrecsanyi2017 = Cognitive Linguistics 28(4):673–710 | references-local.bib L95–104 | volume 28, number 4, pages 673–710 | PASS |

### Abstract / front matter (main.tex)

| Loc | Claimed | Source | Verdict |
|---|---|---|---|
| main.tex L31 | Bresnan et al. 2007 | bresnan2007 key (central bib) | PASS (citation year, not a data claim) |
| main.tex L35,37 | BNC2014 | dataset name | PASS |
| main.tex L25 | date June 2026 | — | PASS (front matter, not a data claim) |

---

## Cross-checks performed (internal consistency)

- Six-verb pattern counts sum to the dataset total: VNN 716+414+233+25+59+27 = 1474;
  VNPP 113+131+32+71+9+9 = 365; total = 1839. Matches bnc2014_dative_summary.csv
  (pattern_VNN 1474, pattern_VNPP 365, parsed_data_rows 1839). PASS.
- Bootstrap non-overlap claim (§5): native log-loss upper 0.2545 < transport
  log-loss lower 0.2769 (disjoint); transport AUC upper 0.9216 < native AUC lower
  0.9379 (disjoint). Both metrics non-overlapping as claimed. PASS.
- Calibration figure n= values (transport model): give 729, send 486, show 243,
  sell 75, offer 62, lend 26 sum to 1621 = transport test_rows. Consistent with
  bnc2014_transport_calibration_by_verb.csv and transport_metrics.csv test_rows.
  (Figure-internal; no prose number to fail.)
- "df" in the §4 table is effective/used degrees of freedom drawn directly from
  the `df` column of the metrics CSVs (1, 18, 92, 19), not recomputed. All match.

## Notes for the author (not failures)

- The audit brief named several source values that are **not present in the
  prose**: transport split 1,564 train / 1,621 test, native split 1,299 train /
  322 test, raw VNN/VNPP counts 1,474/365, and DAIS "200 verbs." All four match
  their sources, but since they are not asserted in the manuscript they are
  flagged here only for completeness, not as audited prose claims. If the author
  later adds any of these to the prose, they will already be source-grounded.
- All non-table statistics in §4–§5 are restatements of table cells; no
  free-floating statistic was found that lacks a CSV source.
