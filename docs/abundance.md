# Relative Abundance and CLR Transform

This page will instruct you in the calculation of relative abundance and the centered log-ratio (CLR) transform, and provide background on the purpose and interpretation of each. These steps are intended to follow the [calculation of diversity](diversity.md) and precede the [creation of a PCA plot](pca.md).

## Calculating Relative Abundance

Relative abundance expresses each ASV's read count as a proportion of the total reads in its sample, rather than as a raw count — this makes samples with different sequencing depths comparable. 

Feed in your *_filtered_* phyloseq, so that each proportion is calculated over food reads only:

``` r
ps.ra <- microbiome::transform(ps.filt, 'compositional')
```

## CLR Transform

A center log-ratio (CLR) transformation removes the constant-sum constraint of compositional data representing relative abundances (i.e., that all components sum to 1, or 100%) and linearizes relationships while preserving relative information. This allows for plotting the PCA using Euclidean distances, equivalent to computing Aitchison distance on the original compositional data. 

Feed in the relative abundance phyloseq from the previous step: 

``` r
ps.filt.clr <- microbiome::transform(ps.ra, 'clr') 
```

??? info "The pseudocount `microbiome::transform()` adds automatically"

    A CLR transform takes the log of every value, and log(0) is undefined, so zeros have to be replaced with a small positive number first. microbiome::transform(ps, 'clr') does this automatically. It converts counts to relative abundances, takes half the smallest non-zero proportion in the whole dataset as a pseudocount, and adds that to every value (not just the zeros) before taking logs. You don't need to add a pseudocount yourself, but keep in mind:
    
    - ps.filt.clr's values aren't simply log() of ps.ra's proportions. The pseudocount is built into every value.
    - The pseudocount depends on your data, so filtering or subsetting samples before transforming can change it.
    - A manual CLR won't match unless you use the same pseudocount. The common log(counts + 1) approach gives noticeably different values, especially for rare taxa. If you do it by hand, match microbiome's approach or report the pseudocount you used.

