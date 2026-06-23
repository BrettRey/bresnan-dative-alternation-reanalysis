# Reviewer 5 — Contribution Skeptic / Desk-Reject Voice

**Paper:** Brett Reynolds, "Production probability, transport, and grammatical possibility: Reanalysing the English dative alternation with open data."

**Role:** Senior referee / handling editor predisposed to ask "why publish this?" Reviewing for a competitive linguistics journal.

---

## 1. One-sentence summary

The paper reproduces the languageR::dative production-choice models with modern partial pooling and null checks (and concedes this changes only the statistical packaging), runs one out-of-domain transport test to Spoken BNC2014 whose result it admits is causally unresolvable, and uses both to argue conceptually that production probability is not grammatical possibility — a point its own introduction states as already obvious.

---

## 2. Strengths (steelmanned honestly, before the knife)

I want to be fair to what is actually here, because the execution is more careful than most reanalyses I see.

1. **The reproducibility-plus-transport pairing is a real, if modest, empirical move.** I grant the central claim of §7: this is not just a refit. Bresnan et al.'s profile is (a) re-derived under explicit baselines, scrambled-label and fake-data null checks, and partial pooling, and then (b) carried to a corpus that differs in variety, period, register, and annotation, where it could have failed and did not (§4 Table 1, §5 Table 2). The transported core model clears both the marginal baseline (log loss 0.308 vs 0.473) and the scrambled-outcome control (0.885), and the directional coefficients (recipient/theme length, pronominality) point the right way (§5). That is a genuine out-of-sample test, not a same-corpus artefact, and the paper is unusually honest that the gap to the BNC2014-native model (0.202 log loss, 0.960 AUC) is a "bounded downgrade." Many published transport claims are weaker than this and less candid.

2. **The discipline of separating channel from target is executed cleanly, and the opportunity-set framing (§6, Fig. 2) is the paper's best original asset.** The nested-denominator point — that languageR and BNC2014 estimate realization choice *inside the annotated NP/PP frame*, not the full space of transfer-event encodings — is correct, concretely stated, and more rigorous than the usual hand-wave about "performance vs competence." The observation that no quantity of additional production tokens can ever reach the unattested-but-grammatical region (§6, final paragraphs) is the one sentence in the paper that earns its keep.

3. **Source and data hygiene is exemplary and review-ready.** Row counts, outcome counts, licence status, and the 1,839-vs-1,840 line-count artefact are all reconciled (§3, and notes/source-verification.md). The refusal to analyze DAIS because its repository has no licence file is the correct call and is disclosed. This paper will not embarrass an editor on the data-availability axis.

I say all this so the rest is not mistaken for reflex hostility. The problem is not quality. The problem is **contribution.**

---

## 3. Weaknesses (the desk-reject case)

### W1. Three half-results, no publishable whole — and the paper says so itself.

This is the core objection, and the paper hands me the evidence for it.

- **The languageR half is conceded as packaging only.** §4 states it twice in its own voice: "modern modelling changes Bresnan et al.'s linguistic conclusion or mainly repackages it statistically. The answer, so far, is the latter," and "It does not create a new grammatical conclusion on its own." §7 repeats: "The classic result is not overturned." So this half is, by the author's admission, a replication note. A competitive journal does not publish a confirmation that a 2007 result reproduces under better software unless the reproduction itself overturns or materially qualifies something. It does not.

- **The transport half is, by the paper's own admission, causally uninterpretable.** §5 is admirably frank: "the residual gap cannot be assigned to variety, period, register, annotation, or the six-verb restriction one by one. Those dimensions are bundled in this comparison" — and "Failure, if it had occurred, would not have identified a single cause." A test in which neither success *nor* failure can be attributed to any one factor is a test that licenses almost nothing. What survives is "the canonical six-verb core of the dative alternation behaves similarly in American 1990 telephone speech and British 2012–2014 speech." That the six most frequent, most canonical alternating verbs behave consistently across two corpora of conversational English is close to the prior expectation; §5 even concedes transport "is tested where the conditioning profile is most likely to hold." The informative cases (marginal, contested, idiosyncratic verbs) "go untested here." So the empirical novelty reduces to a positive result on the part of the space where a positive result was least surprising and least diagnostic.

- **The acceptability/possibility half analyzes no judgment data at all.** §5–§6 are the conceptual payload, but DAIS "is not analyzed here" (§5). The bridge from production to grammatical possibility — the thing the title promises with the word "possibility" — is described, diagrammed (Fig. 2), and then explicitly *not* built: "Crossing that boundary needs acceptability evidence, not more tokens" (§7). The paper ends by pointing at the contribution it did not make. A title with three nouns ("production probability, transport, and grammatical possibility") delivers one reproduced result, one confounded result, and one promissory note.

Each piece is defensible in isolation. None is sufficient. The cover holds them together; the argument does not.

### W2. The conceptual contribution is not new, and the paper concedes the premise in its first 12 lines.

The "structural blindness" thesis — production frequency is silent by construction about the grammatical-but-unattested region — is correct. It is also a restatement of points that are foundational, not novel:

