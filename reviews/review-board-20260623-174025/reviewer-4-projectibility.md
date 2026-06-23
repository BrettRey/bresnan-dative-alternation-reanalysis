# Reviewer 4 — Projectibility / philosophy of linguistics

**Paper:** Brett Reynolds, "Production probability, transport, and grammatical
possibility: Reanalysing the English dative alternation with open data."

**Reviewer stance:** Philosopher of linguistics; mandatory projectibility
reviewer; Pullum-style gradience scepticism; sensitive to the
competence/performance distinction (adjacent to Nefdt and Miller on
grammaticality as a kind).

---

## 1. One-sentence summary

A careful, honest no-new-data reanalysis of Bresnan et al. (2007) that
reproduces the production-choice profile, adds real null checks and a genuine
cross-corpus transport test, and then tries to cash the result out as a claim
about projectibility and grammatical possibility — but the conceptual payoff
(sections 1, 6, 7) is asserted in the vocabulary of projectibility while doing
the work of the old competence/performance distinction, and the "for a purpose"
clause that would make projectibility load-bearing is missing.

---

## 2. Strengths

1. **The empirical spine is genuinely good and genuinely honest.** The transport
   test (section 5, table 2) is the real contribution: a model trained on
   spoken `languageR` rows is evaluated out-of-domain on BNC2014, beats the
   marginal baseline (0.308 vs 0.473 log loss; AUC 0.906), collapses on a
   scrambled outcome (0.885 / 0.515), and still loses to the BNC2014-native
   model (0.202 / 0.960). The paper reports the gap as a "bounded downgrade,"
   refuses to attribute the residual to any single cause because variety,
   period, register, annotation, and the six-verb restriction are bundled, and
   says so plainly. This is exactly the discipline a transport claim needs. The
   null checks in section 4 (scrambled-label, fake-data collapse to singular
   random effects, fake verb-effect recovery) are the right falsification
   apparatus and are described at the correct explanatory level ("these checks
   make the production result more credible, but they do not change its
   explanatory level," section 4).

2. **The level-keeping is real and consistently maintained.** The paper never
   slides from frequency to grammar. Section 2 separates "impossible / rare /
   wrong verb / missing discourse condition / stripped context" as distinct
   sources of a single informal verdict. Section 6's target/channel distinction
   (corpus choices are one channel, judgements another, grammaticality the
   target both bear on indirectly) is the right shape for the problem and is the
   paper's best conceptual move. The opportunity-set figure (nested
   denominators) is a good way to make the "silent by construction" point
   concrete rather than rhetorical.

3. **Scope honesty about the six-verb core.** Section 5 concedes that the two
   datasets intersect only on the high-frequency canonical verbs, so transport
   is tested "where the conditioning profile is most likely to hold," and the
   result "licenses a claim about the core, not about the periphery, where
   projectibility is hardest to establish." That is precisely the right caveat,
   and it is the one place where projectibility is used to do actual epistemic
   work rather than as decoration (see Weakness 1 for why it is the exception).

---

## 3. Weaknesses (actionable)

### W1. Projectibility is named, not cashed out — the "for a purpose" clause is missing (MAJOR, structural)

