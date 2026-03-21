# PCR Amplification

The FoodSeq workflow uses a two-step PCR approach.

A primary qPCR amplifies the target locus from extracted DNA: trnL(UAA)gh for plants and 12SV5 for animals. All amplification primers include Illumina overhang adapter sequences added at the 5' end. Primary qPCR for 12SV5 also includes a human blocking primer. All primary qPCR primers that are used with KAPA HiFi HotStart DNA Polymerase (Roche, Basel, Switzerland) include a phosphorothioate (PS) bond for protection from exonuclease activity.

A secondary PCR adds Illumina adapters and dual 8-bp indices for sample multiplexing.

Primers are custom-synthesized DNA oligos (Integrated DNA Technologies, Coralville, IA) with standard desalting purification.

**Table 1.** FoodSeq primers. Locus-specific sequences are bolded and Illumina adapters are in standard typeface.

| Name | Primer sequence 5'–3' | Reference |
|---|---|---|
| trnL(UAA)g | TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG**GGGCAATCCTGAGCCA\*A** | Taberlet et al., 2007 |
| trnL(UAA)h | GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG**CCATTGAGTCTCTGCACCTAT\*C** | |
| 12SV5F | TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG**TAGAACAGGCTCCTCTAG** | Shehzad et al., 2012 |
| 12SV5R | GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG**TTAGATACCCCACTATGC** | |
| DeBarba14 HomoB | **CTATGCTTAGCCCTAAACCTCAACAGTTAAATCAACAAAACTGCT**/3SpC3/ | De Barba et al., 2014 |
| i7 indexing primer | CAAGCAGAAGACGGCATACGAGAT*XXXXXXXX*GTCTCGTGGGCTCGG | Illumina, 2025 |
| i5 indexing primer | AATGATACGGCGACCACCGAGATCTACAC*XXXXXXXX*TCGTCGGCAGCGTC | |

