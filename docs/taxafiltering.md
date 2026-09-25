# Filtering Taxa

After [assigning common names](commonnames.md), the next step is to remove taxa that should not be included in downstream analysis — synthetic control ASVs, non-food taxa (unassigned, and, for 12Sv5, human reads), and any cohort-specific taxa that need to be excluded. These are listed out as independent steps below, rather than wrapped in a single function, so you can adapt, reorder, or skip individual steps as your study needs.

=== "trnL"

    ## Removing Controls

    If your sequencing run included a synthetic positive control (e.g. a synthetic trnL ASV), remove it by its exact species name:

    ``` r
    ps.trnL <- subset_taxa(ps.trnL, species != "synthetic trnL ASV" | is.na(species))
    ```

    Adjust the species name to match whatever your own control ASV is named if it differs from the default above.

    ## Removing Non-Food Taxa

    An unassigned trnL ASV has `NA` at every taxonomic rank, i.e. at `superkingdom`:

    ``` r
    ps.trnL <- subset_taxa(ps.trnL, !is.na(superkingdom))
    ```

=== "12Sv5"

    ## Removing Controls

    ``` r
    ps.12S <- subset_taxa(ps.12S, species != "synthetic 12S ASV" | is.na(species))
    ```

    Adjust the species name to match whatever your own control ASV is named if it differs from the default above.

    ## Computing `lowest_level`

    The next step, and [agglomerating taxa](glomming.md) afterward, both rely on a `lowest_level` column — the most specific non-`NA` taxonomic rank assigned to each ASV. Compute it once here with [`lowest_level()`](foodseqtools.md) from `foodseq.tools`:

    ``` r
    # install.packages("devtools")
    devtools::install_github("LAD-LAB/foodseq.tools")

    library(foodseq.tools)

    tax_table(ps.12S) <- tax_table(ps.12S) %>%
        data.frame() %>%
        lowest_level() %>%
        tax_table()
    ```

    ## Removing Non-Food Taxa

    Two things count as non-food for 12Sv5: unassigned ASVs (`NA` at `kingdom`, or `NA` at both `order` and `family`) and human reads, which are commonly detected in 12Sv5 sequencing of stool samples and reflect the host rather than dietary intake:

    ``` r
    ps.12S <- subset_taxa(ps.12S, !(is.na(kingdom) | (is.na(family) & is.na(order))))
    ps.12S <- subset_taxa(ps.12S, is.na(lowest_level) | lowest_level != "Homo sapiens")
    ```

    ## Manual Review for Ambiguous Human-Matching ASVs

    The `lowest_level != "Homo sapiens"` step above only catches ASVs the classifier itself assigned to human. Some ASVs may BLAST to human without being classified that way — for example, ASVs ambiguous between human and a closely related species. If you've identified such ASVs manually (e.g., through the [BLAST review process](reviewing.md#blasting-unassigned-asvs)), remove them by sequence:

    ``` r
    # Remove specific ASVs identified as human through manual review:
    manual_human_asvs <- c("ACGT...", "TGCA...")
    ps.12S <- prune_taxa(!taxa_names(ps.12S) %in% manual_human_asvs, ps.12S)
    ```

## Cohort-Specific Removals

Some studies may require removing additional taxa based on the study design, after the steps above. Common examples include:

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
