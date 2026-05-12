# PacBio 16S DADA2 Pipeline
# Optimized version with chimera removal and proper output handling

# Set parallel processing
options(mc.cores = parallel::detectCores())

library(dada2)
library(Biostrings)
library(ShortRead)
library(ggplot2)
library(phyloseq)
library(magrittr)
library(fs)
library(tidyverse)

data.dir <- "/work/fastx_files"
greengenes2 <- "/work/gg2_2024_09_toSpecies_trainset.fa.gz"
user_biosamples <- "/work/user_biosamples.csv"

# Use scratch/tmp for intermediate files (much faster I/O)
path.out <- ifelse(Sys.getenv("TMPDIR") != "", 
                   Sys.getenv("TMPDIR"), 
                   "/work/temp")
path.rds <- file.path(path.out, "RDS")
dir.create(path.rds, recursive = TRUE, showWarnings = FALSE)

if (!file.exists(greengenes2)) {
  stop("GreenGenes2 reference does not exist.")
}

fns <- list.files(data.dir, pattern = "fastq.gz", full.names = TRUE)
old <- Sys.time()

F27 <- "AGRGTTYGATYMTGGCTCAG"
R1492 <- "RGYTACCTTGTTACGACTT"

cat("Removing primers...", format(Sys.time()), "\n")

