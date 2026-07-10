# Pre-deployment checklist — Corpora (Edinburgh UP)

Supersedes the Vanguard-era `pre-submission-checklist-2026-07-08.md`.
Venue decided 2026-07-10 (`venue-decision-2026-07-10.md`). Guidelines verified
2026-07-10 from the EUP Corpora submissions page.

## Verified venue facts (the ones that change the plan)

- **Submission by EMAIL, not a portal.** Send to Prof. Paul Baker,
  `j.p.baker@lancaster.ac.uk`. Book reviews go elsewhere; this is a research paper.
- **File format .doc/.rtf, explicitly NOT .pdf or LaTeX.** Figures and tables
  **inline at the relevant place** for the initial (review) submission.
- **Length:** research paper 6,000–10,000 words all-in (title, abstract,
  references, notes, appendices, tables, figures). We are at **6,890** — fits,
  near the low end. Abstract **150–200 words**; ours is **199** (at the ceiling).
- **Anonymised review:** remove the name everywhere, clean the file Properties,
  anonymise self-citations in text and references.
- **Reference style is bespoke** (not biblatex-apa): in-text `(Forde, 1964: 102)`;
  bibliography year-after-author, single-quoted article titles, `pp 5-28` ranges.
- **AI policy = disclosure-model.** Disclose at submission via the **EUP AI
  disclosure form**; the truthful "substantially assisted" disclosure goes there.
- **Presentation:** Times New Roman 12pt; bold, numbered section headings;
  single quotation marks (double nested); quotes >40 words indented; foreign words
  italic; dates "23 July 1945 / the 1940s / 1952-56"; numbers up to ninety-nine in
  words, else figures; "percent" not %; initials without stops (UK); footnotes not
  endnotes.
- **Precedence signal (fit):** Corpora gives methodology papers precedence over
  "access a corpus to study some aspect of linguistics" — our paper is the
  priority type.
- **Known costs:** acceptance 10–28% (desk-reject-heavy); ~21–25 months to
  publication; Green OA self-archiving of a pre-publication version is allowed
  (so a LingBuzz preprint is fine; the Version of Record is not depositable).

## Already done (manuscript content)

- [x] LaTeX build clean; house-style lint clean; no undefined refs.
- [x] Reader-first framing; coefficient-transport figure added; calibration figure demoted to supplement; §4 reframed off "modern"; editorial scar tissue cleaned.
- [x] `make blind` LaTeX build leak-free (author block, ORCID, metadata).
- [x] All-in length 6,890 (in band); abstract 199 (in band).

## Format conversion — the main new work

- [ ] Produce a **.doc/.rtf** version from the LaTeX (pandoc first pass, then hand-fix math, tables, the two figures, and the bibliography). This is the load-bearing task.
- [ ] Reformat all references to **Corpora style** (in-text `(Author, year: page)`; bibliography year-after-author, single-quoted titles, `pp` ranges). biblatex-apa does not match.
- [ ] Apply Corpora **presentation conventions** in the Word file: single quotes, numbers ≤ ninety-nine spelled out, "percent" not %, date formats, foreign words italic, bold numbered headings, footnotes not endnotes.
- [ ] Embed figures/tables **inline** at their reference points (initial-submission rule).
- [ ] Confirm the abstract stays within 150–200 after any Word-side edits (currently 199, no headroom).

## Anonymisation (Corpora single-anonymised)

- [ ] Remove author name from text, headers/footers, and **Word file Properties/metadata**.
- [ ] Anonymise self-citations in text and References. NB: if the projectibility citation to the Thomasson preprint (REYFWF) is added, it is a self-cite and must be anonymised.

## Package (email, not portal)

- [ ] Cover **email** to Paul Baker (not a portal cover letter): one-sentence journal-reader contract, methodology-precedence fit, confirmation the work is not under consideration elsewhere.
- [ ] **EUP AI disclosure form** completed with the truthful "substantially assisted" statement.
- [ ] **Author copyright form** downloaded and included.
- [ ] Data/code: repo link + a **DOI'd snapshot** (Zenodo). Deposit a pre-publication preprint (LingBuzz) if desired — allowed under Green OA.

## Standard gate checks (re-run against the Word version)

- [ ] Re-audit numbers/claims against source CSVs after this session's §5 trims and the new coefficient figure (the figure is CSV-generated, so low drift risk; verify the qualitative claims and caption).
- [ ] Title and file metadata match; all figures/tables referenced.
- [ ] Minor/cosmetic: overfull `\hbox` (7.3pt, lines 3–10) in the LaTeX PDF — moot for the Word submission; fix only if the PDF stays a canonical artifact.

## Optional carry-overs (from the 2026-07-10 cross-project scan)

- [ ] §6/§8 DAIS clarity check (prompted by the CJL rejection of the judges-evaluators paper): keep the "detector-channel / role-dependent instrument" framing subordinate and make the "paired-preference target, not grammaticality target" distinction impossible to misread.
- [ ] Light projectibility citation to the now-public Thomasson preprint (REYFWF) in §6 (self-cite → anonymise).
- [ ] LingBuzz preprint.
