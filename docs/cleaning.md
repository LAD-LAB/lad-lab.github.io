# Amplicon Cleaning and Quantification

These instructions cover the lab's protocols for cleaning PCR amplicons with AMPure XP beads and quantifying the cleaned product.

After PCR amplification and gel verification, the amplicons still contain leftover primers, dNTPs, salts, and other reaction components that would interfere with downstream library preparation and sequencing. Bead-based purification selectively binds the amplicon DNA while washing away these contaminants, and quantification tells us how much cleaned DNA we have so that we can pool samples at equimolar concentrations.

## Bead Cleaning

This section covers **WI-AC001 — Amplicon Cleaning by Bead Method (AMPure XP / SPRIselect)**.

AMPure XP beads (and the equivalent SPRIselect beads) use a solid-phase reversible immobilization (SPRI) mechanism: in the presence of polyethylene glycol (PEG) and salt, DNA molecules bind to the surface of carboxyl-coated paramagnetic beads. Shorter fragments (primers, primer-dimers, adapter artifacts) remain in solution and are washed away, while the target amplicons stay bound to the beads and are eluted in a low-salt buffer. The bead-to-sample volume ratio determines the size cutoff — a higher ratio retains shorter fragments, while a lower ratio selects for longer fragments only. We use a 1.8X ratio, which retains fragments above approximately 100 bp and is appropriate for our typical amplicon sizes (trnL ~50--250 bp, 12SV5 ~100--250 bp, 16S ~450 bp).

### Equipment and Consumables

- AMPure XP beads (Beckman Coulter, Cat. No. A63881) or SPRIselect beads
- Magnetic plate/stand (96-well or strip)
- 80% ethanol (freshly prepared)
- 1X TE buffer (10 mM Tris-HCl, 1 mM EDTA, pH 8.0)
- Multichannel pipettor and filter tips
- 96-well PCR plate or strip tubes

!!! warning
    Make fresh 80% ethanol each time you perform bead cleaning. Ethanol is hygroscopic — it absorbs water from the air — and degrades over time, which reduces cleaning efficiency and can lead to poor DNA recovery. Prepare the 80% ethanol solution no more than 24 hours before use, and keep the container capped when not actively dispensing.

### Preparing 80% Ethanol

Mix 80 mL of 100% molecular-grade ethanol with 20 mL of nuclease-free water to make 100 mL of 80% ethanol. Scale the recipe up or down depending on the number of samples; each sample requires two washes of 200 uL, so a full 96-well plate needs at least 38.4 mL. Prepare extra to account for pipetting dead volume.

| Component | Volume (mL) |
|---|---|
| 100% molecular-grade ethanol | 80 |
| Nuclease-free water | 20 |
| **Total** | **100** |

### Protocol

Before starting, gather all materials and set up a waste container for discarded supernatant and ethanol washes. Label a new plate or strip tubes for the final eluate. If you are cleaning a full 96-well plate, make sure you have enough beads, ethanol, and TE buffer on hand for the entire plate — interrupting the protocol mid-plate to prepare more reagents introduces delays that can affect bead drying and recovery consistency.

The protocol has four stages: bead binding, magnetic separation and washes, drying, and elution. The entire process takes approximately 30--40 minutes per plate once the beads have equilibrated to room temperature.

#### Bead Binding

Allow the AMPure XP beads to come to room temperature for at least 30 minutes before use. Cold beads perform inconsistently; the PEG/salt binding chemistry is temperature-sensitive. Vortex the bead stock well to resuspend — the beads settle during storage, and thorough resuspension is critical for consistent bead-to-sample ratios across wells. The resuspended beads should appear as a uniform brown suspension with no visible sediment at the bottom of the bottle.

Add beads to each PCR product at a **1.8X ratio**. For a 25 uL PCR product, this means adding 45 uL of beads.

| Component | Volume (uL) |
|---|---|
| PCR product | 25 |
| AMPure XP beads (1.8X) | 45 |

Pipette up and down 10 times to mix the beads and sample thoroughly. The bead-sample mixture should appear homogeneous with no visible streaks or unmixed regions. If using a multichannel pipettor, make sure all channels are dispensing and aspirating evenly.

