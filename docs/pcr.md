# PCR Amplification

These instructions cover the lab's PCR amplification protocols for 16S and FoodSeq (trnL and 12SV5) amplicons. The primary PCR amplifies the target region, and the indexing PCR (for FoodSeq) adds sample-specific barcodes. Primer stock preparation and barcode plate creation are covered at the bottom of the page.

The general workflow is:

- **Primary PCR** — amplify the target locus from extracted DNA
- **Indexing qPCR** (FoodSeq only) — add sample-specific barcodes in a second round of amplification
- **Gel electrophoresis** — verify that amplification was successful before downstream steps

The seven work instructions covered on this page are:

- **WI-PA001** — 16S PCR with AccuStart II PCR SuperMix
- **WI-PA003A** — Primary qPCR for trnLGH
- **WI-PA003B** — Primary qPCR for 12SV5
- **WI-PA003C** — Multiplex trnL + 12SV5 qPCR
- **WI-PA004** — Indexing qPCR for FoodSeq
- **WI-021** — Preparing working primer stock for 16S
- **WI-PA005** — Creating FoodSeq barcode plates

!!! warning

    All PCR setup should be performed in a PCR hood or designated clean area to minimize contamination risk. Wear gloves throughout the protocol and change them if you touch anything outside the clean area. Always include a negative control (nuclease-free water in place of template) on every plate. Contamination is the most common cause of failed PCR experiments, and it is far easier to prevent than to diagnose after the fact.

## General Notes on qPCR Setup

The FoodSeq protocols (trnL, 12SV5, multiplex, and indexing) all use qPCR with SYBR Green I detection. Here are a few general guidelines that apply to all of the qPCR protocols on this page.

- **SYBR Green I concentration** — We add SYBR Green I at a 1X final concentration (from a 10X stock). Higher concentrations can inhibit PCR; lower concentrations produce a weaker signal. If your SYBR Green stock is at a different concentration than 10X, adjust the volume accordingly to reach 1X final.
- **Plate seal** — Use optically clear adhesive seals (not foil seals or strip caps) for qPCR plates. The qPCR instrument reads fluorescence through the top of the plate; opaque seals will block the signal.
- **qPCR instrument setup** — Select SYBR Green as the reporter dye and set the passive reference to "none" (we do not use ROX normalization). Set the run mode to "Standard" with the cycling parameters specified in each protocol. Make sure the correct plate type is selected in the software (96-well, 0.1 mL or 0.2 mL, depending on your plate).
- **Exporting data** — After each run, export the amplification data (Ct values and raw fluorescence) and save them alongside your plate layout. This information is useful for troubleshooting and for comparing amplification efficiency across runs.
- **Plate layout planning** — Before setting up any qPCR, plan your plate layout on paper or in a spreadsheet. Record which samples go in which wells, and mark your negative and positive control positions. This avoids errors during pipetting and creates a record that you can refer back to during data analysis.

## Primary PCR

