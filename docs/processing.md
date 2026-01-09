# Overview

After creating a phyloseq object, lab members have developed the below workflow for beginning to process and analyze it. The rest of the pages in this section will walk you though the three steps of calculating diversity metrics and relative abundance and creating a PCA plot:

``` mermaid
graph TD
    A[phyloseq] --> |filter out NAs / human reads for 12Sv5| B[Step 1: Calculate diversity metrics]
    A -.-> C[unfiltered phyloseq]
    B --> |add to sample metadata| C
    C --> D[Step 2: Calculate relative abundances]
    D --> E[Step 3a: Perform a clr transform]
    D --> F[BLAST file of NAs]
    F --> |add back into phyloseq| A
    E --> |filter out NAs / human reads for 12Sv5| G[Step 3b: Create a PCA plot]

```