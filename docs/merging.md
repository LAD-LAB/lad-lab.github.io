# Merging Phyloseqs

These instructions will help you merge multiple phyloseq objects into a single combined dataset using `merge_phyloseq()` from the `phyloseq` package. Merging is most commonly used when combining sequencing runs into a single dataset for cross-run analysis or when building a megaphyloseq that aggregates across many runs.

## Before Merging

Before calling `merge_phyloseq()`, make sure the following are addressed for each phyloseq you plan to merge.

### Ensuring Unique Sample Names

Phyloseq objects from different sequencing runs will often share sample names (e.g., `1-A01`, `2-B03`) because the well-based naming scheme resets with each run. If you merge phyloseqs with overlapping sample names, one will silently overwrite the other. To prevent this, prefix each phyloseq's sample names with a unique identifier before merging:

``` r
sample_names(ps.run1) <- paste0("[prefix1]-", sample_names(ps.run1))
sample_names(ps.run2) <- paste0("[prefix2]-", sample_names(ps.run2))
```

The prefix can be anything that uniquely identifies the run — a project name, a run date, a short label. For example, `"CHOICE-"`, `"20250401-"`, or `"Run1-"` would all work, as long as each phyloseq gets a different prefix. You can verify there are no collisions with:

``` r
any(sample_names(ps.run1) %in% sample_names(ps.run2))
```

This should return `FALSE`.

### Updating Taxonomy for Reference Consistency

If the phyloseqs you are merging were created against different versions of the trnL or 12Sv5 reference, the same organism may have different taxonomy assignments across runs. To avoid inconsistencies in the merged dataset, re-run taxonomy assignment on each phyloseq against the same reference using `update_taxonomy()` from `foodseq.tools`:

``` r
ps.run1 <- update_taxonomy(ps.run1, reference = "[/path/to/current/reference.fasta]", marker = "trnL")
ps.run2 <- update_taxonomy(ps.run2, reference = "[/path/to/current/reference.fasta]", marker = "trnL")
```

The `marker` argument should be `"trnL"` for plant data or `"12S"` for animal data. Both phyloseqs should point to the same reference FASTA so that taxonomy is assigned identically.

### Standardizing Sample Metadata

The `merge_phyloseq()` function combines the `sam_data` components by row-binding. If one phyloseq has metadata columns that the other does not, those columns will be filled with `NA` in the merged object. Before merging, check that the column names and value formats are consistent across phyloseqs:

``` r
setdiff(colnames(sample_data(ps.run1)), colnames(sample_data(ps.run2)))
setdiff(colnames(sample_data(ps.run2)), colnames(sample_data(ps.run1)))
```

If either call returns column names, either add the missing columns to the other phyloseq or remove columns that are not shared. Values in shared columns should use the same format — for example, the `type` column should use exactly `"sample"`, `"positive control"`, `"negative control"`, or `"blank"` across all phyloseqs.

## Merging

With sample names, taxonomy, and metadata aligned, merge the phyloseqs with:

``` r
ps.merged <- merge_phyloseq(ps.run1, ps.run2)
```

You can merge more than two phyloseqs at once by passing additional arguments:

``` r
ps.merged <- merge_phyloseq(ps.run1, ps.run2, ps.run3)
```

After merging, verify the result:

``` r
ps.merged
```

The output should show the combined number of samples and the union of all ASVs across the input phyloseqs.