Incubate at room temperature for 5 minutes to allow DNA to bind to the beads. During this time the beads form complexes with the amplicon DNA; do not shake, tap, or otherwise disturb the plate. You can set a timer and use this incubation period to prepare the ethanol wash solution if you have not already done so, or to label the elution plate.

!!! note
    The 5-minute incubation is the minimum recommended binding time. Longer incubations (up to 15 minutes) are acceptable and may slightly improve recovery for low-concentration samples, but they are not typically necessary.

#### Magnetic Separation and Washes

Place the plate on the magnetic stand and wait approximately 2 minutes until the solution clears completely. The beads will migrate to the side of the well nearest the magnet, forming a tight brown pellet, and the supernatant will become transparent. If the solution has not cleared after 2 minutes, wait an additional minute — incomplete separation leads to bead loss during the supernatant removal step.

Carefully remove and discard the supernatant without disturbing the bead pellet. Angle the pipette tips away from the bead pellet (toward the opposite side of the well) and aspirate slowly. It is better to leave a small amount of supernatant behind than to disturb the pellet and lose beads.

With the plate still on the magnet, add 200 uL of freshly prepared 80% ethanol to each well. Dispense the ethanol gently along the wall of the well opposite the bead pellet to avoid dislodging the beads. Wait 30 seconds, then carefully remove and discard the ethanol.

Repeat the ethanol wash — add another 200 uL of 80% ethanol, wait 30 seconds, and remove. This second wash is important; a single wash does not sufficiently remove residual salts and PEG, which can inhibit downstream enzymatic reactions.

| Wash Step | Ethanol Volume (uL) | Incubation Time |
|---|---|---|
| First wash | 200 | 30 seconds |
| Second wash | 200 | 30 seconds |

#### Drying and Elution

After the second wash, remove as much residual ethanol as possible using a 10 uL pipette. Even small amounts of carryover ethanol can inhibit downstream reactions and reduce sequencing quality.

Allow the beads to air-dry on the magnet for approximately 5 minutes with the plate lid off or open. The goal is to evaporate the remaining ethanol without over-drying the bead pellet. Watch the pellet closely during this step:

- **Under-dried** — the pellet still looks wet and shiny. Residual ethanol will carry over into the eluate. Continue drying.
- **Properly dried** — the pellet appears matte and slightly cracked at the edges but is still dark brown and cohesive. This is the ideal stopping point.
- **Over-dried** — the pellet is visibly cracked throughout and may appear lighter in color. Over-drying reduces DNA recovery because the DNA becomes trapped in the desiccated bead matrix. If you see significant cracking, proceed to elution immediately.

!!! note
    Drying time varies with ambient humidity and temperature. In a dry environment (e.g., winter with indoor heating), beads may dry in as little as 3 minutes. In humid conditions, drying may take closer to 10 minutes. Adjust your timing based on the appearance of the pellet rather than relying on a fixed timer.

Remove the plate from the magnet. Add 40 uL of 1X TE buffer to each well and pipette up and down 10 times to fully resuspend the beads. The pellet should break apart completely; if clumps remain, continue pipetting gently until the suspension is uniform. You can also gently scrape the pipette tip along the well wall where the pellet was sitting to help dislodge any remaining beads.

Incubate at room temperature for 2 minutes to allow the DNA to elute from the beads into the TE buffer. The low-salt TE environment disrupts the PEG/salt-mediated interaction, releasing the DNA from the bead surface.

Place the plate back on the magnet and wait until the solution clears (approximately 2 minutes). Carefully transfer the eluate — which now contains your cleaned amplicon DNA — to a new plate or tubes. Avoid transferring any beads with the eluate; brown discoloration in the eluate indicates bead carryover, which can interfere with fluorometric quantification.

### Storage

Cleaned amplicons can be stored at 4 °C for short-term use (up to one week) or at -20 °C for longer storage. If freezing, seal the plate with an adhesive film or cap the strip tubes to prevent evaporation and cross-contamination. Label the plate clearly with the date, project name, and amplicon type (trnL, 12SV5, 16S).

