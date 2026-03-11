# DNA Extraction

These instructions cover the lab's DNA extraction protocols, from extraction through quantification. The protocols described here correspond to work instructions WI-DE002 (manual PowerSoil Pro), WI-DE003 (automated MagAttract PowerSoil Pro with epMotion), and WI-DE005 (LVis Plate quantification on the CLARIOstar).

## Extraction

The lab uses two extraction methods depending on sample throughput and the nature of the experiment.

For small batches (up to 24 samples), we use the manual PowerSoil Pro kit with individual spin columns. This method is straightforward and requires only a microcentrifuge, vortex, and standard micropipettors. It is well suited to pilot experiments, re-extractions of individual samples, and any situation where you have a manageable number of tubes.

For larger batches (up to 96 samples), we use the MagAttract PowerSoil Pro kit with the epMotion 5075 automated liquid handler. The MagAttract kit uses magnetic beads instead of spin columns, which allows the epMotion to perform the binding, wash, and elution steps automatically in a 96-well plate format. This is the standard method for full cohort extractions.

Both kits are manufactured by Qiagen and are optimized for extracting DNA from challenging sample types like soil and stool. The chemistries are similar — both use bead-beating lysis with Solution CD1, inhibitor removal with Solution CD2, and multiple wash steps — but the purification approach differs (silica spin columns vs. magnetic beads).

