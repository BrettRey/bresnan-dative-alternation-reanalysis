# BNC2014 Harmonization

Purpose: define what can be transported from `languageR::dative` to the Spoken
BNC2014 dative dataset before fitting a cross-corpus model.

## Inspection Result

`analysis/04_inspect_bnc2014_dative.R` verifies the Figshare file metadata and
streams the public CSV through a temporary file only. No raw CSV is committed.

Key facts:

- Figshare article ID: `7353164`
- Dataset DOI: `10.6084/m9.figshare.7353164.v6`
- Article DOI: `10.5334/johd.11`
- Licence: CC BY 4.0
- CSV file ID: `16713434`
- CSV MD5: `1c041dbcb635855f3d8f4be9f3e1fced`
- Parsed dimensions: 1,839 rows, 44 columns
- Pattern counts: `VNN` = 1,474; `VNPP` = 365
- Verbs: `give`, `send`, `show`, `sell`, `offer`, `lend`

The apparent line-count discrepancy is resolved: the raw file has 1,839 newline
characters but no terminal newline, so it has 1,840 logical text lines including
the header and 1,839 parsed data rows.

## Outcome Mapping

| Claim target | `languageR::dative` | BNC2014 | Status | Decision |
|---|---|---|---|---|
| Double-object realization | `RealizationOfRecipient == "NP"` | `Pattern == "VNN"` | Direct | Map BNC `VNN` to `NP`. |
| Prepositional-dative realization | `RealizationOfRecipient == "PP"` | `Pattern == "VNPP"` | Direct | Map BNC `VNPP` to `PP`. |

This keeps the transport outcome binary and comparable. The label should be
described as production realization, not grammatical possibility.

## Predictor Mapping

| `languageR::dative` field | BNC2014 field | Status | Transport decision |
|---|---|---|---|
| `Verb` | `Verb` | Direct but restricted | All six BNC verbs occur in `languageR`, but the BNC verb set is only six verbs. Transport should evaluate on this shared six-verb subset or explicitly report the restriction. |
| `SemanticClass` | `VerbSemTag` | Proxy only | BNC has token-level semantic tags, not the same five Bresnan semantic classes. Do not treat these as the same predictor. Use only in a BNC-native model or a separate sensitivity check. |
| `LengthOfRecipient` | `RecLen` | Incompatible as released | BNC `RecLen` is character length from the cleaning script; `languageR` length is token-like. Derive recipient word counts in memory from `Recipient` if needed, and do not commit raw strings. |
| `LengthOfTheme` | `ThemeLen` | Incompatible as released | Same issue as recipient length. Derive theme word counts in memory for transport. |
| `AnimacyOfRec` | `AnimateRec` | Proxy/direct | Comparable binary construct, but BNC has 31 missing values and a different annotation path. Use with missingness reported. |
| `AnimacyOfTheme` | `AnimateTheme` | Proxy/direct | Comparable binary construct, but BNC theme animacy is regex-coded and heavily imbalanced: 26 true cases. Use with caution. |
| `DefinOfRec` | none released | Derivable proxy | BNC lacks a released recipient-definiteness field. A simple determiner regex over `Recipient` is possible in memory, but it must be labelled as a proxy. |
| `DefinOfTheme` | `DefTheme` | Proxy/direct | BNC `DefTheme` is regex-derived from theme text. Comparable enough for a first transport model if labelled as a proxy. |
| `PronomOfRec` | `RecPrn` | Proxy/direct | Comparable binary construct, but BNC has 112 missing values and derives it from semantic tags. |
| `PronomOfTheme` | `ThemePrn` | Proxy/direct | Comparable binary construct, but BNC has 139 missing values and derives it from semantic tags. |
| `AccessOfRec` | none | Unavailable | Drop from transport. Do not invent accessibility from BNC metadata. |
| `AccessOfTheme` | none | Unavailable | Drop from transport. Do not invent accessibility from BNC metadata. |
| `Modality` | corpus design | Constant in BNC | BNC2014 is spoken only. Either train/evaluate against the spoken `languageR` subset or include this as a corpus-level limitation, not as a varying predictor. |
| `Speaker` | none released | Unavailable | BNC has speaker metadata but no stable speaker ID in the released final CSV. Do not fit a cross-corpus speaker effect. |

## BNC-Only Predictors

BNC2014 adds social and interactional metadata that `languageR::dative` does not
have: age, gender, nationality, language background, dialect levels, education,
social grade, number of speakers, relation among speakers, and conversation
size. These can support a BNC-native model, but they are not transport
predictors.

## Minimal Transport Feature Set

The first transport model should use only fields that can be made comparable
with transparent caveats:

1. outcome: `NP`/`PP` mapped from `VNN`/`VNPP`;
2. verb: restricted to the six shared BNC verbs;
3. recipient/theme word lengths: derived in memory from BNC raw phrase fields;
4. recipient/theme animacy;
5. theme definiteness;
6. recipient/theme pronominality;
7. optionally recipient definiteness as a labelled regex proxy.

Accessibility and full verb semantic class should be excluded from the transport
model. They can be discussed as losses in the comparison.

## Modelling Implication

The transport test is not a literal replication of Bresnan et al. The correct
question is narrower: how much of the production-choice conditioning profile
survives when the model is moved to a later spoken British corpus with a smaller
verb set, different annotation, and no discourse-accessibility fields?
