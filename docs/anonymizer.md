# Anonymizing Human Reads

These instructions will help you anonymize human DNA reads in 12Sv5 metabarcoding FASTQ files for deposition to SRA or other public repositories. The Human Read Anonymizer detects human reads using k-mer matching against a reference database of 1,318 human 12S sequences and replaces them with a synthetic sequence — preserving read counts, FASTQ structure, and quality scores so that the files remain compatible with downstream tools. This step is required for IRB compliance when publishing 12Sv5 data. A [flowchart](#flowchart) is provided at the bottom of the page showing where anonymization fits in the overall workflow.

The tool replaces human reads rather than removing them. Removal would alter total read counts and change the structure of the FASTQ files; replacement keeps everything intact while rendering the human sequences unidentifiable. The replacement sequence is derived from the human 12S mitochondrial region, so it is classified as *Homo sapiens* during taxonomy assignment and can be filtered out in the phyloseq like any other human read.

The anonymizer lives in the [`mb-pipeline` repository](https://github.com/LAD-LAB/mb-pipeline/tree/main/reference/anonymizer). It operates on demultiplexed FASTQ files; when preparing data for SRA submission, you run it on the demultiplexed files and then re-run the marker pipeline on the anonymized output to generate a clean set of results for deposition.

## How Detection Works

The anonymizer decomposes the region downstream of the 5' primer into k-mers (default k=8) and evaluates both the forward and reverse-complement orientations of each read. It computes the fraction of query k-mers that match the human reference database; reads exceeding the threshold (default 0.70) are classified as human and replaced.

## How Replacement Works

Replaced reads are constructed to preserve compatibility with cutadapt and DADA2 merging. The structure of a replaced read pair is:

- **R1** — `[5' forward primer]` + `[replacement core, 100 bp]` + `[3' reverse primer]` + `[original adapter tail]`
- **R2** — `[5' RC(reverse primer)]` + `[RC(replacement core), 100 bp]` + `[3' RC(forward primer)]` + `[original adapter tail]`

The fixed 100 bp core matches the expected 12Sv5 amplicon length. Primers are preserved so that cutadapt trims them normally; strand complementarity between R1 and R2 allows DADA2 to merge the pair. Original quality scores are retained.

## Requirements

The anonymizer requires:

- R >= 4.0 with the Bioconductor packages `Biostrings` and `ShortRead`
- `human-sequences.fasta` (included in the repository)
- A Singularity/Apptainer container with R and the above packages, or a system R installation on the cluster

If you have already cloned the `mb-pipeline` repository and have the lab's Singularity container, you should have everything you need.

## Single-File Usage

To process a single FASTQ file, run the following:

``` sh
Rscript human_read_anonymizer.R \
    human-sequences.fasta \
    sample_R1_001.fastq.gz \
    output/sample_R1_001.fastq.gz \
    0.7 \
    8
```

The five positional arguments are:

- **reference FASTA** — path to `human-sequences.fasta`
- **input FASTQ** — the demultiplexed `.fastq.gz` file to process
- **output FASTQ** — where to write the anonymized file
- **threshold** — fraction of k-mers that must match to classify a read as human (default `0.7`)
- **k-mer size** — length of each k-mer (default `8`)

R1 and R2 files are processed independently; the script auto-detects read direction from the filename.

## Batch Processing on the Cluster

For a full sequencing run, use the batch submission script to process all demultiplexed files in parallel via SLURM.

=== "Duke"

    First, open `submit_anonymization.sh` and edit the configuration variables at the top of the file to match your setup. You will need to set the path to the Singularity image, the reference FASTA, the input directory (your demultiplexed folder), the output directory, the threshold, and the k-mer size.

    Next, make the scripts executable and submit the jobs:

    ``` sh
    ssh [NetID]@dcc-login.oit.duke.edu

    cd /hpc/group/ldavidlab/users/[NetID]/mb-pipeline/reference/anonymizer

    chmod +x submit_anonymization.sh human_read_anonymizer.R
    ./submit_anonymization.sh
    ```

    You can monitor the jobs with `squeue`:

    ``` sh
    squeue -u [NetID]
    ```

=== "General"

    First, open `submit_anonymization.sh` and edit the configuration variables at the top of the file to match your setup. You will need to set the path to the Singularity image, the reference FASTA, the input directory (your demultiplexed folder), the output directory, the threshold, and the k-mer size.

    Next, make the scripts executable and submit the jobs:

    ``` sh
    ssh [username]@[hpc-hostname]

    cd [/path/to/mb-pipeline]/reference/anonymizer

    chmod +x submit_anonymization.sh human_read_anonymizer.R
    ./submit_anonymization.sh
    ```

    You can monitor the jobs with `squeue`:

    ``` sh
    squeue -u [username]
    ```

Once all jobs finish, point the marker pipeline at the anonymized output directory instead of the original demultiplexed directory.

## Parameters

- **threshold** — controls the sensitivity of human read detection. The default is `0.7`, meaning 70% of a read's k-mers must match the human reference to be classified as human. Lower values (e.g., `0.6`) increase sensitivity at the cost of more false positives; higher values (e.g., `0.8`) increase specificity but may miss divergent human sequences. The default of `0.7` works well in practice.
- **k** — the k-mer size used for decomposition. The default of `8` provides a space of 65,536 possible k-mers, which balances specificity against computational cost. There is generally no reason to change this.

## Known Limitation

!!! warning

    Replacing a large fraction of reads (~70%) with an identical synthetic sequence alters DADA2's error model, which can cause over-splitting at the ASV level. In testing, mean ASV-level richness increased from 4.5 to 7.9 after anonymization. However, species-level composition, beta diversity, and ecological conclusions are unaffected. If you are working with anonymized data, be aware that raw ASV counts may appear inflated relative to non-anonymized runs.

## Adapting for Other Markers

The anonymizer can be adapted for markers other than 12Sv5. To do so, edit `human_read_anonymizer.R` and replace three constants:

- `REPLACEMENT_CORE` — the synthetic core sequence for the new marker
- `FORWARD_PRIMER` — the forward primer sequence
- `REVERSE_PRIMER` — the reverse primer sequence

You will also need to provide a new reference FASTA containing human sequences for the target marker region.

***

## Flowchart

``` mermaid
graph TD
  A[raw sequencing data] -->|demux-barcodes.sh| B[demultiplexed FASTQs];
  B -->|human_read_anonymizer.R| C[anonymized FASTQs];
  C -->|12SV5-pipeline.sh| D[pipeline output];
  D --> E[phyloseq creation];
```
