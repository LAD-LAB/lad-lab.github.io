# Overview

After creating a phyloseq object, lab members have developed the below workflow for processing and analyzing it. The rest of the pages in this section will walk you through each step:

``` mermaid
graph TD
    A[Raw Phyloseq] -->|Step 1: Assign common names| B[Phyloseq with Common Names]
    B -->|Step 2: Review NAs and BLAST unassigned ASVs| C[Phyloseq with Reviewed NAs]
    C -->|Step 3: Filter taxa — NAs, human reads, controls, cohort-specific removals| D[Taxa-Filtered Phyloseq]
    D -->|Step 4: Filter samples — controls and other exclusions| E[Sample-Filtered Phyloseq]
    E -->|Step 5: Prune taxa at 0 reads after sample filtering| F[Pruned Phyloseq]
    F -->|Step 6: Agglomerate taxa — differs for trnL and 12Sv5| G[Agglomerated Phyloseq]
    G -->|Step 7: Calculate diversity metrics| H[Phyloseq + Diversity Metrics]
    H -->|Step 8: Calculate relative abundance and CLR transform| I[CLR-Transformed Phyloseq]
    I -->|Step 9: Create PCA biplot| J[PCA Biplot]
```
