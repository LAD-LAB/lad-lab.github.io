# Overview

After creating a phyloseq object, lab members have developed the below workflow for processing and analyzing it. The rest of the pages in this section will walk you through each step:

``` mermaid
graph TD
    A[Raw Phyloseq] -->|Step 1: Assign common names| B[Phyloseq with Common Names]
    B -->|Step 2: Filter taxa — NAs, human reads, controls, cohort-specific removals| C[Taxa-Filtered Phyloseq]
    C <-->|Review NAs and BLAST unassigned ASVs| R[Reviewed NAs]
    C -->|Step 3: Filter samples — controls and other exclusions| D[Sample-Filtered Phyloseq]
    D -->|Step 4: Prune taxa at 0 reads after sample filtering| E[Pruned Phyloseq]
    E -->|Step 5: Agglomerate taxa — differs for trnL and 12Sv5| F[Agglomerated Phyloseq]
    F -->|Step 6a: Calculate diversity metrics| G[Phyloseq + Diversity Metrics]
    G -->|Step 6b: Calculate relative abundance| H[Relative Abundance Phyloseq]
    H -->|Step 6c: CLR transform| I[CLR-Transformed Phyloseq]
    I -->|Step 7: Create PCA biplot| J[PCA Biplot]
```
