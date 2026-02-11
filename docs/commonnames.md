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

From this point, the `result` dataframe will have a `common_name` column containing concatenated species-level common names from `human-foods.csv`. These individual names need to be consolidated into a single standardized name per ASV — a `conventional_name` — that is concise and human-readable. For example, an ASV matching *Fragaria* and *Rubus* species might have a `common_name` of "beach strawberry; scarlet strawberry; strawberry; arctic bramble; cloudberry; ..." but a `conventional_name` of "strawberries, raspberries, and blackberries."

This consolidation is done manually and saved as a new column in the CSV. The lab maintains a curated trnL common names CSV with `conventional_name` already populated for all known ASVs; if you are working with trnL data, you likely do not need to create the CSV from scratch.

!!! note

    The common names CSV also includes `genus` and `genus_conventional_name` columns, which are used by the `assign_common_names()` function (below) to resolve conflicts when an ASV in your phyloseq matches multiple rows in the CSV. These columns are semicolon-separated and map each genus to a conventional name at the genus level.

## Assigning Common Names to a Phyloseq

Once you have a common names CSV — either the lab's existing trnL CSV or one you have created following the steps above — you can use the `assign_common_names()` function to assign those names to your phyloseq object. The function matches each ASV in the phyloseq against the CSV, handles cases where an ASV matches multiple rows, and adds `common_name` and `taxa` columns to the phyloseq's taxonomy table.

### Reading In the Function

Source the function from the R file where it is saved:

``` r
source("[path/to/assign_common_names.R]")
```

### Running the Function

The function takes a phyloseq object and the path to a common names CSV and returns the phyloseq with two new columns appended to the taxonomy table:

``` r
ps <- assign_common_names(ps, "[path/to/common_names.csv]")
```

The inputs of the function are:

* `physeq` (required) — your phyloseq object
* `common_names_csv` (required) — the file path to a common names CSV containing at least the columns `asv`, `taxon`, and `conventional_name`
* `report_conflicts` (optional) — a Boolean that controls whether conflicts (ASVs matching multiple CSV rows) are printed to the console; by default `TRUE`
* `report_all_conflicts` (optional) — a Boolean that controls whether all conflicts are printed or only unresolved ones; by default `TRUE`
* `concatenate_conflicts` (optional) — a Boolean that controls whether unresolved conflicts are concatenated into a single name rather than defaulting to the first match; by default `TRUE`

### Understanding the Output

The function returns the same phyloseq object with two columns added to the taxonomy table:

* `common_name` — the conventional name assigned to each ASV (e.g., "wheat and rye," "bananas and plantains," "oranges, lemons, grapefruits, and other citruses")
* `taxa` — the full set of scientific names associated with the ASV, alphabetized and semicolon-separated

You can view the updated taxonomy table with the following:

``` r
View(as.data.frame(tax_table(ps)))
```

ASVs that did not match any row in the CSV will have `NA` for both `common_name` and `taxa`.

### How Matching Works

The function matches each ASV in the phyloseq's taxonomy table against the `asv` column of the CSV using substring matching. For most ASVs, this produces a single, unambiguous match; the `conventional_name` from that row is assigned directly.

When an ASV matches multiple rows in the CSV — which can happen when a shorter ASV sequence is a substring of multiple longer reference sequences — the function attempts to resolve the conflict using the following strategies, in order:

1. **Superset resolution** — if one matched row's `taxon` field contains all of the species from every other matched row, that row's `conventional_name` is used.
2. **Genus-level resolution** — if the `genus` and `genus_conventional_name` columns in the CSV provide mappings for all genera involved, those genus-level names are merged into a single conventional name.
3. **Partial genus resolution** — if genus-level mappings exist for some but not all genera, the function combines genus-level names with the `conventional_name` values from unresolved rows.
4. **Concatenation** — if none of the above strategies resolve the conflict and `concatenate_conflicts` is `TRUE`, the function merges the `conventional_name` values from all matched rows into a single name using intelligent formatting (consolidating subtypes, deduplicating plurals, and formatting with commas and "and").

The function prints a summary of all conflicts and their resolution methods to the console. You can also access the full conflict report as a dataframe:

``` r
conflicts <- attr(ps, "common_name_conflicts")
View(conflicts)
```

The conflict report includes the ASV sequence, the number of matches, the resolution method used, the assigned name, and all candidate names and taxa. This is useful for auditing assignments and identifying cases that may need manual review.

??? question "When would I need to review conflicts manually?"

    In most cases, the function's resolution strategies produce sensible names automatically. Manual review is most useful when you see `concatenated` or `first_match_default` in the `resolution_method` column of the conflict report, as these indicate cases where the function could not confidently resolve the conflict using taxonomic information alone. You can update the CSV's `conventional_name`, `genus`, or `genus_conventional_name` columns to improve resolution for these ASVs in future runs.