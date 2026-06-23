# Reviewer 1 — Cross-variety probabilistic-grammar referee

**Paper:** Brett Reynolds, "Production probability, transport, and grammatical possibility: Reanalysing the English dative alternation with open data."

**Standpoint:** Cross-variety probabilistic grammar (Bresnan; Bresnan & Ford; Gries-style corpus methods; Szmrecsanyi/Grafmiller comparative-variation programme). Reviewing for a linguistics journal, pre-submission stress test.

---

## 0. What the paper is doing (Rapoport pass, so the criticism lands on the real argument)

I want to state the argument as the author would want it stated. The paper is a deliberately modest, no-new-data reanalysis with three moves, and it is honest about being modest.

1. **Reproduction.** It refits the `languageR::dative` production-choice model (NP double-object vs. PP prepositional recipient) with explicit baselines, a scrambled-label falsification check, fake-data checks, and a hierarchical verb-intercept model. The finding (Section 4, Table 1) is that modern modelling does not overturn Bresnan et al.'s conclusion; the fixed-verb and partial-pooling models reach essentially the same held-out AUC (~0.951–0.952), and the verb random-intercept SD of 2.106 shows lexical conditioning survives pooling. The paper is careful to call this "a robustness result," not a new linguistic claim.

2. **Transport.** It trains a six-verb spoken `languageR` model and evaluates it out-of-domain on the Spoken BNC2014 dative dataset (Jenset & McGillivray). Table 2 shows the transported model beating both a marginal baseline (0.308 vs. 0.473 log loss; AUC 0.906) and a scrambled-outcome control (0.885 log loss, AUC 0.515), while a BNC2014-native model does better still (0.202 log loss, AUC 0.960). The paper reads the gap as "a bounded downgrade rather than an apology" and is explicit that the residual cannot be decomposed into variety/period/register/annotation because those are bundled.

3. **Conceptual payoff.** It uses the transport result to keep three things apart — production probability, acceptability preference, grammatical possibility — and to mark a structural limit (Section 6): a production model is silent *by construction* about the grammatical-but-unattested region, "no amount of additional production data closes this gap."

**Non-obvious agreements and things I learned.** The opportunity-set framing in Section 6 is genuinely good and I have not seen it laid out this cleanly in the dative literature: the explicit point that the released rows estimate realization choice *inside an already-annotated NP/PP denominator*, not over the wider set of transfer events that could have been paraphrased, omitted, or otherwise packaged (Section 3, lines 30–35; Section 6, lines 29–35). That is a real and underappreciated denominator problem, and the nested-opportunity-set figure is the right way to show it. The discipline of refusing to identify a single cause for transport failure (Section 5, lines 66–70 and 88–92) is exactly the caution I want from a corpus methodologist and is more honest than most transport papers. And the recipient-definiteness proxy being demoted to a sensitivity check (Section 5, lines 106–109) is the correct call. I would happily sign off on the *temperament* of this paper.

Now the sharp part.

---

## 1. One-sentence summary of the main claim

A reproducible refit of Bresnan et al.'s dative production model, plus an out-of-domain test on Spoken BNC2014, shows the conditioning profile is durable and partly transportable, but production probability remains structurally distinct from grammatical possibility because a production model is silent about the grammatical-but-unattested region.

---

## 2. Strengths

- **Honest, well-instrumented reproduction.** The baseline/scramble/fake-data scaffolding (Section 4, lines 37–41) is more falsification-minded than the original 2007 study and than most reanalyses. The partial-pooling result (verb-intercept SD 2.106) is the right way to show lexical conditioning is not a parameterization artefact. This is competent, cautious quantitative work.

- **The opportunity-set / denominator argument (Section 6).** The explicit statement that the corpus estimates conditional choice *given entry into the annotated alternation frame*, and that more tokens "enlarge the attested region without ever reaching the unattested-but-grammatical one" (lines 60–64), is the paper's best idea. It is a clean, general, levels-respecting point about what usage frequency can and cannot license, and it deserves to be the spine of the paper.

- **Refusal to over-read the transport result.** Stating up front that success cannot be credited to, and failure cannot be blamed on, any single dimension because variety/period/register/annotation/verb-set move together (Section 5, lines 66–70, 88–92) is the methodologically correct posture. Many transport papers claim a clean "variety effect" they have not earned; this one explicitly declines to.

---

## 3. Weaknesses (specific, actionable)

### 3.1 The transport contribution is not located in the literature that owns it — and this is disqualifying as written.

This is my central objection and it is concrete, not stylistic. I checked the bibliography. The paper cites `bresnan2007` and the DAIS paper (Hawkins, Yamakoshi, Griffiths & Goldberg 2020) and nothing else in the relevant conceptual space. It cites **neither Bresnan & Ford 2010** ("Predicting syntax: Processing dative constructions in American and Australian varieties of English," *Language* 86) **nor any of the comparative-variation probabilistic-grammar literature** (Szmrecsanyi, Grafmiller, Bresnan, and colleagues). Neither Bresnan & Ford nor any Szmrecsanyi/Grafmiller entry exists in `references.bib` or `references-local.bib`. *[VERIFICATION: the absence of these citations in the submitted bib is confirmed by grep; the identity of Bresnan & Ford 2010 as an American/Australian cross-variety dative study using the dative-model predictors is well established, but the author must read it directly and cite specifics — do not paraphrase its findings from memory.]*

