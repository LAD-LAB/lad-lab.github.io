# PCR Amplification

The FoodSeq workflow uses a two-step PCR approach: a primary qPCR (qPCRA) amplifies the target locus from extracted DNA, and an indexing qPCR (qPCRB) adds sample-specific barcodes in a second round of amplification. Both steps use SYBR Green I detection on a quantitative real-time PCR instrument.

!!! warning

    All PCR setup should be performed in a PCR hood or designated clean area. Wipe both the reagent and DNA PCR hoods with RNAse Away, then treat both hoods with UV light for ~15 minutes before beginning. Wear gloves throughout the protocol and always include a no-template control (nuclease-free water in place of template) on every plate.

## Primary qPCR

=== "trnL"

    This protocol amplifies the trnLGH region for plant detection. It corresponds to WI-PA003.

    ### Equipment and Consumables

    - 96-well optical PCR plate, optical sealing film, and foil seals
    - PCR-certified filter pipette tips and pipettors
    - Cooling rack for 96-well plate, ice, and ice bucket
    - Nuclease-free water
    - KAPA HiFi HotStart ReadyMix (2X) (Roche; Cat. No. KK2602)
    - SYBR Green I, diluted in filtered DMSO to 100X
    - Positive control template DNA
    - PCR primers with Illumina bridges for trnLGH at 10 uM working concentration, diluted with IDTE pH 8.0:
        - **BP031** (trnL(UAA)g-Sq) — `5' TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGGGGCAATCCTGAGCCA*A 3'`
        - **BP032** (trnL(UAA)h-Seq) — `5' GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGCCATTGAGTCTCTGCACCTAT*C 3'`

    !!! note

        Make only as much 10 uM working stock as you need; 10 uM primers degrade with multiple freeze-thaw cycles.

    ??? question "ReadyMix vs. individual components?"

        The KAPA HiFi HotStart kit is also available with individual components (dNTPs kit; Cat. No. KK2502), which allows adjustment of the polymerase concentration to reduce primer dimers. However, the dNTP kit is more temperature-sensitive, and the lab has had issues with kits going bad. The ReadyMix is preferred to avoid these issues.

    ### Protocol

    Thaw all necessary reagents on ice. Vortex and spin down all reagents *except* the mix containing the polymerase.

    In the **reagent PCR hood**, prepare the master mix according to the table below. Keep the reaction mix and plate on ice; otherwise, the exonuclease in the enzyme can degrade the primers prior to the start of the reaction.

    | Component | 1 rxn (uL) | 100 rxns (uL) |
    |---|---|---|
    | Nuclease-free water | 1.3 | 130 |
    | 10 uM forward primer (BP031) | 0.3 | 30 |
    | 10 uM reverse primer (BP032) | 0.3 | 30 |
    | 2X KAPA HiFi HotStart ReadyMix | 5.0 | 500 |
    | 100X SYBR Green I | 0.1 | 10 |
    | **Total master mix** | **7.0** | **700** |

    Aliquot 7 uL of master mix into each well, then seal the plate and move it to the DNA hood.

    In the **DNA PCR hood**, add 3 uL of nuclease-free water to the no-template control wells. Add 3 uL of DNA template to each sample well, and 3 uL of positive control DNA to the positive control well(s). The positive control DNA should be synthetic or relatively phylogenetically distinct and not commonly eaten by humans. Seal the plate with optical film and briefly spin down (13 seconds at 1,000 rpm).

    Run the qPCR with the following cycling parameters:

    | Step | Temperature | Time | Cycles |
    |---|---|---|---|
    | Initial denaturation | 95 °C | 3 min | 1 |
    | Denaturation | 98 °C | 20 sec | 35 |
    | Annealing | 63 °C | 15 sec | 35 |
    | Extension | 72 °C | 15 sec | 35 |
    | Hold | 12 °C | ∞ | — |

    After the run, clean both hoods with RNAse Away and UV. Transfer plates to -20 °C if pausing for more than one day; otherwise, keep at 4 °C. Inspect the qPCR curves to confirm amplification and/or run 2 uL on an agarose gel or E-Gel to confirm a single band of expected size.

