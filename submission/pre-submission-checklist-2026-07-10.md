# Paper Submission Checklist — Corpora (Edinburgh UP)

Completed copy of `Project-Management/templates/paper-submission-checklist.md`.
Supersedes the Vanguard-route copy `pre-submission-checklist-2026-07-08.md` (venue
changed to Corpora on 2026-07-10).
Prepared: 2026-07-10. Status: **content complete; NOT ready to send.** The gate
is blocked on a LaTeX→Word conversion and Corpora's reference restyle.

## Submission Record

- [x] Project: `bresnan-dative-alternation-reanalysis`
- [x] Submission type: journal, first submission
- [x] Target venue: *Corpora* (Edinburgh University Press), Subscribe-to-Open
- [x] Target route: **email** to Prof. Paul Baker `<j.p.baker@lancaster.ac.uk>`; file as **.doc/.rtf, not PDF/LaTeX**
- [x] Canonical source: `main.tex` (Word version to be generated)
- [ ] Canonical submission file (.doc/.rtf): not yet produced
- [x] Supplement: §8 DAIS bridge (`sections/08-supplementary-dais.tex`)
- [ ] Exact submitted-version archive path: not created (make a Zenodo DOI snapshot)
- [x] Venue decision record: `submission/venue-decision-2026-07-10.md`
- [x] Decision owner: Brett Reynolds
- [x] Assisting model: Claude Opus 4.8
- [x] Date checked: 2026-07-10

## 1. Submission Decision

- [x] Venue decision record complete before package work.
- [x] Journal-reader contract stated in the record.
- [x] Alternatives named (IJCL, Vanguard, Glossa) with reasons.
- [~] Desk/reviewer risks identified; Corpora's low acceptance (10–28%, desk-reject-heavy) and ~21–25-month timeline are accepted implicitly by choosing it — confirm with Brett.
- [x] Motivating problem is live; Corpora explicitly prioritises methodology papers.
- [x] Target fit checked against current Corpora instructions (2026-07-10).
- [x] 3 recent Corpora fit articles pinned (2026-07-10): Larsson & Hancock 2026 (Vol 21.1, equivalence testing); Sönning 2025 (Vol 20.1, dispersion); Egbert & Biber 2023 (Vol 18.1, key feature analysis); Gries 2015 (Vol 10.1, mixed-effects) as precedent. See the venue record.
- [x] Not under consideration elsewhere; the DiD paper at IJCL is a separate manuscript.
- [ ] Preprint disclosure: none yet (no preprint posted).
- [x] Single author; no coauthor approval needed.
- [x] Project constraints: no no-LLM constraint; anonymised review; public data only.
- [x] Public/private clear: repo public; reviewer file must be anonymised.
- [x] First submission, not a retarget-after-rejection.

## 2. Objection And Source Gate

- [~] Objection ledger: the 2026-07-10 cross-project scan flagged the DAIS-framing risk (from the judges-evaluators rejection) and the projectibility hook; logged in STATUS/DECISIONS, no formal ledger built.
- [x] Load-bearing numbers source-grounded: 60/60 numbers audit (2026-06-23); the coefficient figure is generated directly from `bnc2014_source_native_coefficient_comparison.csv`.
- [ ] Re-audit §5's qualitative claims and the coefficient caption after this session's trims (low risk; CSV-backed).
- [x] Projectibility audit (`/check-hpc`) run 2026-07-10: all GREEN. Projectibility is structural (the organizing concept), not decorative; projection target, inferential payoff, and sustaining structure are explicit; the paper correctly stays at "stable/projectible/durable" and never overclaims a securing tier (no "homeostatic"/control language); scope and demotion handling is exemplary. Optional self-cite hook to the Thomasson preprint remains.
- [x] Reread notes/plans saved under `notes/`.

## 3. Manuscript Content Gate

- [x] Title/abstract/keywords/conclusion match the contribution.
- [x] Intro states the problem and claim type (external predictive validation, not grammaticality measurement).
- [x] Conclusion does not overclaim.
- [x] Content passes re-run against the current draft (2026-07-10); strict house-style lint clean. Two fixes: "they are" -> "they're" (§5); filler verb "encodes" -> "in the profile" (§6). Itemized below.
- [x] **Lakoff-style metaphor audit:** governing metaphors (TRANSPORT model-as-vehicle, LADDER, CHANNEL/BRIDGE, CONTAINER/denominator, VISION/hiding) all have entailments that support the argument. The two with risky entailments are actively defused: transport→"arrives intact" is blocked by "projectible and still travel poorly" plus the calibration story; ladder→"higher is better" is blocked by the caption ("each stage licenses a different conclusion"). Residual flag: the ladder's sequential-dependency entailment is in mild tension with "pass some rungs while failing others" (defused by caption; "validation ladder" is conventional; a "battery/suite" frame would avoid it). §6 is metaphor-dense but compartmentalized, not mixed.
- [x] **Rhetorical pass:** governing structure = validation ladder (abstract → Table 3 → conclusion). Functional figures only: §2 six-fold isocolon; contrastive antithesis as the argumentative engine; "bounded" staged recurrence. No ornamental figures. Watch: heavy "X, not Y" antithesis, but each marks a real distinction, so warranted.
- [x] **Humour/wit pass:** Brett chose the "can't-collect-your-way-out" spot (§6) to sharpen (Codex-consulted). Edited to "Once the sampling design D0 fixes the opportunity set, counting harder doesn't move its boundary…". This also folded in a correctness fix Codex caught: more tokens *can* fill sampling-zero cells within D0, so the limit is specifically the structural-zero-vs-sampling-zero distinction, now its own clause. The other two latent-wit spots (the Bresnan reversal; "ranks well but mis-calibrated") left deliberately dry. Existing functional wit: "beyond concordance."
- [x] **Level/category + terminology:** production probability / predictive transport / paired preference / grammaticality kept distinct throughout; discrimination, calibration, profile, transport, projectibility, channel, native, source used consistently; concordance-index = AUC tie holds.
- One borderline kept: "Two scores carry the paper" (§4), judged acceptable (describes which metrics the analysis relies on, not praise-as-structure).
- [x] Placeholder scan clean at 2026-07-08 (re-scan after edits).
- [x] Data/code and AI-use statements present (AI statement to be moved to the EUP form for Corpora).
- [x] Figures/tables all cited and numbered (Figs 1–5, verified 2026-07-10).
- [x] Captions interpretable standalone.