# Create output directories
noprimers_dir <- file.path(data.dir, "noprimers")
filtered_dir <- file.path(noprimers_dir, "filtered")
dir.create(noprimers_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(filtered_dir, recursive = TRUE, showWarnings = FALSE)

nops <- file.path(noprimers_dir, basename(fns))
prim <- removePrimers(fns, nops, primer.fwd = F27, 
                      primer.rev = dada2:::rc(R1492), 
                      orient = TRUE, verbose = TRUE)

cat("Filtering...", format(Sys.time()), "\n")

filts <- file.path(filtered_dir, basename(fns))
track <- filterAndTrim(nops, filts, minQ = 3, minLen = 1000, maxLen = 1600, 
                       maxN = 0, rm.phix = FALSE, maxEE = 2, 
                       compress = TRUE, multithread = TRUE)

cat("Dereplicating...", format(Sys.time()), "\n")

drp <- derepFastq(filts, verbose = TRUE)
saveRDS(drp, file.path(path.rds, "drp_derepFastq.rds"))

cat("Learning errors...", format(Sys.time()), "\n")

err <- learnErrors(drp, errorEstimationFunction = PacBioErrfun, 
                   BAND_SIZE = 32, multithread = TRUE,
                   randomize = TRUE)

saveRDS(err, file.path(path.rds, "DADA2_Derep_16S.rds"))

# Save error plot to file
pdf(file.path(path.out, "error_plot.pdf"))
plotErrors(err)
dev.off()

cat("Denoising...", format(Sys.time()), "\n")

dd <- dada(drp, err = err, BAND_SIZE = 32, multithread = TRUE, 
           verbose = 1)

saveRDS(dd, file.path(path.rds, "DADA2_Denoise_16S.rds"))

cat("Read tracking...\n")
tracking <- cbind(ccs = prim[,1], primers = prim[,2], 
                  filtered = track[,2], 
                  denoised = sapply(dd, function(x) sum(x$denoised)))
write.csv(tracking, file.path(path.out, "read_tracking.csv"))

cat("Making sequence table...", format(Sys.time()), "\n")

st <- makeSequenceTable(dd)
cat("Sequence table dimensions:", dim(st), "\n")

cat("Assigning taxonomy...", format(Sys.time()), "\n")

tax <- assignTaxonomy(st, greengenes2, multithread = TRUE, 
                      verbose = TRUE, minBoot = 50)

tax[,"Genus"] <- gsub("Escherichia/Shigella", "Escherichia", tax[,"Genus"])

cat("Checking chimeras...", format(Sys.time()), "\n")

bim <- isBimeraDenovo(st, minFoldParentOverAbundance = 3.5, 
                      multithread = TRUE, verbose = TRUE)
cat("Chimeras detected:", sum(bim), "/", length(bim), "\n")
cat("Chimera abundance:", round(sum(st[,bim])/sum(st)*100, 2), "%\n")

# Remove chimeras from BOTH sequence table AND taxonomy
st_nochim <- st[,!bim]
tax_nochim <- tax[!bim,]

cat("Extracting sample names...\n")

file.names <- basename(fns)
sample.names <- sub(".*\\.hifi_reads\\.(.*?)\\.hifi_reads\\.fastq\\.gz", 
                    "\\1", file.names)
rownames(st_nochim) <- sample.names

cat("Saving processed objects...\n")

saveRDS(st_nochim, file.path(path.rds, "Sequence_Table_16S.rds"))
saveRDS(tax_nochim, file.path(path.rds, "Taxonomy_GreenGenes.rds"))
saveRDS(bim, file.path(path.rds, "Chimeras_16S.rds"))

cat("Reading metadata...\n")

df <- read.csv(user_biosamples, header = TRUE, row.names = 1)

# Verify sample names match
if (!all(rownames(st_nochim) %in% rownames(df))) {
  warning("Some samples in sequence table not found in metadata!")
}

cat("Creating phyloseq object...\n")

# Create phyloseq with chimera-free data
ps <- phyloseq(
  otu_table(st_nochim, taxa_are_rows = FALSE),
  sample_data(df[rownames(st_nochim), , drop = FALSE]),
  tax_table(tax_nochim)
)

# Add reference sequences AFTER creating phyloseq
dna <- Biostrings::DNAStringSet(colnames(st_nochim))
names(dna) <- colnames(st_nochim)
ps <- merge_phyloseq(ps, dna)

cat("Final phyloseq object:\n")
print(ps)

cat("Exporting final phyloseq object...\n")

# Save to RDS directory
saveRDS(ps, file.path(path.rds, "ps_PacBio_16S.rds"))

# Copy results to output directory for easy access
output_dir <- "/work/output"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

cat("Copying final results to output directory...\n")

# Copy the main phyloseq object
file.copy(file.path(path.rds, "ps_PacBio_16S.rds"),
          file.path(output_dir, "ps_PacBio_16S.rds"),
          overwrite = TRUE)

# Also copy the intermediate objects (useful for troubleshooting)
file.copy(file.path(path.rds, "Sequence_Table_16S.rds"),
          file.path(output_dir, "Sequence_Table_16S.rds"),
          overwrite = TRUE)

file.copy(file.path(path.rds, "Taxonomy_GreenGenes.rds"),
          file.path(output_dir, "Taxonomy_GreenGenes.rds"),
          overwrite = TRUE)

# Copy read tracking and error plot if they exist
if (file.exists(file.path(path.out, "read_tracking.csv"))) {
  file.copy(file.path(path.out, "read_tracking.csv"),
            file.path(output_dir, "read_tracking.csv"),
            overwrite = TRUE)
}

if (file.exists(file.path(path.out, "error_plot.pdf"))) {
  file.copy(file.path(path.out, "error_plot.pdf"),
            file.path(output_dir, "error_plot.pdf"),
            overwrite = TRUE)
}

cat("Results copied to:", output_dir, "\n")
cat("Main output: ps_PacBio_16S.rds\n")

# Copy RDS files back from scratch if using TMPDIR
if (path.out != "/work/temp") {
  final_rds <- "/work/temp/RDS"
  dir.create(final_rds, recursive = TRUE, showWarnings = FALSE)
  file.copy(list.files(path.rds, full.names = TRUE), 
            final_rds, overwrite = TRUE)
  cat("Copied temp files from scratch to /work/temp/RDS\n")
}

elapsed <- Sys.time() - old
cat("\nTotal runtime:", format(elapsed), "\n\n")

sessionInfo()