# Pooling and Sequencing Prep

These instructions cover the workflow from generating a pooling list through sequencing prep and bioanalyzer submission.

After amplicon cleaning and quantification, we have concentration data for every sample on the plate. The next series of steps transforms those individual samples into a single, sequencing-ready library: we calculate how much of each sample to combine, physically pool the samples, clean and size-select the pool, and then verify its quality before loading it onto the MiniSeq.

Each step in this process has its own work instruction (WI), referenced throughout the page. The relevant work instructions are:

- **WI-PL001** — Generating a Pooling List
- **WI-PL002** — Pooling with epMotion
- **WI-SP001** — Sequencing Prep (MinElute cleanup and gel extraction)
- **WI-SP002** — Final Qubit Quantification
- **WI-SP003** — Bioanalyzer Submission

## Generating a Pooling List

This section covers **WI-PL001 — Generating a Pooling List**.

After quantification, we use the pooling list Excel template (WI-PL000) to calculate the volume of each sample to pool. The goal is to combine all samples at equimolar concentrations so that each sample is represented roughly equally in the sequencing run; unequal pooling leads to uneven read depth across samples, which can compromise downstream analyses. Samples that contribute disproportionately to the pool will dominate the sequencing reads, while underrepresented samples may not yield enough reads for reliable taxonomic assignment.

The principle behind equimolar pooling is straightforward: if every sample contributes the same number of DNA molecules to the pool, then every sample should receive roughly the same number of sequencing reads. In practice, perfect equimolarity is difficult to achieve because quantification measurements have inherent variability and pipetting small volumes introduces error. The pooling list template does the math to get as close as possible given your concentration data.

### Filling in the Template

Open the pooling list Excel template (WI-PL000) and navigate to the input sheet. The template has a standardized layout that matches the 96-well plate format, so entering data in the wrong row or column is easy to catch visually.

Enter your quantification results (in ng/uL) and sample volumes into the template. The spreadsheet uses these values along with the average amplicon size (in bp) to calculate the molar concentration of each sample. From there, it determines the volume of each sample needed to reach the target concentration in the final pool. Samples with higher concentrations contribute smaller volumes, while samples with lower concentrations contribute larger volumes.

The key columns in the template are:

| Column | Description |
|---|---|
| Sample ID | Your sample identifier (must match the plate map) |
| Well | Source plate well position (e.g., A1, B3) |
| Concentration (ng/uL) | Qubit or plate reader result |
| Available Volume (uL) | Volume of cleaned amplicon remaining in the well |
| Calculated Pool Volume (uL) | Volume to transfer (calculated by the spreadsheet) |

Make sure to double-check that the sample IDs and well positions match your plate layout. A mismatch here means the wrong volumes get transferred from the wrong wells, and this type of error is very difficult to detect downstream. It is good practice to compare the plate map in the template against your physical plate labels before proceeding.

The template also calculates the total pool volume — the sum of all individual sample volumes. Review this value to make sure it is practical for your downstream tubes and columns. If the total volume is very large (e.g., >1 mL), you may need to use a larger collection tube during pooling or plan for a split-tube approach.

??? question "What if I have samples from multiple plates?"
    If you are pooling samples from more than one 96-well plate (e.g., combining trnL and 12SV5 plates, or combining plates from a large study), create a separate pooling list for each plate. Pool each plate individually first, then combine the per-plate pools in a final step. This reduces the complexity of the pooling process and makes it easier to troubleshoot if something goes wrong with a specific plate.

??? question "How does the template calculate the pool volume for each sample?"
    The template converts each sample's mass concentration (ng/uL) to a molar concentration (nM) using the average amplicon size, then calculates the volume needed to contribute a fixed number of moles to the pool. The underlying formula is:

    $$
    V_{\text{sample}} = \frac{n_{\text{target}}}{C_{\text{sample (nM)}}}
    $$

    where $n_{\text{target}}$ is the target number of moles per sample and $C_{\text{sample (nM)}}$ is the molar concentration of that sample. You do not need to do this calculation manually — the template handles it — but understanding the logic helps when troubleshooting unexpected volumes.

### Handling Low-Concentration and Failed Samples

For samples that fall below the minimum concentration threshold, pool the maximum available volume. These samples may end up underrepresented in the sequencing run, but including them preserves the possibility of recovering usable data. In many cases, even a small number of reads is sufficient for presence/absence detection of major dietary items, so it is generally better to include a low-concentration sample than to exclude it entirely.

For samples that fail quantification entirely — where the Qubit or plate reader returns no detectable concentration — they may be excluded from the pool at your discretion. Document which samples were excluded and why in your lab notebook; this information is important when interpreting results later, particularly if certain participants or time points appear to have missing data.

??? question "Should I re-extract or re-amplify failed samples?"
    That depends on the project timeline and sample availability. If the sample is irreplaceable (e.g., a unique time point from a clinical study), it is worth re-extracting and re-amplifying before giving up on it. If the sample is one of many replicates or if the study has sufficient statistical power without it, exclusion is usually the more practical choice. Consult with the PI if you are unsure.

### Reviewing the Calculated Volumes