=== "Manual (PowerSoil Pro)"

    ### Equipment and Consumables

    - PowerSoil Pro Kit (Qiagen, Cat. No. 47014)
    - Vortex Adapter (Cat. No. 13000-V1-24)
    - Microcentrifuge capable of 16,000 x g
    - Micropipettors and filter pipette tips
    - Clean 2 mL Microcentrifuge Tubes
    - Clean 1.5 mL Collection Tubes

    !!! warning

        Gloves are required throughout this protocol; a lab coat is recommended. Make sure to change gloves between samples if contamination is a concern, and wipe down surfaces with ethanol between sample sets.

    ### Protocol

    Before starting, label a set of PowerBead Pro Tubes with your sample IDs. If you are extracting extraction blanks (negative controls), label one tube as a blank and process it alongside your samples with no sample material added; this helps identify any contamination introduced during the extraction process.

    Begin by adding up to 250 mg of solid sample (or 200 uL of liquid sample) to each labeled PowerBead Pro Tube. The PowerBead Pro Tubes are pre-loaded with a mixture of ceramic and glass beads that will mechanically lyse cells during the vortexing step. Add 800 uL of Solution CD1 to the tube; Solution CD1 is a lysis buffer that works in conjunction with the bead-beating to break open cells and release DNA.

    Secure the tubes in the Vortex Adapter and vortex at maximum speed for 10 minutes. Make sure all tubes are tightly capped before vortexing; loose caps can open during bead-beating. This step is critical for achieving thorough lysis, particularly with tough sample matrices like stool.

    ??? question "Why 10 minutes of vortexing?"

        Ten minutes at maximum speed is the manufacturer's recommendation for complete lysis across a wide range of sample types. Reducing the vortex time may result in lower DNA yields, particularly for samples containing organisms with thick cell walls (e.g., plant material, fungal spores). If you are working with a sample type that is known to lyse easily, you can experiment with shorter vortex times, but 10 minutes is the standard for our FoodSeq workflows.

    Next, centrifuge the tubes at 15,000 x g for 1 minute. This pellets the beads, cell debris, and other particulates. Transfer the supernatant to a clean 2 mL Microcentrifuge Tube, being careful not to carry over any beads.

    Add 200 uL of Solution CD2 to the transferred supernatant and vortex for 5 seconds. Solution CD2 is an inhibitor removal reagent; it precipitates humic substances, polysaccharides, and other contaminants that co-extract with DNA and can interfere with PCR and other downstream enzymatic reactions. Centrifuge at 15,000 x g for 1 minute.

    Carefully transfer 700 uL of the supernatant to a new clean 2 mL Microcentrifuge Tube. Take care to avoid disturbing the dark pellet of precipitated inhibitors at the bottom of the tube; carrying over inhibitor precipitate defeats the purpose of this step.

    Now, add 600 uL of Solution CD3 to the supernatant and vortex for 5 seconds. Solution CD3 is a high-salt binding buffer that conditions the DNA for adsorption to the silica membrane in the MB Spin Column. Load 650 uL of the lysate onto an MB Spin Column sitting in a 2 mL Collection Tube. Centrifuge at 15,000 x g for 1 minute; the DNA binds to the silica membrane while the liquid passes through. Discard the flow-through.

    Load the remaining lysate onto the same MB Spin Column and centrifuge again at 15,000 x g for 1 minute. Discard the flow-through. All of the DNA from your sample is now bound to the silica membrane in the spin column.

    Next, wash the bound DNA by adding 500 uL of Solution EA to the MB Spin Column. Centrifuge at 15,000 x g for 1 minute and discard the flow-through. This first wash removes residual contaminants from the membrane while the DNA remains bound.

    Add 500 uL of Solution C5 to the MB Spin Column and centrifuge at 15,000 x g for 1 minute. Discard the flow-through. Solution C5 is an ethanol-based wash buffer that removes remaining salts and provides a final cleaning of the DNA on the membrane.

    Now, centrifuge the empty MB Spin Column at 16,000 x g for 2 minutes with no additional buffer added. This dry spin removes residual ethanol from the membrane. This step is important: traces of ethanol carried over from Solution C5 can inhibit PCR and other downstream enzymatic reactions.

    !!! warning

        Do not skip the dry spin. Even small amounts of residual ethanol on the membrane can reduce PCR efficiency or cause failed reactions downstream.

    Place the MB Spin Column in a new clean 1.5 mL Collection Tube. Add 50--100 uL of Solution C6 (a 10 mM Tris elution buffer) directly to the center of the white filter membrane. Make sure the buffer is applied to the center of the membrane and not to the walls of the column. Centrifuge at 15,000 x g for 1 minute to elute the purified DNA.

    Discard the MB Spin Column. Your purified DNA is now in the 1.5 mL Collection Tube, ready for quantification. Label the tube with the sample ID and date, and store at -20 C if you are not proceeding to quantification immediately.

    !!! note

        The elution volume affects DNA concentration. A lower volume (50 uL) yields more concentrated DNA, while a higher volume (100 uL) recovers more total DNA but at a lower concentration. For most FoodSeq applications, 100 uL works well; if you expect very low yields from your sample type, consider eluting in 50 uL to maximize concentration.

    ??? question "Why use Solution C6 instead of water for elution?"

        Solution C6 is a 10 mM Tris buffer at pH 8.0. The slightly basic pH helps release DNA from the silica membrane more efficiently than water. Tris also provides buffering capacity that stabilizes the DNA during storage. While nuclease-free water can be used in a pinch, Solution C6 is recommended for optimal yield and long-term stability.

    The protocol steps and centrifuge settings are summarized below for quick reference:

    | Step | Reagent | Volume | Centrifuge | Time |
    |---|---|---|---|---|
    | Lysis | Solution CD1 | 800 uL | 15,000 x g | 1 min |
    | Inhibitor removal | Solution CD2 | 200 uL | 15,000 x g | 1 min |
    | Binding | Solution CD3 | 600 uL | 15,000 x g | 1 min (x2 loads) |
    | Wash 1 | Solution EA | 500 uL | 15,000 x g | 1 min |
    | Wash 2 | Solution C5 | 500 uL | 15,000 x g | 1 min |
    | Dry spin | — | — | 16,000 x g | 2 min |
    | Elution | Solution C6 | 50--100 uL | 15,000 x g | 1 min |

    ??? bug "Troubleshooting"

        - **Low DNA yield** — make sure you are using up to 250 mg of sample material and vortexing for the full 10 minutes. If the sample type is difficult to lyse, you can try adding a 10-minute incubation at 65 C after the vortexing step (before centrifuging) to improve yields.
        - **Poor 260/280 ratios** — this typically indicates carryover of inhibitors or protein contamination. Make sure you are not transferring pellet material during the Solution CD2 step. You can also try increasing the volume of Solution EA wash or performing the wash step twice.
        - **No DNA detected** — verify that you added Solution CD1 to the PowerBead Pro Tube and that the sample was properly lysed. Check that Solution C6 was added to the center of the membrane during elution.

