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

=== "Duke"

    ``` r
    taxref <- Biostrings::readDNAStringSet("/Users/[NetID]/Library/CloudStorage/Box-Box/project_davidlab/LAD_LAB_Personnel/Ashish_S/References/dada2-compatible/[path-to-reference]")

    taxref
    ```

=== "General"

    ``` r
    taxref <- Biostrings::readDNAStringSet("[/path/to/references/dada2-compatible/path-to-reference]")

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

## `assign_common_names()` Function

<div class="download-buttons" markdown>
[Download assign_common_names.R](files/assign_common_names.R){ .md-button }
[Download trnL common names CSV](files/trnL_common_names.csv){ .md-button }
</div>

With a common names CSV ready, we can now use the `assign_common_names()` function to assign those names to a phyloseq object. The function matches ASV sequences via substring lookup, resolves multi-match conflicts through superset logic, genus-level resolution, and smart name merging, and propagates common names to unmatched ASVs that share species-level taxonomy with matched siblings. After reading it into your analysis file, run:

``` r
source("[path/to/assign_common_names.R]")

ps <- assign_common_names(ps, "[path/to/common_names.csv]")
```

at minimum to assign common names. The inputs of the function are:

* `physeq` (required) — your phyloseq object
* `common_names_csv` (required) — the file path to a common names CSV containing at least the columns `asv`, `taxon`, and `conventional_name`
* `report_conflicts` (optional) — whether conflicts (ASVs matching multiple CSV rows) are printed to the console; by default `TRUE`
* `report_all_conflicts` (optional) — whether all conflicts are printed or only unresolved ones; by default `TRUE`
* `concatenate_conflicts` (optional) — whether unresolved conflicts are concatenated into a single name rather than defaulting to the first match; by default `TRUE`

The function first reads in the common names CSV and builds a genus-level lookup table from the `genus` and `genus_conventional_name` columns, splitting semicolon-separated entries into individual genus-name pairs:

``` r
common_names <- utils::read.csv(common_names_csv, stringsAsFactors = FALSE)

genus_key <- NULL
if ("genus" %in% colnames(common_names) && "genus_conventional_name" %in% colnames(common_names)) {
  # ...
  genus_list <- list()
  for (idx in which(valid_genus)) {
    genera <- trimws(strsplit(common_names$genus[idx], ";")[[1]])
    conv_names <- trimws(strsplit(common_names$genus_conventional_name[idx], ";")[[1]])

    for (j in seq_along(genera)) {
      if (j <= length(conv_names)) {
        genus_list[[genera[j]]] <- conv_names[j]
      }
    }
  }

  if (length(genus_list) > 0) {
    genus_key <- unlist(genus_list)
  }
}
```

Next, it extracts the taxonomy table and ASV sequences from the phyloseq and initializes `common_name` and `taxa` columns:

``` r
tax_tab <- as.data.frame(phyloseq::tax_table(physeq))

if ("ASV" %in% colnames(tax_tab)) {
  asv_seqs <- tax_tab$ASV
} else {
  asv_seqs <- rownames(tax_tab)
}

