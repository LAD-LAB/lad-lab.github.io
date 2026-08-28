# Creating the References

These instructions will help you create a trnL or 12Sv5 reference for use in creating phyloseq objects. Where code differs between the two references, largely just due to differences in the naming of variables, content tabs have been used to allow selection of the code for the gene of interest; tabs are linked such that selecting "12Sv5" for one tab will switch all tabs on this page to "12Sv5."

!!! info "A newer reference-building pipeline is in beta"

    The process described on this page is the established one. A newer, more automated pipeline lives in the [food-dbs repository](https://github.com/LAD-LAB/food-dbs), where `foodseq_reference_pipeline.Rmd` builds the references end to end and writes both DADA2- and QIIME2-formatted output. It is still in beta testing and has not replaced the workflow below, so treat it as a preview rather than the current standard.

## Setting Up and Reading in Data

First, load the necessary packages and functions. If you do not have a package installed, install it first with the function `install.packages("[package name]")`. Make sure to replace the paths to `find_primer_pair.R`, `query_ncbi.R`, and `query_ncbi_accession.R`.

``` r
library(Biostrings)
library(here)
library(ShortRead) # for clean()
library(taxonomizr) # for NCBI accession lookup
library(tidyverse)

source('/path/to/code/functions/find_primer_pair.R')
source('/path/to/code/functions/query_ncbi.R')
source('/path/to/code/functions/query_ncbi_accession.R')
```

``` r
theme_set(theme_bw() +
               theme(
                    axis.text = element_text(size = 12),
                    axis.title = element_text(size = 14,
                                              face = 'bold'),
                    legend.title = element_text(size = 12,
                                                face = 'bold'),
                    strip.text = element_text(size = 12,
                                              face = 'bold')
                     )
)
```

Read in primers, food species, and RefSeq data for the gene of interest:

=== "trnL"

    ``` r
    # Primer sequences 
    trnLG <- DNAString('GGGCAATCCTGAGCCAA')
    trnLH <- DNAString('CCATTGAGTCTCTGCACCTATC')

    primers <- list(trnLG, trnLH)
    ```

    ``` r
    # Manually curated list of dietary and medicinal plants
    plants <- 
        read.csv('[path/to/human-foods.csv]', stringsAsFactors = FALSE) |>
        filter(category == 'plant') |> 
        pull(scientific_name)

    length(plants)
    head(plants)
    tail(plants)
    ```

    ``` r
    # Manual edits
    edits <- read_csv('[path/to/data/inputs/Manual renaming.csv]') 

    edits
    ```

    ``` r
    # Parsed RefSeq data (last organized Jan 2023)
    plastid <- 
        readDNAStringSet(
            here('data', 
                'outputs', 
                'parsed-refs',
                'RefSeq',
                'refseq_plastid_species.fasta'))

    plastid
    ```

=== "12Sv5"

    ``` r
    # Primer sequences
    v5F <- DNAString('TAGAACAGGCTCCTCTAG')
    v5R <- DNAString('TTAGATACCCCACTATGC')

    primers <- list(v5F, v5R)
    ```

    ???+ note

        Variables in R cannot begin with a number, so instead of `12Sv5F` and `12Sv5R` we are using `v5F` and `v5R`.

    ``` r
    # Manually curated list of dietary animals
    animals <- 
        read.csv('[path/to/human-foods.csv]', stringsAsFactors = FALSE) |>
        filter(category == 'animal') |> 
        pull(scientific_name)

    length(animals)
    head(animals)
    tail(animals)
    ```

    ``` r
    # Parsed RefSeq data (last organized Jan 2023)
    mito <- 
        readDNAStringSet(
            here('data', 
                'outputs', 
                'parsed-refs',
                'RefSeq',
                'refseq_mito_species.fasta'))

    mito
    ```

Also, read in the SQL file (see [Creating the SQL File](sql.md) for more information):

=== "Duke"

    Make sure you are connected to Isilon:

    ``` r
    # SQL reference
    sql <- '/Volumes/All_Staff/personal_backups/ashish/ncbi_taxonomy/accessionTaxa.sql'
    ```

=== "General"

    ``` r
    # SQL reference
    sql <- '[/path/to/accessionTaxa.sql]'
    ```

## Querying for Sequences

With everything read in, we now need to determine the sequences from both RefSeq (saved locally) and the NCBI that belong to food species and have the gene of interest as determined by our primers.

### RefSeq

=== "trnL"

    First, clean the RefSeq sequences and determine which sequences have the primer pair:

    ``` r
    # Note that there are lots of sequences that include Ns
    length(plastid)
    length(clean(plastid))
    ```

    ``` r
    refseq.trnL <- find_primer_pair(plastid, 
                                    fwd = primers[[1]],
                                    rev = primers[[2]])

    cat(length(refseq.trnL), 'sequences have the primer set')
    ```

    Next, subset the sequences to our list of food species and keep the accessions:

    ``` r
    # Find indices of entries matching 
    plants.i <- 
        lapply(plants, grep, x = names(refseq.trnL)) %>%
        unlist()

    cat('There are', length(plants), 'food plants in our query\n')

    # Subset
    refseq.trnL <- refseq.trnL[plants.i]
    cat(length(refseq.trnL), 'have a trnL sequence in the RefSeq plastid database')
    ```

    ``` r
    # Strip name to only NCBI accession
    names(refseq.trnL) %>% head()

    names(refseq.trnL) <- 
        gsub(names(refseq.trnL),
            pattern = ' .*$',
            replacement = '')

    head(names(refseq.trnL))
    ```

=== "12Sv5"

    First, clean the RefSeq sequences and determine which sequences have the primer pair:

    ``` r
    # Note that there are lots of sequences that include Ns
    length(mito)
    length(clean(mito))
    ```

    ``` r
    refseq.12SV5 <- find_primer_pair(mito, 
                                    fwd = primers[[1]],
                                    rev = primers[[2]])

    cat(length(refseq.12SV5), 'sequences have the primer set')
    ```

    Next, subset the sequences to our list of food species and keep the accessions:

    ``` r
    # Find indices of entries matching 
    animals.i <- 
        lapply(animals, grep, x = names(refseq.12SV5)) %>%
        unlist()

    cat('There are', length(animals), 'food animals in our query\n')

    # Subset
    refseq.12SV5 <- refseq.12SV5[animals.i]
    cat(length(refseq.12SV5), 'have a 12SV5 sequence in the RefSeq mito database')
    ```

    ``` r
    # Strip name to only NCBI accession
    names(refseq.12SV5) %>% head()        

    names(refseq.12SV5) <- 
        gsub(names(refseq.12SV5),
            pattern = ' .*$',
            replacement = '')

    head(names(refseq.12SV5))
        
    ```

### NCBI

!!! tip

    The NCBI query may prove tedious, especially for 12Sv5; for best results:

    * Set an API key. Create an NCBI account (you can log in with Google) and go to [NCBI Account Settings](https://account.ncbi.nlm.nih.gov/settings/). At the bottom of the page, under "API Key Management," you should find an alphanumeric API key. Copy this, and in R, run `set_entrez_key("1a2b3c")` with your API key pasted in. This increases your e-utils limit to 10 requests per second.
    * Run the following code either on weekends or between 9:00 PM and 5:00 AM EST on weekdays.
    * Other usage guidelines and requirements can be found at [this link](https://www.ncbi.nlm.nih.gov/books/NBK25497/#chapter2.Usage_Guidelines_and_Requiremen).

=== "trnL"

    Use the custom `query_ncbi()` function to query the NCBI for trnL sequences from food species:

    ``` r
    # Pull sequences from NCBI
    ncbi.trnL <- query_ncbi(marker = 'trnL',
                            organisms = plants)
    ```

    ``` r
    length(ncbi.trnL)
    length(clean(ncbi.trnL))
    ```

    Determine which sequences have the primer pair:

    ``` r
    ncbi.trnL <- find_primer_pair(ncbi.trnL, 
                                fwd = primers[[1]],
                                rev = primers[[2]])

    cat(length(ncbi.trnL), 'sequences have the primer set')
    ```

    Remove unverified entries:

    ``` r
    # Note some entries are marked as unverified
    names(ncbi.trnL)[grepl('UNVERIFIED', names(ncbi.trnL))] |> 
        head(5)

    # Remove 
    length(ncbi.trnL)
    ncbi.trnL <- ncbi.trnL[!(grepl('UNVERIFIED', names(ncbi.trnL)))]
    length(ncbi.trnL)
    ```

    And last, strip the names to just their accessions:

    ``` r
    # Strip name to only NCBI accession
    names(ncbi.trnL) |> head()
    names(ncbi.trnL) <- 
        names(ncbi.trnL) |> 
        gsub(pattern = ' .+$', replacement = '') |> 
        gsub(pattern = '^>', replacement = '')

    head(names(ncbi.trnL))
    ```

=== "12Sv5"

    Use the custom `query_ncbi()` function to query the NCBI for 12Sv5 sequences from food species:

    ``` r
    # Pull sequences from NCBI
    ncbi.12SV5 <- query_ncbi(marker = '12S',
                            organisms = animals)
    ```

    ``` r
    length(ncbi.12SV5)
    length(clean(ncbi.12SV5))
    ```

    Determine which sequences have the primer pair:

    ``` r
    ncbi.12SV5 <- find_primer_pair(ncbi.12SV5, 
                                fwd = primers[[1]],
                                rev = primers[[2]])

    cat(length(ncbi.12SV5), 'sequences have the primer set')
    ```

    Remove unverified entries:

    ``` r
    # Note some entries are marked as unverified
    names(ncbi.12SV5)[grepl('UNVERIFIED', names(ncbi.12SV5))] |> 
        head(5)

    # Remove 
    length(ncbi.12SV5)
    ncbi.12SV5 <- ncbi.12SV5[!(grepl('UNVERIFIED', names(ncbi.12SV5)))]
    length(ncbi.12SV5)
    ```

    And last, strip the names to just their accessions:

    ``` r
    # Strip name to only NCBI accession
    names(ncbi.12SV5) |> head()
    names(ncbi.12SV5) <- 
        names(ncbi.12SV5) |> 
        gsub(pattern = ' .+$', replacement = '') |> 
        gsub(pattern = '^>', replacement = '')

    head(names(ncbi.12SV5))
    ```

## Combining RefSeq and NCBI Output

We can now merge the output of the above queries.

=== "trnL"

    First, let's check the degree of overlap:

    ``` r
    length(refseq.trnL)
    length(ncbi.trnL)
    ```

    ``` r
    # Named as accession numbers:
    intersect(names(ncbi.trnL), names(refseq.trnL)) |> length()
    setdiff(names(refseq.trnL), names(ncbi.trnL)) |> length()
    setdiff(names(ncbi.trnL), names(refseq.trnL)) |> length()
    ```

    ??? note

        Theoretically, RefSeq should be entirely contained within NCBI's nucleotide record, but the above output will show that there are entries unique to RefSeq in our output. This may be because we restrict the NCBI query to entries containing the term "trnL" in order to keep the output manageable; this can be an area for future updates.

    We can now merge:

    ``` r
    # Data frame of results
    seqs.df <- 
        data.frame(source = 'RefSeq',
                    accession = names(refseq.trnL),
                    seq = as.character(refseq.trnL))

    seqs.df <- 
        data.frame(source = 'GenBank',
                    accession = names(ncbi.trnL),
                    seq = as.character(ncbi.trnL)) |> 
        bind_rows(seqs.df)

    head(seqs.df)
    ```

    For trnL only, manual additions must be added in as well:

    ``` r
    # Also add manual additions here
    additions <- filter(edits, type == 'add')
    additions
    ```

    ``` r
    # Note that these don't have primers currently
    # To get the most accurate sequence, let's just pull these records from NCBI by their accession number and trim directly
    # Note some of these returned sequences are whole genomes-- takes a few mins.
    seqs <- 
        entrez_fetch(db='nucleotide', 
                    id = additions$accession, 
                    rettype='fasta') %>%
        # This returns concatenated sequence strings; split apart 
        # so we can re-name inline
        strsplit('\n{2,}') %>% # Usually two newline chars, but sometimes more
        unlist()

    # Save this to ultimately combine with taxonomy data, as want to
    # be able to identify these sequences after the fact
    ex <- '[^>]\\S*' 
    accs <- str_extract(seqs, ex) 

    # Keep full header for descriptive name
    headers <- str_extract(seqs, '^[^\n]*')

    seqs <- 
        seqs %>%
        # Now update seqs to sequence only, stripping header
        sub('^[^\n]*\n', '', .) %>%
        # And removing separating \n characters
        gsub('\n', '', .)

    # Now add to DNAStringSet
    seqs <- DNAStringSet(seqs)
    names(seqs) <- accs

    seqs <- find_primer_pair(seqs, 
                            fwd = primers[[1]],
                            rev = primers[[2]])
    ```

    ``` r
    # This leaves 'source' labeled as NA for these entries
    seqs.df <-
        data.frame(seq = as.character(seqs),
                    accession = names(seqs)) |> 
        bind_rows(seqs.df) 
    ```

=== "12Sv5"

    First, let's check the degree of overlap:

    ``` r
    length(refseq.12SV5)
    length(ncbi.12SV5)
    ```

    ``` r
    # Named as accession numbers:
    intersect(names(ncbi.12SV5), names(refseq.12SV5)) |> length()
    setdiff(names(refseq.12SV5), names(ncbi.12SV5)) |> length()
    setdiff(names(ncbi.12SV5), names(refseq.12SV5)) |> length()
    ```

    ??? note

        Theoretically, RefSeq should be entirely contained within NCBI's nucleotide record, but the above output will show that there are entries unique to RefSeq in our output. This may be because we restrict the NCBI query to entries containing the term "trnL" in order to keep the output manageable; this can be an area for future updates.

    We can now merge:

    ``` r
    # Data frame of results
    seqs.df <- 
        data.frame(source = 'RefSeq',
                    accession = names(refseq.12SV5),
                    seq = as.character(refseq.12SV5))

    seqs.df <- 
        data.frame(source = 'GenBank',
                    accession = names(ncbi.12SV5),
                    seq = as.character(ncbi.12SV5)) |> 
        bind_rows(seqs.df)

    head(seqs.df)
    ```

## Adding Taxonomy

Now, let's use the SQL file to connect accessions to taxon IDs:

``` r
# Look up accession taxonomy using taxonomizr-formatted SQL database
ids <- taxonomizr::accessionToTaxa(seqs.df$accession, sql)
```

The following code chunks determine if there are names missing and fill them in:

``` r
# Any names missing?
any(is.na(ids))
sum(is.na(ids))
```

``` r
# Which ones?
missing.df <- seqs.df[is.na(ids), c('source', 'accession')]
missing.df
```

Missing entries are sequence records that have been added to NCBI in the time between making the SQL file and now. Using the `query_ncbi_accession()` function, iterate through `missing.df` and add these records in:

``` r
for(i in seq_len(nrow(missing.df))) {
     idx <- rownames(missing.df)[i]
     idx <- as.integer(idx)
     acc <- missing.df[i,2]
     ids[idx] <- query_ncbi_accession(acc)
}

# Confirm got them all
any(is.na(ids))
```

Using the `taxonomizr` package, we can now get taxonomic information from the taxon IDs:

``` r
taxonomy.raw <- taxonomizr::getRawTaxonomy(ids, sql)
```

We can reformat this output to suit our needs by selecting the ranks we're interested in and adding taxon IDs for joining back to accessions:

``` r
# Pull desired levels from this structure
# Not working within getTaxonomy function
vars <- c("superkingdom", 
          "phylum", 
          "class", 
          "order", 
          "family", 
          "genus",
          "species",
          "subspecies")

taxonomy <- data.frame(superkingdom = NULL,
                       phylum = NULL,
                       class = NULL,
                       order = NULL,
                       family = NULL,
                       genus = NULL,
                       species = NULL,
                       subspecies = NULL)

for (i in seq_along(taxonomy.raw)){
     row.i <- 
          taxonomy.raw[[i]] |> 
          t() |> 
          data.frame() 
     
     # Pick columns we're interested in
     shared <- intersect(vars, names(row.i))
     row.i <- select(row.i, one_of(shared))
     
     taxonomy <- bind_rows(taxonomy, row.i)
}

# Add taxon ID
taxonomy$taxid <- 
     names(taxonomy.raw) |> 
     trimws() |> 
     as.integer()

taxonomy <- select(taxonomy, taxid, everything())
```

Now join `taxonomy` back to `seqs.df`:

``` r
# Join back to accession
nrow(taxonomy) == nrow(seqs.df)

seqs.df <- 
     bind_cols(seqs.df,
               taxonomy)
```

Now get the lowest-level taxon name and filter `seqs.df` for the desired columns:

``` r
# Get lowest-level taxon name
seqs.df <- 
     seqs.df |> 
     MButils::lowest_level() |>
     rename(taxon = 'name') |> 
     select(source, accession, taxon, taxid, superkingdom:subspecies, seq)
```

## Manual Updates (trnL only)

For trnL only, we must manually rename and omit certain foods; this is done with the `edits` CSV read in earlier, which has a column `type` corresponding to the necessary change (foods whose `type` is `add` were added when we merged the RefSeq and NCBI outputs). First we can omit the foods whose `type` is `omit`:

``` r
# Handle omissions
omit <- filter(edits, type=='omit')

seqs.df <- 
     filter(seqs.df, 
            !(accession %in% omit$accession & seq %in% omit$sequence))
```

Next we rename the foods whose `type` is `rename`:

``` r
# Handle renaming 
name.update <- filter(edits, type=='rename')

filter(seqs.df,
       accession %in% name.update$accession)
```

The following manual changes are to varietates of *Brassica oleracea* in `seqs.df`:

``` r
# Note that original sequence 'AC183493.1' not found, leaving off for now
# Will need to generalize this later, but now can just update specifically
seqs.df$varietas[seqs.df$accession == 'AB213010.1'] <- 'Brassica oleracea var. capitata'
seqs.df$varietas[seqs.df$accession == 'AC183493.1'] <- 'Brassica oleracea var. alboglabra'
seqs.df$varietas[seqs.df$accession == 'LR031874.1'] <- 'Brassica oleracea var. italica'
seqs.df$varietas[seqs.df$accession == 'LR031875.1'] <- 'Brassica oleracea var. italica'
seqs.df$varietas[seqs.df$accession == 'LR031876.1'] <- 'Brassica oleracea var. italica'
```

``` r
# Get lowest-level taxon name
seqs.df <- 
     seqs.df |> 
     MButils::lowest_level() |>
     rename(taxon = 'name') |> 
     select(source, accession, taxon, taxid, superkingdom:forma, seq)
```

## Quality Control, Sequence Alignment, and Cleaning

We can now do some quality control on `seqs.df`. Let's first check for nucleotide degeneracy (any codes that are not A, C, G, or T) and determine if there are "back-up" sequences to allow for removing degenerate sequences:

``` r
# Check for degenerate nucleotide characters
grep('[AGCT]*[^AGCT]+', seqs.df$seq)
```

``` r
# Add a flag to these taxa, to see if there's a back-up sequence
seqs.df$N <- grepl('[AGCT]*[^AGCT]+', seqs.df$seq)

with_n <- 
     seqs.df$taxon[grepl('[AGCT]*[^AGCT]+', seqs.df$seq)] |> 
     unique()
```

``` r
seqs.df |> 
     filter(taxon %in% with_n) |> 
     group_by(taxon, N) |> 
     count() |> 
     ungroup() |> 
     group_by(taxon) |> 
     summarize(any(!N)) |> 
     arrange(`any(!N)`)
```

``` r
# Remove sequences containing Ns
seqs.df <- 
     filter(seqs.df,
            !grepl(pattern = '[AGCT]*[^AGCT]+', seq))
```

Now, let's align sequence orientations.

=== "trnL"

    The following code sets maximum allowed mismatch thresholds as 20% of the lengths of the forward and reverse primers:

    ``` r
    # Get orientation of sequence by finding primers
    # How many mismatches are allowed?
    fwd_err <- floor(0.2*length(trnLG))
    rev_err <- floor(0.2*length(trnLH))

    fwd_err
    rev_err
    ```

    Now, we feed the sequences from `seqs.df` into a `DNAStringSet` object:

    ``` r
    ref <- DNAStringSet(seqs.df$seq)
    names(ref) <- paste(seqs.df$accession, seqs.df$taxon)
    ```

    The following code finds forward and reverse primer matches, combines them back into `seqs.df`, and checks that no sequences were lost:

    ``` r
    # Forward primer at start of read
    fwd_matches <- 
        vmatchPattern(trnLG, 
                    ref, 
                    max.mismatch = fwd_err,
                    fixed = TRUE) |>
        as.data.frame() |> 
        filter(start <= 1) |> 
        mutate(type = 'forward') |> 
        select(group, type)

    # Reverse primer at start of read
    rev_matches <- 
        vmatchPattern(trnLH, 
                    ref, 
                    max.mismatch = rev_err,
                    fixed = TRUE) |>
        as.data.frame() |> 
        filter(start <= 1) |> 
        mutate(type = 'reverse') |> 
        select(group, type)
    ```

    ``` r
    seqs.df <- 
        bind_rows(fwd_matches,
            rev_matches) |> 
        arrange(group) |> 
        bind_cols(seqs.df)

    seqs.df |> 
        group_by(type) |> 
        count()
    ```

    ``` r
    nrow(rev_matches) + nrow(fwd_matches) == nrow(seqs.df)
    ```

    This code now corrects reverse-oriented sequences with the `reverseComplement()` function:

    ``` r
    seqs.df <- 
        mutate(seqs.df,
                seq = ifelse(type == 'reverse',
                            yes = seq |> 
                                DNAStringSet() |> 
                                reverseComplement() |> 
                                as.character(),
                            no = seq)) |> 
        select(-c(type, group))
    ```

=== "12Sv5"

    The following code sets maximum allowed mismatch thresholds as 20% of the lengths of the forward and reverse primers:

    ``` r
    # Get orientation of sequence by finding primers
    # How many mismatches are allowed?
    fwd_err <- floor(0.2*length(v5F))
    rev_err <- floor(0.2*length(v5R))

    fwd_err
    rev_err
    ```

    Now, we feed the sequences from `seqs.df` into a `DNAStringSet` object:

    ``` r
    ref <- DNAStringSet(seqs.df$seq)
    names(ref) <- paste(seqs.df$accession, seqs.df$taxon)
    ```

    The following code finds forward and reverse primer matches, combines them back into `seqs.df`, and checks that no sequences were lost:

    ``` r
    # Forward primer at start of read
    fwd_matches <- 
        vmatchPattern(v5F, 
                    ref, 
                    max.mismatch = fwd_err,
                    fixed = TRUE) |>
        as.data.frame() |> 
        filter(start <= 1) |> 
        mutate(type = 'forward') |> 
        select(group, type)

    # Reverse primer at start of read
    rev_matches <- 
        vmatchPattern(v5R, 
                    ref, 
                    max.mismatch = rev_err,
                    fixed = TRUE) |>
        as.data.frame() |> 
        filter(start <= 1) |> 
        mutate(type = 'reverse') |> 
        select(group, type)
    ```

    ``` r
    seqs.df <- 
        bind_rows(fwd_matches,
            rev_matches) |> 
        arrange(group) |> 
        bind_cols(seqs.df)

    seqs.df |> 
        group_by(type) |> 
        count()
    ```

    ``` r
    nrow(rev_matches) + nrow(fwd_matches) == nrow(seqs.df)
    ```

    This code now corrects reverse-oriented sequences with the `reverseComplement()` function:

    ``` r
    seqs.df <- 
        mutate(seqs.df,
                seq = ifelse(type == 'reverse',
                            yes = seq |> 
                                DNAStringSet() |> 
                                reverseComplement() |> 
                                as.character(),
                            no = seq)) |> 
        select(-c(type, group))
    ```

The last step is now removing redundant sequences which are the same and come from the same species:

```{r}
seqs.df |> 
     group_by(taxon, seq)
```

```{r}
dups <- 
     seqs.df |> 
     group_by(taxon) |> 
     summarize(n = sum(duplicated(seq)))

arrange(dups, desc(n))
```

How many duplicates are there?

```{r}
sum(dups$n)
```

The number of sequences we expect after filtering is given by:

```{r}
dim(seqs.df)[1] - sum(dups$n)
```

This now groups identical entries, choosing the first accession number which is from RefSeq if possible, effectively removing duplicates. trnL carries the subspecific ranks `varietas` and `forma` through this step; 12Sv5 stops at `subspecies`.

=== "trnL"

    ``` r
    seqs.df <- 
         seqs.df |>
         group_by(superkingdom,
                  phylum,
                  class,
                  order,
                  family,
                  genus,
                  species,
                  subspecies,
                  varietas,
                  forma, 
                  taxon, 
                  seq) |> 
         arrange(desc(source), accession) |> # Puts RefSeq accessions first 
         summarize(accession = first(accession)) # Choose the first accession number

    dim(seqs.df)
    ```

=== "12Sv5"

    ``` r
    seqs.df <- 
         seqs.df |>
         group_by(superkingdom,
                  phylum,
                  class,
                  order,
                  family,
                  genus,
                  species,
                  subspecies,
                  taxon, 
                  seq) |> 
         arrange(desc(source), accession) |> # Puts RefSeq accessions first 
         summarize(accession = first(accession)) # Choose the first accession number

    dim(seqs.df)
    ```

## Adding Human Sequences to the 12Sv5 Reference

The NCBI contains only a single *Homo sapiens* reference sequence for the 12Sv5 region, which is insufficient for accurately assigning all human ASVs in our data due to natural genetic diversity across individuals. To address this, we supplement the 12Sv5 reference with human sequences from Schneider et al. (2021), who compiled a 12S reference from the European Nucleotide Archive (ENA) for forensic dietary analysis and included substantially more *Homo sapiens* sequence variants.

After building the 12Sv5 reference with the steps above, add the human sequences from the Schneider reference by extracting all *Homo sapiens* entries and appending them to `seqs.df`. These sequences should go through the same quality control and deduplication steps described in the previous section.

!!! note

    Schneider J, Mas-Carrió E, Jan C, Miquel C, Taberlet P, Michaud K, Fumagalli L, Comprehensive coverage of human last meal components revealed by a forensic DNA metabarcoding approach. *Sci. Rep.* **11**, 8876 (2021). [https://doi.org/10.1038/s41598-021-88418-x](https://doi.org/10.1038/s41598-021-88418-x)

## Saving the References

Each marker is saved as a FASTA whose headers carry the full taxonomic lineage. This is the file you point `ref_trnL` or `ref_12S` at in [Pipeline-to-Phyloseq](pipeline.md#creating-the-taxonomy-table), and the same file [`assign_common_names()`](commonnames.md) reads. The markers differ in how many ranks go in the lineage.

!!! note

    trnL lineages run through `forma`; 12Sv5 lineages stop at `subspecies`. Each marker's assignment function expects its own depth, so do not copy one `unite()` call across to the other.

### DADA2-formatted reference files

!!! warning

    The `writeXStringSet()` calls below overwrite the current version of the reference. Check that this is what you want before running them.

=== "trnL"

    This section produces `trnLGH_taxonomy.fasta`, which names each sequence by its full lineage across ten ranks. `assignment_trnL()` matches your ASVs against the sequences and reads the lineage off the header of whatever it matched.

    Sort the sequences, then name each one by its full lineage:

    ``` r
    # Sort alphabetically (first by species name, and then accession number)
    seqs.df <- arrange(seqs.df, 
                       taxon,
                       accession)

    seqs.df <- 
         seqs.df |> 
         unite(col = 'name',
               superkingdom:forma,
               sep = ';') 

    # Convert back to DNAStringSet object
    trnL <- seqs.df$seq
    names(trnL) <- seqs.df$name

    trnL <- DNAStringSet(trnL)
    trnL
    ```

    ``` r
    # Save to file
    writeXStringSet(trnL,
                    here('data',
                         'outputs',
                         'dada2-compatible',
                         'trnL',
                         'trnLGH_taxonomy.fasta'))
    ```

    ??? note "Legacy: `trnLGH.fasta`"

        An accession-named copy of the same sequences can also be created using the code below, for the older `assignSpecies()` workflow. Under that workflow the header was an accession, so a match told you which record hit but not its taxonomy, and a separate SQL lookup turned that accession into a lineage.

        ``` r
        names(trnL) <- paste(seqs.df$accession, seqs.df$taxon)

        writeXStringSet(trnL,
                        here('data',
                             'outputs',
                             'dada2-compatible',
                             'trnL',
                             'trnLGH.fasta'))
        ```

=== "12Sv5"

    This section produces `12Sv5_taxonomy.fasta`, which names each sequence by its full lineage across eight ranks.

    Sort the sequences, then name each one by its full lineage:

    ``` r
    # Sort alphabetically (first by species name, and then accession number)
    seqs.df <- arrange(seqs.df, 
                       taxon,
                       accession)

    seqs.df <- 
         seqs.df |> 
         unite(col = 'name',
               superkingdom:subspecies,
               sep = ';') 

    # Convert back to DNAStringSet object
    ref <- seqs.df$seq
    names(ref) <- seqs.df$name

    ref <- DNAStringSet(ref)
    ref
    ```

    ``` r
    # Save to file
    writeXStringSet(ref,
                    here('data',
                         'outputs',
                         'dada2-compatible',
                         '12Sv5',
                         '12Sv5_taxonomy.fasta'))
    ```

    ??? note "Legacy: `assignTaxonomy()`"

        12Sv5 was assigned with `dada2::assignTaxonomy()` before `assignment_12S()`, and both read taxonomy from the FASTA headers.
