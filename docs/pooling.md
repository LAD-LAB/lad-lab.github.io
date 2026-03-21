# Quantification and Pooling

After purification, quantify the library concentration using the Quant-iT 1X dsDNA Assay Kits, high sensitivity (HS) or broad range (BR) (Thermo Fisher Scientific, Waltham, MA; Cat. Nos. Q33232 and Q33267). Kit selection can be cohort-specific: start with the BR for standard samples, but pivot to HS if you anticipate low DNA concentrations.

On the same day as quantification, combine samples in equimolar ratios to create a sequencing pool. If samples cannot contribute enough DNA to fully balance the pool due to low concentration, add them up to a set volume, typically 15–20 uL.

Measure the final concentration of the sequencing pool using a Qubit Fluorometer (Thermo Fisher Scientific, Waltham, MA) and measure the average amplicon size (between 100 and 300 bp) using a Bioanalyzer instrument (Agilent, Santa Clara, CA). Use these measurements to calculate the final nanomolar concentration of the sequencing pool:

$$
\text{nM} = \frac{\text{concentration (ng/uL)} \times 10^6}{660 \frac{\text{g}}{\text{mol}} \times \text{average amplicon size (bp)}}
$$

With the pool quantified and verified, proceed to [Sequencing](sequencing.md).
