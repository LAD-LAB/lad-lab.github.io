# Gel Electrophoresis

These instructions cover the lab's gel electrophoresis protocols for verifying PCR amplification. After running PCR, we use gel electrophoresis to confirm that the target amplicon was successfully amplified before proceeding to cleanup and quantification. The lab uses three gel formats depending on throughput needs and equipment availability; select the appropriate tab below for the protocol you need.

??? question "Which gel format should I use?"

    The table below summarizes the key differences between the three formats to help you choose.

    | Feature | Agarose Gel | E-Gel 96 | E-Gel 48 |
    |---|---|---|---|
    | Throughput | Flexible (8--50 wells) | 96 samples | 48 samples |
    | Run time | ~35 min | 12 min | 20 min |
    | Stain | GelGreen/GelRed (added manually) | SYBR Safe (pre-cast) | SYBR Safe (pre-cast) |
    | Sample dilution | 5 uL product + 1 uL dye | 1:4 (5 uL in 15 uL water) | 1:20 (2 uL in 38 uL water) |
    | Gel preparation | Manual (weigh, microwave, pour) | Pre-cast cassette | Pre-cast cassette |
    | Work instruction | WI-GE001 | WI-GE002 | WI-GE003 |

    For routine FoodSeq or 16S runs with a full plate, the E-Gel 96 is the fastest option. For smaller batches or when you need more control over the gel conditions, the agarose gel is the best choice.

=== "Agarose Gel"

    The traditional agarose gel protocol is the most flexible option; it works with any number of samples and allows you to control gel percentage, run time, and voltage. This protocol is documented in WI-GE001.

    ## Equipment and Consumables

    - Agarose (Invitrogen UltraPure, Cat. No. 16500)
    - 1X TBE buffer
    - GelGreen or GelRed nucleic acid stain
    - DNA loading dye (6X)
    - DNA Ladder (1 Kb Plus, Invitrogen Cat. No. 10787018 or 100 bp, Cat. No. 15628050)
    - Gel electrophoresis apparatus and power supply
    - UV transilluminator or gel imaging system

    !!! warning

        Wear gloves when handling gels stained with nucleic acid stain. Dispose of gels in designated waste containers.

    ## Making the Gel

    Choose the appropriate gel size for your number of samples. The table below lists the agarose weight, buffer volume, and comb size for each gel size.

    | Gel Size | Agarose (g) | 1X TBE (mL) | Comb |
    |---|---|---|---|
    | Small | 0.5 | 50 | 8-well or 15-well |
    | Medium | 0.75 | 75 | 20-well |
    | Large | 1.0 | 100 | 25-well or 50-well |

    All three sizes produce a 1% agarose gel, which provides good resolution for the amplicon sizes typical of our trnL, 12SV5, and 16S targets.

    Weigh out the appropriate amount of agarose and add it to an Erlenmeyer flask with the corresponding volume of 1X TBE. Microwave the mixture in 30-second intervals, swirling the flask between each interval, until the agarose is fully dissolved and the solution is clear. Be careful when handling the flask after microwaving; the solution will be very hot, so use a heat-resistant glove or folded paper towel.

    Allow the solution to cool slightly (~60 °C) so that it is comfortable to hold but has not yet started to solidify, then add 5 uL of GelGreen per 100 mL of solution. Swirl gently to distribute the stain evenly throughout.

    !!! note

        GelGreen and GelRed are safer alternatives to ethidium bromide. GelGreen is recommended for most applications; if you are using GelRed, follow the same volume ratio (5 uL per 100 mL).

    Pour the solution into the gel tray with comb(s) in place. Make sure the comb teeth are fully submerged in the agarose solution and that no bubbles are trapped beneath them. If you see bubbles, use a pipette tip to gently push them away from the comb.

    Allow the gel to solidify for ~20--30 minutes at room temperature; the gel will turn from clear to slightly opaque when it is ready. Do not move the tray while the gel is setting.

    ## Loading and Running

    Prepare a ladder mixture by combining the following volumes in a microcentrifuge tube.

    | Reagent | Volume (uL) |
    |---|---|
    | DNA ladder | 1 |
    | Loading dye (6X) | 1 |
    | Nuclease-free water | 4 |

    The choice of ladder depends on the expected amplicon size. The 1 Kb Plus ladder covers a broad range and is suitable for most of our amplicons; the 100 bp ladder provides finer resolution for smaller fragments.

    Next, add 1 uL of loading dye to 5 uL of each PCR product. If your loading dye is pre-mixed into the PCR reaction, you can skip the dye addition and load samples directly.

    Place the solidified gel into the electrophoresis apparatus and fill the buffer chamber with 1X TBE until the gel is fully submerged. Carefully remove the comb(s) from the gel, pulling straight up to avoid tearing the wells.

    Load the ladder into the first well, then load each sample into the remaining wells. Keep track of which sample is in which well so you can match bands to samples later. Run the gel at 80V for 35 minutes, or until the dye front has migrated sufficiently through the gel.

    !!! note

        Running at too high a voltage can cause the bands to smear; 80V for 35 minutes is a good starting point for most gels. If bands are difficult to distinguish, you can run the gel longer at the same voltage rather than increasing the voltage.

    ## Imaging

    Image the gel on the UV transilluminator or gel doc system. Bright, distinct bands at the expected amplicon size indicate successful PCR amplification; faint or absent bands may suggest the PCR did not work for those samples. Compare sample bands against the ladder to confirm that the amplicon is the expected size.

    Save the image to the lab's shared storage for your records. Include the date and project name in the filename for easy retrieval.

    ??? question "What should the gel look like?"

        A successful gel will show bright, crisp bands at the expected amplicon size for each sample. The ladder should display a clear pattern of bands at known sizes that you can use as a reference. Negative controls should show no band (or only a faint primer dimer band). Positive controls should show a strong band at the expected size.

    ??? bug "Troubleshooting"

        - **No bands visible** — Check that the stain was added before pouring the gel. Make sure the gel was oriented correctly (samples should migrate toward the positive electrode). Confirm that the PCR itself produced product by re-running a positive control.
        - **Smeared bands** — The voltage may have been too high, or the gel may have been run for too long. Try lowering the voltage or shortening the run time. Degraded DNA can also cause smearing.
        - **Unexpected band sizes** — Non-specific amplification or primer dimers can produce extra bands. Compare against the ladder to estimate sizes; primer dimers typically appear as small, bright bands near the bottom of the gel.
        - **Gel melted or deformed** — The voltage was too high for the gel concentration or buffer volume. Make sure the gel is fully submerged in buffer before running.