=== "Automated (epMotion)"

    ### Equipment and Consumables

    - MagAttract PowerSoil Pro DNA Kit (Qiagen, Cat. No. 27731)
    - epMotion 5075 (Eppendorf)
    - Deepwell plates (96-well)
    - Standard 96-well plates
    - 8-channel micropipettors and filter pipette tips
    - PowerBead Pro Plates (included in the MagAttract kit)
    - Vortex with MO BIO 96-well plate adapter
    - Sealing mats for 96-well plates
    - Centrifuge with plate rotor capable of 6,000 x g

    !!! warning

        Gloves and safety glasses are required throughout this protocol; a lab coat is strongly recommended. The MagAttract kit involves handling plates at high volumes, and spills during centrifugation can occur if plates are not properly sealed.

    This is a multi-day protocol. Day 1 covers plating samples and completing the lysis and inhibitor removal steps at the bench; Day 2 covers the automated purification run on the epMotion. If you need to pause between days, the lysate plate can be stored overnight at -20 C.

    ### Day 1: Plating and Lysis

    Before beginning, plan your plate layout. Record which sample goes in which well in a spreadsheet or lab notebook; losing track of the plate layout will compromise the entire experiment. We recommend including at least one extraction blank (an empty well processed alongside your samples) per plate as a negative control.

    Begin by adding up to 250 mg of solid sample (or 200 uL of liquid sample) to the wells of a PowerBead Pro Plate. Each well contains the same bead mixture found in the individual PowerBead Pro Tubes used in the manual protocol; the plate format simply scales the process to 96 wells.

    Add 800 uL of Solution CD1 to each sample well. Seal the plate securely with the provided sealing mat, pressing firmly along all edges and corners to prevent leaks during vortexing. A poor seal is one of the most common causes of cross-contamination between wells.

    Vortex the sealed plate at maximum speed for 10 minutes using the MO BIO 96-well plate adapter. Make sure the plate is firmly clamped in the adapter before starting; a loose plate can shift during vortexing, which can compromise lysis consistency across wells and potentially crack the plate.

    !!! warning

        Check the sealing mat immediately after vortexing. If any corners or edges have peeled up during the 10-minute vortex, press them back down before centrifuging. An unsealed well can leak into the centrifuge rotor or contaminate adjacent wells.

    Next, centrifuge the plate at 6,000 x g for 6 minutes. The lower g-force and longer spin time compared to the manual protocol are necessary because plate-format centrifugation is less efficient than microcentrifuge tubes at pelleting beads and debris; the 6-minute spin achieves comparable separation.

    Remove the sealing mat carefully and slowly, peeling from one edge to avoid splashing between wells and introducing cross-contamination. Dispose of the used sealing mat.

    Transfer the supernatant (approximately 500 uL per well) to a clean 96-well deep-well plate using an 8-channel micropipettor. Work carefully; the goal is to transfer as much supernatant as possible without disturbing the bead pellet at the bottom of each well. Pipette slowly and avoid plunging the tips too deep into the wells.

    Add 150 uL of Solution CD2 to each well of the deep-well plate. Solution CD2 precipitates inhibitors that could interfere with downstream reactions. Seal the plate with a new sealing mat and vortex for 5 seconds.

    Centrifuge the plate at 6,000 x g for 6 minutes. You should see a dark pellet of precipitated inhibitors at the bottom of each well after centrifugation.

    Carefully transfer 400 uL of supernatant from each well to a new standard 96-well plate, taking care not to disturb the pellet. Using an 8-channel pipettor, tilt the plate slightly toward you and aspirate from just below the surface of the liquid; this helps avoid drawing up pellet material. If you accidentally aspirate some of the pellet, expel the liquid back into the well, wait a moment for the disturbed material to settle, and try again.

    The plate can now be sealed with a new sealing mat and stored overnight at -20 C, or you can continue directly to the Day 2 epMotion run.

    The Day 1 steps and their centrifuge settings are summarized below:

    | Step | Reagent | Volume | Centrifuge | Time |
    |---|---|---|---|---|
    | Lysis | Solution CD1 | 800 uL per well | 6,000 x g | 6 min |
    | Inhibitor removal | Solution CD2 | 150 uL per well | 6,000 x g | 6 min |

    !!! note

        Label all plates clearly with the date, project name, and plate number. When storing overnight, wrap parafilm around the edges of the sealing mat to prevent evaporation and frost buildup. Record which plate(s) are in the freezer and their location so they are easy to find on Day 2.

    ### Day 2: epMotion Run

    If you stored the lysate plate overnight at -20 C, remove it from the freezer and allow it to thaw at room temperature for approximately 15--20 minutes before proceeding. Make sure the plate contents are fully thawed and at room temperature before loading onto the epMotion; frozen or partially frozen samples can cause pipetting errors and uneven bead binding.

    While the plate is thawing, prepare the epMotion worktable reagents. Check that you have sufficient quantities of all required buffers and that the MagAttract Suspension G beads are thoroughly resuspended (vortex the bead bottle for 30 seconds before use).

    === "Duke"

        Log in to the epMotion computer (Login: `Food_Seq`). Open the epBlue software and load the MagAttract PowerSoil Pro method.

    === "General"

        Log in to the epMotion computer and open the epBlue software. Load the MagAttract PowerSoil Pro method.

    The epBlue software will guide you through the worktable setup step by step. Set up the epMotion worktable with the following items as indicated by the software:

    - The lysate plate from Day 1
    - Fresh reagent reservoirs filled with the kit's wash buffers and elution buffer
    - The MagAttract Suspension G bead plate
    - Tip racks (loaded with the appropriate tips for the method)
    - A clean 96-well elution plate

    Make sure all reagent reservoirs are filled to the volumes specified by the method. The software will indicate the required volumes for each reservoir; fill to slightly above the required minimum to account for dead volume in the reservoirs. We recommend calculating the total volume needed based on the number of samples you are processing and adding 10--15% extra as a buffer.

    Double-check the worktable layout against the diagram displayed in epBlue before starting the run. Each item must be in its designated position; the software will not detect items placed in the wrong slot, and an incorrect layout can cause the run to fail or produce contaminated results.

    ??? question "Why does the epMotion use magnetic beads instead of spin columns?"

        The manual PowerSoil Pro protocol uses silica spin columns, which require centrifugation at each binding and wash step and cannot be automated on a liquid handler. The MagAttract kit replaces the spin columns with paramagnetic beads that bind DNA in solution. The epMotion uses a magnetic plate to immobilize the beads on the side of each well during wash and elution steps, allowing the entire purification to be performed by the liquid handler without any centrifugation.

    Run the method by pressing the start button in epBlue. The epMotion performs the following steps automatically:

    - Adding the MagAttract Suspension G magnetic beads to each sample well
    - Mixing to bind DNA to the beads
    - Magnetically separating the beads and removing the supernatant
    - Performing a series of wash steps with the kit's wash buffers
    - Eluting the purified DNA into the elution plate with Solution EB (a Tris-based elution buffer)

    A full 96-well plate run typically takes 1.5--2 hours depending on the number of samples.

    Do not leave the epMotion unattended for extended periods during the run. While the instrument runs autonomously, errors can occur that require intervention (see Troubleshooting below); catching them early can save time and prevent having to restart the entire run.

    When the run is complete, the epBlue software will display a completion message on screen. Remove the elution plate from the worktable carefully; the wells contain your purified DNA in approximately 100 uL of Solution EB per well. Seal the plate with a foil seal or sealing mat.

    If you are proceeding to quantification immediately, keep the plate at room temperature. Otherwise, store the sealed plate at -20 C until you are ready to quantify and begin PCR setup.

    !!! note

        After the run, clean up the worktable by discarding used tip racks, reagent reservoirs, and the bead plate according to your institution's waste disposal guidelines. Wipe down the epMotion worktable with ethanol.

    ??? bug "Troubleshooting"

        If the epMotion displays an error during the run, note the error message and step number from the run log, then consult the epMotion manual or contact the lab manager. Common issues include:

        - **Tip jams** — caused by improperly seated tip racks or bent tips. Open the tip arm, carefully remove the jammed tip, and verify the rack is seated correctly before resuming. If the tip rack was misaligned, replace it with a fresh rack.
        - **Insufficient reagent volumes** — the software will alert you if a reservoir runs low during the run. Pause the run, refill the reservoir to the required volume, and resume.
        - **Plate alignment errors** — make sure all plates and reservoirs are pushed fully into their worktable positions before starting the run. The epMotion's plate detection sensors are sensitive to even small misalignments.
        - **Bead carryover** — if you notice beads in the elution plate wells after the run, the magnetic separation step may not have been fully effective. This can happen if the magnetic plate was not properly positioned. The beads will not significantly affect downstream applications but can be removed by briefly placing the elution plate on a magnetic stand and transferring the supernatant to a fresh plate.

        If the run fails partway through, check the epBlue run log to determine which step was last completed. Depending on the failure point, you may be able to resume from the last completed step rather than restarting the entire run.