=== "16S"

    ### WI-PA001 — 16S PCR with AccuStart II PCR SuperMix

    This protocol amplifies the V4 region of the 16S rRNA gene using the Earth Microbiome Project (EMP) 515F/806R primer pair. Each well of the working barcode plate already contains a unique combination of barcoded forward and reverse primers, so no separate barcoding step is needed; the primary PCR produces indexed amplicons directly.

    #### Equipment and Consumables

    - AccuStart II PCR SuperMix (Quantabio, Cat. No. 95137)
    - 515F/806R EMP primers (working stock at barcode plate concentration; see [Preparing Working Primer Stock](#preparing-working-primer-stock))
    - Nuclease-free water
    - 96-well PCR plate and optically clear adhesive seal
    - Thermocycler
    - Micropipettors and filter pipette tips
    - Ice bucket or cold block

    !!! note

        The AccuStart II PCR SuperMix is a 2X ready-to-use mix containing Taq polymerase, dNTPs, MgCl2, and buffer. It uses a hot-start antibody that keeps the polymerase inactive until the initial denaturation step, which reduces non-specific amplification during reaction setup.

    #### Master Mix

    Prepare the following master mix on ice for each reaction. When preparing a full plate, scale the per-reaction volumes by the number of reactions plus 10% overage to account for pipetting loss.

    | Reagent | Volume (uL) |
    |---|---|
    | Nuclease-free water | 9.5 |
    | AccuStart II PCR SuperMix | 12.5 |
    | **Total master mix** | **22.0** |

    #### Protocol

    Prepare the master mix on ice in a reagent reservoir or microcentrifuge tube. Vortex the master mix briefly to homogenize, then add 22 uL of master mix to each well of a 96-well PCR plate using a multichannel pipettor.

    Next, add 1 uL of forward primer from the working barcode plate to each well using a single-channel pipettor. Add 1.5 uL of reverse primer from the working barcode plate to each well. The primer volumes differ because the forward and reverse stocks are at different concentrations in the working plate; the forward primer is more dilute (see [Preparing Working Primer Stock](#preparing-working-primer-stock) for details).

    Now, add 1 uL of template DNA to each well (total reaction volume: 25.5 uL). Reserve at least one well for a negative control (nuclease-free water in place of template) and one well for a positive control (a sample known to amplify well with a clear gel band). The negative control is critical for detecting contamination in the reagents or workspace; if it amplifies, the entire plate should be discarded.

    The reaction volume summary for 16S PCR is:

    | Component | Volume (uL) |
    |---|---|
    | Master mix (water + SuperMix) | 22.0 |
    | Forward primer (from barcode plate) | 1.0 |
    | Reverse primer (from barcode plate) | 1.5 |
    | Template DNA | 1.0 |
    | **Total** | **25.5** |

    Seal the plate with an optically clear adhesive seal. Vortex the plate briefly on a plate vortex and spin down in a plate centrifuge to collect all liquid at the bottom of the wells and remove air bubbles.

    #### Cycling Parameters

    Run the sealed plate on a thermocycler with the following program.

    | Step | Temperature | Time | Cycles |
    |---|---|---|---|
    | Initial denaturation | 94 °C | 3 min | 1 |
    | Denaturation | 94 °C | 30 sec | 35 |
    | Annealing | 55 °C | 30 sec | 35 |
    | Extension | 72 °C | 1 min | 35 |
    | Hold | 4 °C | ∞ | — |

    The denaturation, annealing, and extension steps repeat for 35 cycles. The 16S protocol holds at 4 °C (rather than 12 °C as in the FoodSeq protocols) because the AccuStart SuperMix is stable at lower temperatures. You can leave the plate at 4 °C overnight if needed, but proceed to gel electrophoresis within 24 hours for best results.

    After cycling, verify amplification by [Gel Electrophoresis](gel.md) before proceeding to cleaning. You should see a band at approximately 390 bp (the expected V4 amplicon size including primers). The negative control well should show no band; any visible band in the negative control indicates contamination and the plate should be discarded.

    !!! note

        The 16S PCR is a standard (endpoint) PCR, not a qPCR. We do not add SYBR Green I or monitor amplification in real time for 16S; the thermocycler does not need to have fluorescence detection capability for this protocol. Amplification success is confirmed afterward by gel electrophoresis.

    ??? question "Can I run 16S on a qPCR instrument?"

        Yes. A qPCR instrument is just a thermocycler with a fluorescence detector; it can run standard PCR programs without reading fluorescence. If your only available instrument is a QuantStudio or similar qPCR machine, you can use it for 16S PCR — just set up a run without a reporter dye and ignore the fluorescence data.

    ??? bug "Troubleshooting"

        - **No bands in any wells** — Verify that the thermocycler program ran correctly and check the AccuStart SuperMix expiration date. Make sure the primers were added to the reaction; a common mistake is skipping the primer addition step when using a multichannel pipettor.
        - **Bands in the negative control** — This indicates contamination. Discard the plate, prepare fresh reagents in a clean PCR hood, and repeat the protocol. Check that your nuclease-free water stock is not contaminated by running a no-template control with fresh water.
        - **Weak or inconsistent bands** — Some samples may have low DNA concentrations after extraction. Check the quantification values from the LVis plate and consider increasing the template volume (up to 3 uL) while decreasing the water volume accordingly.

=== "FoodSeq (trnL / 12SV5)"

    The FoodSeq primary PCR uses quantitative real-time PCR (qPCR) so that amplification can be monitored in real time via SYBR Green I fluorescence. Monitoring the amplification curves helps identify samples that amplify poorly or plateau early; this information is useful both for troubleshooting and for deciding whether a sample needs to be re-extracted or re-amplified.

    There are three protocol variants depending on whether you are amplifying trnL alone, 12SV5 alone, or both targets in a single multiplex reaction. The table below summarizes the key differences between the three variants for quick reference.

    | Parameter | trnL (WI-PA003A) | 12SV5 (WI-PA003B) | Multiplex (WI-PA003C) |
    |---|---|---|---|
    | Polymerase | KAPA HiFi HotStart | AccuStart II ToughMix | KAPA HiFi HotStart |
    | Annealing temp | 63 °C | 57 °C | 60 °C |
    | Cycles | 35 | 35 | 32 |
    | Template volume | 3 uL | 1 uL | 2.5 uL |
    | Total reaction | 10 uL | 10 uL | 10 uL |
    | Blocking primer | No | Yes (BP102 DKS) | Yes (BP102 DKS) |
    | BSA | No | Yes | Yes |

    !!! warning

        The FoodSeq primary PCR does *not* add sample-specific barcodes. Barcoding is performed in a separate [Indexing qPCR](#indexing-qpcr) step. Do not skip the indexing step.

    === "trnL"

        ### WI-PA003A — Primary qPCR for trnLGH

        This protocol amplifies the trnL-GH intergenic spacer, a short chloroplast DNA locus (~10--150 bp) used for plant identification in dietary studies. The "GH" refers to the primer binding sites flanking this intergenic region in the chloroplast trnL (UAA) gene. The short amplicon length makes trnL well-suited for degraded DNA from stool samples, since shorter fragments survive digestion better than longer ones. However, the short length also means that primer dimers (which are typically ~50--80 bp) can be difficult to distinguish from true amplicons on a gel; you may need to check the gel carefully at the lower end of the size range.

        #### Equipment and Consumables

        - KAPA HiFi HotStart ReadyMix (2X) (Roche, Cat. No. KK2602)
        - trnL primers BP031 DKS (forward) and BP032 DKS (reverse) at working concentration (5 uM)
        - SYBR Green I (10X)
        - Nuclease-free water
        - 96-well qPCR plate and optically clear seal
        - Quantitative real-time PCR instrument (e.g., QuantStudio)
        - Micropipettors and filter pipette tips
        - Ice bucket or cold block

        #### Master Mix

        Prepare the following master mix on ice for each reaction. Scale the per-reaction volumes by the number of reactions plus 10% overage.

        | Reagent | Volume (uL) |
        |---|---|
        | Nuclease-free water | 0.5 |
        | KAPA HiFi HotStart RM (2X) | 5.0 |
        | BP031 DKS (forward, 5 uM) | 0.5 |
        | BP032 DKS (reverse, 5 uM) | 0.5 |
        | SYBR Green I (10X) | 0.5 |
        | **Total master mix** | **7.0** |

        !!! note

            KAPA HiFi HotStart ReadyMix is a high-fidelity polymerase blend designed for low-bias amplification of mixed templates. We use it for FoodSeq instead of Taq-based mixes because the high fidelity reduces amplification bias across the diverse dietary sequences in a sample.

        #### Protocol

        Add 7 uL of master mix to each well of a 96-well qPCR plate. Add 3 uL of template DNA to each well (total reaction volume: 10 uL). The 3 uL template volume is larger than the other FoodSeq protocols because the trnL master mix has fewer components, leaving more room in the 10 uL reaction for template. More template generally means more robust amplification, which is helpful for this locus.

        Include a negative control (nuclease-free water in place of template) and a positive control. The trnL positive control should be a sample that is known to contain plant DNA; a previously successful extraction works well for this purpose.

        Seal the plate with an optically clear adhesive seal; vortex briefly on a plate vortex and spin down.

        #### Cycling Parameters

        Run the plate on the qPCR instrument with the following program.

        | Step | Temperature | Time | Cycles |
        |---|---|---|---|
        | Initial denaturation | 95 °C | 3 min | 1 |
        | Denaturation | 98 °C | 20 sec | 35 |
        | Annealing | 63 °C | 15 sec | 35 |
        | Extension | 72 °C | 15 sec | 35 |
        | Hold | 12 °C | ∞ | — |

        The 63 °C annealing temperature is optimized for the trnL-GH primer pair. After cycling, inspect the amplification curves in the qPCR software; most samples should reach the plateau phase between cycles 20 and 30. Samples that do not amplify (flat curves) may have very low plant DNA content or may have failed extraction.

        Export the amplification data (Ct values and curve plots) from the qPCR software and save them with the plate layout for your records. The Ct values are useful for comparing amplification efficiency across samples and for identifying outliers before proceeding to the indexing step.

        ??? bug "Troubleshooting"

            - **Flat amplification curves for many samples** — Check that the SYBR Green I was added to the master mix. Without the dye, the qPCR instrument cannot detect amplification even if PCR is working. Also verify that the correct excitation/emission filter was selected on the instrument.
            - **Late amplification (Ct > 30) in most samples** — This is common for samples with low plant DNA content (e.g., subjects on low-fiber diets). The amplicons may still be usable; check the gel to confirm the presence of a band at the expected size.
            - **Amplification in the negative control** — Discard the plate and repeat with fresh reagents. trnL contamination is common because plant DNA is ubiquitous; make sure to set up reactions in a clean PCR hood.

    === "12SV5"

        ### WI-PA003B — Primary qPCR for 12SV5

        This protocol amplifies the 12S V5 region of the mitochondrial genome, a short locus (~98 bp) used for vertebrate (animal) identification in dietary studies. The 12S rRNA gene is highly conserved across vertebrates, which allows the primers to amplify DNA from a wide range of animal species — fish, poultry, beef, pork, and others — using a single primer pair. However, because the primers target vertebrate mitochondrial DNA so broadly, they would also amplify the host's (human) DNA from stool samples in overwhelming quantities if no countermeasure were taken. A human-specific blocking primer is therefore included to suppress amplification of host DNA.

        #### Equipment and Consumables

        - AccuStart II PCR ToughMix (2X) (Quantabio)
        - 12SV5 primers BP039 DKS (forward) and BP040 DKS (reverse) at working concentration (5 uM)
        - Blocking primer BP102 DKS (50 uM)
        - BSA (bovine serum albumin, 20 mg/mL)
        - SYBR Green I (10X)
        - Nuclease-free water
        - 96-well qPCR plate and optically clear seal
        - Quantitative real-time PCR instrument (e.g., QuantStudio)
        - Micropipettors and filter pipette tips
        - Ice bucket or cold block

        !!! note

            The 12SV5 protocol uses AccuStart II ToughMix rather than KAPA HiFi. The ToughMix formulation is more tolerant of PCR inhibitors that may be present in stool-derived DNA, which is important when amplifying the relatively low-abundance animal DNA fraction.

        #### Master Mix

        Prepare the following master mix on ice for each reaction. The blocking primer and BSA are included in the master mix; do not omit them.

        | Reagent | Volume (uL) |
        |---|---|
        | Nuclease-free water | 2.0 |
        | AccuStart II ToughMix (2X) | 5.0 |
        | BP039 DKS (forward, 5 uM) | 0.25 |
        | BP040 DKS (reverse, 5 uM) | 0.25 |
        | BP102 DKS (blocking, 50 uM) | 0.5 |
        | BSA (20 mg/mL) | 0.5 |
        | SYBR Green I (10X) | 0.5 |
        | **Total master mix** | **9.0** |

        #### Protocol

        Add 9 uL of master mix to each well of a 96-well qPCR plate. Add 1 uL of template DNA to each well (total reaction volume: 10 uL). The template volume is smaller for 12SV5 (1 uL) than for trnL (3 uL) because the 12SV5 master mix contains more components (blocking primer and BSA), which leaves less room in the 10 uL reaction.

        Include a negative control (nuclease-free water) and a positive control. A good positive control for 12SV5 is a sample from a subject known to consume animal products; a sample that previously produced a clear band on a gel is ideal.

        Seal the plate with an optically clear adhesive seal; vortex briefly and spin down.

        ??? question "Why is there a blocking primer?"

            The blocking primer (BP102 DKS) blocks amplification of human DNA. The 12SV5 primers target vertebrate mitochondrial DNA, which would otherwise amplify large amounts of host (human) DNA from stool samples. The blocking primer binds preferentially to the human 12S sequence and its 3' end is modified with a C3 spacer that prevents polymerase extension. This means the human template is bound but never amplified, leaving the limited PCR cycles available for dietary animal sequences.

        ??? question "Why is BSA included?"

            BSA (bovine serum albumin) acts as a carrier protein that stabilizes the polymerase and sequesters PCR inhibitors commonly found in stool-derived DNA extracts. It is particularly helpful for the 12SV5 reaction because the animal DNA fraction is often present at low concentrations, making the reaction more sensitive to inhibition.

        #### Cycling Parameters

        Run the plate on the qPCR instrument with the following program.

        | Step | Temperature | Time | Cycles |
        |---|---|---|---|
        | Initial denaturation | 94 °C | 3 min | 1 |
        | Denaturation | 94 °C | 20 sec | 35 |
        | Annealing | 57 °C | 15 sec | 35 |
        | Extension | 72 °C | 1 min | 35 |
        | Hold | 12 °C | ∞ | — |

        Note that the 12SV5 protocol uses a lower annealing temperature (57 °C) than trnL (63 °C). The extension time is also longer (1 min vs. 15 sec) to give the ToughMix polymerase sufficient time for complete extension in the presence of the blocking primer.

        After cycling, inspect the amplification curves. Samples from subjects who do not consume animal products may show flat or very late (Ct > 32) amplification; this is expected and not necessarily a sign of protocol failure. In general, 12SV5 samples tend to show more variation in Ct values than trnL samples because animal DNA content varies widely across diets.

        Export the amplification data and save it with your plate layout. If you are running both trnL and 12SV5 separately on the same set of samples, it can be helpful to compare the Ct values side by side to get a rough sense of the plant-to-animal ratio in each sample before sequencing.

        ??? bug "Troubleshooting"

            - **High amplification in the negative control** — This may indicate contamination with human DNA, which is very common in laboratory settings. Repeat the protocol in a clean PCR hood with fresh reagents. Human DNA contamination is the most common issue with 12SV5.
            - **All samples amplify at the same Ct regardless of diet** — The blocking primer may have been omitted or may have degraded. Verify that BP102 DKS was included in the master mix and check the primer's storage history; blocking primers should be stored at -20 °C and undergo minimal freeze-thaw cycles.
            - **No amplification in any samples** — Check that the AccuStart II ToughMix has not expired. Also verify that the correct primers (BP039/BP040) were used; mixing up trnL and 12SV5 primers is an easy mistake when both protocols are being run simultaneously.

    === "Multiplex"

        ### WI-PA003C — Multiplex trnL + 12SV5 qPCR

        The multiplex protocol amplifies both trnL and 12SV5 targets in a single reaction, which reduces the amount of template DNA needed and cuts the number of reactions in half. This is particularly useful when template DNA is limited (e.g., infant stool samples, which tend to yield less DNA) or when processing large sample sets where running two separate plates per batch would be impractical.

        The tradeoff is that the cycling parameters are a compromise between the two single-target protocols, and the amplification efficiency for each target may be slightly lower than in the dedicated reactions. The multiplex also uses KAPA HiFi rather than AccuStart ToughMix (which is the polymerase used in the single-target 12SV5 protocol), so it may be somewhat less tolerant of PCR inhibitors from stool samples.

        #### Equipment and Consumables

        - KAPA HiFi HotStart ReadyMix (2X) (Roche, Cat. No. KK2602)
        - trnL primers BP031 DKS (forward) and BP032 DKS (reverse) at 5 uM
        - 12SV5 primers BP039 DKS (forward) and BP040 DKS (reverse) at 5 uM
        - Blocking primer BP102 DKS (50 uM)
        - BSA (bovine serum albumin, 20 mg/mL)
        - SYBR Green I (10X)
        - Nuclease-free water
        - 96-well qPCR plate and optically clear seal
        - Quantitative real-time PCR instrument (e.g., QuantStudio)
        - Micropipettors and filter pipette tips
        - Ice bucket or cold block

        #### Master Mix

        Prepare the following master mix on ice for each reaction. All six primers (four target primers plus the blocking primer) and BSA are included in the master mix.

        | Reagent | Volume (uL) |
        |---|---|
        | Nuclease-free water | 0.35 |
        | KAPA HiFi HotStart RM (2X) | 5.0 |
        | BP031 DKS (trnL fwd, 5 uM) | 0.25 |
        | BP032 DKS (trnL rev, 5 uM) | 0.25 |
        | BP039 DKS (12SV5 fwd, 5 uM) | 0.25 |
        | BP040 DKS (12SV5 rev, 5 uM) | 0.25 |
        | BP102 DKS (blocking, 50 uM) | 0.25 |
        | BSA (20 mg/mL) | 0.4 |
        | SYBR Green I (10X) | 0.5 |
        | **Total master mix** | **7.5** |

        #### Protocol

        Add 7.5 uL of master mix to each well of a 96-well qPCR plate. Add 2.5 uL of template DNA to each well (total reaction volume: 10 uL). The template volume (2.5 uL) is a middle ground between the trnL protocol (3 uL) and the 12SV5 protocol (1 uL); it provides enough template for both targets without exceeding the total reaction volume.

        The reaction volume summary for multiplex qPCR is:

        | Component | Volume (uL) |
        |---|---|
        | Master mix (all primers + BSA + SYBR) | 7.5 |
        | Template DNA | 2.5 |
        | **Total** | **10.0** |

        Include a negative control (nuclease-free water) and a positive control. For the multiplex reaction, the positive control should ideally be a sample known to contain both plant and animal DNA.

        Seal the plate with an optically clear adhesive seal; vortex briefly and spin down.

        #### Cycling Parameters

        Run the plate on the qPCR instrument with the following program.

        | Step | Temperature | Time | Cycles |
        |---|---|---|---|
        | Initial denaturation | 95 °C | 3 min | 1 |
        | Denaturation | 98 °C | 20 sec | 32 |
        | Annealing | 60 °C | 15 sec | 32 |
        | Extension | 72 °C | 15 sec | 32 |
        | Hold | 12 °C | ∞ | — |

        !!! note

            The multiplex protocol uses only 32 cycles (vs. 35 for single-target). The annealing temperature (60 °C) is a compromise between the trnL optimum (63 °C) and the 12SV5 optimum (57 °C). The reduced cycle count helps prevent over-amplification of the more abundant target, which could otherwise outcompete the less abundant one.

        Because the multiplex uses SYBR Green I (which binds all double-stranded DNA indiscriminately), the amplification curve reflects the combined signal from both trnL and 12SV5 amplicons. You cannot distinguish between the two targets from the qPCR curves alone; the relative proportions are determined downstream during bioinformatic analysis after demultiplexing.

        Export the amplification data and save it with your plate layout, as with the single-target protocols. Even though you cannot separate the two signals, the overall curve shape and Ct values are still useful for identifying failed wells.

        ??? question "When should I use the multiplex vs. single-target protocols?"

            Use the multiplex protocol when you want to minimize the number of reactions and conserve template DNA. This is particularly useful for large sample sets or when extraction yields are low. Use the single-target protocols when you need maximum sensitivity for one target (e.g., when studying a population with very low animal consumption, where the 12SV5 signal would benefit from its own dedicated reaction) or when you want to optimize cycling parameters independently for each target.

        ??? bug "Troubleshooting"

            - **Amplification curves plateau very early (before cycle 20)** — One target may be dominating the reaction. This is more likely when one target is much more abundant in the template (e.g., a subject on a high-fiber, low-meat diet will have mostly trnL amplicons). The multiplex protocol is designed to handle moderate imbalances, but extreme cases may require running the two targets separately.
            - **Inconsistent results between multiplex and single-target runs** — Some primer competition is expected in the multiplex. If results are consistently discordant for a set of samples, consider switching to single-target protocols for that batch.
            - **Primer dimers visible on gel** — With six primers in a single reaction, primer dimer formation is more likely than in the single-target protocols. If primer dimers are a persistent problem, verify that all primer stocks are at the correct concentration and that the master mix volumes are accurate. A small amount of primer dimer is normal and will be removed during the cleaning step.

## Indexing qPCR

This section covers WI-PA004 — the second-round indexing qPCR that adds sample-specific barcodes to the FoodSeq amplicons. The barcodes are short DNA sequences appended to the 5' end of each amplicon during this step, allowing samples to be pooled together and sequenced on a single MiniSeq run while still being computationally assigned back to their sample of origin afterward. The forward and reverse barcoding primers each contain a unique index sequence flanked by Illumina adapter sequences; together, the two indices provide a dual-indexed barcode for each sample.

!!! note

    The indexing qPCR applies only to FoodSeq (trnL / 12SV5) amplicons. The 16S protocol uses pre-barcoded primers in the primary PCR and does not require a separate indexing step.

The indexing step uses FoodSeq-specific barcoding primers from a working barcode plate (see [FoodSeq Barcode Plates](#foodseq-barcode-plates) below for plate preparation). Each well of the barcode plate contains a unique forward-reverse primer combination, so the position of each sample on the barcode plate determines its barcode assignment. Make sure your sample-to-well mapping is recorded accurately before starting this step; errors in the sample sheet will result in samples being assigned the wrong identities after demultiplexing, and this is very difficult to detect computationally.

### Equipment and Consumables

- KAPA HiFi HotStart ReadyMix (2X) (Roche, Cat. No. KK2602)
- FoodSeq barcoding primers (forward and reverse, from working barcode plate at 2.5 uM each)
- SYBR Green I (10X)
- Nuclease-free water
- Primary qPCR product (from the primary PCR step above)
- 96-well qPCR plate and optically clear seal
- Quantitative real-time PCR instrument (e.g., QuantStudio)
- Micropipettors and filter pipette tips
- Ice bucket or cold block

### Template Dilution

First, dilute each primary qPCR product 1:100 in nuclease-free water (e.g., 1 uL product + 99 uL water). This dilution reduces carryover of primary primers, SYBR Green, and dNTPs into the indexing reaction, which could otherwise interfere with barcoding efficiency.

Prepare the dilutions in a clean 96-well plate. You can use a multichannel pipettor to speed up this step: first add 99 uL of nuclease-free water to each well of a clean plate, then transfer 1 uL of primary product from each well. Mix by pipetting up and down several times. Make sure to change tips between every transfer to avoid cross-contaminating samples with different barcode assignments.

!!! warning

    Do not skip the 1:100 dilution. Using undiluted primary product in the indexing reaction can result in high carryover of primary primers, which compete with the barcoding primers and produce un-barcoded amplicons that cannot be demultiplexed after sequencing.

### Master Mix

Prepare the following master mix on ice for each reaction.

| Reagent | Volume (uL) |
|---|---|
| Nuclease-free water | 2.0 |
| KAPA HiFi HotStart RM (2X) | 5.0 |
| SYBR Green I (10X) | 0.5 |
| **Total master mix** | **7.5** |

The barcoding primers are not included in the master mix because each well receives a unique primer combination from the barcode plate.

### Protocol

Add 7.5 uL of master mix to each well of a 96-well qPCR plate. Next, add 5 uL of barcoding forward primer and 5 uL of barcoding reverse primer from the working barcode plate to the corresponding well (10 uL total primers per well). Use a multichannel pipettor for the primer transfers; the working barcode plate is arranged so that each row or column can be transferred efficiently. The primer volumes are larger in this step than in the primary PCR because the barcoding primers are at a lower working concentration (2.5 uM).

Now, add 2.5 uL of diluted (1:100) primary qPCR template to each well (total reaction volume: 25 uL). Make sure the sample-to-well mapping on the indexing plate matches your intended barcode assignments; each sample must go into the well that corresponds to its desired barcode pair.

Include a negative control (nuclease-free water in place of diluted template) and a positive control. Seal the plate with an optically clear adhesive seal; vortex briefly and spin down.

### Cycling Parameters

Run the plate on the qPCR instrument with the following program.

| Step | Temperature | Time | Cycles |
|---|---|---|---|
| Initial denaturation | 95 °C | 3 min | 1 |
| Denaturation | 98 °C | 20 sec | 10 |
| Annealing | 55 °C | 15 sec | 10 |
| Extension | 72 °C | 30 sec | 10 |
| Hold | 12 °C | ∞ | — |

!!! note

    The indexing qPCR uses only 10 cycles to minimize chimera formation while still adding barcodes. Chimeras — artificial sequences formed when an incomplete extension product primes on a different template in the next cycle — become increasingly likely with more cycles. Because the primary product is already amplified, 10 cycles are sufficient to attach the barcode sequences.

After cycling, inspect the amplification curves to verify that all samples amplified. The curves will generally not reach a clear plateau in only 10 cycles; instead, look for a consistent upward trend in fluorescence across samples. Flat curves may indicate that the 1:100 dilution was too dilute for a particular sample, or that the primary PCR failed for that sample.

Verify amplification by [Gel Electrophoresis](gel.md) before proceeding to cleaning. The indexed amplicons will be slightly larger than the primary amplicons due to the added barcode and adapter sequences; expect a size shift of roughly 50--100 bp relative to the primary product.

### Reaction Volume Summary

The following table summarizes the volumes for the indexing qPCR reaction for quick reference.

| Component | Volume (uL) |
|---|---|
| Master mix | 7.5 |
| Barcoding forward primer (2.5 uM) | 5.0 |
| Barcoding reverse primer (2.5 uM) | 5.0 |
| Diluted primary product (1:100) | 2.5 |
| **Total** | **25.0** |

??? bug "Troubleshooting"

    - **No amplification in any wells** — Verify that diluted primary product was added. A common mistake is adding nuclease-free water to all wells (including sample wells) instead of the diluted template. Also check that the working barcode plate has not been exhausted from previous runs.
    - **Amplification in the negative control** — This indicates contamination. Because the indexing reaction uses only 10 cycles, amplification in the negative control suggests a high level of contaminating template. Discard the plate, prepare fresh reagents, and repeat.
    - **Very uneven amplification across wells** — Some variation in Ct values between samples is normal and reflects differences in primary PCR yield. If certain wells consistently fail across replicate plates, the corresponding positions on the barcode plate may contain degraded primers; prepare a fresh working barcode plate.

## Primer and Barcode Plate Preparation

The protocols in this section describe how to prepare the working primer and barcode plates that are used in the PCR reactions above. These plates can be prepared in advance and stored at -20 °C until needed; having plates ready before extraction is complete can save a day or more of turnaround time.

!!! warning

    Primer and barcode plate preparation should be performed in a clean area. Use filter pipette tips throughout and avoid introducing template DNA or PCR product into the primer preparation area. Cross-contamination of barcode plates with amplified product is a common source of indexing failures.

### Preparing Working Primer Stock

This section covers WI-021 — preparing the working primer stock for 16S (EMP/Knight Lab primers). The 16S protocol uses barcoded primers from the Earth Microbiome Project, where the barcodes are built into the primers themselves rather than being added in a separate indexing step. The working barcode plate contains both forward and reverse primers in each well, ready for direct addition to the 16S PCR reaction.

#### Equipment and Consumables

- 515F forward primer stock (100 uM)
- 806R reverse primer barcode plate (100 uM, pre-arrayed)
- IDTE buffer (10 mM Tris, 0.1 mM EDTA)
- 96-well PCR plate
- Adhesive plate seal
- Micropipettors and filter pipette tips

#### Forward Primers

Dilute the 100 uM forward primer stock to working concentration by combining 165 uL of forward primer stock (100 uM) with 2,970 uL of IDTE buffer in a microcentrifuge tube or reagent reservoir. This yields approximately 3,135 uL of ~5.26 uM working stock.

| Reagent | Volume (uL) |
|---|---|
| 515F forward primer (100 uM) | 165 |
| IDTE buffer | 2,970 |
| **Total** | **~3,135** |

Vortex the diluted primer briefly to mix. Next, aliquot 28.5 uL of the diluted forward primer per well into a 96-well plate. A multichannel pipettor and reagent reservoir will speed this step up considerably. The forward primer is the same in every well because the barcode is carried only on the reverse primer.

#### Reverse Primers

The reverse primer barcode plate is typically ordered pre-arrayed at 100 uM from the manufacturer; each well contains a uniquely barcoded 806R reverse primer. The plate arrives sealed and should be stored at -20 °C until use.

To complete the working plate, transfer 1.5 uL from each well of the 100 uM reverse primer stock plate to the corresponding well of the working plate (which already contains 28.5 uL of forward primer). Use a multichannel pipettor and work carefully to avoid cross-contaminating wells; each well must receive only its own unique reverse primer. The final plate has both forward and reverse primers in each well.

| Component | Volume per well (uL) |
|---|---|
| Diluted 515F forward primer | 28.5 |
| Barcoded 806R reverse primer (100 uM) | 1.5 |
| **Total per well** | **30.0** |

Seal the plate, vortex briefly on a plate vortex, and spin down. Store the finished working barcode plate at -20 °C. Each plate provides enough primer for many runs; a single aliquot of forward primer plus 1.5 uL of reverse primer per well is consumed per run.

??? question "How many uses does one working plate support?"

    The working plate starts with 30 uL per well. Each 16S PCR run consumes 2.5 uL per well (1 uL forward + 1.5 uL reverse). In principle, you could get roughly 12 runs from a single plate before the wells run dry — but in practice, pipetting accuracy decreases as the volume drops below ~5 uL. We recommend preparing a new plate when the volume per well drops below 5 uL, or after approximately 10 uses.

!!! warning

    Label the working barcode plate clearly with the date, primer identity, and concentration. Multiple barcode plates may be in use in the lab at the same time; mixing up 16S and FoodSeq barcode plates will result in failed sequencing. We recommend using color-coded plate seals (e.g., blue for 16S, green for FoodSeq) if your lab has them available.

### FoodSeq Barcode Plates

This section covers WI-PA005 — creating the FoodSeq barcode plates used in the indexing qPCR. The barcode plates contain unique combinations of forward (i5) and reverse (i7) indexing primers that are added during the second-round indexing qPCR to tag each sample with a unique barcode pair. The "i5" and "i7" designations refer to the Illumina index read positions; together they form a dual-index system that provides robust sample identification during demultiplexing.

Creating barcode plates is a two-step process: first, prepare a 10 uM stock plate from the 100 uM primer stocks, then dilute the stock plate to a 2.5 uM working plate.

#### Equipment and Consumables

- Forward (i5) indexing primers (8 unique, reconstituted to 100 uM)
- Reverse (i7) indexing primers (12 unique, reconstituted to 100 uM)
- IDTE buffer (10 mM Tris, 0.1 mM EDTA)
- 96-well PCR plates
- Adhesive plate seals
- Micropipettors and filter pipette tips

#### Stock Plate (10 uM)

The stock barcode plate contains forward (i5) and reverse (i7) indexing primers at 10 uM in a 96-well plate layout. Primers are ordered at 100 nmol scale, lyophilized, and reconstituted in IDTE to 100 uM upon arrival.

To make the 10 uM stock plate, dilute 5 uL of each 100 uM primer into 45 uL of IDTE per well.

| Reagent | Volume (uL) |
|---|---|
| Primer stock (100 uM) | 5 |
| IDTE buffer | 45 |
| **Total per well** | **50** |

The plate layout follows an 8x12 grid: 8 unique forward primers are arrayed across rows A--H, and 12 unique reverse primers are arrayed across columns 1--12. Each well therefore contains one forward and one reverse primer, for a total of 96 unique barcode combinations per plate.

Seal the stock plate, vortex briefly, spin down, and store at -20 °C. The stock plate serves as the source for preparing multiple working plates; treat it as a long-term reagent and minimize freeze-thaw cycles.

??? question "How are the forward and reverse primers arranged?"

    The 8 forward (i5) primers are assigned to the 8 rows of the plate (one primer per row, A through H). The 12 reverse (i7) primers are assigned to the 12 columns (one primer per column, 1 through 12). When you prepare the stock plate, each well gets one forward primer (determined by its row) and one reverse primer (determined by its column). For example, well B7 contains forward primer i5-B and reverse primer i7-7. This combinatorial arrangement is what gives you 96 unique barcode pairs (8 x 12 = 96).

#### Working Plate (2.5 uM each)

From the 10 uM stock plate, prepare working barcode plates by diluting to 2.5 uM. For each well, combine the appropriate forward and reverse primers from the stock plate with IDTE.

| Reagent | Volume (uL) |
|---|---|
| Forward primer (10 uM stock) | 6.25 |
| Reverse primer (10 uM stock) | 6.25 |
| IDTE buffer | 12.5 |
| **Total per well** | **25.0** |

Each well now contains both the forward and reverse barcoding primers at 2.5 uM. Seal the plate, vortex briefly on a plate vortex, and spin down. Label the plate clearly with the date, barcode plate number, and primer concentration. Store the finished working barcode plate at -20 °C.

!!! note

    Each working barcode plate provides 96 unique barcode combinations. For experiments with more than 96 samples, use multiple barcode plates with non-overlapping barcode sets. Make sure to record which barcode plate was used for each sample, as this information is needed during demultiplexing.

!!! warning

    Working barcode plates have a limited number of uses because each use consumes primer volume from the wells. Track the number of times each plate has been used and prepare a fresh plate when the volume per well runs low. Pipetting from nearly empty wells introduces air bubbles and inaccurate primer volumes, which can cause barcoding failures.

??? question "How many uses does one working barcode plate support?"

    Each well starts with 25 uL. The indexing qPCR consumes 10 uL per well per run (5 uL forward + 5 uL reverse). You can therefore get two full uses from a single plate before it needs to be replaced. If you are running fewer than 96 samples, the unused wells remain available for future runs; just make sure to record which wells have already been used.

#### Reconstituting Lyophilized Primers

When barcode primers arrive from the manufacturer, they are typically lyophilized (freeze-dried) in individual tubes or a 96-well plate. The primers are stable at room temperature in lyophilized form, but should be reconstituted and stored at -20 °C as soon as practical after arrival.

To reconstitute, spin down the lyophilized primers briefly in a microcentrifuge (or plate centrifuge) to collect any powder at the bottom of the tube or well. Then add the appropriate volume of IDTE to reach 100 uM. The exact volume depends on the amount of primer ordered; for a 100 nmol order, add 1,000 uL of IDTE to get 100 uM.

| Amount ordered | IDTE volume for 100 uM |
|---|---|
| 10 nmol | 100 uL |
| 25 nmol | 250 uL |
| 100 nmol | 1,000 uL |

Vortex each tube or plate thoroughly after adding IDTE; lyophilized primers can take a moment to fully dissolve. Spin down and store the reconstituted primers at -20 °C until you are ready to prepare the stock plate.

!!! note

    We use IDTE (10 mM Tris, 0.1 mM EDTA) rather than plain nuclease-free water for primer reconstitution and dilution. The low concentration of EDTA chelates divalent cations that could degrade the primers during storage, while the Tris buffer maintains a stable pH. This extends the shelf life of primer stocks significantly compared to water-based dilutions.

### Primer Storage and Handling

All primer stocks and working plates should be stored at -20 °C. Avoid repeated freeze-thaw cycles; if you use a primer stock frequently, consider preparing single-use aliquots. The following guidelines apply to all primers used on this page.

- **100 uM stocks** — Store at -20 °C in their original tubes or plates. These are your long-term master stocks; handle them carefully and avoid contamination. Primer stocks at 100 uM are stable for at least two years at -20 °C when reconstituted in IDTE.
- **10 uM stock plates** (FoodSeq barcodes) — Store at -20 °C. These are intermediate dilutions used to prepare working plates. Minimize freeze-thaw cycles by preparing working plates in batches.
- **Working plates** (both 16S and FoodSeq) — Store at -20 °C. These are consumed during PCR reactions; track usage and replace when volumes run low. Working plates at lower concentrations (2.5--5 uM) are more susceptible to degradation than concentrated stocks, so aim to use them within 6 months of preparation.

!!! warning

    Never bring primer stock plates to the PCR bench. Aliquot primers into working plates and use only the working plates for setting up reactions. If concentrated primer stocks become contaminated with PCR product, the contamination will propagate into every downstream plate you prepare from that stock.

After PCR amplification, verify your products by [Gel Electrophoresis](gel.md).