=== "E-Gel 96"

    The E-Gel 96 format is convenient for high-throughput verification of a full 96-well plate of PCR products. The pre-cast cassettes contain SYBR Safe stain, so no additional staining or gel preparation is needed — just dilute your samples, load them, and run. This protocol is documented in WI-GE002.

    ## Equipment and Consumables

    - E-Gel 96 Agarose Gels, 2% with SYBR Safe (Invitrogen, Cat. No. G720802)
    - E-Gel iBase Power System or E-Gel 96 Power System
    - Multichannel pipettor
    - 96-well plate
    - Licor gel imaging system

    ## Protocol

    Prepare your samples by adding 5 uL of PCR product to 15 uL of nuclease-free water in a 96-well plate. This 1:4 dilution brings the total volume to the 20 uL required for each well of the E-Gel cassette.

    | Reagent | Volume (uL) |
    |---|---|
    | PCR product | 5 |
    | Nuclease-free water | 15 |
    | **Total** | **20** |

    Remove the E-Gel 96 cassette from its packaging and place it on the E-Gel base unit. Make sure the cassette is seated firmly and the contacts are aligned with the base; a poor connection will result in an incomplete run.

    Using a multichannel pipettor, load 20 uL of each diluted sample into the corresponding well of the E-Gel. For the ladder wells, prepare a dilution of 5 uL ladder in 15 uL nuclease-free water and load 20 uL into each ladder well. Pipette slowly to avoid introducing air bubbles into the wells.

    Run the gel for 12 minutes on the default program. The E-Gel system will stop automatically when the run is complete. Do not remove the cassette before the program finishes, as this may result in incomplete separation.

    !!! note

        The E-Gel 96 cassette has dedicated ladder wells at fixed positions on the cassette. Check the cassette documentation or the markings on the cassette itself for the exact positions so that you do not accidentally load sample into a ladder well or vice versa.

    ## Imaging

    Once the run is complete, remove the cassette from the base unit and take it to the imaging system. Image the gel as soon as possible after the run; prolonged sitting can cause the bands to diffuse.

    === "Duke"

        The Licor is located in [room]. Turn on the imaging system, select the appropriate channel for SYBR Safe, and capture the image. Save the image with the date and project name.

    === "General"

        Image the E-Gel using your institution's gel imaging system with a SYBR Safe-compatible light source. SYBR Safe excites at ~280 nm and ~502 nm and emits at ~530 nm.

    ??? bug "Troubleshooting"

        - **Weak or absent bands** — Make sure the cassette was properly seated on the base; poor contact can result in incomplete electrophoresis. Verify that the sample dilution volumes were correct and that the PCR amplification was successful.
        - **Air bubbles in wells** — Air bubbles can prevent the sample from entering the gel matrix. Tap the cassette gently on the benchtop before starting the run to dislodge bubbles. Pipette slowly during loading to avoid introducing new ones.
        - **Uneven migration** — If some lanes appear to have migrated farther than others, the cassette may not have been level on the base. Make sure the base unit is on a flat surface.

