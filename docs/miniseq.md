# Running the MiniSeq

These instructions cover PhiX preparation, library denaturation and dilution, and loading and running the Illumina MiniSeq. The protocols below are drawn from three work instructions: WI-IM000 (PhiX preparation), WI-IM001 (16S library denaturation), and WI-IM002 (FoodSeq library denaturation). The loading and run configuration steps apply to both library types.

The overall workflow is: prepare (or thaw) 4 nM PhiX, denature and dilute your pooled library and PhiX in parallel, combine them at the correct spike-in ratio, load the mixture onto the MiniSeq reagent cartridge, install a fresh flow cell, configure the run parameters, and start sequencing.

!!! note

    Plan for the full day. Between thawing the reagent cartridge (~60-90 minutes), preparing reagents, denaturing and diluting the library, loading the instrument, and waiting for self-checks, the hands-on time from start to sequencing launch is typically 2-3 hours. The sequencing run itself then takes 20-25 hours.

## PhiX Preparation

### WI-IM000 — Pooling and Quantifying PhiX

PhiX is a balanced-genome control library derived from the PhiX 174 bacteriophage. It has a well-characterized, balanced base composition (roughly equal proportions of A, C, G, and T), which makes it an ideal spike-in for sequencing runs that involve low-diversity libraries. When we sequence amplicons like 16S or trnL, the first few bases across all reads tend to be very similar, and the sequencer's optics struggle to distinguish clusters during the early cycles. Spiking in PhiX introduces enough sequence diversity to solve this problem.

We prepare a stock of 4 nM PhiX aliquots that can be stored at -20°C and pulled as needed for each sequencing run.

### Equipment and Consumables

- PhiX Control v3 (Illumina, Cat. No. FC-110-3001) — multiple tubes (3) preferred
- Illumina buffer RSB or equivalent (10 mM Tris-HCl pH 8.5 with 0.1% Tween 20)
- Quant-iT 1x dsDNA HS Assay Kit (Invitrogen, Cat. No. Q33232)
- Qubit assay tubes (Cat. No. Q32856) and Qubit 4 fluorometer
- Sterile 1.5 mL microcentrifuge tubes
- Micropipettors and filter pipette tips
- Vortex mixer and microcentrifuge
- Ice bucket with ice

!!! note

    If RSB is not available, prepare an equivalent by adding 1 uL of 100% Tween 20 to 1 mL of Qiagen Buffer EB (10 mM Tris-Cl, pH 8.5).

### Protocol

The starting point depends on whether you are opening new PhiX Control v3 tubes or using a previously saved stock tube.

**If starting from new PhiX Control v3 tubes:**

- Thaw RSB and all new tubes of PhiX on ice. Record the batch number(s).
- In a new, sterile microcentrifuge tube, combine the volumes of all the PhiX tubes into one pool. Record the total volume of the PhiX pool ($V_1$).
- Split the pool evenly into two tubes. Label both (top: Stock PhiX; side: batch no., date, initials). One tube will be used now; store the second at -20°C. Keeping a backup tube at -20°C means we do not need to order new PhiX for the next run.

??? question "Why pool multiple tubes instead of using one?"

    Individual PhiX tubes from Illumina can vary slightly in concentration. Pooling multiple tubes averages out these differences and gives us a more consistent stock. It also means we get more total volume to work with, which translates to more aliquots downstream.

**If starting from a stock PhiX Control tube:**

- Thaw the previously saved stock PhiX tube on ice. Allow the tube to thaw completely before proceeding; partial thawing can lead to uneven concentration within the tube.

### Quantification

We quantify PhiX using the Quant-iT 1x dsDNA HS assay on the Qubit 4 fluorometer. The high-sensitivity assay is needed here because PhiX concentrations from Illumina's stock tubes can be relatively low, and we need an accurate reading to calculate the correct dilution downstream.

