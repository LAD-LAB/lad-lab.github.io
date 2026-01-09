# Calculating Relative Abundance

This page will instruct you in the calculation of relative abundance using the custom `foodseqSetup()` function and to provide background on the purpose and interpretation of relative abundance. These steps are intended to follow the [calculation of diversity](http://127.0.0.1:8000/diversity.html) and precede the [creation of a PCA plot](http://127.0.0.1:8000/pca.html).

!!! to-do

    Finish this page.

## `foodseqSetup()` Function

When calculating relative abundance, feed in an *unfiltered* phyloseq, as opposed to the filtered phyloseq object used for calculating diversity.

``` r
foodseqSetup <- function(ps) {
  ### Relative abundance generation 
  ps.ra <- transform_sample_counts(ps, function(x){x/sum(x)})
  
  ### Filter and CLR transform 
  ps.filt <- ps %>%
  subset_taxa(., !is.na(superkingdom)) # foods only

  ps.filt.clr <- ps.filt %>%
  prune_samples(sample_sums(.) > 0, .) %>% # Remove samples that do not have any food reads, will mess up PCA plot
  microbiome::transform(., 'clr') # clr transform
  
  ### Update read counts in phyloseq object
  sample_data(ps.filt.clr)$reads <- sample_sums(ps.filt.clr)
  
  ### Alpha diversity metrics 
  pMR <- ifelse(subset_taxa(ps.filt.clr, !is.na(superkingdom))@otu_table>0,1,0) %>%      # Converts OTU table values to presence/absence
  rowSums()
  ps.filt.clr@sam_data$pMR <- pMR
  
  # This is done with raw relative abundance, not clr transformed or raw abundance data 
  shan <- estimate_richness(ps.ra, measures = "Shannon") %>%
    rownames_to_column(var = "test") 
  
  sample_data(ps.ra) <- ps.ra@sam_data %>%
    data.frame() %>%
    rownames_to_column(var = "test") %>%
    left_join(shan, by = "test") %>% 
    column_to_rownames(var = "test") %>%
    sample_data()
  
  return(list(ps.ra = ps.ra, # Relative abundance 
              ps.filt = ps.filt, # Foods only 
              ps.filt.clr = ps.filt.clr # Foods only, CLR-transformed 
              ))
}
```