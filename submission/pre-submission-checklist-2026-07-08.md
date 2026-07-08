# Linguistics Vanguard Pre-Submission Checklist
Target: _Linguistics Vanguard_ (De Gruyter Brill)
Portal: <https://mc.manuscriptcentral.com/lingvan>
Prepared: 2026-07-08
Status: **reviewer PDF verified; submission not yet ready to click**
## Review Resolution
- [x]

  Roughdraft comment `c1` addressed. The first record was too close to the general PM template. This file supersedes it with an applied paper-specific checklist and explicit rhetorical, metaphor, humour, level/category, and terminology passes.

## Files
- [x]

  Canonical source: `main.tex`

- [x]

  Reviewer-facing build PDF: `main-blind.pdf`

- [x]

  Named reviewer-facing submission PDF: `submission/beyond-concordance-lingvan-blind-review-2026-07-08.pdf`

- [x]

  Non-blind/admin build PDF: `main.pdf`

- [x]

  Named non-blind/admin submission PDF: `submission/beyond-concordance-lingvan-nonblind-admin-2026-07-08.pdf`

- [x]

  Supplement: embedded after references from `sections/08-supplementary-dais.tex`

- [ ]

  Cover letter: not prepared

- [ ]

  Non-anonymous title page/admin declarations: not prepared

- [ ]

  Reviewer suggestions/exclusions: not prepared

- [ ]

  Source ZIP/package: not prepared

- [ ]

  Exact submitted-version archive/tag/identifier: not created

## Venue Checks
- [x]

  Current journal page checked: <https://www.degruyterbrill.com/journal/key/lingvan/html>

- [x]

  Submission portal recorded: <https://mc.manuscriptcentral.com/lingvan>

- [x]

  Data policy checked: <https://www.degruyterbrill.com/publishing/for-authors/author-policies/data-sharing-policy>

- [x]

  AI policy checked: <https://www.degruyterbrill.com/publishing/for-authors/author-policies/artificial-intelligence>

- [x]

  Double-blind initial review requirement checked.

- [x]

  Data policy classified as Tier 2: data sharing is encouraged; data availability statement is encouraged.

- [x]

  AI-use disclosure checked against policy and revised in `main.tex`.

- [ ]

  Length risk remains: venue target is 3,000-4,000 words plus references and ancillary material; `texcount` reports 4,560 main-text words before references/supplement.

## Manuscript Correctness
- [x]

  Title, abstract, keywords, and conclusion match the methods-led external-validation contribution.

- [x]

  Introduction states the problem and claim type: external predictive validation of a production model, not direct grammaticality measurement.

- [x]

  Final section stays within the body: reproducible production profile, partial transport, calibration/native-benchmark limits, opportunity-set boundary.

- [x]

  DAIS is subordinated as supplementary bridge material, not the paper's main empirical claim.

- [x]

  No unresolved placeholders found by targeted scan for `TODO`, `FIXME`, `VERIFY`, `Brett verify`, and `??`.

- [x]

  Data/code statement present and revised so it does not promise an already-created DOI or tag.

- [x]

  AI-use statement present and revised: AI assisted with drafting/coding/review; no submitted figures, images, or research data were created or manipulated by AI.

- [x]

  Funding, competing interests, and ethics/REB status are represented in the manuscript declarations.

## Rhetorical Pass
- [x]

  Governing structure checked: the paper is organized around a validation ladder, carried from abstract to Section 6/Table 3 to conclusion.

- [x]

  The ladder structure is analytical rather than decorative: each rung has a diagnostic and a licensed conclusion.

- [x]

  Contrastive sequence checked: "not whether the dative travels, but what the full validation regime licenses" is the paper's contribution frame.

- [x]

  No extra ornamental rhetorical figure was added. The existing recurring ladder and target/channel contrasts do enough work; adding more aphoristic antithesis would make the prose feel over-managed.

- [x]

  Local rhetorical/register edit made in `sections/04-modern-modelling.tex`: replaced the casual "So far, only repackage it" turn with "Here, only the statistical packaging changes."

## Metaphor-Frame Pass
- [x]

  Transport/travel/carry language checked. It is controlled by explicit target-domain, calibration, and same-row benchmark language, so it does not imply automatic generalization.

- [x]

  Ladder/rung language checked. It stages diagnostics without implying that every higher rung is simply "better"; the table makes each diagnostic's licensed conclusion explicit.

- [x]

  Lakoff-style impact check completed. The ladder frame now does more useful work in the manuscript: Section 6 says the relevant entailment is failure localization rather than ascent, and each rung marks where a transported model can "pass or slip."

- [x]

  Channel/bridge language checked. The prose repeatedly marks production, acceptability, and grammaticality as distinct evidence targets.

- [x]

  Local metaphor/register edit made in `sections/06-grammatical-possibility.tex`: replaced "not a free one" with "not an automatic one."

- [x]

  No governing metaphor was found to hide a level/category distinction or make an unsupported inference feel earned.

## Humour And Wit Pass
- [x]

  Useful humour/wit added where it helps the argument: Section 6 now uses "pass or slip" to make the validation-ladder metaphor do diagnostic work without turning comic.

- [x]

  Sharpened phrasing checked for scholarly register. Casual spots that were merely loose were regularized; the remaining wit is tied to the paper's method.

- [x]

  Remaining compression is functional rather than decorative: e.g. the conclusion's "The regime, not the finding that the dative travels, is the contribution" is retained because it states the contribution boundary.

## Level, Category, And Terminology Pass
- [x]

  Level/category audit passed: the paper consistently separates production probability, predictive transport, acceptability preference, and grammaticality/licensing.

