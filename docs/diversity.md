# Calculating Diversity

This page will instruct you in the calculation of various common diversity metrics that help us compare the complexity of different dietary profiles. These steps are intended to precede the [calculation of relative abundance](http://lad-lab.github.io/abundance.html).

## Alpha Diversity

Feed in your phyloseq after [filtering taxa](taxafiltering.md), [filtering samples](samplefiltering.md), and [pruning](pruning.md) have already run. Use the `estimate_richness()` function from the package `phyloseq`:

``` r
library(phyloseq)

alphadiv <- estimate_richness(ps.filtered, measures = c("Observed", "Shannon")) %>%
  mutate(barcode_well = rownames(.)) %>%  
  mutate(barcode_well = str_replace_all(barcode_well, "X", "")) %>%  
  mutate(barcode_well = str_replace_all(barcode_well, "\\.", "-")) %>%
  as.data.frame()
```

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
