# Overview

After creating a phyloseq object, lab members have developed the below workflow for processing and analyzing it. The rest of the pages in this section will walk you through each step:

``` mermaid
graph TD
    A[Raw Phyloseq] -->|Step 1: Assign common names| B[Phyloseq with Common Names]
    B -->|Step 2: Agglomerate taxa — differs for trnL and 12Sv5| C[Agglomerated Phyloseq]
    C -->|Step 3: Filter taxa — NAs, human reads, controls, cohort-specific removals| D[Taxa-Filtered Phyloseq]
    D <-->|Review NAs and BLAST unassigned ASVs| R[Reviewed NAs]
    D -->|Step 4: Filter samples — controls and other exclusions| E[Sample-Filtered Phyloseq]
    E -->|Step 5: Prune taxa at 0 reads after sample filtering| F[Pruned Phyloseq]
    F -->|Step 6a: Calculate diversity metrics| G[Phyloseq + Diversity Metrics]
    G -->|Step 6b: Calculate relative abundance — foods only| H[Relative Abundance Phyloseq]
    H -->|Step 6c: CLR transform| I[CLR-Transformed Phyloseq]
    I -->|Step 7: Create PCA biplot| J[PCA Biplot]
```
