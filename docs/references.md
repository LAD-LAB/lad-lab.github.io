# Creating the References

The trnL (g/h) and 12Sv5 reference databases are built with `foodseq_reference_pipeline.Rmd` in the [food-dbs repository](https://github.com/LAD-LAB/food-dbs). It builds these reference databases end to end — downloading and querying sequence data, assigning taxonomy, filtering out off-target hits, adding controls, and writing DADA2- and QIIME2-formatted output — and is now the standard way to (re)build the references, replacing the older step-by-step manual workflow.

!!! info "Manual workflow archived"

    The original per-step R walkthrough that this pipeline automates has been archived to [Creating the References (Legacy Manual Workflow)](references-legacy.md). It's kept for understanding what a given pipeline step is actually doing, or for one-off manual intervention — not as an alternative way to build a production reference.

## Overview

The pipeline builds two databases, sharing the same setup, SLURM jobs, and taxonomy approach:

| Database | Marker | Primers | Source |
|---|---|---|---|
| **Part A** — trnL g/h | Plant | trnLg `GGGCAATCCTGAGCCAA` / trnLh `CCATTGAGTCTCTGCACCTATC` | RefSeq plastid genomes + GenBank |
| **Part B** — 12Sv5 | Vertebrate | V5F `TAGAACAGGCTCCTCTAG` / V5R `TTAGATACCCCACTATGC` | RefSeq mitochondrial genomes + GenBank |

Both markers pull their target species from `human-foods.csv`: trnL takes every row where `category == "plant"`, 12Sv5 every row where `category == "animal"`. As of the Aug 2026 build, that list covers 3,806 food species (1,573 plants + 7 genus-level entries, 2,121 animals + 70 genus-level entries, plus fungi and bacteria); trnL sits at 69% species coverage and 12Sv5 at 46%. See the [food-dbs README](https://github.com/LAD-LAB/food-dbs#database-coverage) for current coverage figures and a breakdown of remaining gaps — those numbers move with every rebuild, so treat anything quoted here as a snapshot rather than the current state.

## Extend vs. Rebuild

Two ways to grow a reference: extend it with a handful of new species from your laptop, or trigger a full cluster rebuild. Pick based on what actually needs to change:

**Extend** (`code/Extend reference.Rmd`) — when new sequence has appeared at NCBI for species already on `human-foods.csv`, or you're adding species that were never targeted before, and nothing about an *existing* record needs to change. Runs on a laptop in minutes: no cluster, no SLURM, no large downloads, since it queries NCBI directly for both sequence and taxonomy over e-utils.

**Rebuild** (`foodseq_reference_pipeline.Rmd`) — needed for anything Extend can't do: taxonomy or curation fixes to existing records, off-target filter or dedup logic changes, or a species whose only NCBI record is a complete genome (Extend applies the same 50 kb length cap as the full pipeline). Also needed for periodic full refreshes that pick up whatever new sequence has accumulated at NCBI more broadly since the last build.

## Extending an Existing Reference

Clone the repository if you haven't already:

``` bash
git clone https://github.com/LAD-LAB/food-dbs.git
```

Then, the usual order:

1. **Find candidates** — run `code/Coverage recheck.Rmd` top to bottom. It checks species on `human-foods.csv` missing from the current build against NCBI (resolving each to its current NCBI-accepted synonym first) and writes `data/outputs/coverage-recheck/CANDIDATES_*.csv`.
2. **Pull sequence** — in `code/Extend reference.Rmd`, point `ADDITIONS` at a `CANDIDATES_*.csv` (or any CSV with a `scientific_name` column, e.g. `data/inputs/reference-additions.csv`), set `MARKER`, `IN_SUFFIX`, and `OUT_SUFFIX`, and run top to bottom. It never overwrites the reference it's extending — it always writes a new, separately-suffixed file pair.
3. **Verify** — run the QC gate against the new suffix, restricted to the marker you touched:

    ``` bash
    Rscript code/qc_reference_build.R . _Aug2026_ext _Aug2026 trnL
    ```

4. **Promote** — if the gate passes, rename the `OUT_SUFFIX` files to the new canonical suffix (e.g. `_Aug2026_ext` → `_Sep2026`).

## Rebuild

Building a reference from scratch — or picking up whatever new sequence has accumulated at NCBI more broadly — uses `foodseq_reference_pipeline.Rmd` on a cluster with SLURM. It builds trnL g/h and 12Sv5 together (see [What Each Part Builds](#what-each-part-builds) below).

1. Clone the repository:

    ``` bash
    git clone https://github.com/LAD-LAB/food-dbs.git
    ```

2. Open `foodseq_reference_pipeline.Rmd` in RStudio (or RStudio Server on Open OnDemand).

3. Update the **Configuration** chunk near the top to match your environment — everything else in the notebook reads from this one chunk:

    ``` r
    # ── Cluster paths ────────────────────────────────────────────
    SCRATCH      <- "/scratch/your_username"                  # cluster scratch directory
    REPO_DIR     <- "/path/to/food-dbs"                       # cloned repo root
    PLASTID_DIR  <- file.path(SCRATCH, "plastid_refseq")      # RefSeq plastid download
    MITO_DIR     <- file.path(SCRATCH, "mito_refseq")         # RefSeq mitochondrial download
    SQL_PATH     <- file.path(SCRATCH, "accessionTaxa.sql")   # taxonomizr SQL database

    # ── SLURM parameters ─────────────────────────────────────────
    PARTITION    <- "general"    # partition/queue name; check with 'sinfo'
    R_MODULE     <- "R/4.3.0"    # R module name; check with 'module avail R'

    # ── QC gate ───────────────────────────────────────────────────
    QC_PREVIOUS_SUFFIX <- "-"    # suffix of the last archived build, e.g. "_Aug2026"
    ```

    `QC_PREVIOUS_SUFFIX` matters: the pipeline always writes date-less output files, so it has no memory of what the previous build was called — this is the only way the final QC gate finds out what to compare against. Leaving it at `"-"` is safe, not silent: the gate refuses to compare a build against itself and stops immediately rather than comparing against the wrong build.

    !!! tip

        If your lab already maintains a shared `accessionTaxa.sql` build, point `SQL_PATH` at it instead of rebuilding — this skips a ~70 GB download/build.

        === "Duke"

            ``` r
            SQL_PATH <- "/Volumes/All_Staff/personal_backups/ashish/ncbi_taxonomy/accessionTaxa.sql"
            ```

        === "General"

            ``` r
            SQL_PATH <- "[/path/to/accessionTaxa.sql]"
            ```

4. Install the required packages and set an NCBI API key. Run the **Install packages** chunk once, on first use:

    ``` r
    # Bioconductor
    BiocManager::install(c("Biostrings", "ShortRead", "pwalign"))

    # CRAN
    install.packages(c("taxonomizr", "tidyverse", "rentrez", "remotes"))

    # GitHub
    remotes::install_github("ammararuby/MButils")
    ```

    `pwalign` holds `pairwiseAlignment()` on Bioconductor ≥ 3.19; on older Bioconductor installations this function ships inside `Biostrings` instead and the install line above simply skips it.

    Set an NCBI API key to raise the e-utils rate limit from 3 to 10 requests per second — create an NCBI account, go to [Account Settings → API Key Management](https://account.ncbi.nlm.nih.gov/settings/), and run:

    ``` r
    rentrez::set_entrez_key("your_key_here")
    ```

    NCBI also recommends running large queries on weekends or between 9 PM and 5 AM EST on weekdays.

5. Submit the three SLURM jobs (sections 2a–2c) and monitor them in the following section. They run in parallel and each take several hours — together they fetch the large files the pipeline needs before it can run:

    | File | Size | Source |
    |---|---|---|
    | RefSeq plastid FASTA | ~15–20 GB uncompressed | `ftp://ftp.ncbi.nlm.nih.gov/refseq/release/plastid/` |
    | RefSeq mitochondrial FASTA | ~5–10 GB uncompressed | `ftp://ftp.ncbi.nlm.nih.gov/refseq/release/mitochondrion/` |
    | `accessionTaxa.sql` | ~70 GB | Built with `taxonomizr::prepareDatabase()` |

6. Once the jobs finish, run **Part A** (trnL g/h) and/or **Part B** (12Sv5), as needed.
7. The notebook's final section, **Verify before shipping**, runs the QC gate automatically — see [Verifying a Build](#verifying-a-build-the-qc-gate) below.

Output files are written date-less (`trnLGH_taxonomy.fasta`, not `trnLGH_taxonomy_Aug2026.fasta`). Once the QC gate passes, archive them under a new suffix before the next rebuild overwrites them in place.

## What Each Part Builds

Each part follows the same shape — RefSeq and GenBank queried and merged, taxonomy assigned, off-target sequences filtered, controls added, then saved — with a few marker-specific steps:

| Step | Part A (trnL g/h) | Part B (12Sv5) |
|---|---|---|
| Load inputs / filter RefSeq to one sequence per species | A1–A2 | B1–B2 |
| Extract target amplicon | A3: in silico PCR (`find_primer_pair()`) | B3: in silico PCR |
| Query GenBank | A4 | B4, submitted as a SLURM job (B3–B6) |
| Combine + taxonomy lookup | A5–A6 | B5–B6 |
| Remove off-target sequences | A6b: Streptophyta + Cyanobacteriota allowlist | B6b: Chordata only |
| Manual curation | A7 (`Manual renaming.csv` + hardcoded *Brassica oleracea* renamings) | — |
| QC / orientation | A8–A9 | B7–B8 |
| Dedup, add controls, save | A10 | B9 |

The trnL off-target allowlist deliberately includes Cyanobacteriota alongside Streptophyta: spirulina (*Arthrospira platensis*) and fat choy (*Nostoc flagelliforme*) are edible cyanobacteria on the food list with real trnL records that a plant-only filter would strip. The 12Sv5 filter is Chordata-only — a lab decision based on production data showing invertebrate reference records were never actually hit by real reads.

## Controls and Host Sequences

`data/inputs/controls.csv` holds two kinds of record, both merged in at each part's final dedup-and-save step (A10 / B9) rather than as a separate post-hoc step:

- **Synthetic spike-in controls** — the lab's positive-control constructs (`synthetic trnL ASV`, `synthetic 12S ASV`), which never come back from a RefSeq/GenBank query since they aren't real organisms. Without an explicit entry here, every food-list-driven rebuild silently drops them, and their reads get reassigned to whatever real taxon they're nearest to.
- **Real biological host/contaminant taxa** — species that aren't on `human-foods.csv` (so the food-list-driven build never queries them) but that the assay reliably amplifies and that dominate raw read counts if absent from the reference: *Rhacodactylus leachianus* (the gecko positive control) and *Homo sapiens* (89 haplotype records, needed because a single NCBI reference sequence for the 12Sv5 region is not enough to catch the genetic diversity of human host DNA in dietary samples). Each of these carries its own real taxonomic lineage in `controls.csv`, rather than the repeated-label format used for the synthetic constructs.

This replaces the older practice of manually appending Schneider et al. (2021) human haplotype sequences after building the 12Sv5 reference (see the [archived manual workflow](references-legacy.md#adding-human-sequences-to-the-12sv5-reference)) — human sequences are now included automatically as part of the standard build.

!!! note

    Schneider J, Mas-Carrió E, Jan C, Miquel C, Taberlet P, Michaud K, Fumagalli L, Comprehensive coverage of human last meal components revealed by a forensic DNA metabarcoding approach. *Sci. Rep.* **11**, 8876 (2021). [https://doi.org/10.1038/s41598-021-88418-x](https://doi.org/10.1038/s41598-021-88418-x)

Without a matching entry in `controls.csv`, host or contaminant reads land on the nearest available taxon in the reference — for 12Sv5 specifically, that has historically meant a large fraction of human reads misassigned into food clades (e.g. Artiodactyla) when human was absent. If you're adding a new marker or a new assay to this pipeline, check whether it needs its own host/control row before shipping a build.

## Outputs

Each run writes both formats:

- `data/outputs/dada2-compatible/{trnL,12Sv5}/` — FASTA files named by full taxonomic lineage, for use with `assignment_trnL()` / `assignment_12S()` (see [Creating a Phyloseq](pipeline.md#creating-the-taxonomy-table))
- `data/outputs/qiime2-compatible/{trnL,12Sv5}/` — sequence FASTA + taxonomy TSV pairs

trnL lineages run through `forma` (ten ranks); 12Sv5 lineages stop at `subspecies` (eight ranks).

## Verifying a Build: the QC Gate

`code/qc_reference_build.R` runs automatically at the end of the notebook (the **Verify before shipping** section), and checks each output against `QC_PREVIOUS_SUFFIX`'s build for:

- presence of all expected controls (hard-fails on a missing spike-in or host control)
- taxonomic rank completeness
- clade consistency (records landing outside the marker's allowed phyla)
- accession integrity (no bare-genus or malformed accessions)
- record-count tolerance vs. the previous build (flags large unexplained jumps or drops)

`0 FAIL` means the build is safe to archive; WARNs are worth reading but don't block a release on their own — they often reflect real, expected coverage churn (e.g. species renamed or removed from `human-foods.csv` since the last build) rather than a defect. Run it manually with:

``` bash
Rscript code/qc_reference_build.R [REPO_DIR] [CURRENT_SUFFIX] [PREVIOUS_SUFFIX]
```

An optional 4th argument restricts the check to one marker (`trnL` or `12SV5`) — needed after an extend-only run (see [Extending an Existing Reference](#extending-an-existing-reference) above), since a single-marker update otherwise reads as a failure on every marker it didn't touch.

## Known Limitations

Most remaining coverage gaps reflect species with no public trnL/12Sv5 sequence at NCBI yet, not a pipeline limitation — with one notable exception: **41 plant species (Aug 2026) are recoverable only from a complete chloroplast genome**, and the pipeline's 50 kb length cap on GenBank queries (added to avoid crashing R's string-length limit on chromosomal assemblies) excludes complete plastomes from the pull entirely. See the [food-dbs README](https://github.com/LAD-LAB/food-dbs#remaining-gaps-aug-2026) for the current gap breakdown.

## Further Reading

- [food-dbs README](https://github.com/LAD-LAB/food-dbs) — full pipeline documentation, current coverage tables, and an interactive Mermaid flowchart of the pipeline
- [`changes-summary.html`](https://github.com/LAD-LAB/food-dbs/blob/master/changes-summary.html) — everything changed in the 2026 pipeline rebuilds, grouped by theme
- [`pipeline-flowchart.html`](https://github.com/LAD-LAB/food-dbs/blob/master/pipeline-flowchart.html) — the same flowchart below, with a parameter comparison table for everything that differs between the trnL and 12Sv5 runs

``` mermaid
flowchart TD

    CTL["controls.csv"]
    SETUP["SLURM setup jobs"]
    REFSEQ_DL["RefSeq plastid + RefSeq mitochondrial"]
    SQL[("accessionTaxa.sql")]
    NCBI_FB["query_ncbi_accession<br/>accessions newer than the SQL build"]

    SETUP -->|download| REFSEQ_DL
    SETUP -->|prepareDatabase| SQL

    REFSEQ_DL -->|filter one per species · trnL, 12SV5| GENOME_SP["② RefSeq genomes<br/>one per species, accession kept"]

    GENOME_SP -->|find_primer_pair, all RefSeq species| REFSEQ["③ RefSeq amplicons"]
    NCBI_SPECIES["① plants or animals from human-foods.csv"] -->|query_ncbi + find_primer_pair| NCBI["④ GenBank sequences"]

    REFSEQ -->|"① Use plants or animals from human-foods.csv to filter amplicons"| REFSEQ_FOOD["RefSeq food amplicons"]

    REFSEQ_FOOD --> COMB["⑤ combined sequences"]
    NCBI -->|combine · trnL also merges manual additions| COMB
    COMB -->|accessionToTaxa| TAX["⑥ + taxonomy"]
    SQL --> TAX
    NCBI_FB -.->|fallback for missing IDs| TAX
    TAX -->|A6b/B6b · phylum allowlist| CLEAN["⑦ on-target only"]

    CLEAN -->|⑧ QC · ⑨ orientation · ⑩ dedup · add controls| OUT["⑩ reference database"]
    CLEAN -.->|trnL only| CUR["⑦b manual curation<br/>Manual renaming.csv"]
    CUR -.->|⑧ QC · ⑨ orientation · ⑩ dedup · add controls| OUT
    CTL -.->|add controls| OUT

    QC{"qc_reference_build.R<br/>controls · rank completeness · clade consistency<br/>accession integrity · count tolerance"}
    OUT --> QC
    QC -->|pass| SHIP["release"]
    QC -->|fail, exit 1| BLOCK["do not ship"]

    style CUR fill:#F5EEDC,stroke:#C9A96E,color:#5F4A1E
    style QC fill:#C8E0C9,stroke:#2C5F2D,color:#1E3A1F
    style BLOCK fill:#F2DCD6,stroke:#BC5138,color:#5F1E1E
    style SHIP fill:#CDE3CE,stroke:#2C5F2D,color:#1E5F1E
```