- Aliquot 800 uL of Quant-iT 1x dsDNA HS Working Solution into a 1.5 mL tube. This working solution contains the fluorescent dye that selectively binds double-stranded DNA; the Qubit reads the fluorescence intensity and converts it to a concentration.
- Dispense 190 uL of working solution into each of two standard Qubit assay tubes (S1 and S2). Dispense 198 uL into the PhiX Qubit assay tube.
- Add 10 uL of the appropriate standard to each standard tube:

| Tube | Standard |
|---|---|
| Standard Tube #1 | 0 ng/uL λ dsDNA HS Standard |
| Standard Tube #2 | 10 ng/uL λ dsDNA HS Standard |

- Add 2 uL of Stock PhiX to its corresponding Qubit assay tube.
- Vortex all tubes 2-3 seconds. Flick to remove air bubbles. Incubate 2 minutes at room temperature.
- Calibrate the Qubit with Standard #1 and Standard #2. Read the PhiX sample; set sample volume to 2 uL and output to ng/uL.
- Record the concentration.

### Calculating nM from ng/uL

The Qubit reports concentration in ng/uL, but we need to work in nM (nanomolar) for the downstream dilution series. The conversion depends on the average fragment size of the library. Based on an average size of 500 bp for PhiX, the conversion formula is:

$$
\text{nM} = \frac{\text{ng/uL}}{660 \frac{\text{g}}{\text{mol}} \times 500 \text{ bp}} \times 10^6
$$

The 660 g/mol in the denominator is the average molecular weight of a single base pair of double-stranded DNA. Multiplying by the fragment length (500 bp) gives the total molecular weight, and dividing the mass concentration by this value converts to molar concentration.

For example, a concentration of 10 ng/uL corresponds to approximately 30.3 nM. Solve for the nM concentration ($C_1$) of your stock PhiX by multiplying the ng/uL reading by 3.03:

$$
C_1 = x \times 3.\overline{03}
$$

where $x$ is the ng/uL concentration.

### Diluting to 4 nM

Now, calculate the volume of RSB needed to dilute the stock PhiX to 4 nM. Use $C_1 V_1 = C_2 V_2$, remembering to subtract 2 uL from $V_1$ (the volume used for the Qubit reading):

$$
C_1 (V_1 - 2\text{ uL}) = 4\text{ nM} \times V_2
$$

Solve for $V_2$, then calculate the volume of RSB to add as $V_2 - (V_1 - 2\text{ uL})$.

On ice, make the 4 nM PhiX dilution by adding the calculated volume of RSB to the remaining stock PhiX. Mix well by vortexing and spinning down. Then make and label 5 uL aliquots of 4 nM PhiX in individual tubes; store at -20°C. Label each aliquot with the concentration (4 nM), the date, and your initials.

Aliquots are good for up to three months from the date of preparation. After three months, the DNA can degrade from repeated freeze-thaw cycles or long-term storage, which would result in lower-than-expected PhiX representation in the final sequencing data. Having pre-made aliquots saves significant time on sequencing day, since you can skip the entire PhiX prep section and go straight to denaturation.

!!! note

    Keep a log of how many aliquots remain. When you are down to the last few, plan to prepare a new batch from the backup stock tube so you are not caught without PhiX on a sequencing day.

## Library Denaturation and Dilution

This section covers the denaturation and dilution of your pooled library and PhiX control before loading onto the MiniSeq reagent cartridge. Denaturation converts the double-stranded library into single strands, which is required for the library to bind to the flow cell surface and form clusters. The protocol diverges slightly between 16S and FoodSeq library types, but both share common reagent preparation steps that we cover first.

**Before starting:**

- Record the kit type used (High Output or Mid Output). The kit type determines the number of reads and run time; the High Output kit yields more clusters but takes longer. For most of our runs, we use the High Output kit to maximize the number of reads per sample.
- Begin thawing the reagent cartridge (kept at -20°C) in a room temperature water bath. Thawing takes ~60-90 minutes. Do not use warm water; heating the reagents above room temperature can degrade the enzymes in the cartridge. Fill the water bath just high enough that the water level reaches the fill line printed on the cartridge packaging.

