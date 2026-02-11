# Assigning Common Names

These instructions will help you generate a CSV file for assigning common names and walk you through code for assigning common names to a created phyloseq object. Common names assignment can be done whenever desired during post-phyloseq analysis.

## Creating the Common Names CSV

### Setting Up and Reading In Data

First, load the necessary packages and functions. If you do not have a package installed, install it first with the function `install.packages("[package name]")`.

``` r
library(here)
library(tidyverse)
```

``` r
humanfoods <- read_csv("[path/to/human-foods.csv]")

humanfoods
```

Read in the desired reference, for either trnL or 12Sv5. Make sure you read in the reference with taxonomy:

``` r
taxref <- Biostrings::readDNAStringSet("/Users/ams292/Library/CloudStorage/Box-Box/project_davidlab/LAD_LAB_Personnel/Ashish_S/References/dada2-compatible/[path-to-reference]")

taxref
```

### Pre-Processing and Data Wrangling

Prune human-foods.csv to the desired species:

=== "trnL"

    ``` r
    # Prune to plants only
    dim(humanfoods)
    humanfoods <- 
        humanfoods %>% 
        filter(category == 'plant') %>% 
        select(scientific_name,
                common_name)
    dim(humanfoods)
    ```

    Modify the names of the read-in reference and mutate into a dataframe:

    ``` r
    headers <- names(taxref)
    asv <- as.character(taxref)

    taxa_df <- headers %>%
      # Remove the leading ">" character from headers
      str_remove("^>") %>%
      # Split headers by ";"
      str_split(";") %>%
      # Convert to a dataframe
      map_dfr(~as.data.frame(t(.x), stringsAsFactors = FALSE)) %>%
      # Rename columns for taxonomic ranks
      rename(
        Kingdom = V1, 
        Phylum = V2, 
        Class = V3, 
        Order = V4, 
        Family = V5, 
        Genus = V6, 
        Species = V7, 
        Subspecies = V8,
        Varietas = V9,
        Forma = V10
      )
    
    taxa_df <- taxa_df %>%
      mutate(across(everything(), ~ na_if(., "NA")))

    taxa_df <- taxa_df %>%
      mutate(
        asv = asv,  # Add sequences as a column
        scientific_name = coalesce(Subspecies, Species, Genus)  # Choose the lowest assigned level; for trnL add Varietas and Forma
      ) %>%
      select(asv, everything()) 
    ```

=== "12Sv5"

    ``` r
    # Prune to animals only
    dim(humanfoods)
    humanfoods <- 
        humanfoods %>% 
        filter(category == 'animal') %>% 
        select(scientific_name,
                common_name)
    dim(humanfoods)
    ```

    Modify the names of the read-in reference and mutate into a dataframe:

    ``` r
    headers <- names(taxref)
    asv <- as.character(taxref)

    taxa_df <- headers %>%
      # Remove the leading ">" character from headers
      str_remove("^>") %>%
      # Split headers by ";"
      str_split(";") %>%
      # Convert to a dataframe
      map_dfr(~as.data.frame(t(.x), stringsAsFactors = FALSE)) %>%
      # Rename columns for taxonomic ranks
      rename(
        Kingdom = V1, 
        Phylum = V2, 
        Class = V3, 
        Order = V4, 
        Family = V5, 
        Genus = V6, 
        Species = V7, 
        Subspecies = V8
      )

    taxa_df <- taxa_df %>%
      mutate(across(everything(), ~ na_if(., "NA")))

    taxa_df <- taxa_df %>%
      mutate(
        asv = asv,  # Add sequences as a column
        scientific_name = coalesce(Subspecies, Species, Genus)  # Choose the lowest assigned level; for trnL add Varietas and Forma
      ) %>%
      select(asv, everything()) 
    ```

Join `humanfoods` to `taxa_df` to add in common names:

``` r
taxa_df <- left_join(taxa_df, humanfoods, by = join_by(scientific_name))
```

### Grouping Species and Common Names

Now, collapse the dataframe and concatenate together scientific names and common names:

``` r
# Collapse the dataframe
result <- taxa_df %>%
  group_by(asv) %>%
  summarize(
    # Find the most specific common taxonomic classification
    name = {
      ranks <- c("Species", "Genus", "Family", "Order", "Class", "Phylum", "Kingdom")  # Specific to general
      common_rank <- ranks[sapply(ranks, function(rank) {
        # Exclude NA and check if all remaining values are identical
        values <- na.omit(cur_data()[[rank]])
        length(unique(values)) == 1
      })][1]
      
      if (!is.null(common_rank) && !is.na(common_rank)) {
        # Return the single shared value for the rank
        unique(na.omit(cur_data()[[common_rank]]))
      } else {
        NA_character_  # If no common rank is found, return NA
      }
    },
    # Concatenate scientific names
    taxon = paste(unique(scientific_name), collapse = "; "),
    # Concatenate common names
    common_name = paste(na.omit(unique(common_name)), collapse = "; ")
  ) %>%
  ungroup()  # Remove grouping
```

From this point, standardized taxa-level common names will need to be added in manually.

!!! to-do

    Finalize this page.