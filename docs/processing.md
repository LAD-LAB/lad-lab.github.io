# Overview

After creating a phyloseq object, lab members have developed the below workflow for beginning to process and analyze it. The rest of the pages in this section will walk you though the three steps of calculating diversity metrics and relative abundance and creating a PCA plot:

``` mermaid
graph TD
    A[Unfiltered Phyloseq] -->|Step 1: Filter out NAs / human reads for 12Sv5| B[Filtered Phyloseq]
    B -->|Steps 2-3: Calculate diversity metrics and add to sample metadata| C[Filtered Phyloseq + Diversity Metrics]
    C -->|Step 4: Perform CLR transform on relative abundances| D[CLR-transformed Phyloseq]
    D -->|Step 5: Create PCA biplot| E[PCA Biplot]
```