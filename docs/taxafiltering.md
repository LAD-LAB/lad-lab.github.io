# Filtering Taxa

After reviewing unassigned ASVs, the next step is to remove taxa that should not be included in downstream analysis. This typically includes unassigned (NA) taxa, human reads (for 12Sv5), synthetic control ASVs, and any cohort-specific taxa that need to be excluded.

These filtering steps are performed with `phyloseq::subset_taxa()` and `phyloseq::prune_taxa()`.

## Removing Unassigned (NA) Taxa

As described on the [reviewing page](reviewing.md), the definition of an unassigned ASV differs by marker:

=== "trnL"

    For trnL, an unassigned ASV has NA at all taxonomic ranks. To remove these:

    ``` r
    ps.trnL <- subset_taxa(ps.trnL, !is.na(superkingdom))
    ```

=== "12Sv5"

    For 12Sv5, an unassigned ASV has NA at both order and family. To remove these:

    ``` r
    ps.12S <- subset_taxa(ps.12S, !(is.na(order) & is.na(family)))
    ```

    Note that this retains ASVs that have an assignment at order or family (or both), even if lower ranks like genus or species are NA.

## Removing Human Reads

Human DNA is commonly detected in 12Sv5 sequencing of stool samples. These reads should be removed before analysis, as they reflect the host rather than dietary intake.

``` r
ps.12S <- subset_taxa(ps.12S, species != "Homo sapiens" | is.na(species))
```

The `| is.na(species)` clause ensures that ASVs without a species-level assignment are not accidentally removed.

In some cases, certain ASVs may BLAST to human but not be assigned as *Homo sapiens* by the classifier — for example, ASVs that are ambiguous between human and a closely related species. If you have identified such ASVs manually (e.g., through the [BLAST review process](reviewing.md#blasting-unassigned-asvs)), you can remove them by sequence:

``` r
# Remove specific ASVs identified as human through manual review:
manual_human_asvs <- c("ACGT...", "TGCA...")
ps.12S <- prune_taxa(!taxa_names(ps.12S) %in% manual_human_asvs, ps.12S)
```

## Removing Synthetic Control ASVs

If your sequencing run included synthetic positive control sequences (e.g., synthetic trnL or 12S ASVs), these should be removed before analysis:

``` r
ps <- subset_taxa(ps, !grepl("synthetic", species, ignore.case = TRUE) | is.na(species))
```

## Cohort-Specific Removals

Some studies may require removing additional taxa based on the study design. Common examples include:

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