## 4. Blind Review And Metadata Gate

- [x] LaTeX `make blind` leak-free (author/ORCID/metadata; 0 hits).
- [ ] **DOCX Properties** must be cleaned (Corpora requires it explicitly).
- [ ] Self-citations anonymised in the Word text and references (esp. if the Thomasson self-cite is added).
- [ ] Repo/DOI links suppressed or editor-on-request in the reviewer file.
- [x] Non-anonymous admin material kept separate.

## 5. Build And File Gate (verified current 2026-07-10)

- [x] House-style scan clean.
- [x] `make` and `make blind` pass, 18 pp; no undefined refs; only fancyhdr/microtype standing warnings.
- [x] `git diff --check` clean at last ship (`fa6b46d`).
- [x] Figure script re-run; coefficient figure regenerated.
- [~] Cosmetic: overfull `\hbox` 7.3pt (lines 3–10); moot for the Word submission.
- [ ] **DOCX** to be produced and visually matched to the PDF.

## 6. Preprint-Specific Gate

- [x] **Posted to LingBuzz 2026-07-10: `lingbuzz/010132`** (https://lingbuzz.net/lingbuzz/010132). Cite as `lingbuzz/010132`.
- [x] Server appropriate; no conflict with the Corpora route (LingBuzz preprints are standard in linguistics; Corpora Green-OA permits a pre-publication version). **Must be disclosed in the Corpora cover email; the review copy stays anonymised.**
- [x] Posted the public non-blind PDF (`Reynolds-Beyond-Concordance-Dative.pdf`, author/ORCID showing), not a blind or working file.
- [x] Title, author, abstract (199 w), and keywords final for public discovery (LingBuzz keywords add "syntax").
- [x] Single author; no coauthor approval needed.
- [ ] Posted from uncommitted working state: commit + tag the repo so the preprint maps to a fixed snapshot.
- [ ] Remaining surface updates for the live preprint: PORTFOLIO, CV, website publications page, central bibliography, machine-readable mirrors (llms.txt, paper.md).

## 7. Journal-Specific Gate (Corpora)

- [x] Author instructions checked 2026-07-10.
- [x] Word band 6,000–10,000 all-in: we are **6,890** (fits). Abstract 150–200: **199** (fits, at ceiling).
- [ ] **References → Corpora bespoke style** (in-text `(Author, year: page)`; year-after-author bibliography, single-quoted article titles, `pp` ranges). biblatex-apa does not match.
- [ ] **Presentation** in Word: Times New Roman 12pt; bold numbered headings; single quotes (double nested); quotes >40 words indented; foreign words italic; dates "23 July 1945 / the 1940s / 1952-56"; numbers ≤ ninety-nine in words, else figures; "percent" not %; initials without stops; footnotes not endnotes.
- [ ] Figures/tables inline at reference points (initial-submission rule).
- [ ] Cover **email** to Paul Baker (journal-reader contract; methodology-precedence fit; not under consideration elsewhere).
- [ ] EUP AI-disclosure form completed with the truthful "substantially assisted" statement.
- [ ] EUP author copyright form included.
- [ ] Data/code availability statement (repo + Zenodo DOI; do not promise an unready DOI).
- [ ] Reviewer suggestions: optional; do not invent names.

## 8. Final Submit Gate

- [ ] The exact .doc/.rtf is confirmed and visually matched to the PDF.
- [ ] Email package listed: manuscript .doc, AI-disclosure form, copyright form, cover email.
- [ ] Copy-paste fields taken from checked local files.
- [ ] No active stop condition remains.
- [ ] Brett's final approval recorded (agent-prepared package).

## 9. After Submission

- [ ] Save the sent email, any acknowledgement, and the exact submitted files under `submission/`.
- [ ] Record target/date/version in `STATUS.md`; add a `DECISIONS.md` entry.
- [ ] Update PORTFOLIO/CV/website/publications when the status is public.
- [ ] Commit and push.
- [ ] Record submitted-vs-working divergence if the draft keeps changing.

## Active Stop Conditions

1. **No .doc/.rtf produced** — Corpora will not take PDF/LaTeX. Blocks submission.
2. **References not in Corpora style.** Blocks.
3. Content passes (rhetorical / metaphor / level-category / terminology) not re-verified after the 2026-07-10 edits.
4. EUP AI-disclosure form and author copyright form not completed.
5. DOCX metadata/Properties not anonymised.
6. ~~Three recent Corpora fit articles not yet pinned~~ — resolved 2026-07-10 (Larsson & Hancock 2026; Sönning 2025; Egbert & Biber 2023; Gries 2015).
