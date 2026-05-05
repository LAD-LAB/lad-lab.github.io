# Overview

After creating a phyloseq object, lab members have developed the below workflow for beginning to process and analyze it. The rest of the pages in this section will walk you though the three steps of calculating diversity metrics and relative abundance and creating a PCA plot:

``` mermaid
graph TD
    A[Unfiltered Phyloseq] -->|Step 1: Review/BLAST NAs, add taxonomic assignments for any that should be kept| B[Unfiltered Phyloseq with Added Taxonomic Assignments for Select NAs]
    B -->|Step 2: Filter out remaining NAs & human reads for 12Sv5| C[Filtered Phyloseq]
    C -->|Steps 3: Calculate diversity metrics and add to sample metadata| D[Filtered Phyloseq + Diversity Metrics]
    D -->|Step 4: Perform CLR transform on relative abundances| E[CLR-Transformed Phyloseq]
    E -->|Step 5: Create PCA biplot| F[PCA Biplot]
```