# Introduction to Lab Biostatistics

This page provides background on the core concepts used throughout this handbook. If you are new to the lab or to DNA metabarcoding, read through this page before proceeding to [Setting Up](settingup.md) or [Creating a Phyloseq](pipeline.md).

## DNA Metabarcoding

DNA metabarcoding is a method for identifying the biological composition of a mixed sample by sequencing short, standardized gene regions (markers) and matching them against a reference database. In our lab, we use metabarcoding to identify foods consumed by study participants from DNA extracted from stool samples. This approach allows us to detect dietary intake at the species level without relying on self-report.

We target two markers:

* **trnL** (trnL-gh intergenic spacer): a chloroplast region used to identify plants. trnL sequences are short and show high interspecies diversity; a single-nucleotide difference can distinguish closely related plant species.
* **12Sv5** (12S ribosomal RNA, V5 region): a mitochondrial region used to identify animals. 12Sv5 sequences are longer than trnL sequences and show more intraspecies variation, meaning a single animal species may produce multiple distinct sequence variants.

Because each marker targets a different kingdom, a typical sequencing run produces both a trnL dataset (plants) and a 12Sv5 dataset (animals), which are processed separately throughout the pipeline.

## Amplicon Sequencing Variants (ASVs)

An amplicon sequencing variant (ASV) is a unique DNA sequence recovered from a sequencing run after denoising. During sequencing, millions of DNA reads are generated from a sample; denoising algorithms like DADA2 correct sequencing errors and resolve the reads into a set of exact sequences, each representing a true biological variant. These are ASVs.

ASVs are the fundamental unit of observation in our data. Each ASV is defined by its exact nucleotide sequence, and each sample in a sequencing run has a count of how many reads were assigned to each ASV. Taxonomy is assigned by matching ASV sequences against a reference database; for trnL, this is done by exact sequence matching, while for 12Sv5, a naive Bayesian classifier is used. An ASV that does not match anything in the reference is marked as `NA` and can be investigated further with tools like BLAST.

A single food species may produce multiple ASVs (due to natural sequence variation within the species), and in some cases a single ASV may match multiple species (when those species share an identical marker sequence). The taxonomy assignment step handles these cases by condensing multi-match ASVs to their last common ancestor.

??? question "How are ASVs different from OTUs?"

    Older metabarcoding workflows clustered similar sequences into operational taxonomic units (OTUs), typically at a 97% similarity threshold. ASVs replace this approach by resolving sequences to exact variants without clustering, which provides higher taxonomic resolution and makes results comparable across studies and sequencing runs. Our lab uses ASVs exclusively.

## Phyloseq Objects

A phyloseq is an R data structure from the `phyloseq` package that bundles together the different components of a metabarcoding dataset into a single object. A phyloseq contains up to three components:

* `otu_table`: a matrix of ASV counts per sample (rows are samples, columns are ASVs)
* `tax_table`: a matrix of taxonomy assignments per ASV (rows are ASVs, columns are taxonomic ranks from superkingdom down to subspecies)
* `sam_data`: a dataframe of sample metadata (participant IDs, sample types, experimental conditions, etc.)

The phyloseq is the central data object throughout the analysis pipeline. After [creating a phyloseq](pipeline.md) from raw sequencing data, the [post-phyloseq processing workflow](processing.md) walks through assigning common names, agglomerating, filtering, and calculating diversity and abundance metrics, all operating on the same phyloseq object (or filtered copies of it).

??? question "Why use phyloseq objects instead of separate tables?"

    Keeping the ASV table, taxonomy, and sample metadata in a single object makes it straightforward to subset and transform the data without worrying about keeping the tables aligned. For example, `subset_samples(ps, type == "sample")` removes control samples from the ASV table and metadata simultaneously. The `phyloseq` package also provides built-in functions for common operations like `estimate_richness()`, `tax_glom()`, and `transform_sample_counts()`.

## Common Statistical and Data Visualization Techniques

The downstream analysis pages cover several statistical techniques in detail; brief descriptions are provided here for reference.

### Alpha Diversity

Alpha diversity measures the diversity within a single sample. We commonly report two metrics: observed richness (the number of distinct taxa detected, referred to as pFR for plants and pMR for meat/animals) and Shannon diversity (which accounts for both richness and evenness of taxa abundances). Alpha diversity is calculated on count data, before any relative abundance or CLR transform; see [Calculating Diversity](diversity.md) for instructions.

### Relative Abundance

Relative abundance expresses each ASV's count as a proportion of the total reads in that sample, so that all proportions sum to 1. This normalization accounts for differences in sequencing depth across samples and is used for calculating Shannon diversity and for stacked bar plots. See [Relative Abundance and CLR Transform](abundance.md) for instructions.

### Centered Log-Ratio (CLR) Transform

Compositional data like relative abundances are constrained to sum to 1, which makes standard statistical methods (like Euclidean distance) inappropriate. The centered log-ratio (CLR) transform removes this constraint by dividing each value by the geometric mean of the sample and taking the log. CLR-transformed data can then be analyzed with standard multivariate techniques. See [Relative Abundance and CLR Transform](abundance.md) for the formula and code.

### Principal Component Analysis (PCA)

PCA is a dimensionality reduction technique that projects high-dimensional data (many ASVs per sample) onto a smaller number of axes (principal components) that capture the most variation. We use PCA on CLR-transformed data to visualize how samples cluster by experimental group and to identify which taxa drive the most separation between groups. See [Creating a PCA Plot](pca.md) for instructions and interpretation.

## Glossary

* **ASV**: amplicon sequencing variant; a unique DNA sequence recovered after denoising. The fundamental unit of observation in metabarcoding data.
* **CLR transform**: centered log-ratio transform; a normalization applied to compositional data before multivariate analysis.
* **DADA2**: the denoising algorithm used to resolve raw sequencing reads into ASVs.
* **denoising**: the process of correcting sequencing errors and collapsing reads into true biological variants (ASVs).
* **marker**: a short, standardized gene region used for identification; our lab uses trnL (plants) and 12Sv5 (animals).
* **metabarcoding**: a method for identifying organisms in a mixed sample by sequencing a shared marker region and matching against a reference.
* **OTU**: operational taxonomic unit; an older clustering-based approach to grouping sequences, replaced by ASVs in our pipeline.
* **pFR**: plant food richness; the number of distinct plant taxa detected in a sample.
* **phyloseq**: an R object bundling ASV counts, taxonomy, and sample metadata into a single data structure.
* **pMR**: plant and meat richness; the number of distinct taxa detected in a sample (used for 12Sv5 data).
* **QIIME2**: the bioinformatics platform used for demultiplexing and initial sequence processing on the computing cluster.
* **reference database**: a curated FASTA file mapping known marker sequences to taxonomy; used for assigning species to ASVs.
* **relative abundance**: ASV counts expressed as proportions of total sample reads, summing to 1.
* **Shannon diversity**: an alpha diversity metric that accounts for both richness and evenness.
* **taxonomy assignment**: the process of matching ASV sequences to a reference database to determine species identity.