*XXXXXXXX* denotes 8-bp barcode sequences, available from Illumina ([Illumina Adapter Sequences](https://support-docs.illumina.com/SHARE/AdapterSequences/Content/Nextera-DNAIndexes.htm)).

All PCR setups should be performed in a PCR hood or designated clean area. Clean the work area with surface decontaminant, then treat with UV light for 15 minutes before beginning.

## Primary qPCR

=== "trnL"

    ### Materials

    - KAPA HiFi Hot Start PCR Kit with dNTP Mix (Roche, Basel, Switzerland; Cat. No. KK2502)
    - 10 µM working stock of trnL(UAA)g primer with Illumina bridges (Table 1)
    - 10 µM working stock of trnL(UAA)h primer with Illumina bridges (Table 1)
    - SYBR Green I (Thermo Fisher Scientific, Waltham, MA) — diluted in DMSO to 100X
    - Extracted DNA from stool sample
    - Positive control template DNA
    - Nuclease-free water

    ### Protocol

    Generate enough PCR master mix for the reactions desired according to Table 2. The reaction mix and plate must be kept on ice. Aliquot 7 uL of mix into each well.

    Add 3 uL of nuclease-free water to no-template control wells (recommendation: 5 wells). Add 3 uL of DNA template to sample wells. Add 3 uL of control DNA to positive control wells (recommendation: 3 wells).

    Seal the plate with optical film. Briefly spin down the plate. Run the qPCR with cycling conditions from Table 3.

    After the run, transfer plates to -20 °C if processing is going to be paused; otherwise, keep plates at 4 °C. Inspect qPCR curves to confirm amplification and/or run up to 5 uL on an agarose gel or an E-Gel 48 Agarose Gel (Thermo Fisher Scientific, Waltham, MA; Cat. No. G820804) to confirm expected size.

    **Table 2.** Primary qPCR master mix for trnL.

    | Component | 1 rxn (uL) | 100 rxns (uL) |
    |---|---|---|
    | Nuclease-free water | 3.5 | 350 |
    | 10 uM trnL(UAA)g primer | 0.5 | 50 |
    | 10 uM trnL(UAA)h primer | 0.5 | 50 |
    | KAPA HiFi Buffer (5X) | 2.0 | 200 |
    | KAPA dNTP Mix (10 mM each) | 0.3 | 30 |
    | SYBR Green I (100X) | 0.1 | 10 |
    | KAPA HiFi HotStart DNA Polymerase (1 U/uL) | 0.1 | 10 |
    | **Total** | **7.0** | **700** |

    **Table 3.** Primary qPCR amplification parameters for trnL.

    | Step | Temperature | Time | Cycles |
    |---|---|---|---|
    | Initial denaturation | 95 °C | 3 min | 1 |
    | Denaturation | 98 °C | 20 sec | 35 |
    | Annealing | 63 °C | 15 sec | 35 |
    | Extension | 72 °C | 15 sec | 35 |
    | Hold | 10 °C | ∞ | — |

=== "12SV5"

    ### Materials

    - AccuStart II PCR SuperMix (Quantabio, Beverly, MA; Cat. No. 95137-500)
    - 10 µM working stock of 12SV5 forward primer with Illumina bridges (Table 1)
    - 10 µM working stock of 12SV5 reverse primer with Illumina bridges (Table 1)
    - SYBR Green I (Thermo Fisher Scientific, Waltham, MA) — diluted in DMSO to 100X
    - Bovine serum albumin (BSA) (Thermo Fisher Scientific, Waltham, MA; Cat. No. B14)
    - Extracted DNA from stool sample
    - Positive control template DNA
    - Nuclease-free water

    ### Protocol

    Generate enough PCR master mix for the reactions desired according to Table 4. Aliquot 9 uL of mix into each well.

    Add 1 uL of nuclease-free water to no-template control wells (recommendation: 5 wells). Add 1 uL of DNA template to sample wells. Add 1 uL of control DNA to positive control wells (recommendation: 3 wells).

    Seal the plate with optical film. Briefly spin down the plate. Run the qPCR with cycling conditions from Table 5.

    After the run, transfer plates to -20 °C if processing is going to be paused; otherwise, keep plates at 4 °C. Inspect qPCR curves to confirm amplification and/or run up to 5 uL on an agarose gel or an E-Gel Agarose Gel (Thermo Fisher Scientific, Waltham, MA) to confirm expected size.

    **Table 4.** Primary qPCR master mix for 12SV5.

    | Component | 1 rxn (uL) | 100 rxns (uL) |
    |---|---|---|
    | Nuclease-free water | 1.65 | 165 |
    | 10 uM 12SV5 forward primer | 0.5 | 50 |
    | 10 uM 12SV5 reverse primer | 0.5 | 50 |
    | 100 uM DeBarba14 HomoB | 1.0 | 100 |
    | AccuStart II PCR SuperMix (2X) | 5.0 | 500 |
    | SYBR Green I (100X) | 0.1 | 10 |
    | BSA (20 mg/mL) | 0.25 | 25 |
    | **Total** | **9.0** | **900** |

    **Table 5.** Primary qPCR amplification parameters for 12SV5.

    | Step | Temperature | Time | Cycles |
    |---|---|---|---|
    | Initial denaturation | 94 °C | 3 min | 1 |
    | Denaturation | 94 °C | 20 sec | 35 |
    | Annealing | 57 °C | 15 sec | 35 |
    | Extension | 72 °C | 1 min | 35 |
    | Hold | 10 °C | ∞ | — |

## Secondary PCR

### Materials

- KAPA HiFi Hot Start PCR Kit with dNTP Mix (Roche, Basel, Switzerland; Cat. No. KK2502)
- Pre-mixed Illumina-compatible indexing primers, 2.5 uM each primer, 5 uM total (diluted and mixed in-house; Table 1)
- Diluted primary PCR amplicons, including any controls
    - Standard dilution is 1:100
    - 1:10 diluted may be used for samples with weak primary amplification such as those from infant cohorts or nutritionally compromised individuals
- Nuclease-free water

### Protocol

Generate enough PCR master mix for the reactions desired according to Table 6. The reaction mix and plate must be kept on ice. Aliquot 35 uL of mix into each well. Add 10 uL of pre-mixed indexing primer to each well.

Add 5 uL of diluted primary PCR products. Seal the plate with optical film. Briefly spin down the plate. Run the PCR with cycling conditions from Table 7.

After the run, transfer plates to -20 °C if processing is going to be paused; otherwise, keep plates at 4 °C. Run up to 5 uL of amplified product on an agarose gel or an E-Gel Agarose Gel (Thermo Fisher Scientific, Waltham, MA) to confirm expected size.

**Table 6.** Secondary PCR master mix.

| Component | 1 rxn (uL) | 100 rxns (uL) |
|---|---|---|
| Nuclease-free water | 22.5 | 2,250 |
| KAPA HiFi Buffer (5X) | 10.0 | 1,000 |
| KAPA dNTP Mix (10 mM each) | 1.5 | 150 |
| SYBR Green I (100X) | 0.5 | 50 |
| KAPA HiFi HotStart DNA Polymerase (1 U/uL) | 0.5 | 50 |
| **Total** | **35.0** | **3,500** |

**Table 7.** Secondary PCR amplification parameters.

| Step | Temperature | Time | Cycles |
|---|---|---|---|
| Initial denaturation | 95 °C | 3 min | 1 |
| Denaturation | 98 °C | 20 sec | 10 |
| Annealing | 55 °C | 15 sec | 10 |
| Extension | 72 °C | 30 sec | 10 |
| Hold | 10 °C | ∞ | — |

After PCR amplification, verify your products by [Gel Electrophoresis](gel.md).
