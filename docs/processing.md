# Overview

Once a phyloseq object is created, the following workflow may be used as a template for further processing and beginning analysis. The rest of the pages in this section will expand on the details of each step.

``` mermaid
graph TD
    A[Unfiltered Phyloseq] -->|Step 1: Assign Common Names| B[Phyloseq with Common Name Assignments]
    B -->|Step 2: Review Unassigned Taxa - NAs| C[Phyloseq with Updated Assignments for Select NAs]
    C -->|Step 3: Taxa Filtering| D[Phyloseq with Filtered Taxa]
    D -->|Step 4: Sample Filtering| E[Phyloseq with Filtered Samples]
    E -->|Step 5: Prune Taxa| F[Phyloseq with Pruned Taxa after Sample Filtering]
    F -->|Step 6: Taxa Glomming| G[Phyloseq with Glommed Taxa]
    G -->|Step 7: Calculate Diversity Metrics| H[Phyloseq with Diversity Metrics]
    H -->|Step 8: Calculate Relative Abundances and CLR-Transform| I[CLR-Transformed Phyloseq]
    I -->|Step 9: Perform PCA| J[PCA Biplot]
```