The problem is not a missing footnote. The whole "transport" move — fit a probabilistic dative grammar on one variety, test whether the conditioning profile holds in another — **is the defining research operation of that programme.** Bresnan & Ford already ran a US-vs-Australian comparison on dative constructions with these predictors. The comparative-variation work (Szmrecsanyi, Grafmiller, et al.) explicitly developed the vocabulary and methods for asking whether a probabilistic grammar is shared across varieties, and for which predictors. *[VERIFY specifics of that programme's claims before citing; do not invent coefficient-level results.]* A referee from that tradition will read Section 5 and ask: **what is a US-telephone-to-British-conversation transport test contributing beyond what Bresnan & Ford and the cross-variety programme already established?** As written, "transport" reads like out-of-domain generalization with bundled confounds, relabelled with a fresh term, and presented as if the conceptual ground were open. It is not open; it is densely occupied. The author must (a) cite that literature, (b) say plainly what is *new* here relative to it, and (c) either adopt its established terminology or justify "transport" as a distinct construct. Right now the paper's novelty claim cannot be assessed because the comparison class is absent from the page.

A secondary casualty: the paper's own caution ("variety, period, register, annotation all move together," Section 5) is *exactly* the confound-control problem the comparative-variation programme works on. By not engaging that programme, the paper reinvents the worry without inheriting any of the tools developed to address it (e.g., holding register/genre constant, matching annotation, multi-corpus designs). The author should be borrowing those tools, not rediscovering the gap.

### 3.2 The reanalysis risks flattening Bresnan's grammar claim into mere prediction.

Bresnan's standpoint matters here and the paper half-honours it. Section 2 correctly states the 2007 claim is "not that whatever occurs often is grammatical" but that observed choices "expose systematic constraints on what speakers treat as available" — a claim about the **grammar/usage relation**, that gradient probabilistic conditioning is itself part of speakers' grammatical knowledge, not noise on top of a categorical competence. But the modelling sections then evaluate the profile almost entirely as *held-out prediction* (log loss, AUC). The verdict in Section 4 — "modern modelling confirms the classic production-choice conclusion" — confirms the *predictive* conclusion. It does not engage the stronger Bresnan thesis that the probabilistic conditioning is grammatically real, i.e., that the same conditioning shows up in comprehension/processing and acceptability, not just production. Bresnan & Ford 2010 is precisely the paper that pushed the dative profile into *processing and reading* to argue the grammar is probabilistic across modalities — which is why its absence (3.1) is doubly costly here. As it stands, Section 6's careful separation of production from grammaticality can read as quietly conceding more than Bresnan would: if you demote production probability to "evidence about grammatical possibility, not a synonym for it" without engaging the cross-modal evidence that the conditioning *is* grammatical knowledge, you have arguably weakened the original claim rather than reproduced it. **Action:** state explicitly whether the paper endorses, qualifies, or rejects the strong Bresnan thesis, and bring the cross-modal evidence (comprehension, acceptability) to bear rather than gesturing at DAIS as future work.

### 3.3 The six-verb intersection is treated as a scope limit when it is also a confound, and the transport test may be a convenience sample. (Gries standpoint.)

The paper is admirably frank that the two datasets "intersect only on this high-frequency core" (Section 5, lines 72–78) and frames this as a bounded-scope caveat: transport is tested where the profile is "most likely to hold." Good. But a corpus methodologist will press two things the paper does not confront:

- **Selection on the dependent variable's easiest region.** Testing transport only on the six most canonical, most frequent, most NP-biased verbs is testing it where success is most likely *and least informative*. The interesting transport question is whether the profile holds for verbs with contested or variety-specific dative behaviour — exactly the verbs that are not shared. So the headline "the profile travels" is true of the core by construction. The paper says this; it does not let it discipline the abstract or conclusion, which still read as a general transport endorsement.

- **Annotation non-equivalence as a live confound, not just a "lossy harmonization" footnote.** The length proxy is reconstructed in memory (character-to-word, Section 5, lines 16–18); recipient definiteness is a regex proxy; accessibility is dropped entirely. From a Gries-style alternation-evidence standpoint, these are not minor: if the `VNN`/`VNPP` annotation in BNC2014 and the `languageR` NP/PP coding do not pick out the *same envelope of variation* (e.g., differ on benefactives, idioms, fixed expressions, or what counts as an alternating token), then the transport comparison is partly measuring annotation mismatch, not grammar. The paper acknowledges bundling but never audits whether the two annotation schemes define the alternation the same way. **Action:** report the verb-by-verb token counts and an explicit comparison of what each scheme counts as an in-envelope dative token; justify the six-verb set as a fair test or relabel it a proof-of-concept. The current Figure (calibration by verb) helps but is not a substitute for an envelope-equivalence check.

---

## 4. Key question I would ask at Q&A

"Bresnan & Ford 2010 already fit a probabilistic dative grammar on one American variety and tested it against Australian English, and the comparative-variation programme built methods for exactly this kind of cross-variety projection. Strip away the word 'transport': what does your US-telephone-to-British-conversation test establish that those studies did not — and given that variety, period, register, annotation, and a hand-picked six-verb core are all confounded in your single comparison, on what grounds is this a *test of grammar* rather than out-of-domain prediction with the confounds left in?"

---

## 5. Verdict

**Revise & Resubmit.** The quantitative work is sound and the opportunity-set argument is a real contribution, but the paper is unsubmittable until it engages Bresnan & Ford 2010 and the cross-variety probabilistic-grammar literature, states its novelty against them, and converts its honest confound caveat into either an envelope-equivalence audit or an explicit downgrade of the transport claim's scope.

---

### Single most damaging point

The entire "transport" contribution sits in conceptual territory already owned by Bresnan & Ford 2010 and the comparative-variation probabilistic-grammar programme, yet the paper cites none of it (confirmed absent from both bib files); until the author engages that literature and says what is new, "transport" reads as out-of-domain generalization with bundled confounds, relabelled.
