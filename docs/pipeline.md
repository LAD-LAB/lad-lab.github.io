# Creating a Phyloseq (trnL and 12Sv5)

These instructions will help you create a phyloseq object from raw sequencing data using `Pipeline-to-Phyloseq.Rmd` and the `foodseq.tools` R package. The pipeline handles both trnL and 12Sv5 markers simultaneously from a single multiplex sequencing run; if your run only contains one marker, it will process whichever is present and skip the other. A [flowchart](/pipeline.html#flowchart) is provided at the bottom of the page if it may help simplify the workflow.

## In the Terminal

=== "Duke"

    ### Clone Repository to DCC

    First, clone the mb-pipelines repository from GitHub to the DCC to use `demux-barcodes.sh` and either `trnL-pipeline.sh` or `12SV5-pipeline.sh` in future steps. This step only needs to be done once; once you have the files on the DCC, you can skip this section.

    The scripts can be downloaded either to the group directory under your folder or to your home directory with the following shell code. If you are prompted for a password, follow [these instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) to set up a personal access token.

    ``` sh
    # Log into the DCC:
    ssh [NetID]@dcc-login.oit.duke.edu

    # Navigate to where you want to clone the repository:
    cd /hpc/group/ldavidlab/users/[NetID]

    # Clone the respository:
    git clone https://github.com/LAD-LAB/mb-pipeline.git
    [GitHub username]
    [personal access token]
    ```

    ### Upload Sequencing Data to DCC

    Now, copy the sequencing data folder from Isilon to the DCC and upload a samplesheet containing the barcodes used during sequencing. In contrast to the above, these steps will need to be run every time.

    To copy the sequencing data folder from Isilon, first create a DCC folder for your project. Then, make sure you are connected to Isilon and run the following:

    ``` sh
    # Navigate to the sequencing folder on Isilon; change 2025 to the year of the sequencing run:
    cd /Volumes/All_Staff/Sequencing/Sequencing2025/

    # Copy sequencing data from Isilon to the DCC project folder:
    scp -r [sequencing data] [NetID]@dcc-login.oit.duke.edu:/hpc/group/ldavidlab/users/[NetID]/[path/to/project/folder]
    ```

    where `[sequencing data]` is in the form `XXXXXX_MNXXXXX_XXXX_XXXXXXXXXX`.

    To this project folder, also upload a samplesheet. A template is available on GitHub and should have been copied to your DCC folder; some lab members remove unnecessary barcodes by deleting their rows, while others recommend using the full template and pruning samples in the phyloseq itself later on. You may develop a preference yourself.

    ``` sh
    scp [/path/to/samplesheet.csv] [NetID]@dcc-login.oit.duke.edu:[/path/to/project/folder]
    ```

    You should now have the sequencing data and a samplesheet CSV in your project folder on the DCC.

    ### Demultiplex and Pipeline

    Now, run the `demux-barcodes.sh` script with the following:

    ``` sh
    # Log into the DCC:
    ssh [NetID]@dcc-login.oit.duke.edu

    # Submit a batch job to run demux-barcodes.sh:
    sbatch --mail-user=[NetID]@duke.edu [/path/to/demux-barcodes.sh] [/path/to/XXXXXX_MNXXXXX_XXXX_XXXXXXXXXX] [/path/to/samplesheet.csv] /hpc/group/ldavidlab/metabarcoding.sif
    ```

    Next, run the `trnL-pipeline.sh` or `12SV5-pipeline.sh` script, depending on the run:

    ``` sh
    # Submit a batch job to run trnL-pipeline.sh or 12SV5-pipeline.sh:
    sbatch --mail-user=[NetID]@duke.edu [/path/to/pipeline.sh] [/path/to/XXXXXXXX_results/demultiplexed] /hpc/group/ldavidlab/qiime2.sif
    ```

    Once this finishes, your file structure should look like

    ```
    └─[/DCC/path/to/]
      ├─ XXXXXX_MNXXXXX_XXXX_XXXXXXXXXX
      └─ XXXXXXXX_results
         ├─ XXXXXXXX_trnL_output or XXXXXXXX_12SV5_output
         ├─ demultiplexed
         │  └─ [demultiplexed .fastq.gz files]
         └─ Reports
            ├─ demux-barcodes-[jobid].err
            └─ demux-barcodes-[jobid].out
    ```

    If everything looks good, you can proceed to RStudio to run `Pipeline-to-Phyloseq.Rmd`.

=== "General"

    ### Clone Repository to HPC

    First, clone the mb-pipelines repository from GitHub to your computing cluster to use `demux-barcodes.sh` and either `trnL-pipeline.sh` or `12SV5-pipeline.sh` in future steps. This step only needs to be done once; once you have the files on the cluster, you can skip this section.

    The scripts can be downloaded to your directory with the following shell code. If you are prompted for a password, follow [these instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) to set up a personal access token.

    ``` sh
    # Log into your cluster:
    ssh [username]@[hpc-hostname]

    # Navigate to where you want to clone the repository:
    cd [/hpc/path/to/lab/directory]/users/[username]

    # Clone the respository:
    git clone https://github.com/LAD-LAB/mb-pipeline.git
    [GitHub username]
    [personal access token]
    ```

    ### Upload Sequencing Data to HPC

    Now, copy the sequencing data folder from your shared storage to the cluster and upload a samplesheet containing the barcodes used during sequencing. In contrast to the above, these steps will need to be run every time.

    First, create a cluster folder for your project. Then, make sure you are connected to your shared storage and run the following:

    ``` sh
    # Navigate to the sequencing folder on your shared storage:
    cd [/path/to/shared/storage/Sequencing/]

    # Copy sequencing data to the cluster project folder:
    scp -r [sequencing data] [username]@[hpc-hostname]:[/hpc/path/to/lab/directory]/users/[username]/[path/to/project/folder]
    ```

    where `[sequencing data]` is in the form `XXXXXX_MNXXXXX_XXXX_XXXXXXXXXX`.

    To this project folder, also upload a samplesheet. A template is available on GitHub and should have been copied to your cluster folder; some lab members remove unnecessary barcodes by deleting their rows, while others recommend using the full template and pruning samples in the phyloseq itself later on. You may develop a preference yourself.

    ``` sh
    scp [/path/to/samplesheet.csv] [username]@[hpc-hostname]:[/path/to/project/folder]
    ```

    You should now have the sequencing data and a samplesheet CSV in your project folder on the cluster.

    ### Demultiplex and Pipeline

    Now, run the `demux-barcodes.sh` script with the following:

    ``` sh
    # Log into your cluster:
    ssh [username]@[hpc-hostname]

    # Submit a batch job to run demux-barcodes.sh:
    sbatch --mail-user=[username]@[your-email] [/path/to/demux-barcodes.sh] [/path/to/XXXXXX_MNXXXXX_XXXX_XXXXXXXXXX] [/path/to/samplesheet.csv] [/path/to/metabarcoding.sif]
    ```

    Next, run the `trnL-pipeline.sh` or `12SV5-pipeline.sh` script, depending on the run:

    ``` sh
    # Submit a batch job to run trnL-pipeline.sh or 12SV5-pipeline.sh:
    sbatch --mail-user=[username]@[your-email] [/path/to/pipeline.sh] [/path/to/XXXXXXXX_results/demultiplexed] [/path/to/qiime2.sif]
    ```

    Once this finishes, your file structure should look like

    ```
    └─[/hpc/path/to/]
      ├─ XXXXXX_MNXXXXX_XXXX_XXXXXXXXXX
      └─ XXXXXXXX_results
         ├─ XXXXXXXX_trnL_output or XXXXXXXX_12SV5_output
         ├─ demultiplexed
         │  └─ [demultiplexed .fastq.gz files]
         └─ Reports
            ├─ demux-barcodes-[jobid].err
            └─ demux-barcodes-[jobid].out
    ```

    If everything looks good, you can proceed to RStudio to run `Pipeline-to-Phyloseq.Rmd`.

## In R

### Installing and Loading Packages

Create a project folder and download or duplicate a copy of `Pipeline-to-Phyloseq.Rmd` to it. You can download it directly from GitHub or through the following code:

=== "Duke"

    ``` sh
    # Navigate to your Box project folder:
    cd [/Box/path/to/project/folder]

    # Download Pipeline-to-Phyloseq.Rmd from GitHub:
    wget https://raw.githubusercontent.com/LAD-LAB/mb-pipeline/main/pipeline/Pipeline-to-phyloseq.Rmd
    ```

=== "General"

    ``` sh
    # Navigate to your project folder:
    cd [/path/to/project/folder]

    # Download Pipeline-to-Phyloseq.Rmd from GitHub:
    wget https://raw.githubusercontent.com/LAD-LAB/mb-pipeline/main/pipeline/Pipeline-to-phyloseq.Rmd
    ```

??? bug "Troubleshooting"

    If you are using a Mac and are getting the error `zsh: command not found: #` due to the comments in this example code, you can update your .zshrc file to allow for bash-style comments. To do so, first open your .zshrc file by going to your Mac's Home directory and pressing  <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>.</kbd>  to display hidden folders and files, including your .zshrc file.

    With the file open, scroll to the bottom and paste `setopt interactivecomments`. Save your .zshrc file and comments should now not trigger errors in Terminal.

Now we will walk through `Pipeline-to-Phyloseq.Rmd`. First, install the `foodseq.tools` package from GitHub if you do not already have it. This package provides all of the helper functions used throughout the pipeline, including `process_qiime_run()`, `assignment_trnL()`, `assignment_12S()`, `qc_controls()`, and `plot_asv_length_hist()`.

``` r
# install.packages("devtools")
devtools::install_github("Ashish-Subramanian/foodseq.tools")
```

Next, load the necessary packages. If you do not have a package installed, install it first with the function `install.packages("[package name]")`.

``` r
library(dada2)
library(foodseq.tools)
library(qiime2R)
library(phyloseq)
library(showtext)
library(sysfonts)
library(tidyverse)
```

The pipeline also sets up a custom font for all plots. The following chunk loads Source Sans 3 from Google Fonts and applies it as the default `ggplot2` theme; if the font cannot be loaded, it falls back to the default `theme_bw()`. You can replace `"Source Sans 3"` with any Google Font, or delete this chunk entirely to use defaults.

``` r
plot_font <- tryCatch({
  font_add_google("Source Sans 3", "Source Sans 3")
  "Source Sans 3"
}, error = function(e) {
  tryCatch({
    font_add_google("Source Sans Pro", "Source Sans Pro")
    "Source Sans Pro"
  }, error = function(e2) {
    message("Could not load Source Sans from Google Fonts; using default font.")
    ""
  })
})
showtext_auto(TRUE)
showtext_opts(dpi = 300)
if (nzchar(plot_font)) theme_set(theme_bw(base_family = plot_font)) else theme_set(theme_bw())
```

### Setting User Inputs

The pipeline is designed so that all user-specific configuration is set in a single chunk. By default, the code creates and expects a file structure resembling the following:

```
└── /path/to/project/folder
    └── Project1
        ├── sample-metadata.csv
        ├── 12SV5
        │   ├── pipeline output
        │   ├── phyloseq objects
        │   ├── quality control plots and graphs
        │   └── tables, etc.
        └── trnL
            ├── pipeline output
            ├── phyloseq objects
            ├── quality control plots and graphs
            └── tables, etc.
```

Set the following variables to match your setup. The `project_path` should be the local folder where your trnL and 12S subfolders will be saved; its name is also used as the project name for titling plots:

=== "Duke"

    ``` r
    username <- "[NetID]"
    hpc_host <- "dcc-login.oit.duke.edu"
    hpc_results_path <- "/hpc/group/ldavidlab/users/[NetID]/Projects/[Project]/[YYYYMMDD]_results"
    project_path <- "/Users/[NetID]/Library/CloudStorage/Box-Box/project_davidlab/LAD_LAB_Personnel/[FirstL]/Projects/[Project]"
    metadata <- "sample-metadata.csv"
    download_mode <- "minimal"
    ```

=== "General"

    ``` r
    username <- "[username]"
    hpc_host <- "[hpc-hostname]"
    hpc_results_path <- "[/hpc/path/to/project/YYYYMMDD_results]"
    project_path <- "[/path/to/local/project/folder]"
    metadata <- "sample-metadata.csv"
    download_mode <- "minimal"
    ```

The `download_mode` variable controls how much data is copied from the cluster. Set it to `"minimal"` (the default) to download only the files needed for phyloseq creation (`4_denoised-table.qza`, `4_denoised-seqs.qza`, and the read-tracking CSV), or `"full"` to download all pipeline output.

You also need to set paths to the trnL and 12Sv5 reference FASTAs used for taxonomy assignment. These references can be downloaded from the [LAD-LAB mb-pipeline GitHub repository](https://github.com/LAD-LAB/mb-pipeline); place them locally and set the paths here:

``` r
ref_trnL <- "[/path/to/trnLGH_taxonomy.fasta]"
ref_12S <- "[/path/to/12Sv5_taxonomy.fasta]"
```

For instructions on creating these references from scratch, see [Creating the References](references.md).

`sample-metadata.csv` should be a CSV in your project folder with a column `Sample_ID` whose entries match the sample names from `samplesheet.csv` (in the form `1-A01`); a column `type` whose values are exactly `"sample"`, `"positive control"`, `"negative control"`, or `"blank"`; and a column `pcr_plate` whose value is the plate number from the sequencing run. If you save your metadata with the file name `sample-metadata.csv`, no changes are needed to the `metadata` variable.

If you keep a personal template of this file, only `hpc_results_path`, `project_path`, `ref_trnL`, and `ref_12S` should need changing from run to run. From this point onward, you should not need to rename anything or change any paths. If you do want to rename variables like `ps.trnL` or `qiime.dir.12S`, be aware that the `foodseq.tools` functions expect these specific names in the calling environment, so breaking the naming conventions will trigger errors.

Before running the code, make sure:

- You have set `username`, `hpc_host`, `hpc_results_path`, `project_path`, `ref_trnL`, `ref_12S`, and (optionally) `metadata`
- Your output folder is empty of potentially conflicting files from a previous run
- If you have a metadata file, it has the required `Sample_ID`, `type`, and `pcr_plate` columns with correctly formatted values

### Building Paths

The following chunk derives `project` (used for titling plots) and `metadata_path` from the variables you set above. If your project folder is not named for your project, or if your metadata is stored in a different location, update them here:

``` r
project <- basename(project_path)
metadata_path <- file.path(project_path, metadata)
```

### Downloading Data from the Cluster

The pipeline downloads results from the cluster using `rsync` over SSH. The following chunk first sets the necessary environment variables so they are accessible from the embedded bash chunk that follows:

``` r
Sys.setenv(
  USERNAME = username,
  HPC_HOST = hpc_host,
  HPC_PATH = hpc_results_path,
  PROJECT_PATH = project_path,
  DL_MODE  = download_mode
)
```

The bash chunk copies the pipeline output from the cluster into a temporary staging directory in your home folder, then sorts the run folders by marker (trnL vs. 12Sv5) and moves them into the appropriate subfolders in your project directory. The staging step works around a file-naming conflict that can occur with cloud storage providers like Box; if you are not using cloud storage, it is harmless.

``` sh
set -euo pipefail

tmp="$HOME/tmp_hpc_stage"
rm -rf "$tmp"/202*_output || true
mkdir -p "$tmp" "$PROJECT_PATH"

if [ "${DL_MODE:-minimal}" = "full" ]; then
  rsync -a \
    "$USERNAME@$HPC_HOST:$HPC_PATH"/202*_output \
    "$tmp"/ > /dev/null
else
  rsync -a --prune-empty-dirs \
    --include='*/' \
    --include='202*_output/4_denoised-table.qza' \
    --include='202*_output/4_denoised-seqs.qza' \
    --include='202*_output/*track-pipeline*.csv' \
    --exclude='*' \
    "$USERNAME@$HPC_HOST:$HPC_PATH"/ \
    "$tmp"/ > /dev/null
fi

for run in "$tmp"/202*_output; do
  [ -d "$run" ] || continue
  base=$(basename "$run")

  if echo "$base" | grep -q '_trnL_output$'; then
    dest="$PROJECT_PATH/trnL"
  elif echo "$base" | grep -q '_12SV5_output$'; then
    dest="$PROJECT_PATH/12S"
  else
    echo "Skipping unknown run folder: $base"
    continue
  fi
  mkdir -p "$dest"

  req1="$run/4_denoised-table.qza"
  req2="$run/4_denoised-seqs.qza"
  if [ ! -f "$req1" ] || [ ! -f "$req2" ]; then
    echo "ERROR: Missing required QZA(s) in $base; not moving this run." >&2
    continue
  fi

  rsync -a "$run"/ "$dest"/ > /dev/null
done

rm -rf "$tmp"
```

In minimal mode, the script only downloads `4_denoised-table.qza`, `4_denoised-seqs.qza`, and the read-tracking CSV for each run — the three files needed for phyloseq creation. It also validates that both QZA files exist before moving a run folder; if either is missing, it skips that run and prints an error.

??? bug "Troubleshooting"

    If the download fails with a `Permission denied (publickey)` error, make sure you have SSH key authentication set up between your local machine and the cluster. See [Setting Up](settingup.md) for instructions on generating and registering SSH keys.

    If the download succeeds but no files appear in your project folder, check that the `hpc_results_path` is correct and that it contains folders matching the `202*_output` pattern (e.g., `20250115_trnL_output`). The script only moves folders whose names end in `_trnL_output` or `_12SV5_output`.

### Extracting Read Counts

Next, set the output directories and count the reads at each pipeline step for quality control. The `process_qiime_run()` function from `foodseq.tools` reads the tracking CSV, assembles a table of per-sample read counts at each processing step, and generates a line plot showing how reads are retained through the pipeline.

``` r
qiime.dir.trnL <- file.path(project_path, "trnL")
qiime.dir.12S  <- file.path(project_path, "12S")
```

``` r
if(dir.exists(qiime.dir.trnL)) {
  read_counts_trnL <- process_qiime_run("trnL")
  print(read_counts_trnL$plot + theme_get())
}

if(dir.exists(qiime.dir.12S)) {
  read_counts_12S <- process_qiime_run("12S")
  print(read_counts_12S$plot + theme_get())
}
```

The output plot shows read counts across pipeline steps (raw, adapter trim, primer trim, filtered, denoised, merged, non-chimeric) for each sample. A steep drop at any step may indicate a quality issue worth investigating before continuing.

??? bug "Troubleshooting"

    If `process_qiime_run()` fails, delete any newly created files in `qiime.dir.trnL` and `qiime.dir.12S` before re-running. The function expects to find the raw pipeline output files and may conflict with partially written results from a previous attempt.

### Data Preparation

Now we create ASV tables from the QIIME2 output. The `join_table_seqs()` function reads in the denoised feature table and representative sequences, replaces hash identifiers with actual DNA sequences, and transposes the table so that rows are samples and columns are ASVs. Then, `dada2::collapseNoMismatch()` merges any ASVs that are perfect subsequences of one another:

``` r
if(dir.exists(qiime.dir.trnL)) {
  qiime.asvtab.trnL <- dada2::collapseNoMismatch(
    join_table_seqs(
      read_qza(file.path(qiime.dir.trnL, '4_denoised-table.qza')),
      read_qza(file.path(qiime.dir.trnL, '4_denoised-seqs.qza'))
    )
  )
}

if(dir.exists(qiime.dir.12S)) {
  qiime.asvtab.12S <- dada2::collapseNoMismatch(
    join_table_seqs(
      read_qza(file.path(qiime.dir.12S, '4_denoised-table.qza')),
      read_qza(file.path(qiime.dir.12S, '4_denoised-seqs.qza'))
    )
  )
}
```

### ASV Length Histograms

For quality control, plot a histogram of ASV read lengths with the `plot_asv_length_hist()` function. The histograms include dashed red lines at the expected length range for the marker, which helps identify any unusually short or long sequences that may warrant further inspection.

``` r
if(dir.exists(qiime.dir.trnL)) {
  length_histograms_trnL <- plot_asv_length_hist("trnL")
  print(length_histograms_trnL$plot + theme_get())
}

if(dir.exists(qiime.dir.12S)) {
  length_histograms_12S <- plot_asv_length_hist("12S")
  print(length_histograms_12S$plot + theme_get())
}
```

### Creating the Taxonomy Table

The `assignment_trnL()` and `assignment_12S()` functions handle taxonomy assignment from start to finish. For trnL, the function performs exact sequence matching against the reference FASTA and uses `taxonomizr::condenseTaxa()` to resolve each ASV to its last common ancestor when multiple species match. For 12Sv5, it uses a naive Bayesian classifier (adapted from `dada2::assignTaxonomy()`) to assign taxonomy at each rank down to subspecies, then similarly condenses multi-match ASVs. Both functions clean up subspecific ranks (subspecies, varietas, forma) before condensing, so that disagreements at those ranks do not inflate the ASV to a higher taxonomic level unnecessarily.

``` r
if(dir.exists(qiime.dir.trnL)) {
  assignments.trnL <- assignment_trnL(ref_fasta = ref_trnL)$assignments
}

if(dir.exists(qiime.dir.12S)) {
  assignments.12S <- assignment_12S(ref_fasta = ref_12S)$assignments
}
```

Both functions print a summary of assignment rates to the console — the percentage of ASVs assigned and the percentage of reads those assigned ASVs cover, followed by a per-rank breakdown. They also save a CSV of unassigned ASVs (with read counts and the number of samples each appears in) to the output directory for later review.

??? bug "Troubleshooting"

    If taxonomy assignment is slow, this is expected for large datasets; trnL assignment in particular performs exact substring matching across all ASVs and reference sequences, which scales with the size of both. For a typical sequencing run, assignment should complete within a few minutes.

    If a large proportion of ASVs are unassigned, check that `ref_trnL` or `ref_12S` points to the correct reference FASTA. An outdated or mismatched reference is the most common cause. The NAs CSV saved to the output directory can help you investigate which sequences went unassigned.

### Creating the Raw Phyloseq

With the ASV table and taxonomy table ready, we now assemble them into phyloseq objects. These raw phyloseqs contain an `otu_table` (the ASV count matrix) and a `tax_table` (the taxonomy assignments) but no sample metadata yet:

``` r
if(dir.exists(qiime.dir.trnL)) {
  ps.trnL <-
    phyloseq(otu_table = otu_table(qiime.asvtab.trnL,
                                   taxa_are_rows = FALSE),
             tax_table = tax_table(assignments.trnL))

  saveRDS(ps.trnL, file.path(qiime.dir.trnL, "raw-ps-trnL.rds"))
}

if(dir.exists(qiime.dir.12S)) {
  ps.12S <-
    phyloseq(otu_table = otu_table(qiime.asvtab.12S,
                                   taxa_are_rows = FALSE),
             tax_table = tax_table(assignments.12S))

  saveRDS(ps.12S, file.path(qiime.dir.12S, "raw-ps-12S.rds"))
}
```

??? bug "Troubleshooting"

    If you get an error creating the phyloseq object, make sure that `qiime.asvtab.trnL` (or `qiime.asvtab.12S`) is a matrix where rows are samples and columns are ASVs, and that `assignments.trnL` (or `assignments.12S`) is a character matrix where rows are ASVs matching the columns of the ASV table. You can verify this with:

    ``` r
    str(qiime.asvtab.trnL)
    str(assignments.trnL)
    identical(colnames(qiime.asvtab.trnL), rownames(assignments.trnL))
    ```

    The `identical()` call should return `TRUE`. If either object is a dataframe rather than a matrix, convert it with `as.matrix()`.

### Adding Metadata

Next, we add sample metadata to the phyloseqs. The following code reads in `sample-metadata.csv`, validates that it has the required columns and correctly formatted values, and attaches it as the `sam_data` component of each phyloseq. The validation checks three things: that `Sample_ID`, `type`, and `pcr_plate` columns exist; that the values in `type` are exactly `"sample"`, `"positive control"`, `"negative control"`, or `"blank"`; and that `Sample_ID` entries follow the `1-A01` format.

``` r
if (file.exists(metadata_path)) {
  samdf <- read.csv(metadata_path)

  required_cols <- c("Sample_ID", "type", "pcr_plate")
  if (!all(required_cols %in% names(samdf))) {
    stop("Missing columns: ", paste(setdiff(required_cols, names(samdf)), collapse = ", "))
  }

  incorrect_types <- setdiff(unique(samdf$type),
                             c("positive control", "negative control", "blank", "sample"))
  if (length(incorrect_types) > 0) {
    stop("Column 'type' has disallowed values: ", paste(incorrect_types, collapse = ", "))
  }

  incorrect_samples <- samdf$Sample_ID[!grepl("^[0-9]-[A-H][0-9]{2}$", samdf$Sample_ID)]
  if (length(incorrect_samples) > 0) {
    stop("Column 'Sample_ID' has disallowed values: ", paste(incorrect_samples, collapse = ","))
  }

  row.names(samdf) <- samdf$Sample_ID

  if(dir.exists(qiime.dir.trnL)) {
    sample_data(ps.trnL) <- samdf
    saveRDS(ps.trnL, file.path(qiime.dir.trnL, "ps-wMetadata-trnL.rds"))
  }

  if(dir.exists(qiime.dir.12S)) {
    sample_data(ps.12S) <- samdf
    saveRDS(ps.12S, file.path(qiime.dir.12S, "ps-wMetadata-12S.rds"))
  }
}
```

If you do not yet have a metadata file, the code will skip this step and the phyloseqs will be saved without sample data. You can always add metadata later by reading in the CSV and assigning it with `sample_data(ps) <- samdf`.

??? bug "Troubleshooting"

    If the `Sample_ID` validation fails, check that your sample IDs follow the `[plate]-[well]` format (e.g., `1-A01`, `2-H12`). The plate number should be a single digit and the well should be a letter A through H followed by a two-digit number. If your sample IDs use a different format, you can modify the regex pattern in the validation check.

    If the `type` validation fails, check for typos or inconsistent capitalization in the `type` column. The values must be exactly `"sample"`, `"positive control"`, `"negative control"`, or `"blank"` — any variation (e.g., `"Sample"`, `"pos control"`, `"Positive Control"`) will trigger the error.

### Quality Control

The final step runs a set of standard quality control checks using the `qc_controls()` function. This function examines the controls in your phyloseq (all samples not labelled `"sample"` in the `type` column) and generates three types of output: a bar plot of species detected in each control, a plot showing non-control samples where positive control species were detected, and plate maps marking the well locations of controls and any samples with positive control contamination.

First, set the positive control species for each marker. These should match the species used in your lab's positive controls:

``` r
# Update these to match your positive control species:
control.trnL <- c("Ilex paraguariensis", "Trifolium pratense", "synthetic trnL ASV")
control.12S <- c("Dromaius novaehollandiae", "Correlophus ciliatus",
                 "Rhacodactylus leachianus", "synthetic 12S ASV")
```

Now run the quality control checks. The `qc_controls()` function requires that the phyloseq has sample metadata attached (i.e., the metadata step above must have completed successfully):

``` r
if(!is.null(sample_data(ps.trnL, errorIfNULL = FALSE))) {
  qc.trnL <- qc_controls("trnL")
  if (!is.null(qc.trnL$p.controls)) print(qc.trnL$p.controls + theme_get())
  if (!is.null(qc.trnL$p.samples))  print(qc.trnL$p.samples + theme_get())
  if (length(qc.trnL$p.plates) > 0) {
    invisible(lapply(qc.trnL$p.plates, function(p) {
      print(p + theme_get() + theme(panel.grid = element_blank()))
    }))
  }
}
```

``` r
if(!is.null(sample_data(ps.12S, errorIfNULL = FALSE))) {
  qc.12S <- qc_controls("12S")
  if (!is.null(qc.12S$p.controls)) print(qc.12S$p.controls + theme_get())
  if (!is.null(qc.12S$p.samples))  print(qc.12S$p.samples + theme_get())
  if (length(qc.12S$p.plates) > 0) {
    invisible(lapply(qc.12S$p.plates, function(p) {
      print(p + theme_get() + theme(panel.grid = element_blank()))
    }))
  }
}
```

If everything looks good, you have successfully created trnL and 12S phyloseqs. The finished phyloseq objects should be saved to your project folder for further analysis; see [Overview](processing.md) for the next steps in post-phyloseq processing.

***

## Flowchart

``` mermaid
graph TD
  A[sequencing data] -->|cluster pipeline| B[demultiplexed data];
  B -->|process_qiime_run| C[read count QC];
  B -->|join_table_seqs + collapseNoMismatch| D[ASV table];
  D -->|plot_asv_length_hist| E[length histogram QC];
  D -->|assignment_trnL / assignment_12S| F[taxonomy table];
  G[reference FASTA] --> F;
  D --> H[otu_table];
  F --> I[tax_table];
  H --> J[raw phyloseq];
  I --> J;
  K[sample-metadata.csv] --> L[sam_data];
  J --> M[final phyloseq];
  L --> M;
  M -->|qc_controls| N[quality control];
```