## Quantification (LVis Plate)

This section covers DNA quantification using the LVis Plate on the CLARIOstar plate reader. Quantification measures DNA concentration by UV absorbance and provides a purity check via the 260/280 ratio. We perform this step after extraction to confirm that we have sufficient, high-quality DNA before proceeding to PCR amplification.

### Equipment and Consumables

- CLARIOstar plate reader (BMG Labtech)
- LVis Plate (BMG Labtech)
- Lint-free wipes (Kimwipes)
- Deionized water
- Micropipettors and tips (2 uL capable)

### Protocol

Open the CLARIOstar software (MARS Data Analysis) and load the LVis Plate protocol. The protocol should already be saved on the instrument computer; if it is not available, contact the lab manager.

Clean the LVis Plate micro-drop glass slide with a lint-free wipe dampened with deionized water. Wipe each micro-drop measurement window individually, applying gentle pressure to remove any dried sample residue from previous measurements. Dry the slide thoroughly with a second clean lint-free wipe. Residual water, sample residue, or fingerprints on the measurement windows will affect absorbance readings and produce unreliable concentration values.

!!! warning

    Do not use ethanol or other solvents to clean the LVis Plate; these can damage the optical coating on the micro-drop windows. Use only deionized water and lint-free wipes.

Add 2 uL of blank to the reference positions on the LVis Plate. The blank should be the same elution buffer used during extraction — Solution C6 for the manual PowerSoil Pro kit, or Solution EB for the MagAttract kit.