Before exporting the pooling list, review the calculated volumes for reasonableness. Look for any samples with unusually large or small volumes, which may indicate data entry errors or samples with anomalous concentrations. The template highlights samples that fall outside expected ranges, but a manual review is still worthwhile.

Common issues to watch for:

- **Very small volumes (< 1 uL)** — These are difficult to pipette accurately, whether manually or on the epMotion. If many samples require sub-microliter volumes, the target pool concentration may be set too high; consider adjusting it downward so that all volumes fall within a pipettable range.
- **Very large volumes (> 30 uL)** — A few samples at the high end of the volume range are normal (these are the low-concentration samples), but if many samples require large volumes, the pool will be very dilute. Check that the target concentration is appropriate for your sequencing run.
- **Volumes that exceed the available sample** — The template flags samples where the calculated pool volume exceeds the available volume. For these samples, pool the maximum available volume and note that they will be underrepresented.

### Choosing the Output Format

The template generates either a manual pooling guide (a printable table of sample IDs and volumes to pipette) or a CSV file formatted for automated pooling on the epMotion. Which format you use depends on the number of samples and the pooling method you plan to follow.

For runs with fewer than 24 samples, manual pooling is straightforward and often faster than setting up the epMotion. For full 96-well plates or multi-plate runs, automated pooling saves time and reduces the risk of pipetting errors that accumulate over dozens of manual transfers.

Save a copy of the final pooling list (regardless of format) to your project folder for your records. This document is part of the sequencing run's audit trail and may be needed for troubleshooting or reanalysis later.

## Pooling

With the pooling list in hand, the next step is to physically combine all the samples into a single library pool. This is the step where dozens (or hundreds) of individual amplicon preparations become a single tube containing the complete sequencing library. We support two approaches: manual pipetting for smaller runs and automated pooling on the epMotion for larger runs.

Regardless of which method you choose, the key principle is the same: transfer the calculated volume of each sample — no more, no less — into the destination tube. Accuracy here determines the evenness of your sequencing coverage across samples.

=== "Manual"

    ### Equipment and Consumables

    - Pooling list (generated from WI-PL000 template)
    - Micropipettors and filter tips (2 uL, 20 uL, and/or 200 uL depending on volumes)
    - 1.5 mL or 2 mL microcentrifuge tubes
    - Vortex mixer
    - Microcentrifuge

    ### Protocol

    Before starting, review the pooling list and identify the range of volumes you will need to pipette. Select the appropriate pipettor(s) for the volume range — using a 200 uL pipettor to transfer 2 uL volumes, for example, will introduce significant error. If the volumes span a wide range, you may need to switch between pipettors partway through.

    Using the pooling list, manually pipette the calculated volume of each sample into a single 1.5 mL or 2 mL microcentrifuge tube. Work through the list systematically, checking off each sample as you go to avoid skipping or double-pipetting any wells. It helps to print the pooling list and physically mark each row as you complete it; the repetitive nature of this task makes it easy to lose your place, especially with a large number of samples.

    !!! warning
        Double-check high-volume and low-volume samples carefully. Pipetting errors at this stage propagate directly into uneven representation in the sequencing data. Pay particular attention to samples at the extremes of the volume range — these are the ones most likely to be affected by systematic pipetting bias.

    If the total pool volume exceeds the capacity of a single tube (1.5 mL or 2 mL), split the pool across multiple tubes and combine them after all samples have been added. Keep track of which samples went into which tube in case you need to troubleshoot later.

    Vortex the pooled library for 5 seconds to mix thoroughly, then spin down briefly in a microcentrifuge to collect the liquid at the bottom of the tube. If you split the pool across multiple tubes, combine them now by pipetting everything into a single tube (or the fewest tubes possible) and vortex again.

    The pool is now ready for sequencing prep. Label the tube with the date, project name, and "pooled library" so that it is clearly identifiable.

    !!! note
        Record the final pool volume in your lab notebook. You will need this value to calculate the amount of Buffer PB for the MinElute cleanup step. If you combined from multiple tubes, measure the total volume with a pipettor before proceeding.

    ??? bug "Troubleshooting"
        If you suspect a pipetting error (e.g., you added a sample twice or skipped one), note the affected sample in your lab notebook. Depending on the severity, you may choose to proceed as-is — a single doubled or missing sample in a pool of 96 will have a relatively minor effect on overall equimolarity — or you may choose to restart the pooling process from scratch if the error affects a critical sample.

        If you notice a visible color difference or cloudiness in the pool, this is usually not a concern — pooled amplicon libraries can appear slightly colored from residual reagents. However, if you see particulates or a precipitate, the sample plates may not have been properly cleaned during the bead step. Proceed with the MinElute cleanup, which should remove most contaminants.

