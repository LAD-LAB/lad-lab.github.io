# Pruning Taxa

After filtering samples, some taxa may have zero total reads across the remaining samples — for example, a taxon that was only present in a control sample you just removed, or one that was only detected in samples excluded for low read counts. These zero-read taxa should be pruned from the phyloseq before proceeding to agglomeration and diversity calculations, as they can interfere with downstream analyses.

``` r
ps.trnL <- prune_taxa(taxa_sums(ps.trnL) > 0, ps.trnL)
ps.12S  <- prune_taxa(taxa_sums(ps.12S) > 0, ps.12S)
```

You can check how many taxa were removed by comparing the count before and after:

``` r
# Before pruning:
ntaxa(ps.trnL)

# After pruning:
ps.trnL <- prune_taxa(taxa_sums(ps.trnL) > 0, ps.trnL)
ntaxa(ps.trnL)
```

This step is quick but important; zero-count taxa will inflate richness metrics and add empty rows to ordination matrices.