When thawing frozen amplicons for quantification, allow the plate to reach room temperature and spin down briefly in a plate centrifuge before opening to collect any condensation that may have formed on the seal.

??? question "Can I use a different bead ratio?"
    The 1.8X ratio is our standard for FoodSeq and 16S amplicons because it retains essentially all fragments above ~100 bp. If you are working with amplicons that produce significant primer-dimer (visible as a ~50--80 bp band on the gel), you can try a lower ratio — such as 1.2X or 1.0X — to exclude the primer-dimer while retaining the target amplicon. However, lower ratios also risk losing shorter target fragments, so verify recovery on a gel or bioanalyzer before committing to a lower ratio for an entire plate. When in doubt, use 1.8X.

??? bug "Troubleshooting"
    **Low DNA yield after cleaning:**

    - Check that the bead ratio was correct (1.8X). Using too few beads will result in incomplete binding of the target DNA.
    - Make sure the ethanol was freshly prepared at 80%. Degraded ethanol is the most common cause of poor recovery.
    - Over-drying the beads (cracked pellet) traps DNA in the bead matrix. If this happened, try adding more TE buffer and incubating for 5 minutes instead of 2 to recover as much DNA as possible.
    - Make sure the beads were fully resuspended before use. If the stock bottle was not vortexed thoroughly, the bead concentration in your pipetted aliquot may have been lower than expected.

    **Bead loss during washes:**

    - Use slower pipetting speed when adding and removing ethanol.
    - Make sure the magnetic stand is fully engaging the beads before removing supernatant. Some magnetic stands require 2--3 minutes for complete separation; do not rush this step.
    - Angle the pipette tips away from the bead pellet when aspirating.

    **Carryover (brown color in eluate):**

    - Allow more time for magnetic separation after resuspension (at least 2 minutes).
    - When transferring the eluate, stop aspirating before reaching the bottom of the well. Leaving 1--2 uL behind is acceptable; it is better to sacrifice a small amount of volume than to carry over beads.

## Quantification

With cleaned amplicons ready, we need to measure DNA concentration before pooling. Accurate quantification is critical because the pooling step requires equimolar input from each sample; if concentrations are inaccurate, some samples will be over-represented and others under-represented in the final sequencing library.

The lab uses two quantification methods depending on throughput and the number of samples:

- **Plate reader with Quant-iT** — best for high-throughput runs (full or partial 96-well plates). The fluorescence-based Quant-iT assay is specific to double-stranded DNA and is not affected by free nucleotides, primers, or salts that may remain after bead cleaning.
- **Qubit fluorometer** — best for smaller batches, spot-checks, or when only a few samples need quantification. The Qubit uses similar fluorescent dye chemistry but reads one tube at a time.

Both methods are fluorescence-based and report dsDNA concentration specifically, unlike UV absorbance (e.g., NanoDrop), which cannot distinguish between dsDNA, ssDNA, free nucleotides, and contaminants. We do not use UV absorbance for amplicon quantification.

Each method also comes in two sensitivity ranges — **HS (High Sensitivity)** and **BR (Broad Range)** — which differ in their detection windows:

| Kit | Detection Range | Typical Use |
|---|---|---|
| HS (High Sensitivity) | 0.005--120 ng/uL (Qubit) or 0.5--500 ng/mL (Quant-iT) | FoodSeq amplicons (trnL, 12SV5); low-yield samples |
| BR (Broad Range) | 0.2--1,000 ng/uL (Qubit) or 2--2,000 ng/mL (Quant-iT) | 16S amplicons; high-yield samples |

For most FoodSeq work, the HS kit is the better choice because cleaned amplicon concentrations typically fall in the low ng/uL range. If you are unsure which to use, start with HS; you can always re-read on the BR kit if your samples are above the HS detection range.