=== "Automated (epMotion)"

    ### Equipment and Consumables

    - Pooling CSV file (exported from WI-PL000 template)
    - epMotion 5075 (Eppendorf)
    - Source plate containing quantified amplicons
    - 1.5 mL or 2 mL destination tube(s)
    - Appropriate tip racks for the volume range
    - Vortex mixer
    - Microcentrifuge

    This protocol follows **WI-PL002 — Pooling with epMotion**.

    ### Preparing the CSV

    Export the pooling list as a CSV file formatted for the epMotion. The CSV should contain the following columns: source well, volume (in uL), and destination. Verify the file before loading it into the software; a misformatted CSV can cause the epMotion to transfer incorrect volumes or skip wells entirely.

    The expected CSV format is:

    | Column | Example | Description |
    |---|---|---|
    | Source Well | A1 | Well position on the source plate |
    | Volume (uL) | 5.3 | Volume to transfer |
    | Destination | 1 | Destination tube identifier |

    Open the CSV in a text editor or spreadsheet program and spot-check a few rows against the original pooling list to confirm that the export was successful. Pay particular attention to well identifiers — the epMotion expects a specific format (e.g., A1, not A01) and will reject or misinterpret non-conforming entries. Also verify that the CSV uses the correct delimiter (comma) and does not contain extra header rows or trailing blank rows that could confuse the epBlue parser.

    Transfer the CSV file to the epMotion computer via USB drive or network share.

    ### Running the epMotion

    === "Duke"

        Log in to the epMotion computer (Login: `Food_Seq`, Password: `Duke123`). Open epBlue software.

    === "General"

        Log in to the epMotion computer and open the epBlue software.

    Load the pooling CSV into the epBlue software. The software will parse the file and display the transfer list for your review. Scan through the list to confirm that the number of transfers matches the number of samples you expect; if the count is off, the CSV may have formatting issues or blank rows.

    Set up the worktable with the source plate (your quantified amplicons), destination tube(s), and the appropriate tip racks as indicated by the software. Make sure the source plate is oriented correctly — well A1 should align with the A1 position on the worktable. Double-check that the destination tube is uncapped and seated securely in its holder.

    !!! note
        Select the tip rack that matches the volume range in your pooling list. If the volumes span a wide range (e.g., 1 uL to 50 uL), you may need to load multiple tip sizes. The epBlue software will prompt you if additional tip racks are required.

    Run the pooling method. The epMotion will transfer the calculated volume from each source well to the destination tube according to the CSV. Monitor the first few transfers to confirm that the instrument is aspirating and dispensing correctly; if the tips are not reaching the liquid or are picking up air, pause the run and adjust the plate position or liquid level settings.

    The entire pooling run for a 96-well plate typically takes 15-30 minutes depending on the number of samples and the tip-changing strategy.

    When complete, remove the destination tube from the worktable. Vortex the pooled library for 5 seconds and spin down briefly in a microcentrifuge. The pool is now ready for sequencing prep.

    ??? bug "Troubleshooting"
        If the epMotion skips wells or transfers incorrect volumes, check that the CSV file has the correct well identifiers (e.g., A1 through H12 for a 96-well plate) and that volumes are within the instrument's pipetting range. Very small volumes (< 1 uL) are below the accuracy threshold for most tip types; for these samples, consider manually pipetting outside of the automated run and adding those volumes to the pool separately.

        If the epMotion displays a tip jam error, open the tip arm, remove the jammed tip, and verify the rack is seated correctly before resuming. If the instrument aspirates air instead of liquid, the plate may have dried down or the liquid level may be too low for the aspiration height setting.

## Sequencing Prep

This section covers **WI-SP001 — Sequencing Prep**. After pooling, the library needs to be cleaned and size-selected before sequencing. The prep workflow has three stages: MinElute cleanup to remove residual primers, buffer salts, and other contaminants from the pool; gel extraction to isolate the target amplicon band and remove adapter dimers or off-target products; and a final Qubit quantification to determine the loading concentration for the MiniSeq.

These steps are performed on the single pooled library rather than on individual samples, which makes them much faster than the per-sample cleaning done earlier in the workflow. However, because all of your samples are now combined into one tube, errors at this stage affect the entire run — so work carefully and methodically.

The overall flow of sequencing prep is:

- MinElute column cleanup (remove primers, salts, and short fragments)
- Agarose gel electrophoresis and band excision (verify amplicon size and remove adapter dimers)
- MinElute gel extraction (recover DNA from the excised gel slice)
- Final Qubit quantification (determine loading concentration for the MiniSeq)

### MinElute Cleanup

The first step is a column-based cleanup of the pooled library using the MinElute PCR Purification Kit. This removes short fragments (including primer dimers), salts, and enzymes that could interfere with gel electrophoresis and downstream sequencing. The MinElute column uses a silica membrane that selectively binds DNA fragments above ~70 bp while allowing smaller molecules to pass through in the flow-through.

#### Equipment and Consumables

- MinElute PCR Purification Kit (Qiagen, Cat. No. 28006)
- Microcentrifuge capable of 17,900 x g
- Collection tubes (2 mL, provided in kit)
- Clean 1.5 mL microcentrifuge tubes
- Micropipettors and filter tips

#### Protocol

Before starting, gather all required materials and set up a clean workspace. The MinElute cleanup takes approximately 15 minutes from start to finish.

Measure the volume of your pooled library before starting. You will need this value to calculate the amount of Buffer PB to add. If you split the pool across multiple tubes during the pooling step, combine them now and measure the total volume.

Add 5 volumes of Buffer PB to the pooled library. For example, if your pool volume is 100 uL, add 500 uL of Buffer PB. Mix well by pipetting up and down or vortexing briefly. Buffer PB is a binding buffer that adjusts the pH and salt concentration to promote DNA adsorption to the silica membrane.

