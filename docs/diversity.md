# Calculating Diversity

This page will instruct you in the calculation of various common diversity metrics that help us compare the complexity of different dietary profiles. These steps are intended to precede the [calculation of relative abundance](http://lad-lab.github.io/abundance.html).

## Alpha Diversity

To calculate alpha diversity, first filter out `NA`s and then use the `estimate_richness()` function from the package `phyloseq`:

``` r
library(phyloseq)

ps.filtered <- ps %>%
  subset_taxa(!is.na(superkingdom))

alphadiv <- estimate_richness(ps.filtered, measures = c("Observed", "Shannon")) %>%
  mutate(barcode_well = rownames(.)) %>%  
  mutate(barcode_well = str_replace_all(barcode_well, "X", "")) %>%  
  mutate(barcode_well = str_replace_all(barcode_well, "\\.", "-")) %>%
  as.data.frame()
```

!!! note "Filtering unassigned taxa" 

    It is recommended to filter out `NA`s at the highest level (i.e., superkingdom) for trnL and at Order + Family for 12Sv5. This is because `assignment_trnL()` uses exact sequence matching, so any non-`NA` assignment reflects a true match in the reference and `NA`s appear only when no match exists. 12Sv5, by contrast, is assigned by `assignment_12S()`, which uses a naive Bayesian classifier and makes assignments at every level along with bootstrap confidence values, which tend to fall off below Order. Any ASV that is `NA` at both the Order and Family level should be filtered out. Include Family in your filtering criteria to ensure you retain entries that do not have Order or Family assignments but still contain valid assignments at lower taxonomic ranks (e.g., due to gaps in the reference).

This code creates a dataframe with a column `barcode_well` with the name of each sample and two columns `Observed` and `Shannon` with the observed number of taxa and the Shannon diversity respectively of each sample, measures of alpha diversity. We can now join this dataframe to the sample metadata with the following code chunk, based on if a matching `barcode_well` column exists in your sample metadata:

=== "If `barcode_well` exists"

    ``` r
    joined <- sample_data(ps.filtered) %>%
        data.frame() %>%
        left_join(alphadiv, by = "barcode_well")

    rownames(joined) <- sample_names(ps.filtered)  # left_join drops rownames
    sample_data(ps.filtered) <- joined
    ```

=== "If `barcode_well` does not exist"

    ``` r
    joined <- sample_data(ps.filtered) %>%
        data.frame() %>%
        tibble::rownames_to_column("barcode_well") %>%  # Create barcode_well column
        left_join(alphadiv, by = "barcode_well")

    rownames(joined) <- sample_names(ps.filtered)  # left_join drops rownames
    sample_data(ps.filtered) <- joined
    ```

=== "If `barcode_well` exists under a different name"

    ``` r
    joined <- sample_data(ps.filtered) %>%
        data.frame() %>%
        left_join(alphadiv, by = c("[different name]" = "barcode_well")) # Replace [different name] with the matching column's name

    rownames(joined) <- sample_names(ps.filtered)  # left_join drops rownames
    sample_data(ps.filtered) <- joined
    ```

Now that you have a phyloseq object with alpha diversity metrics added to your sample metadata, you can continue with further analyses to analyze the differences in diversity between different samples or groups or continue with calculating relative abundance.
