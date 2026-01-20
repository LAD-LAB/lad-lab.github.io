# Creating a PCA Plot

This page will instruct you in the creation of a principal component analysis (PCA) plot using the custom `pcaPlot()` function and to provide background on the purpose and interpretation of PCA plots. These steps are intended to follow the [calculation of relative abundance](http://127.0.0.1:8000/abundance.html).

## What is a PCA Plot?

A PCA plot is a graphical representation of Principal Component Analysis (PCA), a technique used to reduce the dimensionality of complex datasets while preserving as much variability (or information) as possible.

In many datasets, you might have a large number of variables (features). PCA helps simplify such datasets by transforming them into a smaller set of uncorrelated variables called principal components (PCs). These PCs capture the maximum variation in the data, with each successive PC accounting for progressively less of the remaining variability.

`[rewrite; from ChatGPT]`

## CLR Transform

Before creating a PCA plot, you must perform a centered log-ratio (clr) transform and filter out `NA`s at the highest level (i.e. superkingdom). To perform the clr transform, feed in an *unfiltered* phyloseq, just as for calculating relative abundances, and run the following:

``` r
ps.clr <- ps %>%
  prune_samples(sample_sums(.) > 0, .) %>% # Remove samples that do not have any food reads, will mess up PCA plot
  microbiome::transform(transform = "compositional") %>%
  microbiome::transform(transform = "clr")
```

Before filtering out `NA`s, you may find it useful to create a table of ASVs that don't have assigned taxa in order to BLAST them later. You can optionally do this with:

``` r
tax_table_df <- as.data.frame(tax_table(ps.clr))
na_asvs <- tax_table_df[is.na(tax_table_df$superkingdom), ]
```

Otherwise, continue to the filtering step and remove `NA`s:

``` r
ps.filtered <- ps.clr %>%
  subset_taxa(!is.na(superkingdom))
```

This transformed, filtered phyloseq object can now be used to plot a PCA!

??? question "Why do we need to perform a clr transform?"

    In short, a clr transform removes the constant-sum constraint of compositional data representing relative abundances (i.e. that all components sum to 1, or 100%) and linearizes relationships while preserving relative information. This allows for plotting the PCA using Euclidean distances, equivalent to computing Aitchison distance on the original compositional data.

    The function for the clr transform is:

    $$
    \text{clr}(x) = \left[\log \frac{x_1}{g(x)},\ldots, \log \frac{x_D}{g(x)}\right]
    $$
    
    where $g(x)$ is the geometric mean of $x$.

## `pcaPlot()` Function

The function below was written by Ben Neubert to create a PCA plot. After reading it into your analysis file, run:

``` r
pcaPlot(ps, colorVar, colorName, nTaxa)
```

at minimum to plot a PCA. The inputs of Ben's function are:

* `ps` (required) — your phyloseq object
* `colorVar` (required) — the variable from your sample metadata to color the samples by
* `colorName` (required) — a legend title corresponding to the `colorVar` variable
* `nTaxa` (required) — the number of taxa to display loadings for
* `customColors` (optional) — a vector of colors corresponding in length to the number of unique values for `colorVar`; by default `NULL`
* `xPC` (optional) — the principal component for the x-axis; by default `1`
* `yPC` (optional) — the principal component for the y-axis; by default `2`
* `ellipse` (optional) — a Boolean for the option to add centroid ellipses to your plot; by default `FALSE`

``` r
pcaPlot <- function(ps, # clr transformed and filtered data
                    colorVar, # variable from samdf to color samples by
                    colorName, # what to display variable name as in legend
                    nTaxa, # number of taxa to display
                    customColors = NULL, # optional named vector of colors
                    xPC = 1, # Principal Component for x-axis
                    yPC = 2,  # Principal Component for y-axis
                    ellipse = FALSE # optional add centroid ellipses 
                    ) { 
  
  if ("name" %in% colnames(data.frame(ps@sam_data))) { 
    # Prevent conflict with 'name' column
    sample_data(ps) <- ps@sam_data %>%
      data.frame() %>%
      dplyr::rename(name.x = name)
  }
  
  samdf <- data.frame(ps@sam_data) %>%
    rownames_to_column(var = 'name')
  
  # PCA
  pca <- prcomp(ps@otu_table, center = TRUE, scale = FALSE)
  
  # % variance explained
  eigs <- pca$sdev^2
  varExplained <- 100 * eigs / sum(eigs)
  names(varExplained) <- paste0('PC', seq_along(varExplained))
  
  # Extract variance explained for specified PCs
  ve.xPC <- as.character(round(varExplained[paste0('PC', xPC)], 3))
  ve.yPC <- as.character(round(varExplained[paste0('PC', yPC)], 3))
  
  # PCA scores
  pca.df <- data.frame(pca$x) %>% 
    rownames_to_column(var = 'name')
  
  # Add back sample data
  pca.df <- left_join(pca.df, samdf, by = "name")
  
  # Calculate plotting limits based on specified PCs
  limit <- max(abs(pca.df[, c(paste0('PC', xPC), paste0('PC', yPC))])) +
    0.05 * max(abs(pca.df[, c(paste0('PC', xPC), paste0('PC', yPC))]))
  
  # Initialize PCA plot
  pca.plot <- ggplot(pca.df, aes_string(x = paste0('PC', xPC), y = paste0('PC', yPC), color = colorVar)) +
    geom_point(size = 2, alpha = 0.5) +
    coord_equal() +
    labs(x = paste0('PC', xPC, ' (', ve.xPC, '%)'),
         y = paste0('PC', yPC, ' (', ve.yPC, '%)')) + 
    xlim(-limit, limit) + ylim(-limit, limit) +
    theme_classic() +
    theme(axis.line = element_line(size = 1, color = 'black'),
          axis.ticks = element_line(color = 'black'),
          axis.title = element_text(size = 14, face = 'bold', color = 'black'))
  
  # Add custom color scale if provided
  if (!is.null(customColors)) {
    pca.plot <- pca.plot + scale_color_manual(values = customColors)
  }
  
  # Add optional ellipses
  if (ellipse) {
    pca.plot <- pca.plot + stat_ellipse(level = 0.95, aes_string(group = colorVar), linetype = "dashed")
  }
  
  # Calculate loadings
  V <- pca$rotation # Eigenvectors
  L <- diag(pca$sdev) # Diagonal matrix with square roots of eigenvalues
  loadings <- V %*% L
  colnames(loadings) <- colnames(V)  # Assign column names to loadings
  
  # Get loadings for specified PCs and format for plotting
  loadings.xy <- data.frame(loadings[, c(paste0('PC', xPC), paste0('PC', yPC))]) %>%
    dplyr::rename(PCx = paste0('PC', xPC), PCy = paste0('PC', yPC)) %>% 
    mutate(variable = row.names(loadings),
           length = sqrt(PCx^2 + PCy^2),
           ang = atan2(PCy, PCx) * (180 / pi))
  
  loadings.plot <- top_n(loadings.xy, nTaxa, wt = length) 
  
  # Adjust angles to keep labels upright
  loadings.plot <- loadings.plot %>%
    mutate(adj_ang = ifelse(ang < -90, ang + 180,
                     ifelse(ang > 90, ang - 180, ang)))
  
  # Rename loadings with lowest taxonomic level
  loadings.taxtab <- tax_table(ps)[row.names(loadings.plot)] %>% 
    data.frame() 
  loadings.taxtab <- loadings.taxtab[cbind(1:nrow(loadings.taxtab), max.col(!is.na(loadings.taxtab), ties.method = 'last'))] %>%  
    data.frame()
  colnames(loadings.taxtab) <- c("name")
  loadings.taxtab$asv <- tax_table(ps)[row.names(loadings.plot)] %>% 
    data.frame() %>% 
    rownames()
  
  loadings.plot <- loadings.taxtab %>% 
    dplyr::select(asv, name) %>% 
    right_join(loadings.plot, by = c('asv' = 'variable'))
  
  # Determine the quadrant of each label
  q1 <- filter(loadings.plot, PCx > 0 & PCy > 0)
  q2 <- filter(loadings.plot, PCx < 0 & PCy > 0)
  q3 <- filter(loadings.plot, PCx < 0 & PCy < 0)
  q4 <- filter(loadings.plot, PCx > 0 & PCy < 0)
       
  pca.biplot <- 
       pca.plot + 
       geom_segment(data = loadings.plot,
                    aes(x = 0, y = 0, 
                        xend = PCx, yend = PCy),
                    color = 'black',
                    arrow = arrow(angle = 15, 
                                  length = unit(0.1, 'inches'))) + 
    labs(color = colorName)
  
  # Add geom_text for each quadrant with adjusted angle and justification
  if (nrow(q1) != 0) {
       pca.biplot <- pca.biplot +
            geom_text(data = q1, aes(x = PCx, y = PCy, hjust = 0, vjust = 0, angle = adj_ang,
                                     label = name,
                                     fontface = 'bold'),
                      color = 'black', show.legend = FALSE)
  }
  if (nrow(q2) != 0) {
       pca.biplot <- pca.biplot +
            geom_text(data = q2, aes(x = PCx, y = PCy, hjust = 1, vjust = 0, angle = adj_ang,
                                     label = name,
                                     fontface = 'bold'),
                      color = 'black', show.legend = FALSE)
  }
  if (nrow(q3) != 0) {
       pca.biplot <- pca.biplot +
            geom_text(data = q3, aes(x = PCx, y = PCy, hjust = 1, vjust = 1, angle = adj_ang,
                                     label = name,
                                     fontface = 'bold'),
                      color = 'black', show.legend = FALSE)
  }
  if (nrow(q4) != 0) {
       pca.biplot <- pca.biplot +
            geom_text(data = q4, aes(x = PCx, y = PCy, hjust = 0, vjust = 1, angle = adj_ang,
                                     label = name,
                                     fontface = 'bold'),
                      color = 'black', show.legend = FALSE)
  }
  
  return(list(pca.df = pca.df, pca.biplot = pca.biplot, loadings = loadings))
}
```

### Understanding the Output

The `pcaPlot()` function returns three things: `loadings`, representing the PCA loadings; `pca.df`, representing the PCA scores; and `pca.biplot`, the PCA plot.

`loadings` should look like this:

```
$pca.df

$pca.biplot

$loadings
                                                                                     PC1           PC2           PC3
ATCCTTCTTTCCGAAAACAAAATAAAAGTTCAGAAAGTTAAAATAAAAAAGG                        -0.945388925  0.5892904525 -0.0973427943
ATCCTTATTTTGAGAAAACAAAGGTTTATAAAACTAGAATTTAAAAG                              0.098959450 -3.8495772105  0.7049946079
ATCCGTGTTTTGAGAAAACAAGGGGTTCTCGAACTAGAATACAAAGGAAAAG                         1.228102502 -1.5218304409 -0.1646736346
ATCCGTGTTTTGAGAGGGGGGTTCTCGAACTAGAATACAAAGGAAAAG                             2.535100338  0.2163598635 -1.3204555799
ATCCTGGGTTACGCGAACAAAACAGAGTTTAGAAAGCGG                                      1.782297628  0.7683108632  3.2098321172
ATCCTGTTTTCAGAAAACAAGGGTTCAGAAAGCGAGAACCAAAAAAAGGATAG                        0.618113591  0.0999320340 -0.5458098584
ATCCATGTTTTGAGAAAACAAGCGGTTCTCGAACTAGAACCCAAAGGAAAAG                         0.616755384 -0.7076333908 -0.9999314334
```

Each row is an ASV and each column is a principal component. `loadings` represents the degree to which each ASV contributes to each principal component, where the sign indicates the relationship with the PC and the absolute value indicates the strength of contribution. You can use `loadings` to identify which variables drive separation the most.

`pca.df` should look like this:

| name | PC1 | PC2 | PC3 | PC4 | PC5 | PC6 |
| ---- | ---: | ---: | ---: | ---: | ---: | ---: |
| 3-B11 | -8.0250433 | -1.0884380 | 0.6269016 | 1.92399773 | -3.8568241 | 0.0976452 |
| 3-D11 | -7.9289715 | 8.0726668 | -1.6161495 | 1.46896403 | -0.1878901 | -0.3016497 |
| 3-F11 | -10.0973405 | 6.8490332 | -1.1455442 | 1.96876274 | -1.9607628 | 1.3939926 |
| 3-G11 | -11.2714679 | 9.4835516 | -1.4488316 | 2.28493958 | -1.4831855 | 1.4202594 |
| 4-A01 | 5.9251184 | -5.0456726 | -3.6501921 | 5.07511353 | -2.2493445 | -2.9363608 |
| 4-A02 | -4.1142239 | -7.6482507 | 0.1921778 | 3.06642220 | -1.1873046 | -2.5132890 |
| 4-A03 | 1.2596879 | -2.3772487 | 4.0742153 | 0.15822156 | -6.4265191 | 1.8207811 |
| 4-A04 | 4.7598974 | -3.4523810 | -4.5502059 | -2.54135272 | 1.9651763 | 8.6794485 |
| 4-A05 | -3.6920555 | -3.4102144 | -1.5141453 | -0.38240620 | -6.2446326 | 0.8044125 |
| 4-A06 | -0.1208256 | -5.7453982 | -6.2540801 | -4.07782675 | -0.8463138 | 7.7707162 |

Each row is a sample and each column is a principal component or a metadata field. `pca.df` represents the PCA scores for each sample, which allows for plotting sample separation in PCA space, colored by a chosen metadata field.

The PCA plot `pca.biplot` and its interpretation will be covered in the next section.

## Interpreting the PCA Plot

!!! to-do
    
    Replace the PCA below with one from a published, lab-internal cohort.

Below is an example of a PCA plot for us to interpret. It was created with the following line of code:

``` r
pcaPlot(ps.filtered, "age", "Age", 10, c("red", "blue", "green"), ellipse = TRUE)
```

<figure markdown="span">
  ![PCA Plot](images/pca_biplot_light.png#only-light){ width="600" }
  ![PCA Plot](images/pca_biplot_dark.png#only-dark){ width="600" }
  <figcaption></figcaption>
</figure>

The axes show that PC1 explains 8.85% of the total variation in the data, while PC2 explains 6.69%; combined, they explain 15.54% of the variance.

The samples are colored by age. The three groups (mothers, infants at 12 months, and infants at 9 months) each cluster together, indicating similar characteristics within groups; the 12-month and 9-month infants' clusters overlap greatly, indicating high similarity between the infant samples, while the mothers' samples overlap less, suggesting that the composition of the mothers' diets differs noticeably from the diets of infants (as expected). This is shown by the overlap of the dashed ellipses as well, which represent the 95% confidence intervals for each group.

The loadings (variables contributing most to variation) are represented by black arrows; the magnitude of the arrow indicates the influence of that variable on variation in the data, while the direction indicates correlation with the principal components. For example, *Musa* (the banana genus) and *Pyrus communis* (the pear) are more indicative of infant dietary patterns, while *Linum usitatissimum* (flax), *Apiaceae* (the family containing carrots, parsnips, parsley, dill, cumin, and fennel), *Avena* (the oat genus), and *Asteraceae* (the sunflower family) are more indicative of mothers' dietary patterns.