=== "Plate Reader (Quant-iT)"

    ### Equipment and Consumables

    - Quant-iT 1x dsDNA HS Assay Kit (Invitrogen, Cat. No. Q33232) or Quant-iT dsDNA BR Assay Kit (Cat. No. Q33133)
    - Black 96-well flat-bottom plate (Greiner, Cat. No. 655076)
    - CLARIOstar or similar fluorescence plate reader
    - Multichannel pipettor (or Viaflo 96-channel pipettor)
    - Lambda DNA standard (included in kit)

    !!! note
        Use the **HS (High Sensitivity)** kit for samples expected to be in the low ng/uL range, which is typical for most FoodSeq amplicons after bead cleaning. Use the **BR (Broad Range)** kit if you expect higher concentrations (e.g., 16S amplicons or samples with high input DNA).

    This protocol follows **WI-AQ001 — Quant-iT dsDNA Quantification with Viaflo/Plate Reader**.

    ### Standard Curve Preparation

    Prepare a standard curve using the Lambda DNA standard provided in the kit. The table below shows a typical two-point standard setup for the HS kit; for most routine quantification runs, a two-point curve (blank + high standard) is sufficient. Refer to the kit instructions for a full multi-point curve if higher precision is needed across a broader concentration range.

    | Standard | Lambda DNA (uL) | 1x dsDNA HS Working Solution (uL) | Concentration (ng/mL) |
    |---|---|---|---|
    | S1 (blank) | 0 | 200 | 0 |
    | S2 | 10 of 10 ng/uL stock | 190 | 500 |

    If you need a broader standard curve for improved accuracy, prepare additional standards by serial dilution of the Lambda DNA stock. A five-point curve covering 0, 50, 100, 250, and 500 ng/mL provides excellent linearity for the HS kit.

    Run standards in duplicate or triplicate when possible; replicates allow the software to flag outliers and improve the curve fit. Pipette each standard into the black 96-well plate and record the well positions in your plate map. Having a clear plate map is important for matching fluorescence readings back to the correct sample IDs after the run.

    ### Sample Preparation and Reading

    Add 195 uL of Quant-iT working solution to each sample well of the black 96-well plate. If you are using the Viaflo 96-channel pipettor, you can dispense the working solution to an entire plate in a single step; otherwise, use a multichannel pipettor.

    Add 5 uL of each cleaned amplicon to the corresponding well. Pipette up and down several times to mix the sample with the working solution. Avoid introducing bubbles, as they scatter light and produce artificially high or erratic fluorescence readings.

    | Component | Volume (uL) |
    |---|---|
    | Quant-iT working solution | 195 |
    | Cleaned amplicon | 5 |
    | **Total** | **200** |

    Incubate the plate at room temperature for 5 minutes, protected from light. The Quant-iT dye is light-sensitive; keep the plate covered with aluminum foil or in a closed drawer during incubation. Exceeding the 5-minute incubation is fine — the fluorescence signal is stable for at least 3 hours at room temperature — but do not read the plate before the minimum 5 minutes.

    Read fluorescence on the plate reader using the appropriate protocol. The standard excitation and emission wavelengths for the Quant-iT dsDNA assay are approximately 485 nm (excitation) and 530 nm (emission). If you are using the CLARIOstar, select the pre-configured Quant-iT protocol from the instrument software; this protocol includes the correct filter settings, gain adjustment, and read mode (fluorescence intensity, top optic).

    Calculate sample concentrations from the standard curve. The plate reader software will generate a linear regression from the standard wells and interpolate sample concentrations. Export the results as a CSV or spreadsheet and record concentrations in your lab notebook or tracking spreadsheet. These values will be used in the pooling calculation.

    !!! note
        The Quant-iT plate reader assay reports concentration in the well (ng/mL), not the concentration of your original sample. To convert to the original sample concentration, account for the dilution factor. With 5 uL of sample in 200 uL total, the dilution factor is 40X — so multiply the well concentration by 40 and divide by 1,000 to get ng/uL. For example, a well reading of 250 ng/mL corresponds to (250 x 40) / 1,000 = 10 ng/uL in the original sample. Some plate reader software can perform this correction automatically if you configure the sample volume in the protocol settings.

    ??? bug "Troubleshooting"
        **Standard curve has poor fit (R-squared below 0.99):**

        - Check that the standards were pipetted accurately. A 1 uL pipetting error at the 10 uL scale is a 10% error in standard concentration.
        - Make sure no bubbles are present in the standard or sample wells.
        - Make sure the plate is a **black flat-bottom** plate. Clear plates allow light bleed-through between wells, and white plates produce high background autofluorescence. Both will distort the standard curve.

        **Sample readings fall outside the standard curve range:**

        - If readings are above the highest standard, dilute the sample 1:5 or 1:10 in TE buffer and re-read. Multiply the resulting concentration by the dilution factor.
        - If readings are at or near the blank, the sample may have very low DNA concentration. Re-read with a larger sample input (e.g., 10 uL sample + 190 uL working solution), or switch to the Qubit for higher sensitivity with small sample volumes.

        **High background fluorescence in sample wells:**

        - Bead carryover from the cleaning step can produce a fluorescent signal. If the eluate appeared brown or turbid, re-clean the sample on the magnet before quantifying.
        - Residual ethanol carryover can also increase background. Make sure ethanol was fully removed and beads were dried appropriately during cleaning.