!!! warning

    Once thawed, the reagent kit is only stable for ~24 hours. Make sure you will sequence when you thaw it. If waiting, leave the thawed cartridge in the fridge until ready.

- Thaw Hybridization buffer from the kit; keep on ice once thawed. The hybridization buffer is used for the final dilution steps and must be chilled when added to the denatured library.
- Remove the Flow Cell from the fridge to begin warming up. Keep the package sealed until ready to use; allow at least 30 minutes at 4°C before use.

**Make reagents for prep (fresh each time):**

Both reagents below must be prepared fresh for each run. Degraded NaOH is one of the most common causes of poor cluster density, so this step is critical.

- **0.1N NaOH** — make sure the 2N NaOH comes from the stock bottle, not an aliquot. The stock solution must have a pH >12.5 before diluting; check with pH strips if you are unsure. In a microfuge tube, combine the following:

    | Reagent | Volume |
    |---|---|
    | 2N NaOH (stock bottle) | 50 uL |
    | Nuclease-free water | 950 uL |
    | **Total** | **1000 uL** |

- **200 mM Tris-HCl pH 7** — in a microfuge tube, combine the following:

    | Reagent | Volume |
    |---|---|
    | 1M Tris-HCl pH 7 | 200 uL |
    | Nuclease-free water | 800 uL |
    | **Total** | **1000 uL** |

    The Tris is used to quench the NaOH denaturation reaction; without it, the high pH would continue to degrade the library DNA.

Now the protocol diverges by library type.

=== "16S"

    ### WI-IM001 — 16S Library Denaturation and Dilution

    This protocol picks up at the end of WI-SP001 (sequencing prep), where you should have a 10 nM pooled library ready to go.

    **Create a 1 nM pooled library from the 10 nM pool:**

    - In a new microfuge tube, combine 10 uL of the 10 nM pool + 90 uL of Illumina RSB. This is a 1:10 dilution that brings the library down to 1 nM. Vortex briefly and spin down.

    **Dilute to 333 pM and denature (done in parallel with PhiX denaturation):**

    The library and PhiX are denatured and diluted in parallel, as both require a 5-minute incubation with NaOH. Working both tubes simultaneously saves time and keeps the timing consistent between them.

    | Step | Library | PhiX |
    |---|---|---|
    | Denature to 333 pM | Combine 5 uL of 1 nM pool + 5 uL of 0.1N NaOH | Combine 5 uL of 4 nM PhiX + 5 uL of 0.1N NaOH |
    | | Vortex and spin down | Vortex and spin down |
    | | Incubate at RT for 5 min | Incubate at RT for 5 min |
    | | Add 5 uL of 200 mM Tris-HCl pH 7 (quench) | Add 5 uL of 200 mM Tris-HCl pH 7 (quench) |
    | | Vortex and spin down | Vortex and spin down |
    | Dilute to 5 pM | Add 985 uL chilled hybridization buffer (total 1000 uL) | Add 985 uL chilled hybridization buffer to make 20 pM PhiX. Then combine 45 uL of 20 pM PhiX + 135 uL chilled hybridization buffer = 5 pM PhiX |
    | Dilute to final loading conc. | Add 120 uL of 5 pM library + 380 uL hybridization buffer = 1.2 pM library | Add 140 uL of 5 pM PhiX + 360 uL hybridization buffer = 1.4 pM PhiX |

    **Final prep for loading:**

    - In a new tube labeled "final library," combine 350 uL of 1.2 pM library + 150 uL of 1.4 pM PhiX.

    !!! note

        The final result is a library + ~30% PhiX spike-in, required for 16S libraries due to low diversity between samples. Without this level of PhiX, the sequencer cannot properly calibrate its color channels during the early cycles, which leads to poor quality scores and reduced data yield.

    - Vortex briefly and spin down. The library is now ready for loading onto the reagent cartridge. Proceed to the Loading and Running the MiniSeq section below.

    ??? bug "Troubleshooting"

        - **Low cluster density** — the most common cause is degraded NaOH. Make sure you prepared 0.1N NaOH fresh from the 2N stock bottle (not from an old aliquot) and that the stock solution pH was >12.5 before diluting.
        - **High PhiX percentage (>40%)** — this usually means the library concentration was lower than expected. Double-check the 10 nM pool concentration with a fresh Qubit reading before your next run.
        - **Uneven cluster density across the flow cell** — make sure you loaded the full 500 uL into the reagent cartridge and that the hybridization buffer was chilled when used.