- [x]

  The estimand is explicit: conditional NP-recipient probability given entry into the annotated NP/PP dative sample.

- [x]

  Opportunity-set boundary is explicit: more positive corpus tokens under the same design do not identify grammatical-but-unattested cases.

- [x]

  Terminology audit passed: `profile`, `transport`, `projectibility`, `calibration`, `channel`, `bridge`, `native`, and `source` are used consistently.

- [x]

  Review-board usage has been converted into edits and recorded in project decisions/status; it is not treated as evidence.

## Blind Review And Metadata
- [x]

  `make blind` produces `main-blind.pdf`.

- [x]

  Reviewer-facing PDF has no author line.

- [x]

  `pdfinfo main-blind.pdf` has no `Author` field; `main.pdf` retains author metadata for admin/non-blind use.

- [x]

  Blind identity scan returned no hits for Brett/Reynolds/Humber/Toronto/email/ORCID/GitHub strings.

- [x]

  Repository link is suppressed in blind mode and replaced with editor-on-request language.

- [ ]

  Portal-generated reviewer PDF cannot be checked until upload.

## Build And Verification
- [x]

  Analysis script `Rscript analysis/08_dais_acceptability_bridge.R` passed.

- [x]

  Analysis script `Rscript analysis/09_bnc2014_metadata_scope.R` passed.

- [x]

  Analysis script `Rscript analysis/10_bnc2014_paired_transport_cv.R` passed.

- [x]

  Figure script `python3 analysis/06_denominator_and_figure_candidates.py` passed and regenerated derived figures.

- [x]

  House-style scan passed: `python3 ../../../.house-style/check-style.py main.tex sections/*.tex`.

- [x]

  `make` passed sequentially after clearing Biber's temporary extraction cache.

- [x]

  `make blind` passed sequentially.

- [x]

  `biber --validate-datamodel main` passed with datamodel validation complete.

- [x]

  Build-log scan found no unresolved citations/references, LaTeX errors, severe overfull/underfull boxes, or rerun requests; the only `Rerun` hits are the `rerunfilecheck` package name.

- [x]

  Standing non-blocking warnings noted from build output: fancyhdr one-sided/header-height warnings and microtype footnote patch warning.

- [x]

  `git diff --check` passed.

- [x]

  `pdftotext` spot check passed for `main-blind.pdf`: title, date, abstract, keywords, and opening text extract sensibly.

- [x]

  `pdfinfo main.pdf`: 17 pages, title/keywords/author metadata present.

- [x]

  `pdfinfo main-blind.pdf`: 17 pages, title/keywords present, no author metadata.

- [x]

  Named submission PDFs created and checked: the blind review copy has no author metadata or visible identity hits; the nonblind admin copy retains author metadata.

- [x]

  Visual PDF spot-check completed earlier for pages 1, 5, 9, 14, and 15.

## Edits Made During This Checklist Pass
- Revised `main.tex` data/code statement so submitted-version archive language is future-facing until a tag/DOI exists.

- Revised `main.tex` AI-use disclosure to align with De Gruyter Brill policy.

- Removed the blind author placeholder from `main.tex`.

- Removed nonessential bibliography fields from `HawkinsYamakoshiGriffithsGoldberg2020VerbBias` to satisfy Biber datamodel validation.

- Resolved house-style linter issues across `main.tex` and `sections/*.tex`.

- Made the rhetorical/register edits in `sections/04-modern-modelling.tex` and `sections/06-grammatical-possibility.tex` listed above.

- Created named submission PDF copies: `submission/beyond-concordance-lingvan-blind-review-2026-07-08.pdf` and `submission/beyond-concordance-lingvan-nonblind-admin-2026-07-08.pdf`.

## Stop Conditions Before Submission
- [ ]

  Decide whether to trim to <= 4,000 main-text words or explicitly accept the _Linguistics Vanguard_ target-length risk.

- [ ]

  Prepare cover letter, including disclosure of the related CLLT submission if still relevant to the journal route.

- [ ]

  Prepare non-anonymous title page/admin declarations.

- [ ]

  Decide whether to provide reviewer suggestions/exclusions.

- [ ]

  Create exact submitted-version archive/tag/identifier-bearing repository snapshot.

- [ ]

  Assemble and check any source ZIP/package if ScholarOne requires it.

- [ ]

  Check portal file roles and generated reviewer PDF after upload.

- [ ]

  Record Brett's final approval before final submit.

---
comments:
  c1:
    body: um, ok, but I put together a checklist, and this isn't it. It's a general
      checklist
    by: user
    at: 2026-07-08T13:44:40.238Z
  c2:
    body: Replaced the general-template-style record with a compact applied
      checklist and explicit rhetorical, metaphor, humour, level/category, and
      terminology passes.
    by: Codex
    at: 2026-07-08T13:50:10Z
    re: c1
  c3:
    by: user
    at: 2026-07-08T13:53:05.720Z
  c4:
    by: user
    at: 2026-07-08T13:53:45.037Z
  c5:
    by: user
    at: 2026-07-08T13:54:25.402Z
  c6:
    body: Addressed by adding useful, restrained wit to the paper itself: the validation ladder now marks where a transported model can "pass or slip."
    by: Codex
    at: 2026-07-08T13:56:57Z
    re: c3
  c7:
    body: Addressed by making the Lakoff-style check constructive. Section 6 now sharpens the ladder frame around failure localization rather than ascent.
    by: Codex
    at: 2026-07-08T13:56:57Z
    re: c4
  c8:
    body: Addressed by creating named PDF copies in submission/ for the blind review file and non-blind admin file.
    by: Codex
    at: 2026-07-08T13:56:57Z
    re: c5