| Component | Volume |
|---|---|
| Pooled library | *V* uL |
| Buffer PB | 5*V* uL |

Transfer the mixture to a MinElute column seated in a 2 mL collection tube. Centrifuge at 17,900 x g for 1 minute. Discard the flow-through.

!!! note
    If the total volume of pool + PB exceeds the column capacity (~800 uL), load the column in two passes: add the first ~750 uL, centrifuge, discard flow-through, then load the remainder and centrifuge again. The DNA binds to the membrane during the first pass, so no DNA is lost by loading in multiple steps.

Add 750 uL of Buffer PE to the column. Centrifuge at 17,900 x g for 1 minute. Discard the flow-through. Buffer PE is an ethanol-based wash buffer that removes salts and other contaminants from the membrane while the DNA remains bound.

Centrifuge the empty column again at 17,900 x g for 1 minute to remove residual wash buffer. This dry spin is important; traces of ethanol from Buffer PE can inhibit downstream reactions and interfere with gel electrophoresis (causing bands to appear diffuse or to float out of the wells).

Place the column in a clean 1.5 mL microcentrifuge tube. Add 15 uL of Buffer EB directly to the center of the membrane. Wait 1 minute to allow the buffer to soak into the membrane and rehydrate the bound DNA, then centrifuge at 17,900 x g for 1 minute. The eluate is your cleaned pooled library.

!!! note
    The MinElute column elutes in a small volume (15 uL) to maximize concentration. Do not use more than 15 uL unless you specifically need a more dilute eluate; the column's dead volume means that larger elution volumes do not proportionally increase DNA recovery.

The cleanup steps are summarized below:

| Step | Reagent | Volume | Centrifuge | Time |
|---|---|---|---|---|
| Binding | Buffer PB | 5X pool volume | 17,900 x g | 1 min |
| Wash | Buffer PE | 750 uL | 17,900 x g | 1 min |
| Dry spin | — | — | 17,900 x g | 1 min |
| Elution | Buffer EB | 15 uL | 17,900 x g | 1 min |

??? bug "Troubleshooting"
    If DNA recovery is low after MinElute cleanup, make sure Buffer PB was added at the correct ratio (5:1) and that the column was not overloaded. A second elution with an additional 10 uL of Buffer EB can recover residual DNA from the membrane, though the eluate will be more dilute. Combine both eluates if you choose this approach.

    If the cleaned pool appears viscous or cloudy, centrifuge it briefly and transfer only the clear supernatant. Cloudiness may indicate that agarose or other contaminants from the bead cleaning step were carried over into the pool.

### Gel Extraction

After MinElute cleanup, we run the cleaned pool on an agarose gel to verify the expected band size and perform gel extraction. This step serves two purposes: it confirms that the pool contains amplicons at the correct size, and it physically separates the target band from any adapter dimers (~120-150 bp) or high-molecular-weight artifacts that made it through the column cleanup.

Gel extraction is the most effective method for removing adapter dimers, which are too large to be eliminated by the MinElute column's size cutoff but small enough to form clusters on the sequencer and consume reads without producing useful data. Adapter dimers consist of the forward and reverse Illumina adapters ligated directly to each other without any insert DNA between them. Because they are short and highly amplifiable, they can dominate a sequencing run if not removed, producing reads that contain no useful sequence information.

The gel extraction process involves three phases: running the gel, excising the band, and recovering the DNA from the gel slice. Allow approximately 2 hours for the complete process (45 minutes for the gel run, 15 minutes for band excision, and 45 minutes for gel extraction and elution).

#### Equipment and Consumables

- Agarose (Invitrogen UltraPure, Cat. No. 16500)
- 1X TBE buffer
- GelGreen nucleic acid stain
- DNA loading dye (6X)
- DNA Ladder (100 bp, Invitrogen Cat. No. 15628050)
- Gel electrophoresis apparatus and power supply
- UV transilluminator (or blue-light transilluminator)
- Clean razor blade or scalpel
- MinElute Gel Extraction Kit (Qiagen, Cat. No. 28704)
- Microcentrifuge capable of 17,900 x g
- Heat block or water bath set to 50 C
- Clean 1.5 mL microcentrifuge tubes
- Isopropanol
- Analytical balance (for weighing gel slices)

#### Running the Gel

Prepare a 2% agarose gel with GelGreen stain following the gel preparation protocol described on the [Gel Electrophoresis](gel.md) page. A 2% gel provides better resolution of small fragments in the 100-500 bp range compared to a 1% gel, which is important here because we need to clearly distinguish the target amplicon band from adapter dimers that may be only 50-100 bp smaller.

For gel preparation, mix the following:

| Gel Size | Agarose (g) | 1X TBE (mL) | GelGreen (uL) |
|---|---|---|---|
| Small (50 mL) | 1.0 | 50 | 2.5 |
| Medium (75 mL) | 1.5 | 75 | 3.75 |

Use a comb with wide wells if available; the entire cleaned pool needs to fit into the well(s). If using a standard comb, the 15 uL eluate plus loading dye should fit in a single well, but check the well capacity first. A comb with 1.0 mm or 1.5 mm thickness provides good well volume for this purpose.

