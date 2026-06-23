# Production And Possibility

Purpose: keep the paper from sliding from production probability to grammatical
possibility without an explicit bridge.

## Three Targets

| Target | Evidence type | What it can show | What it cannot show alone |
|---|---|---|---|
| Production choice | Corpus tokens, `languageR::dative`, BNC2014 | Which realization speakers/writers actually used under observed conditions | Whether an unattested alternative is grammatical |
| Acceptability preference | DAIS, judgement studies, controlled minimal pairs | How speakers compare constructed alternatives under controlled contrasts | Natural production frequency in real discourse |
| Grammatical possibility | Theoretical claim over possible forms | Whether a construction belongs to the grammar, including rare or unattested cases | Production probability without auxiliary assumptions |

## Current Evidence

The `languageR::dative` reanalysis supports a strong production-choice claim:
the original conditioning profile is reproducible, beats real null checks, and
survives partial pooling. It does not by itself show that low-probability or
unattested alternatives are grammatical.

BNC2014 can test transport. If the conditioning profile survives there, the
production result becomes less corpus-local. If it fails, the failure is still
informative because it locates where the classic profile depends on corpus,
variety, period, verb inventory, or annotation regime.

## Opportunity Set

The `languageR::dative` and BNC2014 analyses define a narrow opportunity set:
attested dative-alternation tokens already coded as NP or PP realization. This
is enough for conditional production choice, but it is not the full set of
contexts where a transfer event could have been expressed, omitted, paraphrased,
or judged acceptable in more than one form.

This imports the useful lesson from the left-branch-extraction paper: a corpus
claim becomes interpretable only after the denominator is explicit. For this
paper, the denominator is not "all possible dative meanings." It is "tokens that
entered the corpus sample as dative-alternation observations."

## Boundary Cases Production Cannot See

Production data is structurally weak for:

- grammatical but rare realizations;
- grammatical but unattested realizations;
- unacceptable but produced performance errors;
- alternatives made visible only by controlled contrast;
- speaker preferences masked by discourse frequency.

This is why a scrambled-label or fake-data null is necessary but not sufficient:
null checks tell us the production model is not learning pure noise; they do not
turn production frequency into a direct grammaticality measure.

## Role For DAIS And NLMs

DAIS and neural language models should enter only if they test the boundary
between production and acceptability:

- Do human preference judgements preserve the same verb-bias profile as
  production tokens?
- Do low-frequency but grammatical alternatives receive acceptable ratings?
- Do model probabilities track production, human preference, both, or neither?

Until that probe is implemented, DAIS/NLMs should remain background or future
work. They should not be advertised as part of the title or the core result.
Because the DAIS repository has no explicit licence file, this project should
cite DAIS but not fetch, analyze, or redistribute the DAIS files without further
permission or a clearer licence record.

## Manuscript Language

Use this discipline in the paper:

- Say "production probability" for `languageR` and BNC2014 models.
- Say "transport" for cross-corpus generalization.
- Say "grammatical possibility" only when the argument has crossed the bridge
  from attested production to possible alternatives.

The paper's honest current claim is: modern open reanalysis can show that
Bresnan et al.'s production-choice result is robust and then test whether it
transports; grammatical possibility remains the motivating question, not the
direct output of a production model.