tax_tab$common_name <- NA_character_
tax_tab$taxa <- NA_character_
```

The function also defines a set of internal helper functions for string manipulation (`singularize()`, `pluralize()`, `consolidate_subtypes()`, `deduplicate_with_plurals()`, and others) used to intelligently merge conventional names when conflicts arise — for example, consolidating "wild rice" and "rice" into "rices," or deduplicating plural forms. These are wrapped by `smart_merge_names()`, which applies them in sequence.

The main matching loop iterates over each ASV in the phyloseq and uses `grepl()` for substring matching against the `asv` column of the CSV. For most ASVs this produces a single match, and the `conventional_name` from that row is assigned directly:

``` r
for (i in seq_along(asv_seqs)) {
  query_seq <- asv_seqs[i]
  matches <- grepl(query_seq, common_names$asv, fixed = TRUE)

  if (sum(matches) == 0) {
    next
  } else if (sum(matches) == 1) {
    tax_tab$common_name[i] <- common_names$conventional_name[matches]
    tax_tab$taxa[i] <- common_names$taxon[matches]
  } else {
    # Multiple matches — attempt to resolve (see below)
  }
}
```

When an ASV matches multiple rows — which can happen when a shorter ASV sequence is a substring of multiple longer reference sequences — the function tries three resolution strategies in order. First, it checks whether one matched row's `taxon` field is a superset of all others:

``` r
for (j in seq_along(matched_taxa)) {
  species_j <- strsplit(matched_taxa[j], "; ")[[1]]
  is_superset_of_all <- TRUE
  for (k in seq_along(matched_taxa)) {
    if (j == k) next
    species_k <- strsplit(matched_taxa[k], "; ")[[1]]
    if (!all(species_k %in% species_j)) {
      is_superset_of_all <- FALSE
      break
    }
  }
  if (is_superset_of_all) {
    tax_tab$common_name[i] <- matched_conv_names[j]
    resolution_method <- "superset"
    resolved <- TRUE
    break
  }
}
```

If that does not resolve the conflict, it attempts genus-level resolution using the `genus_key` lookup built earlier:

``` r
if (!resolved && !is.null(genus_key)) {
  all_genera <- unique(unlist(lapply(matched_taxa, extract_genera)))
  genus_common_names <- genus_key[all_genera]
  genus_common_names <- genus_common_names[!is.na(genus_common_names)]

  if (length(genus_common_names) == length(all_genera) && length(all_genera) > 0) {
    # All genera have mappings — merge them
    formatted_name <- smart_merge_names(genus_common_names)
    tax_tab$common_name[i] <- formatted_name
    resolved <- TRUE
  } else if (length(genus_common_names) > 0) {
    # Partial resolution — combine genus-level and row-level names
    # ...
  }
}
```

Finally, if the conflict is still unresolved and `concatenate_conflicts` is `TRUE`, it merges the matched `conventional_name` values with `smart_merge_names()`:

``` r
if (!resolved) {
  if (concatenate_conflicts) {
    unique_names <- unique(matched_conv_names[matched_conv_names != "" & !is.na(matched_conv_names)])
    if (length(unique_names) > 0) {
      formatted_name <- smart_merge_names(unique_names)
      tax_tab$common_name[i] <- formatted_name
      resolution_method <- "concatenated"
    }
  }
}
```

All conflicts are recorded in a dataframe that is stored as an attribute on the returned phyloseq.

### Species-Level Propagation

After the main matching loop, the function makes a second pass over ASVs that did not match any row in the CSV. If such an ASV has a species-level (or below) taxonomy assignment, the function looks for sibling ASVs that share the same species/subspecies/varietas/forma classification and already have a common name assigned. If all siblings agree on a single unambiguous name, that name is propagated to the unmatched ASV:

``` r
has_species <- !is.na(tax_tab[[sp_col]]) & nzchar(tax_tab[[sp_col]])
needs_name  <- is.na(tax_tab$common_name) & has_species
has_name    <- !is.na(tax_tab$common_name) & has_species

for (i in which(needs_name)) {
  donors <- which(has_name & species_key == species_key[i])
  if (length(donors) > 0) {
    donor_names <- unique(tax_tab$common_name[donors])
    if (length(donor_names) == 1) {
      tax_tab$common_name[i] <- donor_names
    }
  }
}
```

This handles the common case where differential trimming across sequencing runs produces slightly different ASV sequences for the same organism: the longer or shorter variant may not appear in the CSV, but a sibling ASV with the same species assignment does. The function reports how many ASVs were propagated and how many were skipped due to ambiguity (multiple different common names for the same species).

### Understanding the Output

The function returns the same phyloseq with two columns added to the taxonomy table: `common_name`, the conventional name assigned to each ASV (e.g., "wheat and rye," "bananas and plantains"); and `taxa`, the full set of scientific names associated with the ASV, alphabetized and semicolon-separated. ASVs that did not match any row in the CSV will have `NA` for both columns. You can view the updated taxonomy table with:

``` r
View(as.data.frame(tax_table(ps)))
```

The function also prints a summary of all conflicts and their resolution methods to the console. You can access the full conflict report as a dataframe with:

``` r
conflicts <- attr(ps, "common_name_conflicts")
View(conflicts)
```

The conflict report includes the ASV sequence, the number of matches, the resolution method, the assigned name, and all candidate names and taxa.

??? question "Why would I need to review conflicts manually?"

    In most cases the function's resolution strategies produce sensible names automatically. Manual review is most useful when you see `concatenated` or `first_match_default` in the `resolution_method` column of the conflict report, as these indicate cases where the function could not confidently resolve the conflict using taxonomic information alone. You can update the CSV's `conventional_name`, `genus`, or `genus_conventional_name` columns to improve resolution for these ASVs in future runs.


!!! note "Avoid blanket agglomeration by common name"

    For trnL, we strongly advise against performing a blanket agglomeration (`tax_glom()`) by common name. Grouping by common name risks silently merging biologically distinct organisms. If grouping is needed for nutritional analysis, it should be done manually and deliberately.

## Known Issues

### Human/Elk 

!!! warning "User action required"

    In the 12Sv5 region, human and elk are phylogenetically similar. We have found that ASVs assigned to elk (*Cervus canadensis*) are not reliably elk: some BLAST to human, others to elk. Users should recheck elk-labeled ASVs and decide whether to manually relabel them as human, based on context.

### Pecan/Walnut

!!! warning "User action required"

    Pecan and walnut ASVs cannot be reliably distinguished. The two species differ by only a single nucleotide, and within a given sample the error-correction step labels reads as one or the other. As a result, pecan and walnut are never both present in the same sample. Users must manually merge these ASVs, labeling them with a combined name (e.g., `pecan/walnut`).