=== "FoodSeq (trnL / 12SV5)"

    ### WI-IM002 — FoodSeq Library Denaturation and Dilution

    This protocol picks up at the end of WI-IM003 (Final Sample Prep Excel Template), assuming a 10 nM pooled library. The FoodSeq protocol includes an additional heat denaturation step at the end that is not required for 16S.

    - Set a heat block to 96°C for final heat denaturation. It needs time to reach temperature, so start it early. Verify the temperature with a thermometer if possible; an under-heated block is one of the most common causes of low cluster density for FoodSeq runs.
    - Check the MiniSeq for a Quick Wash; if prompted, prepare 40 mL of 0.5% Tween 20 (20 uL Tween 20 in 40 mL lab-grade water), load into the gray wash tray, and follow the machine prompts. The Quick Wash takes about 20 minutes, so starting it now gives it time to finish while you prepare the library.

    **Thaw reagents:**

    - Thaw 5 uL aliquot of 4 nM PhiX control (kept at -20°C). If no aliquots are available, follow the PhiX Preparation section above (WI-IM000).
    - Thaw Illumina buffer RSB (kept at -20°C).
    - Vortex all tubes briefly and spin down.

    **Create a 1 nM pooled library:**

    - In a new microfuge tube, combine 10 uL of the pre-made 10 nM pool + 90 uL of RSB. This is a 1:10 dilution bringing the pool down to 1 nM. Vortex and spin down.

    **Dilute to 333 pM and denature (in parallel with PhiX):**

    The library and PhiX are denatured and diluted in parallel, as both require a 5-minute incubation with NaOH. Work both tubes at the same time to keep the timing consistent.

    | Step | Library | PhiX |
    |---|---|---|
    | Denature to 333 pM | 5 uL of 1 nM pool + 5 uL of 0.1N NaOH | 5 uL of 4 nM PhiX + 5 uL of 0.1N NaOH |
    | | Vortex and spin down | Vortex and spin down |
    | | Incubate at RT for 5 min | Incubate at RT for 5 min |
    | | Add 5 uL of 200 mM Tris-HCl pH 7 | Add 5 uL of 200 mM Tris-HCl pH 7 |
    | | Vortex and spin down | Vortex and spin down |
    | Dilute to 5 pM | Add 985 uL chilled hybridization buffer | Add 985 uL chilled hybridization buffer to make 20 pM. Then 45 uL of 20 pM + 135 uL buffer = 5 pM |
    | Dilute to final | 120 uL of 5 pM library + 380 uL buffer = 1.2 pM | 140 uL of 5 pM PhiX + 360 uL buffer = 1.4 pM |

    **Final prep for loading:**

    - Combine 350 uL of 1.2 pM library + 150 uL of 1.4 pM PhiX. Vortex and spin down.
    - Perform a final heat denaturation: incubate at 96°C on the heat block for 2 minutes. This step provides a more thorough denaturation than NaOH alone, which we have found improves cluster density for FoodSeq libraries. After incubation, invert the tube 1-2 times to mix.
    - Quickly move the library to an ice water bath for 5 minutes. The rapid cooling locks the library in its single-stranded form by preventing the complementary strands from re-annealing.
    - Load the library onto the reagent cartridge as soon as possible. Single-stranded DNA will gradually re-anneal at room temperature, so minimizing the time between the ice bath and loading is important.

    ??? bug "Troubleshooting"

        - **Low cluster density** — check that the NaOH was prepared fresh and that the heat denaturation reached 96°C. A heat block that has not fully equilibrated will produce incomplete denaturation, leaving double-stranded fragments that cannot bind the flow cell.
        - **Library re-annealing** — if you notice the library sitting at room temperature for more than a few minutes after the ice bath, the strands may have re-annealed. In severe cases, you may need to repeat the heat denaturation step (96°C for 2 minutes, then ice for 5 minutes).
        - **High PhiX percentage** — same as the 16S troubleshooting note above; verify the 10 nM pool concentration before the next run.