??? question "Why does the blank matter?"

    The CLARIOstar software subtracts the blank absorbance from all sample measurements to zero out the background absorbance of the elution buffer itself. If you use a different buffer as the blank (or forget to add a blank entirely), your concentration values will include the buffer's own absorbance, introducing a systematic offset. This is typically a small effect, but it can matter for low-concentration samples where accuracy is most important.

Next, add 2 uL of each DNA sample to the corresponding position on the LVis Plate. Pipette carefully, placing the droplet squarely in the center of each micro-drop window; an off-center droplet may not cover the full optical path, producing an inaccurate reading. Avoid touching the glass surface with the pipette tip, as this can scratch the optical coating.

Make sure to record which sample is in which LVis position so you can match the results to the correct sample IDs after the measurement.

!!! note

    The LVis Plate measures 16 samples at a time (plus reference positions). If you have more than 16 samples, you will need to run multiple measurement cycles, cleaning the plate between each cycle.

Place the loaded LVis Plate into the CLARIOstar plate reader, making sure the plate is oriented correctly (the notch on the LVis Plate should match the notch indicator in the plate reader). Close the lid.

Run the measurement. The instrument measures absorbance at 260 nm and 280 nm for each sample position and calculates DNA concentration automatically using the Beer-Lambert law.

When the measurement is complete, the software displays a results table. Export the results as a CSV or copy them into your lab notebook or spreadsheet for record-keeping. Clean the LVis Plate with a lint-free wipe and deionized water after use so it is ready for the next measurement.