=== "E-Gel 48"

    The E-Gel 48 format is useful when you have fewer samples than a full 96-well plate or when you want to check a subset of samples before committing to a full run. Like the E-Gel 96, these cassettes are pre-cast with SYBR Safe, so no gel preparation is required. This protocol is documented in WI-GE003.

    ## Equipment and Consumables

    - E-Gel 48 Agarose Gels, 2% with SYBR Safe (Invitrogen, Cat. No. G720802)
    - E-Gel iBase Power System
    - Multichannel or single-channel pipettor
    - Licor gel imaging system

    ## Protocol

    Prepare your samples by adding 2 uL of PCR product to 38 uL of nuclease-free water in a plate or tubes; this gives a 1:20 dilution. You will only load 15 uL of this mixture into the gel, so the remaining volume can serve as a backup if you need to re-run.

    | Reagent | Volume (uL) |
    |---|---|
    | PCR product | 2 |
    | Nuclease-free water | 38 |
    | **Total** | **40** |

    !!! note

        The E-Gel 48 uses a higher dilution factor (1:20) compared to the E-Gel 96 (1:4). This is because the E-Gel 48 wells accept a smaller loading volume, so a larger dilution is needed to bring the sample to the correct concentration range.

    Remove the E-Gel 48 cassette from its packaging and place it on the E-Gel iBase unit. Make sure the cassette is firmly seated and the contacts are engaged.

    Load 15 uL of each diluted sample into the corresponding well of the E-Gel. For ladder wells, load 15 uL of pre-diluted ladder into each ladder well. You can use either a multichannel or single-channel pipettor depending on the plate or tube format of your prepared samples.

    Run the gel for 20 minutes on the default program. The E-Gel system will stop automatically when the run is complete. As with the E-Gel 96, do not remove the cassette before the program finishes.

    !!! note

        The E-Gel 48 uses a longer run time (20 minutes) compared to the E-Gel 96 (12 minutes) and a smaller loading volume (15 uL vs. 20 uL). Make sure you are using the correct protocol for the cassette type you have; mixing up the volumes or run times between the two formats can lead to poor results.

    ## Imaging

    Once the run is complete, remove the cassette from the base and image the gel on the Licor imaging system following the same procedure described in the E-Gel 96 tab above. Save the image to the lab's shared storage with the date and project name.

    ??? bug "Troubleshooting"

        - **Uneven band intensity across the cassette** — This can occur if sample volumes were inconsistent across wells. Make sure to pipette accurately and use calibrated pipettors.
        - **No bands in specific wells** — Verify that samples were loaded into the correct wells and that the PCR product was not too dilute to begin with. You may need to re-run the PCR for those samples.
        - **Cassette does not fit on the base** — Make sure you are using the E-Gel iBase, not the E-Gel 96 Power System; the two base units are not interchangeable for different cassette sizes.

    ??? question "Can I reuse E-Gel cassettes?"

        No. E-Gel cassettes are single-use; the gel matrix and buffer are consumed during the run. Discard the cassette after imaging.

With amplification verified, proceed to [Amplicon Cleaning and Quantification](cleaning.md).