## Loading and Running the MiniSeq

With the denatured library ready, we can now load the reagent cartridge, install the flow cell, and configure the sequencing run. This section walks through each step from cartridge loading through the start of the run.

Before you begin, make sure you have the following items ready:

- Thawed reagent cartridge (no ice pellets remaining)
- Flow cell (warmed to room temperature, still in sealed foil pack)
- Gray wash tray (in case a Quick Wash is needed)
- Lens paper and 70% ethanol (for cleaning the flow cell glass)

### Loading the Library onto the Reagent Cartridge

- Check that the reagent cartridge is fully thawed by shaking it from side to side. If you hear ice pellets knocking against the walls, continue thawing. Once thawed, invert the cartridge 5 times to mix the reagents; tap on the bench to reduce bubbles.
- Using a clean pipet tip, pierce the foil on the sample loading well (marked with an orange circle), then pipet the sample in slowly.

!!! warning

    Pipet *slowly* — making bubbles in this well can affect the run. Bubbles in the loading well can cause air to be drawn into the fluidics system, which leads to poor or uneven cluster generation.

- Load 500 uL of the final library into the reagent cartridge. If you have less than 500 uL, that is fine; the instrument will still draw the sample in. However, having the full 500 uL volume helps the system prime its fluidics correctly.

### Loading Custom Sequencing Primers

The primer loading step differs between 16S and FoodSeq; 16S uses custom EMP primers that must be manually added, while FoodSeq relies on the standard primers pre-loaded in the cartridge.

=== "16S"

    The 16S protocol uses custom EMP sequencing primers. Make sure the custom primers are at 100 uM concentration.

    Using a clean pipet tip, pierce the foil on the primer wells and pipet primers into the bottom of each well:

    - Well 24 of the reagent cartridge — add 3 uL of Read 1 primer
    - Well 25 — add 3 uL of Read 2 primer
    - Well 28 — add 4 uL of Index primer

    ??? question "Why do we spike in custom primers instead of checking the 'custom primers' box in the software?"

        Spiking custom primers directly into the reagent cartridge wells gives us more control over the primer concentration and avoids the instrument's internal mixing step. The EMP primers are designed for a specific annealing temperature and chemistry that differs from the standard Illumina primers, so adding them directly to the correct wells is the recommended approach.

=== "FoodSeq (trnL / 12SV5)"

    The FoodSeq protocol does not use custom sequencing primers; the standard Illumina primers pre-loaded on the cartridge are sufficient. Do not add any additional primers to the cartridge wells. The FoodSeq indexing PCR adds standard Illumina adapter sequences to the amplicons, so the default Read 1/Read 2 and Index sequencing primers on the cartridge will bind correctly.

### Configuring and Starting the Run

- Quick wash the MiniSeq if prompted (red circle with exclamation point on the screen). Use the gray wash tray and follow the on-screen instructions. Do not skip this step; running a sequence without completing the wash can introduce contaminants into the fluidics system.

Now, configure the analysis output mode. This setting determines where the data goes after the run.

=== "Duke"

    The David Lab QIIME pipeline will not work with the standard Illumina output into BaseSpace, so you must change the analysis method: go to Manage Instrument > System Configuration > pick stand-alone mode as the analysis method. This setting persists between runs, so you only need to change it once unless someone else has changed it back.