Mix the entire cleaned pool with the appropriate volume of 6X loading dye (typically 3 uL of dye for 15 uL of sample). Load the mixture into one or more wells alongside a 100 bp DNA ladder. If the pool volume exceeds a single well's capacity, split it across adjacent wells — you will excise and combine the bands from all wells during the extraction step.

| Component | Volume (uL) |
|---|---|
| Cleaned pool (MinElute eluate) | 15 |
| 6X loading dye | 3 |
| **Total** | **18** |

Run the gel at 80V for approximately 45 minutes, or until the bands are well separated. You should be able to clearly distinguish the target amplicon band from any adapter dimer band below it. If the bands are not well resolved, continue running the gel at the same voltage for an additional 10-15 minutes. Running at lower voltage (60V) for a longer time can also improve resolution between closely spaced bands, though the tradeoff is longer gel run time.

Before cutting the gel, it can be helpful to quickly image it on the transilluminator to assess band separation and plan your cuts. If the bands overlap or the separation is insufficient, do not cut — instead, continue running the gel until the bands are clearly distinguishable.

#### Excising the Band

!!! warning
    Minimize UV exposure time when cutting the band to prevent DNA damage. Use a blue-light transilluminator if available. If using a UV transilluminator, set it to low intensity and work quickly — prolonged UV exposure introduces pyrimidine dimers and strand breaks in the DNA, which reduce the effective concentration of sequenceable molecules.

Have your razor blade and a clean microcentrifuge tube ready before turning on the transilluminator. Using a clean razor blade, excise the band at the expected amplicon size. Cut as close to the band as possible to minimize the amount of agarose you carry forward; excess gel reduces extraction efficiency and dilutes the final eluate. If you loaded the pool across multiple wells, excise each band separately and combine the gel slices in a single tube.

Transfer the gel slice(s) to a pre-labeled, pre-weighed 1.5 mL microcentrifuge tube. Work quickly and turn off the transilluminator as soon as the band has been excised.

!!! note
    If you are processing pools for multiple target regions (e.g., trnL and 12SV5 from the same sequencing run), run them in separate lanes on the same gel but excise and process each band independently. The expected amplicon sizes differ between targets, so each will have its own band position on the gel.

#### Extracting DNA from the Gel Slice

Extract DNA from the gel slice using the MinElute Gel Extraction Kit (Qiagen, Cat. No. 28704). The kit works by dissolving the agarose in a chaotropic buffer (Buffer QG) at elevated temperature, then binding the released DNA to a MinElute silica column. The chemistry is similar to the MinElute PCR cleanup performed earlier, but with additional steps to handle the gel matrix.

Weigh the tube containing the gel slice on an analytical balance and subtract the tare weight of the empty tube to determine the gel weight. Record this value in your lab notebook — you will use it to calculate buffer volumes. A typical gel slice from a single well weighs 50-150 mg, depending on how tightly the band was cut and the thickness of the gel.

Add 3 volumes of Buffer QG per 1 volume of gel (e.g., 300 uL of Buffer QG per 100 mg of gel). The gel density is approximately 1 mg per uL, so use the weight in mg as your volume estimate in uL.

Incubate the tube at 50 C for 10 minutes, vortexing every 2-3 minutes until the gel slice is fully dissolved. The solution should be uniformly yellow with no visible gel fragments remaining. If gel pieces are still visible after 10 minutes, continue incubating and vortexing until dissolution is complete; incomplete dissolution will clog the column membrane and reduce DNA recovery.

??? question "Why does the color of the dissolved gel matter?"
    Buffer QG contains a pH indicator. The solution should be yellow at the correct pH for DNA binding (pH <= 7.5). If the solution turns orange or violet, the pH is too high and DNA will not bind efficiently to the column. This can happen if the gel was made with TAE buffer instead of TBE, or if the gel slice was very large relative to the buffer volume. If the color is not yellow, add 10 uL of 3M sodium acetate (pH 5.0) and mix until the color returns to yellow.

Add 1 gel volume of isopropanol to the dissolved gel solution (e.g., if the gel weighed 100 mg, add 100 uL of isopropanol). Mix by inverting the tube several times. The isopropanol increases the yield of small DNA fragments by reducing their solubility and promoting binding to the silica membrane.

Transfer the mixture to a MinElute column seated in a 2 mL collection tube. If the total volume exceeds the column capacity, load in multiple passes as described for the MinElute cleanup above. Centrifuge at 17,900 x g for 1 minute. Discard the flow-through.

Add 500 uL of Buffer QG to the column. Centrifuge at 17,900 x g for 1 minute. Discard the flow-through. This additional QG wash removes residual agarose and dissolved gel stain from the membrane; skipping this step can result in gel carryover that inhibits downstream applications.

Add 750 uL of Buffer PE to the column. Centrifuge at 17,900 x g for 1 minute. Discard the flow-through.

Centrifuge the empty column again at 17,900 x g for 1 minute to remove residual wash buffer. Place the column in a clean 1.5 mL microcentrifuge tube.