This is my mandate and it is the paper's central structural problem. The slogan
for a projectible kind is **a profile, stabilised by mechanisms, projectible for
a purpose**. The paper delivers the first clause richly (the conditioning
profile), gestures at the second (section 6: "Cognitive and social mechanisms
stabilize that status"), and **never states the third**. Projectibility appears
in three places:

- Section 1 frames the whole question as projectibility, citing Goodman 1955.
- Section 5 says success is "evidence that the conditioning profile is
  projectible across macro-variety and period, not just refittable."
- Section 6 defines grammar-membership via projection: "licensed strongly enough
  to project to new cases."

But ask the Boyd question: **projectible *for what purpose*, and *what* does the
category let you predict, explain, or inductively generalize that you couldn't
otherwise?** The paper's answer, when you trace it, is: it lets you predict
held-out production choice in another corpus. That is a prediction-accuracy
result. Projectibility here is functioning as an *honorific re-description of a
good AUC on a transfer set*, not as an epistemic engine that generates new
predictions about the kind.

Concretely: section 5's "projectible across macro-variety and period" is
literally a paraphrase of "the model transports." Strip the word "projectible"
and replace it with "transfers" and not one inference in the paper changes. That
is the diagnostic for ornament. Compare the one place it *isn't* ornament — the
six-verb-core caveat (Strength 3), where projectibility does real work because
it marks *where the induction is licensed and where it is not* (core vs
periphery). The paper has the materials to make projectibility load-bearing; it
just doesn't follow through. **What would fix it:** state, in section 6 or 7,
what the kind [grammatical-possibility-for-the-dative] licenses you to project
that production probability alone does not — e.g., predictions about
unattested-but-grammatical verbs, about acceptability under DAIS-style
manipulation, about new varieties, about the *boundary* of the alternation. Name
the purpose (explanatory? predictive? guiding the next data collection?). Right
now the conclusion (section 7) cashes out in "the classic result is reproducible
and partly transports" — a result about *what holds the profile together and how
far it travels*, never about *what the category buys you*. By Boyd's lights that
is the wrong terminus.

### W2. "Structural blindness" is the competence/performance distinction relabelled, and the paper does not earn the new label (MAJOR)

Section 6's core claim — "a production model ... is silent by construction about
realizations that are grammatical but unattested" and "no amount of additional
production data closes this gap" — is, stripped of the corpus-modelling dress,
exactly the classic point that **performance data underdetermine competence**.
A finite corpus cannot exhibit the grammatical-but-unattested region; more
performance does not yield competence. Chomsky 1965, Miller and Chomsky 1963
(the latter is already in your bib, `Miller1963`). The paper presents this as
a finding ("the paper's centre," section 7) without acknowledging that it is a
sixty-year-old observation. Two things follow:

- **Rapoport-style charitable reading first:** the paper *does* add something
  real over the bare competence/performance point — it makes the boundary
  *quantitative and demonstrable* (the opportunity-set denominators, the "more
  tokens enlarge the attested region without ever reaching the
  unattested-but-grammatical one"), and it ties the gap to a *specific
  remediation* ("crossing that boundary needs acceptability evidence, not more
  tokens," section 7). That is a genuine sharpening: it tells you *which other
  channel* closes the gap and why. So the contribution is not nil.

- **But the paper must say what it adds and where it differs.** As written, a
  Pullum-minded reader will say: you have relabelled performance/competence as
  "production probability / grammatical possibility" and rediscovered that one
  doesn't fix the other. Section 6 needs one paragraph that (a) names the
  competence/performance lineage, (b) states precisely the delta ("structural
  blindness" makes the underdetermination *measurable* and *channel-specific*),
  and (c) defends why the new vocabulary earns its keep. Without that, the
  centrepiece reads as old wine.

### W3. The grammaticality definition is stipulated, and it smuggles a categorical notion back in after gesturing at gradience (MODERATE-MAJOR)

Section 6: "grammaticality: a community-conditioned licensing status for
form–value, or form–meaning, relations. ... A form belongs to the grammar when
the relevant relation is licensed strongly enough to project to new cases."

Three problems, in increasing severity:

- **Stipulation, not defence.** This definition arrives fully formed with no
  argument and no citation. Given the bib already contains Nefdt and Miller on
  grammaticality-as-a-kind and Boyd on HPC, the omission is conspicuous (see
  W4). A definition this consequential needs either a derivation or an
  acknowledged source.

- **Pullum's knife: a categorical boundary re-enters through "strongly
  enough."** The paper opens (sections 1–2) by celebrating gradience — rare,
  conditioned, lexically restricted patterns that are *still grammatical*. Then
  section 6 installs a *threshold*: "licensed strongly enough to project."
  "Strongly enough" is a categorical cut on a graded quantity. Where is the
  threshold? Who sets it? If the alternation is graded all the way down (which
  the production models suggest), then "belongs to the grammar" is either (i) a
  sharp line the paper has not located and has earlier argued against, or (ii)
  itself graded, in which case "belongs to the grammar" should be "is licensed
  to degree d," and the binary verb "belongs" is misleading. The paper cannot
  have it both ways: it spends five sections dissolving the categorical verdict
  and then reinstates one in its definition. This is precisely the move a
  gradience-sceptic-of-the-sceptics will pounce on.

- **"Projects to new cases" makes the definition circular with the result.**
  Grammaticality is defined *as* projectibility ("licensed strongly enough to
  project"), and then the empirical result is offered as *evidence about*
  projectibility. If membership in the grammar just *is* projecting to new
  cases, then the transport result is not evidence about grammaticality — it is
  partly constitutive of it, and the paper owes an account of why a *production*
  transport result is not, on its own definition, already a grammaticality
  result. This tension sits unresolved between section 5's "projectible across
  variety and period" and section 6's insistence that production probability is
  not identical to grammaticality.

### W4. Goodman fits but is under-used; Boyd, Nefdt, Miller are in the bib but never cited (MODERATE)

Goodman 1955 (*Fact, Fiction, and Forecast*) is the right source for
projectibility and is correctly the canonical reference — verified, see source
notes below. But it is cited *once*, in section 1, and never engaged. Goodman's
actual content (entrenchment, the new riddle of induction, why *some*
predicates project and others don't) is exactly what would let the paper argue
*which features of the conditioning profile are projectible and which are not* —
e.g., why recipient pronominality travels (section 5) but theme definiteness
flips sign. That is a live Goodmanian question the paper raises in its data and
then doesn't connect to its only philosophical citation. As it stands the
Goodman cite is closer to name-dropping than engagement, and a referee in this
venue will read it that way.

More serious for a *projectibility* mandate: the bib contains Boyd (HPC),
Nefdt, and Miller, all directly relevant to "grammaticality as a projectible
kind," and **none is cited in the body**. The paper's section-6 definition is
doing HPC-flavoured work (cluster of conditioning features, stabilised by
"cognitive and social mechanisms," membership via projection) without ever
invoking the HPC framework that would license and discipline it. If the kind
is meant to be projectible-for-a-purpose in Boyd's sense, say so and cite Boyd.
If it is not, then drop the mechanism-and-projection framing and own a
different account. Right now the paper gets the *aroma* of HPC projectibility
without the *commitments*, which is the worst of both worlds.

---

## 4. Key question at Q&A

**"Replace the word 'projectible' with 'transfers' everywhere it appears and tell
me which inference in the paper changes. If none does, then projectibility is a
re-description of your transport AUC, not the epistemic payoff. So: what does the
category 'grammatical possibility for the dative' license you to predict,
explain, or inductively generalize — about unattested verbs, about acceptability,
about new varieties — that a well-fitted production model does not? Name the
purpose the kind is projectible *for*. And while you're at it: how is 'silent by
construction about the grammatical-but-unattested region' more than the claim
that performance underdetermines competence?"**

---

## 5. Verdict

**Revise & Resubmit.** The empirical work is sound, honest, and worth
publishing; the conceptual frame is currently an ornament on a transport result
— projectibility is named but not cashed out, "structural blindness" relabels
competence/performance without naming the delta, and the grammaticality
definition is stipulated and smuggles a categorical threshold back in. All four
are fixable in revision without new data, and the materials to fix them are
already in the paper and the bibliography.

---

## Source-grounding notes (citations checked against the repo bib)

- **Goodman 1955** — VERIFIED in `references.bib` (line ~3751): *Fact, Fiction,
  and Forecast*, Harvard University Press, 1955. Correct canonical source for
  projectibility / the new riddle of induction. (Cited once, section 1.)
- **bresnan2007** — present in `references.bib` (`@incollection`, line ~6676).
  Used as `\textcite` in sections 1–2. Not independently verified for
  page/volume here; flag only if final citation details are claimed.
- **Boyd** — multiple entries present in `references.bib` (HPC, Boyd 1990, 1999,
  etc.). **NOT cited in any section.** My "projectible for a purpose" framing
  attributes the slogan to Boyd's HPC programme; the paper does not invoke it,
  so this is a *recommended* engagement, not a claim the paper makes.
- **Pullum** — multiple entries in `references.bib`. **NOT cited in any
  section.** My gradience-scepticism framing is the reviewer's lens, not a claim
  in the paper.
- **Nefdt, Miller** — entries present in `references.bib` (`Nefdt...`,
  `Miller1963` = Miller & Chomsky 1963; `Miller, J. T. M.` philosophy entry).
  **NOT cited in any section.** `Miller1963` is the relevant
  competence/performance source already available to the author for W2.
- I have **not** fabricated any page numbers, quotations, or claims attributed
  to these authors. Where I invoke Boyd's slogan, Goodman's entrenchment, or the
  Chomsky/Miller competence-performance point, those are standard positions
  flagged as the reviewer's framing; the author should verify exact wording and
  pages before incorporating any of them.
