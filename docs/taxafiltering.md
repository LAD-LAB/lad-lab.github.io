# Filtering Taxa

After [agglomerating taxa](glomming.md), the next step is to remove taxa that should not be included in downstream analysis — unassigned (NA) taxa, human reads (for 12Sv5), synthetic control ASVs, and any cohort-specific taxa that need to be excluded. This is handled by two functions, `filter_trnL_taxa()` and `filter_12S_taxa()`, which replace the individual `subset_taxa()`/`prune_taxa()` calls previously used for these steps. Cohort-specific removals are still done manually with `subset_taxa()`, after calling the appropriate function.

## `filter_trnL_taxa()` and `filter_12S_taxa()` Functions

<div class="download-buttons" markdown>
[Download filter_trnL_taxa.R](files/filter_trnL_taxa.R){ .md-button }
[Download filter_12S_taxa.R](files/filter_12S_taxa.R){ .md-button }
</div>

Both functions compute a `lowest_level` column (the most specific non-`NA` taxonomic rank per ASV) and remove unassigned and named control ASVs. `filter_12S_taxa()` additionally removes *Homo sapiens* reads. Neither function agglomerates — that happens earlier, in [Agglomerating Taxa](glomming.md).

!!! to-do

    `filter_12S_taxa()` currently still performs an internal `tax_glom()` step and always recomputes `lowest_level`, even if the column already exists from the [Agglomerating Taxa](glomming.md) step. Both will be corrected in an upcoming revision — agglomeration will happen only in the Agglomerating Taxa step, and `lowest_level` will be reused if already present. The downloadable script above has not yet been updated to reflect this.

After reading the appropriate function into your analysis file, run:

=== "trnL"

    ``` r
    ps.trnL <- filter_trnL_taxa(ps.trnL)
    ```

=== "12Sv5"

    ``` r
    ps.12S <- filter_12S_taxa(ps.12S)
    ```

Both functions preserve any tax-table columns not used for filtering (e.g. `taxa`/`common_name` from [`assign_common_names()`](commonnames.md#assign_common_names-function)) — these are set aside during filtering and reattached at the end for whichever ASVs survive, so run [Assigning Common Names](commonnames.md) first if you want those columns carried through.

Key inputs:

* `controls` (optional) — exact `species` values to treat as synthetic control ASVs and remove; defaults to `"synthetic trnL ASV"` / `"synthetic 12S ASV"`. Set to `NULL` to skip control removal, or pass your own value if your control species differs from the default.
* `tax_cols` / `tax_coal` (optional) — which tax-table columns to use for filtering, and respectively to coalesce into `lowest_level`; default to trnL's/12Sv5's own rank sets.
* `export_NA_ASVs` (optional) — a file path to write a CSV of removed unassigned ASVs (with prevalence and read counts) to, for later review.
* `filter_12S_taxa()` also takes `export_human_ASVs` (a file path to write removed *Homo sapiens* ASVs to) and `calculate_human_reads_perc` (whether to report the percentage of reads from *Homo sapiens* before filtering; default `TRUE`).

## Manual Review for Ambiguous Human-Matching ASVs (12Sv5)

`filter_12S_taxa()`'s `controls` argument only matches ASVs assigned exactly to *Homo sapiens* or to a named control species. Some ASVs may BLAST to human without being classified that way — for example, ASVs ambiguous between human and a closely related species. If you have identified such ASVs manually (e.g., through the [BLAST review process](reviewing.md#blasting-unassigned-asvs)), remove them by sequence after calling `filter_12S_taxa()`:

``` r
# Remove specific ASVs identified as human through manual review:
manual_human_asvs <- c("ACGT...", "TGCA...")
ps.12S <- prune_taxa(!taxa_names(ps.12S) %in% manual_human_asvs, ps.12S)
```

!!! note "Synthetic controls with a different name"

    If your sequencing run's synthetic control ASV isn't named exactly `"synthetic trnL ASV"` or `"synthetic 12S ASV"`, pass the actual value via `controls = "[your control's species name]"`, or filter it out manually with `subset_taxa()`.

## Cohort-Specific Removals

Some studies may require removing additional taxa based on the study design, after calling `filter_trnL_taxa()`/`filter_12S_taxa()`. Common examples include:

* **Environmental contamination** — for trnL, taxa like grasses or trees that reflect environmental DNA rather than dietary intake.
* **Known contaminants** — taxa identified during [quality control](pipeline.md#quality-control) as likely cross-contamination from positive controls or other samples.
* **Study-specific exclusions** — taxa that are not relevant to the research question (e.g., removing non-mammalian vertebrates from a study focused on meat consumption).

These removals are study-dependent and should be documented in your analysis scripts. Use `subset_taxa()` to filter by any column in the taxonomy table:

``` r
# Example: remove a specific genus
ps <- subset_taxa(ps, genus != "Festuca" | is.na(genus))

# Example: remove multiple species
exclude <- c("Bos taurus", "Sus scrofa")
ps <- subset_taxa(ps, !species %in% exclude | is.na(species))
```