Add 15 uL of Buffer EB to the center of the membrane. Make sure the buffer is applied directly to the white membrane rather than running down the side of the column; off-center application reduces elution efficiency because the buffer does not contact the full membrane surface. Wait 1 minute to allow the buffer to soak into the membrane, then centrifuge at 17,900 x g for 1 minute. The eluate is your gel-extracted library pool.

Label the tube with the date, project name, and "gel-extracted pool." This tube contains your final sequencing library — handle it carefully and store at -20 C if you are not proceeding immediately to Qubit quantification.

The gel extraction steps are summarized below:

| Step | Reagent | Volume | Conditions |
|---|---|---|---|
| Dissolve gel | Buffer QG | 3X gel weight | 50 C, 10 min |
| Add isopropanol | Isopropanol | 1X gel weight | Mix by inversion |
| Bind to column | — | — | 17,900 x g, 1 min |
| Wash 1 | Buffer QG | 500 uL | 17,900 x g, 1 min |
| Wash 2 | Buffer PE | 750 uL | 17,900 x g, 1 min |
| Dry spin | — | — | 17,900 x g, 1 min |
| Elution | Buffer EB | 15 uL | 17,900 x g, 1 min |

??? bug "Troubleshooting"
    If DNA yield from gel extraction is low, the most common causes are incomplete gel dissolution (gel fragments clogging the membrane), over-trimming the band (cutting too conservatively and leaving DNA behind in the gel), and UV damage from prolonged transilluminator exposure.

    If the dissolved gel solution turns orange or violet instead of yellow, the pH is too high — add 10 uL of 3M sodium acetate (pH 5.0) to bring the pH back to the correct range before loading the column. A yellow color indicates the correct pH for DNA binding.

    If you suspect that a significant amount of DNA remains on the column, perform a second elution with 10 uL of Buffer EB and combine the two eluates. The second elution typically recovers an additional 10-20% of the total DNA.

### Final Qubit

This section covers **WI-SP002 — Final Qubit Quantification**. After gel extraction, we quantify the final pool by Qubit to determine the concentration for MiniSeq loading. This is the most critical quantification step in the workflow; the MiniSeq loading concentration directly affects cluster density and sequencing quality. Loading too much DNA results in overclustering (overlapping clusters that cannot be resolved), while loading too little results in underclustering (wasted sequencing capacity and low data output).

#### Equipment and Consumables

- Qubit 4 fluorometer (Invitrogen)
- Qubit dsDNA HS Assay Kit (Cat. No. Q32854)
- Qubit assay tubes (Cat. No. Q32856)
- Micropipettors and filter tips (2 uL and 200 uL)
- Lab notebook for recording results

!!! note
    Use the **HS (High Sensitivity)** kit for the final pool quantification, not the BR (Broad Range) kit. The HS kit has a detection range of 0.2-100 ng, which is well-suited for the typical concentrations of a gel-extracted pool. The BR kit is less precise at low concentrations and may give inaccurate readings for dilute samples.

#### Protocol

Prepare the Qubit working solution by diluting the Qubit reagent 1:200 in Qubit buffer. For the final pool quantification you only need one sample tube plus two standards, so prepare at minimum 3 x 200 uL = 600 uL of working solution (3 uL reagent + 597 uL buffer). Prepare a small excess to account for pipetting losses — making 800 uL total (4 uL reagent + 796 uL buffer) gives a comfortable margin.

Set up the standard tubes first. Add 190 uL of working solution to each of two Qubit assay tubes, then add 10 uL of the appropriate standard (S1 or S2) to each.

Now set up the sample tube: add 198 uL of working solution and 2 uL of the gel-extracted pool for a total volume of 200 uL.

| Tube | Working Solution (uL) | Standard/Sample (uL) | Total Volume (uL) |
|---|---|---|---|
| Standard #1 | 190 | 10 uL of Standard S1 | 200 |
| Standard #2 | 190 | 10 uL of Standard S2 | 200 |
| Sample | 198 | 2 uL of gel-extracted pool | 200 |

Vortex all tubes for 2-3 seconds to mix. Do not vortex vigorously — brief, gentle mixing is sufficient. Incubate at room temperature for 2 minutes to allow the fluorescent dye to bind to the DNA.

On the Qubit, select the dsDNA HS assay. Calibrate with the two standards first — the instrument will prompt you to insert each standard tube in sequence. Once calibration is complete, read the sample tube. Set the sample volume to 2 uL and the output units to ng/uL so that the concentration is reported directly without manual conversion.

Record the final concentration in your lab notebook alongside the date, project name, and target region (e.g., trnL, 12SV5, or 16S). This value will be used to calculate the dilution series needed for MiniSeq loading.

We recommend reading the sample twice (remove the tube, reinsert, and read again) to confirm that the reading is consistent; a discrepancy between the two readings may indicate a mixing or pipetting issue. If the two readings differ by more than 10%, vortex the tube again for 2-3 seconds and read a third time. Use the average of the consistent readings as your final concentration.

After recording the Qubit result, store the gel-extracted pool at -20 C if you are not proceeding to MiniSeq loading immediately. The pool is stable at -20 C for several weeks, but avoid repeated freeze-thaw cycles — if you anticipate multiple uses, consider making small aliquots before freezing.

