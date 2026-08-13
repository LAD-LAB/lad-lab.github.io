# Reviewing Unassigned Taxa

After taxonomy assignment, some ASVs will not match any sequence in the reference database and will be left unassigned (NA). This page covers how to identify, review, and BLAST these ASVs to determine what they are and whether the reference needs updating.

## What Counts as Unassigned

The definition of an unassigned ASV differs by marker:

* **trnL** — an ASV is considered unassigned if it has NA at all taxonomic ranks (i.e., NA at superkingdom). Because trnL assignment uses exact sequence matching, an ASV either matches the reference or it doesn't; there are no partial assignments.
* **12Sv5** — an ASV is considered unassigned if it has NA at both order and family. An ASV can have assignments at higher ranks (superkingdom, phylum, class) from the Bayesian classifier and still be flagged as unassigned if it lacks order and family; conversely, an ASV with order but not family (or vice versa) is considered assigned.

## NAs CSV

The `assignment_trnL()` and `assignment_12S()` functions automatically save a CSV of unassigned ASVs to the output directory (`trnL_NAs.csv` and `12S_NAs.csv`). Each CSV contains:

| Column | Description |
|--------|-------------|
| `ASV` | The full ASV sequence |
| `samples_with_reads` | Number of samples in which this ASV was detected |
| `total_reads` | Total read count for this ASV across all samples |

ASVs with high read counts or high sample prevalence are the most important to investigate, as they may represent real organisms missing from the reference rather than sequencing artefacts.

## BLASTing Unassigned ASVs

To identify what an unassigned ASV is, you can query it against NCBI's nucleotide database using [BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome):

1. Open the NAs CSV and sort by `total_reads` in descending order to prioritize the most abundant unassigned ASVs.
2. Copy the ASV sequence from the `ASV` column.
3. Go to [NCBI Nucleotide BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome) and paste the sequence into the query box.
4. Under "Database," select "Nucleotide collection (nr/nt)."
5. Click BLAST and wait for results.

### Interpreting Results

When reviewing BLAST results:

* **High identity (>97%) and low E-value** — the ASV likely belongs to the matched organism. If this organism should be in your reference but isn't, it may need to be added.
* **Multiple hits with similar scores** — the ASV may be ambiguous at the species level, which is expected for short amplicons. Look at whether the hits agree at a higher rank (genus or family).
* **No significant hits** — the ASV may be a chimera, a sequencing artefact, or an organism not well-represented in NCBI. These are generally safe to filter out.
* **Hits to non-food organisms** — for trnL, hits to environmental plant DNA (e.g., grasses, trees) are common and typically reflect environmental contamination rather than dietary intake. For 12Sv5, hits to human sequences are expected and are removed during [taxa filtering](taxafiltering.md).

## Extracting NAs from the Phyloseq

If you want to examine unassigned ASVs directly from the phyloseq rather than from the CSV, you can extract them in R:

=== "trnL"

    ``` r
    tax_df <- as.data.frame(tax_table(ps.trnL))
    na_asvs <- tax_df[is.na(tax_df$superkingdom), ]
    ```

=== "12Sv5"

    ``` r
    tax_df <- as.data.frame(tax_table(ps.12S))
    na_asvs <- tax_df[is.na(tax_df$order) & is.na(tax_df$family), ]
    ```

To see how many reads these unassigned ASVs account for:

``` r
na_seqs <- rownames(na_asvs)
otu <- as.data.frame(otu_table(ps))
total_reads <- sum(otu)
na_reads <- sum(otu[, na_seqs])
cat(sprintf("Unassigned ASVs: %d (%.1f%% of reads)\n", length(na_seqs), 100 * na_reads / total_reads))
```

## Tracking NAs Across Runs

The `update_na_catalog()` function in `foodseq.tools` maintains a shared Google Sheets workbook for tracking unassigned ASVs across sequencing runs. The workbook has two sheets:

* **asv_totals** — cumulative sample counts and read counts per ASV across all ingested runs, with a `runs` column summarizing per-run contributions. Manually added annotation columns (e.g., BLAST results) are preserved across updates.
* **runs_ingested** — a log of which runs have been processed, preventing duplicate ingestion.

To update the catalog after a new run:

``` r
update_na_catalog(
  na_trnL = assignments.trnL$NAs_trnL,
  na_12S  = assignments.12S$NAs_12S,
  run_id  = project,
  ss      = "[your-google-sheets-id]"
)
```

The function is idempotent; if a run has already been recorded, it will skip the update and print a message.
