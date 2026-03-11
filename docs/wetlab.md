# Overview

These instructions document the wet lab protocols for the lab's core sequencing workflows, from DNA extraction through running the MiniSeq. The pages in this section walk you through each stage of the workflow below:

``` mermaid
graph TD
    A[DNA Extraction] --> B[PCR Amplification]
    B --> C[Gel Electrophoresis]
    C --> D[Amplicon Cleaning]
    D --> E[Amplicon Quantification]
    E --> F[Pooling]
    F --> G[Sequencing Prep]
    G --> H[MiniSeq Run]
```

- [**DNA Extraction:**](extraction.md) Manual extraction with the PowerSoil Pro kit or automated extraction with the epMotion, followed by LVis quantification.
- [**PCR Amplification:**](pcr.md) Primary and indexing qPCR for 16S and FoodSeq (trnL / 12SV5) amplicons, as well as primer stock and barcode plate preparation.
- [**Gel Electrophoresis:**](gel.md) Running agarose gels or E-Gels to verify amplification.
- [**Amplicon Cleaning and Quantification:**](cleaning.md) Bead cleaning with AMPure XP beads and quantification by plate reader or Qubit.
- [**Pooling and Sequencing Prep:**](pooling.md) Generating a pooling list, pooling with the epMotion, MinElute cleanup, gel extraction, and bioanalyzer submission.
- [**Running the MiniSeq:**](miniseq.md) PhiX preparation, library denaturation and dilution, and loading and running the MiniSeq.