??? question "What concentration do I need?"
    The target concentration for MiniSeq loading depends on the kit and protocol. Typically, you need a 10 nM pooled library. Use the following formula to calculate the nM concentration from ng/uL:

    $$
    \text{nM} = \frac{\text{ng/uL} \times 10^6}{660 \times \text{average amplicon size (bp)}}
    $$

    For FoodSeq amplicons, the average size is typically 200-400 bp depending on the target region (trnL amplicons tend to be shorter than 12SV5 amplicons). Use the bioanalyzer results for a more precise average fragment size. For example, if the Qubit reads 2.5 ng/uL and the average amplicon size from the bioanalyzer is 300 bp:

    $$
    \text{nM} = \frac{2.5 \times 10^6}{660 \times 300} = \frac{2{,}500{,}000}{198{,}000} \approx 12.6 \text{ nM}
    $$

    This pool would then be diluted to 10 nM before proceeding to the MiniSeq denaturation and loading protocol.

??? bug "Troubleshooting"
    If the Qubit reads "Out of Range" (too low), the gel extraction may have yielded insufficient DNA. Check that the correct band was excised and that the gel slice was fully dissolved during extraction. You can attempt a second elution of the MinElute column with 10 uL of Buffer EB to recover additional DNA, or re-pool from the original quantified amplicons and repeat the sequencing prep from the beginning.

    If the concentration is unexpectedly high, re-read the sample to rule out a pipetting error (e.g., adding more than 2 uL of sample to the Qubit tube, or adding too little working solution). If the second reading confirms the high concentration, the pool is fine — a concentrated pool is easier to work with than a dilute one, since you can always dilute down to the target nM.

    If the Qubit fails to calibrate, make sure the standards are from the same kit as the reagent and buffer. Mixing components from different kits or lot numbers can cause calibration failure. Also check that the standard tubes contain the correct volumes (190 uL working solution + 10 uL standard = 200 uL total).

## Bioanalyzer Submission

This section covers **WI-SP003 — Bioanalyzer Submission**. The bioanalyzer provides a detailed size distribution of your final library pool, which serves as the definitive quality check before sequencing. A clean bioanalyzer trace confirms that the pool contains amplicons at the expected size with minimal contamination from adapter dimers or off-target products.

The bioanalyzer is more informative than Qubit quantification alone because it shows the full fragment size distribution rather than just the total DNA concentration. This is critical for two reasons: it reveals whether adapter dimers or other contaminants survived the gel extraction step, and it provides the precise average fragment size needed to calculate the accurate nM concentration for MiniSeq loading.

### Sample Preparation for Submission

Prepare a small aliquot of your gel-extracted pool for bioanalyzer submission. Most core facilities require 1-2 uL of sample at a concentration of at least 0.5 ng/uL. Since the gel-extracted pool is typically concentrated enough (1-10 ng/uL), you usually do not need to dilute. Transfer 2-4 uL of the pool to a PCR tube or strip tube labeled with your sample name and the date.

!!! warning
    Do not submit your entire pool for bioanalyzer analysis — you need the remaining volume for MiniSeq loading. The bioanalyzer consumes only ~1 uL of sample, but it is good practice to submit a small aliquot in a separate tube to avoid the risk of losing the entire pool.

### Submission

