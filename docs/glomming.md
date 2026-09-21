# Agglomerating Taxa

Agglomeration groups ASVs that represent the same organism — whether because they were sequenced at slightly different lengths, assigned at different taxonomic resolutions, or are simply redundant with one another — into a single representative taxon. This step happens right after [assigning common names](commonnames.md) and before [filtering taxa](taxafiltering.md). The approach differs by marker.

!!! to-do

    Convert the trnL and 12Sv5 sections below into content tabs, to match the convention used on the rest of the site.

## 12Sv5

12Sv5 agglomeration is a straightforward `tax_glom()` by a `lowest_level` column — the most specific non-`NA` taxonomic rank assigned to each ASV. Compute `lowest_level` by coalescing ranks from most to least specific, then agglomerate:

```r
tax_table(ps.12S) <- tax_table(ps.12S) %>%
    data.frame() %>%
    mutate(lowest_level = coalesce(species, genus, family, order, class, phylum, kingdom)) %>%
    tax_table()

ps.12S <- phyloseq::tax_glom(ps.12S, taxrank = "lowest_level")
```

## trnL 

!!! to-do

    A first version of `plan_harmonization()` and `apply_asv_corrections()` was released in September 2026 and the section below describes that version. Both are still being actively developed, so check the function documentation before relying on the arguments and return values shown here.

trnL agglomeration works differently: rather than grouping by taxonomic rank alone, it detects ASVs that likely represent the same organism across (or within) sequencing batches — near-identical sequences, differing resolutions, overlapping or subset taxonomy — and merges them once a human has reviewed the ambiguous cases. Two functions handle this: `plan_harmonization()` and `apply_asv_corrections()`.

### `plan_harmonization()`

`plan_harmonization()` compares ASVs pairwise — by sequence (is one a substring of another?) and by taxonomy (do their assigned species sets match, overlap, or conflict?) — and classifies each pair. Clear-cut cases (a substring pair with an identical species set) are queued for automatic merging, keeping the shorter ASV; everything else (differing resolutions, overlapping or conflicting taxonomy, missing taxonomy) is flagged for you to review. 

Flagged pairs can be reviewed interactively with a Shiny gadget in the RStudio Viewer pane showing each pair side by side and letting you choose to merge, keep both distinct, or rename. This requires the `shiny`, `miniUI`, and `DT` packages to be installed.

``` r
plan <- plan_harmonization(ps.trnL)
```

### `apply_asv_corrections()`

Once decisions are made, `apply_asv_corrections()` applies them: it adds a `glom_name` column to the tax table, physically merges ASVs (transferring read counts and pruning discarded ASVs, including through multi-hop merge chains) and applies any chosen names.

Pass the plan itself — everything the function needs is carried on it.

``` r
result <- apply_asv_corrections(plan)
ps.trnL <- result$ps_harmonized
```

Alongside `ps_harmonized`, the result carries `decisions` (one row per reviewed pair, with the scenario, the decision and your rationale), `asv_summary`, and `unresolved` for any flagged pairs you did not settle.
