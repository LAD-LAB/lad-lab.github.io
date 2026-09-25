[foodseqtools.md](https://github.com/user-attachments/files/32664989/foodseqtools.md)
# foodseq.tools

`foodseq.tools` is the R package maintained by [LAD-LAB](https://github.com/LAD-LAB/foodseq.tools) that provides nearly every custom function referenced throughout this handbook — from creating a phyloseq object all the way through PCA. If you're setting up your environment for the first time, install it here before working through the rest of the handbook; most later pages assume it's already installed and loaded.

## Installation

``` r
# install.packages("devtools")
devtools::install_github("LAD-LAB/foodseq.tools")

library(foodseq.tools)
```

## Functions Used in This Handbook

Every function below is documented in more detail on the handbook page it's linked from.

| Function | Used in | What it does |
|---|---|---|
| `process_qiime_run()` | [Creating a Phyloseq](pipeline.md) | Reads the pipeline's read-tracking CSV and plots per-sample read retention across processing steps, for quality control |
| `join_table_seqs()` | [Creating a Phyloseq](pipeline.md) | Reads the denoised QIIME2 feature table and representative sequences, replaces hash identifiers with actual sequences, and transposes to samples × ASVs |
| `plot_asv_length_hist()` | [Creating a Phyloseq](pipeline.md) | Plots a histogram of ASV read lengths against the marker's expected length range, for quality control |
| `assignment_trnL()` | [Creating a Phyloseq](pipeline.md) | Assigns trnL taxonomy via exact sequence matching against a reference FASTA |
| `assignment_12S()` | [Creating a Phyloseq](pipeline.md) | Assigns 12Sv5 taxonomy via a naive Bayesian classifier |
| `qc_controls()` | [Creating a Phyloseq](pipeline.md) | Runs standard quality control checks on positive/negative controls in a phyloseq |
| `assign_common_names()` | [Assigning Common Names](commonnames.md#assign_common_names-function) | Assigns conventional common food names to ASVs from a common names CSV |
| `lowest_level()` | [Filtering Taxa](taxafiltering.md) | Adds a `lowest_level` column giving each ASV's most specific non-`NA` taxonomic rank |
| `plan_harmonization()` | [Agglomerating Taxa](glomming.md#plan_harmonization) | Detects likely-redundant trnL ASVs within or across sequencing batches and builds a review plan |
| `apply_harmonization()` | [Agglomerating Taxa](glomming.md#apply_harmonization) | Applies a harmonization plan's merge/rename decisions to a phyloseq |
| `pca_plot()` | [Creating a PCA Plot](pca.md#pca_plot-function) | Fits a PCA on a phyloseq and returns a ready-to-plot biplot |
| `plan_projection()` | [PCA Projection](projection.md#plan_projection) | Detects correspondences between a new phyloseq's ASVs and a harmonized reference's ASV space |
| `apply_projection()` | [PCA Projection](projection.md#apply_projection) | Builds a phyloseq projected into a reference's exact ASV space |
| `project_pca()` | [PCA Projection](projection.md#project_pca) | Projects new data into an existing PCA's fixed coordinate space |

!!! note "Other lab packages"

    [`MButils`](https://github.com/ammararuby/MButils), made by past lab members, is still referenced in a few places (e.g. the archived [legacy reference-building workflow](references-legacy.md)) — see [Setting Up](settingup.md#common-commands-and-packages) for installing it if you need it. Most of its functionality that's still in active use has since been ported into `foodseq.tools`, including `lowest_level()`.