=== "Duke"

    Submit samples to the Duke Molecular Core Facility (MCF) for bioanalyzer analysis. Go to the [MCF iLab page](https://duke.ilab.agilent.com) and submit a service request for Agilent Bioanalyzer DNA analysis (HS DNA chip). Upload your sample information and drop off the sample at the core facility.

    The bioanalyzer results will show the size distribution of your library. A successful pool should have a clear, sharp peak at the expected amplicon size with minimal adapter dimers (~120-150 bp) or large fragments. If the trace shows a significant dimer peak, you may need to repeat the gel extraction with more precise band excision. If the main peak is broad or split, the pool may contain off-target amplification products.

    !!! note
        MCF turnaround time is typically 1-2 business days. Plan your sequencing schedule accordingly; you should have the bioanalyzer results in hand before loading the MiniSeq so that you can calculate an accurate loading concentration based on the true average fragment size.

    When you receive the results, download the electropherogram and the region table from the MCF data portal. The region table provides the molarity, concentration, and average size for each peak, which you will use to calculate the final loading concentration.

=== "General"

    Submit your final pool to your institution's core facility for bioanalyzer or equivalent fragment analysis (e.g., TapeStation, Fragment Analyzer). Request a high-sensitivity DNA assay for the best resolution in the 100-1000 bp range.

    The results should show a clear peak at the expected amplicon size. A successful library pool will have a single dominant peak with minimal adapter dimer signal (~120-150 bp). Record the average fragment size from the bioanalyzer output — this value is used in the nM concentration calculation for MiniSeq loading.

    Contact your core facility in advance to confirm sample submission requirements (volume, concentration, tube format), turnaround time, and the format in which results will be delivered. Most core facilities provide an electropherogram image and a data table with peak sizes and concentrations.

    !!! note
        If your institution does not have a bioanalyzer or equivalent instrument, you can proceed to MiniSeq loading based on the Qubit concentration and an estimated average amplicon size. However, without the bioanalyzer quality check, you risk loading a library with significant adapter dimer contamination, which can reduce the usable data yield from the run. We strongly recommend bioanalyzer analysis whenever possible.

### Interpreting Bioanalyzer Results

The bioanalyzer electropherogram displays fluorescence intensity (proportional to DNA concentration) as a function of fragment size in base pairs. The x-axis shows fragment size and the y-axis shows fluorescence units (FU). Two internal markers — a lower marker at 35 bp and an upper marker at 10,380 bp — appear on every trace as reference peaks; these are added by the instrument and do not represent your library DNA.

Here is what to look for in a successful trace:

- **Target amplicon peak** — A sharp peak at the expected size for your target region. For trnL, this is typically 50-250 bp; for 12SV5, 100-300 bp; for 16S, 250-450 bp. The exact size depends on the primers and the taxa present in your samples. A sharp, symmetric peak indicates a clean, well-prepared library.

- **Adapter dimers** — A peak at ~120-150 bp indicates adapter dimer contamination. A small amount is acceptable (dimers below 5-10% of the total library concentration are unlikely to cause problems), but a prominent dimer peak will consume sequencing reads without producing useful data. If the dimer peak is comparable in height to the amplicon peak, repeat the gel extraction with a tighter band cut.

- **High-molecular-weight smear** — Broad signal above the expected amplicon size may indicate non-specific amplification, chimeras, or incomplete cleanup. This can usually be resolved by repeating the gel extraction with a tighter band cut. A small amount of smear above the main peak is normal and typically does not affect sequencing quality.

- **No peak / flat trace** — If the bioanalyzer shows no signal at the expected size, the pool may have been lost during cleanup or gel extraction. Check the Qubit concentration; if it reads near zero, you will need to re-pool from the original quantified amplicons and repeat the sequencing prep.

- **Multiple distinct peaks** — Two or more well-separated peaks in the expected size range may indicate that the pool contains amplicons from multiple target regions (e.g., trnL and 12SV5 in a dual-target run) or that non-specific amplification produced off-target products at a discrete size. If you expect a single target, investigate the source of the extra peak before proceeding.

- **Broad, low peak** — A wide, low-amplitude peak rather than a sharp, tall one may indicate that the library is overly diverse in fragment size (which can happen with certain primer sets and complex dietary samples) or that the DNA was partially degraded. If the Qubit concentration is sufficient, the library may still sequence successfully, but the read quality and mapping rate may be lower than expected.

### Recording Bioanalyzer Data

Record the following values from the bioanalyzer output in your lab notebook or project tracking spreadsheet:

| Parameter | Where to Find It | What It Is Used For |
|---|---|---|
| Average fragment size (bp) | Region table / peak summary | nM concentration calculation |
| Molarity (pmol/L) | Region table | Alternative to manual nM calculation |
| Concentration (pg/uL or ng/uL) | Region table | Cross-check against Qubit reading |
| Dimer percentage | Peak integration | Assessing library purity |

The bioanalyzer-reported molarity can serve as a direct measurement of library concentration in nM, which may be more accurate than calculating nM from the Qubit ng/uL value. If the bioanalyzer molarity and the Qubit-derived nM differ by more than 20%, investigate the discrepancy — it may indicate that the Qubit is detecting contaminant DNA (e.g., dimer fragments) that the bioanalyzer resolves as a separate peak.

??? question "How do I use the bioanalyzer average size to recalculate my nM concentration?"
    The bioanalyzer region table reports the average fragment size (in bp) for the peak of interest. Use this value — rather than the rough estimate you used earlier — in the nM conversion formula:

    $$
    \text{nM} = \frac{\text{ng/uL (from Qubit)} \times 10^6}{660 \times \text{average size (from bioanalyzer, in bp)}}
    $$

    This gives a more accurate nM concentration, which translates to more precise MiniSeq loading and better cluster density. If the bioanalyzer-derived nM differs significantly from your initial estimate, recalculate the dilution volumes for MiniSeq loading accordingly.

??? bug "Troubleshooting"
    If the bioanalyzer trace shows a large dimer peak despite gel extraction, the most likely cause is that the band cut included dimer fragments. Dimers can co-migrate with the target band if the gel was not run long enough to separate them. Re-run a diagnostic gel at lower voltage for a longer time to confirm separation before cutting.

    If the trace shows no signal or only the internal markers, the sample may have been too dilute for the HS chip's detection range. Check your Qubit concentration — the HS DNA chip has a sensitivity range of approximately 5-500 pg/uL. If your sample is more concentrated, dilute it before resubmitting.

    If the average fragment size reported by the bioanalyzer is significantly different from what you expected, review the gel image from the extraction step. The band you excised may have been at the wrong position, or the gel may have run unevenly. Consult the DNA ladder positions on the gel image to verify that the excised band was at the correct size.

Keep all bioanalyzer data files (electropherograms, region tables, and raw data) saved to your project folder alongside the Qubit results and pooling lists. These records form a complete audit trail for the sequencing run and are essential for troubleshooting any issues that arise during or after the MiniSeq run.

With the final pool quantified and verified, proceed to [Running the MiniSeq](miniseq.md).