=== "Qubit"

    ### Equipment and Consumables

    - Qubit 4 fluorometer (Invitrogen)
    - Qubit dsDNA HS Assay Kit (Cat. No. Q32854) or BR Assay Kit (Cat. No. Q32853)
    - Qubit assay tubes (Cat. No. Q32856)
    - Micropipettors and filter tips

    !!! note
        Qubit assay tubes are thin-walled 0.5 mL tubes specifically designed for the Qubit fluorometer. Standard 0.5 mL or 1.5 mL microcentrifuge tubes will not fit in the Qubit reader and should not be used.

    This protocol follows **WI-020 — Amplicon Quantification by Qubit**.

    ### Working Solution Preparation

    Prepare Qubit working solution by diluting the Qubit reagent 1:200 in Qubit buffer. Each tube (standard or sample) requires 200 uL of working solution, so calculate the total volume needed based on your number of samples plus 2 standards.

    For example, for 10 samples plus 2 standards, prepare enough for 12 tubes with some overage to account for pipetting loss:

    | Component | Volume |
    |---|---|
    | Qubit buffer | 2,388 uL |
    | Qubit reagent (1:200) | 12 uL |
    | **Total working solution** | **2,400 uL** |

    Vortex the working solution briefly to mix. The working solution is light-sensitive; prepare it fresh for each quantification session and do not store it for reuse. The solution should appear uniformly colored — if you see particulates or phase separation, discard and prepare a new batch.

    !!! warning
        Do not substitute the Qubit reagent with Quant-iT reagent (or vice versa), even though both are fluorescent dsDNA dyes. The two kits use different dye concentrations and buffer formulations, and mixing them produces inaccurate results.

    ### Standard and Sample Setup

    Set up the standard tubes first. Add 190 uL of working solution to each of two Qubit assay tubes. Then add 10 uL of Standard #1 (0 ng/uL) to the first tube and 10 uL of Standard #2 (concentration varies by kit) to the second.

    | Tube | Working Solution (uL) | Standard/Sample (uL) | Total Volume (uL) |
    |---|---|---|---|
    | Standard #1 | 190 | 10 uL of Standard #1 | 200 |
    | Standard #2 | 190 | 10 uL of Standard #2 | 200 |
    | Sample | 198 | 2 uL of sample | 200 |

    Now set up sample tubes: add 198 uL of working solution and 2 uL of cleaned amplicon to each Qubit assay tube for a total volume of 200 uL. The 2 uL sample volume is the standard input for the Qubit HS assay and provides the best balance of sensitivity and sample conservation.

    Vortex all tubes for 2--3 seconds to mix. Do not vortex vigorously — a brief pulse is sufficient to homogenize the solution. Spin down briefly in a microcentrifuge to collect the liquid at the bottom of each tube and remove any bubbles from the solution surface.

    Incubate all tubes at room temperature for 2 minutes. This allows the fluorescent dye to intercalate into the dsDNA and reach a stable fluorescence signal.

    ### Reading Samples

    On the Qubit, select the appropriate assay (dsDNA HS or BR) from the home screen. The instrument will prompt you to calibrate with the two standards first — insert Standard #1, close the lid, and press "Read." Repeat with Standard #2.

    The Qubit will display the fluorescence values for both standards. Standard #1 should read near zero (it is the blank), and Standard #2 should produce a value within the range printed on the kit tube. If either standard produces an unexpected value, recalibrate with freshly prepared standards before reading samples.

    Once calibration is complete, proceed to sample reading.

    Read each sample tube by inserting it into the reader and pressing "Read." Before reading the first sample, set the sample volume to **2 uL** and the output units to **ng/uL** in the instrument settings.

    These settings tell the Qubit how to perform the dilution correction. Because you added 2 uL of sample to 198 uL of working solution (a 100X dilution), the raw fluorescence reading corresponds to the diluted concentration. By specifying the original sample volume, the Qubit back-calculates and reports the concentration of your original sample rather than the concentration in the assay tube. This saves a manual calculation step and reduces the chance of errors.

    Record the concentration for each sample in your lab notebook or tracking spreadsheet alongside the sample ID and the assay type (HS or BR). Unlike the plate reader, the Qubit reports concentration in the original sample (ng/uL) directly — no manual dilution correction is needed, as long as you set the sample volume correctly in the instrument settings.

    If a reading falls outside the assay's detection range, the Qubit will display "Out of Range." In that case:

    - **Too concentrated** — dilute the sample 1:10 in TE buffer, re-read with a 2 uL input, and multiply the reported concentration by 10 to get the original sample concentration.
    - **Too dilute** — increase the sample input volume to 5 uL or 10 uL (adjusting the working solution volume so the total is still 200 uL), update the sample volume setting on the Qubit accordingly, and re-read.

    ??? bug "Troubleshooting"
        **Qubit fails to calibrate:**

        - Make sure both standards are from the same kit as the reagent and buffer. Mixing components from different kits or lot numbers can cause calibration failure.
        - Check that you added 10 uL of standard (not sample) to each standard tube. Swapping a standard with a sample tube is a common mistake.
        - If calibration values look abnormal, prepare fresh working solution and new standard tubes.

        **Sample readings are unexpectedly low:**

        - Check that the sample was actually added to the tube. A 2 uL volume is easy to miss — watch the pipette tip as you dispense to confirm the liquid was delivered.
        - Make sure the tube is properly seated in the reader. The tube should drop fully into the sample chamber with the cap open.
        - Bead carryover can quench fluorescence. If the eluate was not clear, re-separate on the magnet.

        **Inconsistent readings between replicates:**

        - Vortex the tubes again before re-reading. The dye-DNA complexes can settle or distribute unevenly.
        - Make sure you are reading each tube only once per insertion. Removing and re-inserting the same tube without vortexing can give different readings due to settling.
        - Check that the 2-minute incubation was complete before reading. Reading too early produces unstable fluorescence values.

### Recording and Organizing Results

Regardless of which quantification method you used, record all concentrations in a structured format — typically a spreadsheet or CSV with columns for sample ID, concentration (ng/uL), date of quantification, and assay type (HS or BR). This file serves as the input for the pooling calculation, where we will normalize each sample to the same DNA mass before combining them into a single library.

If any samples returned concentrations of zero or below the detection limit, flag them in the spreadsheet. These samples may need to be re-amplified by PCR before proceeding, or they may need to be excluded from the sequencing run. Discuss with the lab before making a decision, as the appropriate course of action depends on the study design and sample availability.

??? question "Should I re-quantify samples that were cleaned days ago?"
    If the cleaned amplicons were stored at 4 °C for more than a few days, or if they went through a freeze-thaw cycle, it is good practice to re-quantify a subset of samples before pooling. DNA degradation is unlikely at these temperatures, but evaporation can change concentrations — especially if the plate seal was not tight. Re-quantifying a few representative samples (e.g., one high, one medium, one low concentration) is a quick sanity check that can catch evaporation-related shifts.

With cleaned and quantified amplicons in hand, proceed to [Pooling and Sequencing Prep](pooling.md).