### Interpreting Results

The 260/280 ratio is the primary indicator of DNA purity. Nucleic acids absorb strongly at 260 nm, while proteins absorb at 280 nm; the ratio of these two values indicates how free your sample is from protein contamination.

The expected values and their interpretations are summarized below:

| Parameter | Expected Value | Interpretation |
|---|---|---|
| A260/A280 ratio | ~1.8 | Pure DNA |
| A260/A280 < 1.6 | Low | Possible protein or phenol contamination |
| A260/A280 > 2.0 | High | Possible RNA contamination |
| DNA concentration | Variable | Depends on sample type and input amount |
| Blank | Solution C6 or EB | Must match the elution buffer used during extraction |
| Sample volume | 2 uL | Pipette to center of micro-drop window |

Record the concentration (in ng/uL) and 260/280 ratio for each sample. These values will be used when setting up PCR reactions to normalize the amount of input DNA across samples, which helps produce more even amplification and sequencing depth across your dataset.

### Storage

After quantification, extracted DNA should be stored at -20 C for short-term storage (weeks to months) or at -80 C for long-term archival storage. Avoid repeated freeze-thaw cycles, as these can degrade DNA over time. If you anticipate needing to access a sample multiple times, consider making aliquots (5--10 uL each) before freezing so you can thaw only what you need.

For samples extracted in the 96-well plate format, seal the elution plate with an adhesive foil seal (rather than a sealing mat) for long-term freezer storage; foil seals provide a more secure barrier against evaporation and are easier to puncture individually when you need to access specific wells.

!!! note

    We recommend keeping a running spreadsheet or database of all extracted samples, including the extraction date, sample type, extraction method (manual or automated), DNA concentration, 260/280 ratio, and storage location. This makes it much easier to locate samples for downstream experiments and to track extraction quality over time.

??? question "Why does the 260/280 ratio matter for downstream steps?"

    PCR amplification is sensitive to contaminants that co-purify with DNA. Proteins, phenol, and other organic compounds that absorb at 280 nm can inhibit Taq polymerase and reduce amplification efficiency. A 260/280 ratio near 1.8 indicates that your DNA is sufficiently pure for reliable PCR. Samples with ratios well below 1.8 may amplify poorly or fail entirely, leading to missing data for those samples.

??? question "What concentration do I need for PCR?"

    The required input concentration depends on the specific PCR protocol, but for most FoodSeq reactions we target 1--10 ng/uL of input DNA. Samples with concentrations below 1 ng/uL may still amplify but are more likely to produce inconsistent or failed reactions. If your concentrations are very high (> 100 ng/uL), you can dilute the DNA with nuclease-free water or elution buffer before setting up PCR.

!!! note

    If a sample shows a very low concentration (< 1 ng/uL) or an abnormal 260/280 ratio, consider re-extracting that sample. Low yields can result from insufficient starting material, incomplete lysis, or loss during the wash steps. If re-extraction is not possible, note the low concentration and proceed; some samples with low concentrations still amplify successfully in PCR.

=== "Duke"

    The CLARIOstar plate reader is located in [room]. Contact [lab manager] if the software is not installed or the plate reader needs servicing.

=== "General"

    Use your institution's plate reader with a micro-volume DNA measurement protocol. Record concentrations and 260/280 ratios for each sample.

With extraction and quantification complete, you can proceed to [PCR Amplification](pcr.md).