- That **performance underdetermines competence** is the oldest commitment in generative grammar (Chomsky 1965; **NEEDS VERIFICATION** that the paper does not already cite this — I see no Chomsky cite in the seven sections, which is itself a problem for a paper claiming to mark the production/grammar boundary).
- That **rarity is not ungrammaticality** is stated by *this paper's own §1*: "A rare pattern can be lexically restricted, strongly dispreferred, or tied to a discourse context without falling outside the grammar." If the headline conceptual move is already "easy to misread" common ground in the introduction, it cannot also be the paper's contribution in §6.
- Bresnan et al. (2007) themselves framed their work as showing that intuitions *underestimate* the space of grammatical possibility (per notes/source-verification.md, citing the MPI abstract: usage data can reveal grammatical possibilities that judgments miss). The present paper's §1 and §2 attribute exactly this framing to Bresnan. So the conceptual axis the paper occupies was opened by the very work it reanalyzes. Recasting "usage reveals possibility" (Bresnan) as "usage cannot reach possibility without a judgment bridge" (this paper) is a sharpening of emphasis, not a new claim — and it is a sharpening the paper does not operationalize, because the judgment data is absent.

The opportunity-set / nested-denominator formalization (Fig. 2) is the strongest candidate for novelty. But a single conceptual diagram, however clean, is a discussion-note contribution, not a research-article one. It would land better as two paragraphs in a paper that *used* it to adjudicate a real case.

### W3. Venue mismatch: this is a replication note plus a position piece, submitted as a research article.

Where would this go? Walk the options:

- **A flagship general linguistics journal** (*Language*, *Linguistics*) wants a result that changes how the field models the alternation. By the paper's own §4/§7, the model does not change the conclusion. Desk-reject for insufficient advance.
- **A quantitative/usage venue** (*Corpus Linguistics and Linguistic Theory*, *Journal of Linguistics*) will ask what the transport test establishes that the bundled-confound admission does not immediately retract. The honest §5 answer — "core verbs travel, periphery untested, residual gap unattributable" — is a methods caution, not a finding.
- **A reproducibility / open-data venue** (a registered-report or data-paper track) is the *natural* home for the languageR half and the BNC2014 harmonization, and there the data hygiene (§3) is a strength. But such venues will not credit the §6 conceptual essay as the contribution, and stripping it leaves a competent but unsurprising replication-plus-transport data note.

The structural problem is that the two genuinely good components belong to two different genres with two different reviewer expectations. Submitting them together to one competitive venue invites each set of reviewers to reject the half they were not asked to value.

---

## 4. Key question at Q&A

> You concede in §4 that the languageR reanalysis only repackages the 2007 conclusion, and in §5 that the transport result is "too bundled to identify separate variety, period, register, or annotation effects," and you do not analyze any acceptability data. Strip those three concessions out and state, in one sentence, the *new claim about the English dative alternation* — not about method, not about what future work could do — that a reader could not have made before reading this paper. If the only honest answer is "the canonical six-verb core transports across two corpora," why is that more than a footnote to Bresnan et al.?

A strong rebuttal would have to either (a) reframe the paper explicitly as a reproducibility-plus-conceptual-framework note for the right venue and drop the research-article posture, or (b) build the DAIS bridge so the "possibility" in the title is earned by data rather than diagram. Without one of those, the question has no answer that survives the paper's own admissions.

---

## 5. Verdict

**Reject (as a research-article submission to a competitive linguistics journal), with explicit encouragement to resubmit reframed.**

One-line justification: by its own repeated admissions the paper offers a replication that changes only packaging (§4), a transport test whose result is causally unattributable and tested only where success was least surprising (§5), and a conceptual distinction the paper itself states as obvious common ground in §1 — three half-results under one cover, none sufficient for this venue, though the opportunity-set framing and data hygiene would make a strong open-data/methods note if reframed and if the DAIS judgment bridge were actually built.

---

## Source-grounding flags

- **NEEDS VERIFICATION (internal inconsistency):** §5 states DAIS "contains human judgements for 5,000 dative sentence pairs." notes/source-verification.md records "50K human judgments for 5K distinct sentence pairs" (50,000 judgments over 5,000 pairs, 200 verbs). The paper's prose collapses the judgment count and pair count; the sentence as written undercounts the judgments by an order of magnitude. Fix to "50,000 human judgements for 5,000 dative sentence pairs" or similar.
- **NEEDS VERIFICATION:** No Chomsky (1965) or comparable competence/performance citation appears in any of the seven sections. A paper whose central conceptual move is the performance/competence (production/grammaticality) boundary should locate that move in the literature that originated it; its absence both weakens the novelty defense and risks a reviewer reading the framing as under-cited. Confirm whether such a citation exists elsewhere in main.tex (it does not appear in §1–§7).
- Empirical numbers in §3–§5 (row counts 3,263 / 1,839; outcome counts; log loss and AUC values; verb std. dev. 2.106) were cross-checked against notes/source-verification.md and the section tables and are internally consistent. I did not re-run the analysis scripts; the modelling metrics themselves are taken on trust from the paper's own derived files.