=== "General"

    Configure the MiniSeq for local/stand-alone output if your bioinformatics pipeline requires raw data rather than BaseSpace output. If your pipeline can work with BaseSpace, you can leave the default setting.

- Select the Sequence button on the home screen.
- Remove the previous reagent cartridge or wash tray (do not throw away the wash tray).

!!! warning

    While *wearing gloves and a lab coat*, pop out the formamide waste reservoir from the used cartridge and place it in the formamide waste stream collection (chemical hood). Formamide is hazardous and toxic for reproductive systems. The rest of the cartridge can go in normal trash.

- Load the new reagent cartridge.
- While *wearing gloves*, empty the liquid waste container. Cap and take it to the liquid formamide waste collection container (chemical hood). After emptying, replace the container and close the door.

Next, swap the flow cell. The flow cell is the glass chip where cluster generation and sequencing occur; a clean, undamaged flow cell is essential for good data quality.

- Open the flow cell door and push the white button to release the old flow cell. Handle the old flow cell by its edges to avoid cutting yourself on the glass.
- Open the new flow cell's foil pack. Remove the new flow cell and wet *lens paper* (not a Kimwipe) with 70% ethanol to gently wipe down the glass. The glass surface must be clean and free of fingerprints for the optics to image clusters properly. Load the flow cell into the top of the instrument; close the lid.

!!! warning

    Once the flow cell foil pack is opened, the flow cell must be used within 12 hours. Prolonged exposure to air degrades the surface chemistry that the clusters bind to.

- Press Next and enter the run parameters:

=== "16S"

    | Parameter | Value |
    |---|---|
    | Name | YYYY-MM-DD + Initials |
    | Read type | Paired-End |
    | Read 1 | 151 bp |
    | Index 1 | 12 bp |
    | Index 2 | 0 bp |
    | Read 2 | 151 bp |
    | Custom primers | Do **not** check this box (custom primers were spiked into the primer wells directly) |

    ??? question "Why is Index 2 set to 0 bp?"

        The 16S EMP protocol uses a single 12 bp golay barcode on the reverse primer for sample demultiplexing. There is no second index read. Setting Index 2 to 0 bp tells the instrument to skip the second index cycle entirely.

=== "FoodSeq (trnL / 12SV5)"

    | Parameter | Value |
    |---|---|
    | Name | YYYY-MM-DD + Initials |
    | Read type | Paired-End |
    | Read 1 | 151 bp (75 bp for 150 cycle kit) |
    | Index 1 | 8 bp |
    | Index 2 | 8 bp |
    | Read 2 | 151 bp (75 bp for 150 cycle kit) |
    | Custom primers | Do **not** check this box |

    The FoodSeq protocol uses dual 8 bp indexes (i7 and i5) for sample demultiplexing. The read length depends on the kit you are using: 151 bp for a 300 cycle kit or 75 bp for a 150 cycle kit.

- Select 'Manual' set up. Leave everything else unchecked. Press Next.
- The system will run through its self-checks, verifying that the cartridge, flow cell, and waste container are properly installed. The checks include a flow test (to verify the fluidics path is clear), a registration test (to verify the flow cell is properly seated), and a focus test (to verify the optics can image the flow cell surface). If any check fails, the instrument will indicate which component needs attention.
- Once the checks pass, start the run. Flip the green paper down over the touch screen to protect the display during the run.

!!! warning

    Keep the door to the room propped open during the run. The system keeps reagent cool by passive cooling; if the room temperature exceeds ~78°F, the reagents may degrade. Closed doors and nearby freezers can push the temperature above 85°F.

### Finishing a Run

Once the run is complete, the home screen will display a summary with cluster density, percent clusters passing filter, and the percentage of bases with quality scores above Q30. These metrics give you a quick sense of how the run went before you transfer the data.

For reference, typical values for a good run are:

| Metric | Typical Range |
|---|---|
| Cluster density | 120-170 K/mm² (High Output); varies by kit |
| Clusters passing filter | >80% |
| %Q30 | >80% |
| PhiX alignment rate | ~25-35% (for 30% spike-in) |

If any of these metrics fall significantly outside the expected range, see the troubleshooting section below.

- Runs take approximately 20-25 hours (300 cycle High kit ~25 hours; 300 cycle Mid kit ~20 hours). The home screen will display estimated time remaining and current cycle progress throughout the run.
- Data will be stored locally on the machine. Use a USB 3.0 stick to transfer the entire run folder (transfers can take 20-60 minutes depending on folder size). The folder will be named in the format `YYMMDD_MN00462_####_[long string]`. Copy the entire folder — do not cherry-pick individual files, as the downstream QIIME pipeline expects the complete folder structure including the `Data/Intensities/BaseCalls/` directory, the `RunInfo.xml` file, and the `InterOp/` folder.

=== "Duke"

    16S data is stored at `D:\Illumina\Miniseq Run Data`. FoodSeq (12SV5/trnL) data is stored at `D:\Output`.

=== "General"

    Check the MiniSeq's local storage path and copy the entire run data folder to a USB stick or network share.

- After copying the data, verify the transfer was successful by checking that the folder size on the USB matches the folder size on the instrument. A corrupted or incomplete transfer will cause errors during demultiplexing.
- Leave the used reagent cartridge and flow cell in place after the run to prevent dust from getting into the system. We swap them out at the start of the next run rather than immediately after the current one finishes.

### Quick Wash After a Run

If the MiniSeq will not be used for a sequencing run within the next 7 days, perform a Quick Wash to prevent salt buildup in the fluidics lines. Salt deposits can clog the fluidics path and cause errors on subsequent runs.

- Prepare 40 mL of 0.5% Tween 20 wash solution:

    | Reagent | Volume |
    |---|---|
    | Tween 20 | 20 uL |
    | Lab-grade water | 40 mL |

- Load the wash solution into the gray wash tray.
- On the MiniSeq home screen, select Wash > Quick Wash and follow the on-screen prompts.
- The wash takes approximately 20 minutes. Once complete, the instrument is safe to leave idle until the next run.

!!! note

    The gray wash tray is reusable. Rinse it with deionized water between uses and store it near the MiniSeq so it is ready for the next wash or run.

??? bug "Troubleshooting"

    - **Run fails during self-checks** — the most common cause is an improperly seated reagent cartridge or flow cell. Remove and re-seat the component that failed the check. Also verify that the waste container is properly installed and that the door is fully closed.
    - **Poor quality scores (Q30 < 80%)** — check the room temperature during the run. If it exceeded ~78°F, the reagents may have partially degraded. Also check the PhiX alignment rate; if it is unusually low, the PhiX aliquot may have been degraded or the spike-in percentage was too low.
    - **Run completes but no data on the machine** — verify that the instrument was configured for stand-alone mode (not BaseSpace) before starting the run. If it was set to BaseSpace, the data may have been uploaded to the cloud instead of saved locally.
    - **Cannot find the run folder** — the folder is named `YYMMDD_MN00462_####_[long string]`. On the Duke instrument, check both `D:\Illumina\Miniseq Run Data` and `D:\Output` depending on the library type. The folder may also be in a different location if the output path was changed in System Configuration.
    - **USB transfer is slow or fails** — MiniSeq run folders can be 5-15 GB depending on the kit type and read length. Use a USB 3.0 drive for faster transfer. If the transfer fails partway through, delete the partial copy on the USB and start over; partial folders will cause errors in the QIIME pipeline.
    - **Instrument prompts for a wash before sequencing** — this is normal if the previous run finished more than 7 days ago or if the instrument was left idle. Complete the Quick Wash before proceeding; it takes about 20 minutes and should not delay your run significantly if you start it early in the prep process.
