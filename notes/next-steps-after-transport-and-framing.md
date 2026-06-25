# Next Steps After Transport And Framing

## Checkpoint

What we learned:

- The original `languageR::dative` data are American: Switchboard telephone speech from 1990-1991 plus Wall Street Journal Treebank material from the late 1980s.
- The BNC2014 target is British spoken data from 2012-2014.
- The transport result is positive but partial. The profile travels, but the residual gap cannot identify variety, period, register, annotation, or verb-set effects one by one.
- Brett's grammaticality/homeostatic property cluster (HPC) writing and the difference-in-differences (DiD) paper point in the same direction: keep the observed channel separate from the target.

Current approach:

- Working. The paper now has a clean empirical spine: robust reanalysis, partial transport, and a disciplined production/possibility boundary.
- The risk is overextension. Adding DAIS or neural language model work now would reopen the paper before the current argument has been made maximally clear.

## Recommendation

Do a polish-and-pressure-test pass next. Do not add a new empirical arm yet.

The next draft should make three things impossible to miss:

1. `languageR::dative` is not just "the old data"; it is late-1980s/early-1990s American source data.
2. BNC2014 is not a direct replication; it is out-of-domain transport to 2012-2014 British spoken data.
3. Production probability, judgement preference, and grammatical possibility are separate targets connected by evidence, not interchangeable labels.

## Immediate Work

1. Polish the abstract, introduction, and conclusion so the provenance and transport interpretation are visible before the results section.
2. Add one compact "claim ladder" paragraph or table if the prose still lets readers slide from production probability to grammatical possibility too quickly.
3. Tighten the data and code availability note. A good sentence would be: "No source corpus files are committed; scripts fetch public sources to temporary locations and write only derived summaries."
4. Build an objection matrix in notes before the next prose pass. The likely reviewer objections are:
   - BNC transport bundles too many differences.
   - High area under the receiver operating characteristic curve may hide calibration mismatch.
   - The paper gestures at grammatical possibility without testing acceptability directly.
   - The dative rows are a narrow opportunity set, not the full set of transfer-event expressions.
5. Decide whether Table 2 is enough or whether the paper needs one figure. If a figure is added, make it a transport diagnostic, not a decorative model comparison.

## Defer

- DAIS analysis: done narrowly in `analysis/08_dais_acceptability_bridge.R` after licence/permission cleared; keep it as an acceptability-preference bridge, not a second full target.
- Neural language models: defer unless the paper is reframed around the production/acceptability bridge.
- More `languageR` model variants: defer unless a reviewer asks. The current same-data result already answers that part of the question.

## Next Concrete Move

Write the objection matrix, then use it to do a targeted manuscript polish pass. After that, build, view, commit, and push.