=== "12SV5"

    This protocol amplifies the 12SV5 region for animal detection. It corresponds to WI-PA003B.

    ### Equipment and Consumables

    - 96-well optical PCR plate, optical sealing film, and foil seals
    - PCR-certified filter pipette tips and pipettors
    - Cooling rack for 96-well plate, ice, and ice bucket
    - Nuclease-free water
    - 2X AccuStart II PCR SuperMix (Quantabio; Cat. No. 95137)
    - SYBR Green I, diluted in filtered DMSO to 100X
    - BSA, 20 mg/mL (Thermo Fisher; Cat. No. B14)
    - Positive control template DNA (e.g., gecko gDNA)
    - 10 uM working stock of PCR primers with Illumina bridges for 12SV5, diluted with IDTE pH 8.0:
        - **BP039** (12SV5F-Seq) — `5' TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGTAGAACAGGCTCCTCTAG 3'`
        - **BP040** (12SV5R-Seq) — `5' GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGTTAGATACCCCACTATGC 3'`
    - 100 uM working stock of human blocking primer:
        - **BP102** — `5' CTATGCTTAGCCCTAAACCTCAACAGTTAAATCAACAAAACTGCT/3SpC3/ 3'`

    !!! note

        Make only as much 10 uM working stock as you need; 10 uM primers degrade with multiple freeze-thaw cycles.

    ??? question "Why is there a blocking primer?"

        The blocking primer (BP102) blocks amplification of human mitochondrial DNA. The 12SV5 primers target vertebrate mitochondrial DNA, which would otherwise amplify large amounts of host (human) DNA from stool samples. The 3' C3 spacer modification prevents the blocking primer from being extended by the polymerase.

    ### Protocol

    Thaw all necessary reagents on ice. Vortex and spin down all reagents *except* the mix containing the polymerase.

    In the **reagent PCR hood**, prepare the master mix according to the table below. Keep the reaction mix and plate on ice.

    | Component | 1 rxn (uL) | 100 rxns (uL) |
    |---|---|---|
    | Nuclease-free water | 1.65 | 165 |
    | 10 uM forward primer (BP039) | 0.5 | 50 |
    | 10 uM reverse primer (BP040) | 0.5 | 50 |
    | 100 uM blocking primer (BP102) | 1.0 | 100 |
    | 100X SYBR Green I | 0.1 | 10 |
    | 20 mg/mL BSA | 0.25 | 25 |
    | 2X AccuStart II PCR SuperMix | 5.0 | 500 |
    | **Total master mix** | **9.0** | **900** |

    Aliquot 9 uL of master mix into each well, then seal the plate with adhesive foil and move it to the DNA hood.

    In the **DNA PCR hood**, add 1 uL of nuclease-free water to the no-template control well. Add 1 uL of DNA template to each sample well, and 1 uL of positive control DNA to the positive control well. Seal the plate with optical film and briefly spin down (13 seconds at 1,000 rpm).

    Run the qPCR with the following cycling parameters:

    | Step | Temperature | Time | Cycles |
    |---|---|---|---|
    | Initial denaturation | 94 °C | 3 min | 1 |
    | Denaturation | 94 °C | 20 sec | 35 |
    | Annealing | 57 °C | 15 sec | 35 |
    | Extension | 72 °C | 1 min | 35 |
    | Hold | 12 °C | ∞ | — |

    After the run, clean both hoods with RNAse Away and UV. Transfer plates to -20 °C if pausing; otherwise, keep at 4 °C. Inspect the qPCR curves to confirm amplification and/or run 2 uL on an agarose gel or E-Gel to confirm a single band of expected size.

## Indexing qPCR

The indexing qPCR (qPCRB) adds sample-specific barcodes to the primary amplicons. This protocol corresponds to WI-PA004.

### Equipment and Consumables

- 96-well optical PCR plate, optical sealing film, and foil seals
- PCR-certified filter pipette tips and pipettors
- Cooling rack, ice, and ice bucket
- Nuclease-free water
- KAPA HiFi HotStart ReadyMix (2X) (Roche; Cat. No. KK2602)
- SYBR Green I, diluted in filtered DMSO to 100X
- Pre-mixed Illumina-compatible barcoding primers at 2.5 uM each primer (5 uM total), ordered from IDT and diluted/mixed in-house
- Primary qPCR product (from the previous step)
- Clean biosafety cabinet (BSC)

!!! note

    The working barcode plate is generally made for three uses (each well contains 36 uL of pre-mixed primer when new). Barcoding does not have to be a qPCR — you can replace the SYBR Green volume with nuclease-free water and run it as a regular PCR if preferred.

### Preparing the Template

Template dilution can be done on the epMotion or manually in the biosafety cabinet (BSC). Treat the BSC with RNAse Away, let it dry, then treat with UV for ~15 minutes before starting.

In a new plate, make a 1:10 dilution of the primary qPCR product by adding 5 uL of amplicons to 45 uL of nuclease-free water; mix well. In another new plate, make a 1:100 dilution by adding 5 uL of the 1:10 diluted amplicons to 45 uL of nuclease-free water; mix well.

### Protocol

In the **reagent PCR hood** (with fresh gloves and a disposable lab gown), treat the area with RNAse Away and UV for ~15 minutes. Prepare the master mix according to the table below; mix gently.

| Component | 1 rxn (uL) | 100 rxns (uL) |
|---|---|---|
| Nuclease-free water | 9.5 | 950 |
| 2X KAPA HiFi HotStart ReadyMix | 25.0 | 2,500 |
| 100X SYBR Green I | 0.5 | 50 |
| **Total master mix** | **35.0** | **3,500** |

Aliquot 35 uL of master mix into each well. Add 10 uL of pre-mixed barcoding primers from the working barcode plate to each well. Seal the plate with foil.

In the **BSC**, add 5 uL of the 1:100 diluted primary qPCR product to each well. Seal the plate with optical film. Briefly spin down (13 seconds at 1,000 rpm).

Run the qPCR with the following cycling parameters:

| Step | Temperature | Time | Cycles |
|---|---|---|---|
| Initial denaturation | 95 °C | 3 min | 1 |
| Denaturation | 98 °C | 20 sec | 10 |
| Annealing | 55 °C | 15 sec | 10 |
| Extension | 72 °C | 30 sec | 10 |
| Hold | 12 °C | ∞ | — |

After the run, clean all work areas with RNAse Away and UV. Transfer plates to -20 °C if pausing; otherwise, keep at 4 °C. Run 5 uL on an agarose gel or E-Gel to confirm amplification.

After PCR amplification, verify your products by [Gel Electrophoresis](gel.md).
