# Denominator Recovery And Figures
## Bottom Line
Yes: we can work out a missing denominator, or at least estimate it, by showing the nested denominators rather than choosing one too early. The released analysis rows give us the narrow denominator: attested dative-alternation tokens already classified as noun phrase (NP) or prepositional phrase (PP) recipient realizations. A broader denominator is empirically possible, but it changes the estimand.

That is not a weakness to hide. It is the next clean theoretical move. Your grammaticality-theory work treats grammaticality evidence as channel-bound and opportunity-conditioned. The denominator is exactly the opportunity set.

Grammaticality should be stated as the target in your current system: a
community-conditioned licensing status for form-value/form-meaning relations,
stabilized by cognitive and social mechanisms. Acceptability, raw judgement,
corpus frequency, formal generability, and standardness are neighbouring
constructs or evidence channels. Judgements matter because they are noisy,
role-dependent instruments, not because their raw responses are the target.
## Nested Denominators
| Level | Denominator | Question Answered | Feasibility | Main Risk |
| --- | --- | --- | --- | --- |
| D0  | Attested NP/PP dative rows | Given an alternation token, which realization was chosen? | Already done | Cannot speak to non-dative paraphrases or unattested alternatives |
| D1  | All candidate tokens of the six target verbs | How often do eligible verb tokens enter the alternation frame at all? | Plausible for BNC2014 if source queries or prefiltered files can be reconstructed | Verb tokens include many non-transfer uses and annotation exclusions |
| D2  | All transfer-event expressions | How often is a transfer event expressed by a dative alternation rather than another paraphrase or left implicit? | Possible only with new semantic/event annotation or a classifier with validation | The event definition may dominate the result |
| D3  | Constructed acceptable alternatives | Which low-frequency or unattested alternatives are acceptable to speakers? | Requires judgement data, DAIS-style data, or a new task | It is a judgement-channel result, not production frequency |

The current paper is D0 plus transport. The denominator extension should start with D1, not D2 or D3. D1 is close enough to the existing corpus design to be a genuine extension without turning the paper into a new acceptability study.
## What The Other Grammaticality Papers Add
The detector paper supplies the response/target/channel distinction. Corpus tokens are one channel; judgements are another; grammatical possibility is the target.

The de-idealized grammaticality paper supplies the missing term here: opportunity set. A low count is uninterpretable until we know whether the grammar had many chances to license the form, few chances, or many chances that were systematically preempted.

The expert-judge paper supplies reference-class discipline. A production corpus generalizes over produced tokens. A judgement task generalizes over responses to constructed items. Neither automatically generalizes over grammatical status.

The grammaticality-as-kind and homeostatic property cluster material supplies the bridging claim: frequency and absence matter when they are tied to a stable form-value coupling, but raw corpus presence or absence is not itself the coupling.
## BNC2014 Feasibility
The BNC2014 Figshare package is encouraging but not sufficient by itself. Its released cleaning script builds a prefiltered object, `verbs_all`, and then creates the released dative rows by filtering to:

```r
Pattern == "VNN" | Pattern == "VNPP"
```

That means a D1 denominator existed in the workflow: all six-verb candidate rows before the NP/PP filter. However, the public package appears to include the final CSV and scripts, not the prefiltered verb-specific concordance files or raw CQPweb exports needed to recreate `verbs_all` directly from the repository alone.

So the honest claim is:

> A broader corpus denominator is estimable in principle and probably recoverable for BNC2014, but not from the released dative rows alone.

The practical next step is a denominator feasibility spike:

1. Document the exact BNC2014 filtering path from source scripts.
  
2. Check whether the prefiltered concordance files can be obtained from BNC2014/CQPweb queries or the original authors.
  
3. If recoverable, compute D1 counts by verb and pattern before the NP/PP filter.
  
4. If not recoverable, report the limitation explicitly and keep the paper at D0 plus transport.
  

The original `languageR::dative` denominator is harder. Its sources are licensed Switchboard and Treebank/Wall Street Journal material, and the released R data already start at the annotated alternation rows. A D1 denominator for the original data would require reconstructing the original corpus extraction and annotation process, not just reusing the package.
## Figures To Consider

For now, over-produce figures and prune later. The right decision should come
after we can compare house-style versions of the candidate graphics.
### Figure 1: Nested Opportunity Sets
Use a conceptual figure in the grammatical-possibility section:

```text
Transfer events
  -> six-verb candidate tokens
    -> annotated NP/PP dative rows
      -> chosen NP vs PP realization
```

Then put judgement evidence beside, not inside, that production funnel:

```text
constructed alternatives -> acceptability responses -> grammatical possibility
```

This figure would do real argumentative work. It shows why the current analysis is valid, why it is not the whole grammaticality question, and where a recovered denominator would enter.
### Figure 2: BNC2014 Verb Calibration
Use the existing derived file `data/derived/bnc2014_transport_calibration_by_verb.csv` to plot observed versus predicted NP rates by verb. This is better than another AUC/log-loss bar chart because it shows where transport succeeds and where it misses:

- `give` and `show` are very close under transport.
  
- `offer` and `send` are underpredicted.
  
- `sell` is structurally different and remains the obvious stress case.
  
- `lend` is too sparse for a strong visual claim.
  

If we add only one empirical figure, this should be it.
## Recommended Revision Path
1. Add a short manuscript paragraph saying that the denominator is not impossible, but nested: the released rows provide D0; a recoverable BNC2014 source workflow may provide D1; D2 and D3 require different evidence.
  
2. Add the conceptual opportunity-set figure if the section still feels abstract.
  
3. Add the BNC2014 verb-calibration figure if we want one empirical graphic.
  
4. Run a small denominator feasibility spike before promising D1 results in the paper.
  

The main change from the previous next-steps note is that the denominator question is not a distraction. It is a controlled way to extend the paper without jumping all the way to neural language models or a new acceptability experiment.
