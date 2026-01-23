# Creating the SQL File

These instructions help you create a `taxonomizr`-prepared SQLite database for use in taxonomy assignment during reference and phyloseq creation.

!!! info "Why HPC?"
    This process requires significant memory (~64GB) and will likely fail on a local machine. Run it on your institution's HPC cluster.

## Overview

You'll need four scripts to create the taxonomy database:

1. **conda.sh** — Conda environment initialization
2. **taxonomizr.sh** — SLURM batch script to run the R code
3. **taxonomizr.R** — R script that creates the SQL database
4. **Rscript-echo.R** — Helper script for logging R output

## Download Scripts

=== "General"

    Create a working directory on your HPC cluster and download these scripts. Also create a `tempdir` subfolder for temporary files:

    ```sh
    mkdir -p /path/to/your/working-directory/tempdir
    cd /path/to/your/working-directory
    ```

    Download the scripts from [LAD-LAB mb-pipeline](https://github.com/LAD-LAB/mb-pipeline/tree/main/reference/sql-creation) or create them manually below.

=== "Duke DCC"

    Create your working directory on the DCC:

    ```sh
    mkdir -p /hpc/group/ldavidlab/users/[NetID]/sql-creation/tempdir
    cd /hpc/group/ldavidlab/users/[NetID]/sql-creation
    ```

    Download the scripts from [LAD-LAB mb-pipeline](https://github.com/LAD-LAB/mb-pipeline/tree/main/reference/sql-creation).

## Script Files

### conda.sh

This script initializes the Conda environment. Update the paths to match your Miniconda installation:

=== "General"

    ```sh title="conda.sh"
    export CONDA_EXE='/path/to/your/miniconda3/bin/conda'
    export _CE_M=''
    export _CE_CONDA=''
    export CONDA_PYTHON_EXE='/path/to/your/miniconda3/bin/python'

    # Copyright (C) 2012 Anaconda, Inc
    # SPDX-License-Identifier: BSD-3-Clause
    __conda_exe() (
        "$CONDA_EXE" $_CE_M $_CE_CONDA "$@"
    )

    __conda_hashr() {
        if [ -n "${ZSH_VERSION:+x}" ]; then
            \rehash
        elif [ -n "${POSH_VERSION:+x}" ]; then
            :  # pass
        else
            \hash -r
        fi
    }

    __conda_activate() {
        if [ -n "${CONDA_PS1_BACKUP:+x}" ]; then
            PS1="$CONDA_PS1_BACKUP"
            \unset CONDA_PS1_BACKUP
        fi
        \local ask_conda
        ask_conda="$(PS1="${PS1:-}" __conda_exe shell.posix "$@")" || \return
        \eval "$ask_conda"
        __conda_hashr
    }

    conda() {
        \local cmd="${1-__missing__}"
        case "$cmd" in
            activate|deactivate)
                __conda_activate "$@"
                ;;
            install|update|upgrade|remove|uninstall)
                __conda_exe "$@" || \return
                __conda_activate reactivate
                ;;
            *)
                __conda_exe "$@"
                ;;
        esac
    }

    if [ -z "${CONDA_SHLVL+x}" ]; then
        \export CONDA_SHLVL=0
        if [ -n "${_CE_CONDA:+x}" ] && [ -n "${WINDIR+x}" ]; then
            PATH="$(\dirname "$CONDA_EXE")/condabin${PATH:+":${PATH}"}"
        else
            PATH="$(\dirname "$(\dirname "$CONDA_EXE")")/condabin${PATH:+":${PATH}"}"
        fi
        \export PATH

        if [ -z "${PS1+x}" ]; then
            PS1=
        fi
    fi
    ```

=== "Duke DCC"

    ```sh title="conda.sh"
    export CONDA_EXE='/hpc/group/ldavidlab/users/[NetID]/miniconda3/bin/conda'
    export _CE_M=''
    export _CE_CONDA=''
    export CONDA_PYTHON_EXE='/hpc/group/ldavidlab/users/[NetID]/miniconda3/bin/python'

    # (rest of script is identical - see General tab)
    ```

### taxonomizr.sh

SLURM batch script to run the taxonomy database creation. Adjust partition names and paths for your cluster:

=== "General"

    ```sh title="taxonomizr.sh"
    #!/bin/bash
    #SBATCH --job-name=taxonomizr
    #SBATCH --partition=[YOUR_PARTITION]
    #SBATCH --mem=64000
    #SBATCH -n 2
    #SBATCH --out=taxonomizr-%j.out
    #SBATCH --error=taxonomizr-%j.err
    #SBATCH --mail-user=[YOUR_EMAIL]
    #SBATCH --mail-type=FAIL
    #SBATCH --mail-type=END

    # Usage: taxonomizr.sh [/path/to/SQL/directory]

    # source conda environment
    source /path/to/conda.sh
    conda activate [your-conda-env]

    # load R and run taxonomizr script
    Rscript Rscript-echo.R taxonomizr.R $1
    ```

=== "Duke DCC"

    ```sh title="taxonomizr.sh"
    #!/bin/bash
    #SBATCH --job-name=taxonomizr
    #SBATCH --partition common-old,scavenger
    #SBATCH --mem=64000
    #SBATCH -n 2
    #SBATCH --out=taxonomizr-%j.out
    #SBATCH --error=taxonomizr-%j.err
    #SBATCH --mail-user=[NetID]@duke.edu
    #SBATCH --mail-type=FAIL
    #SBATCH --mail-type=END

    # Usage: taxonomizr.sh [/path/to/SQL/directory]

    # source conda environment
    source /hpc/group/ldavidlab/users/[NetID]/sql-creation/conda.sh
    conda activate qiime2-2022.8

    # load R and run taxonomizr script
    Rscript Rscript-echo.R taxonomizr.R $1
    ```

???+ note
    You must create a conda environment first (see next section). Update the environment name in the script after creating it.

### taxonomizr.R

R script that creates the SQLite database:

```r title="taxonomizr.R"
# Prepare NCBI taxonomy SQL database on cluster (runs out of memory locally)

# Setup -----------------------------------------------------------------------

args <- commandArgs(trailingOnly=TRUE)
print(args)
setwd(args[2]) # Set the directory

library(taxonomizr); packageVersion('taxonomizr') # Read in library

# Format SQL database ---------------------------------------------------------
prepareDatabase('accessionTaxa.sql',
    extraSqlCommand="PRAGMA temp_store_directory = args[2]")
```

### Rscript-echo.R

Helper script for capturing R output:

```r title="Rscript-echo.R"
# Using a combination of source() and sink(), get Rscript to produce an .Rout file

# Command-line usage: Rscript Rscript-echo.R [Primary script name] [Primary script args]

args <- commandArgs(TRUE)
srcfile <- args[1]

outfile <- file.path(args[2], paste0(make.names(date()), '.Rout'))

sink(outfile, split=TRUE)
source(srcfile, echo=TRUE)
```

## Setting Up a Conda Environment

=== "General"

    Most HPC clusters have Conda available via modules. If not, install Miniconda:

    ```sh
    mkdir -p /path/to/your/working-directory
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    sh Miniconda3-latest-Linux-x86_64.sh
    ```

    When prompted, install to a location in your group's directory (not your home directory, which typically has limited storage).

    Create and set up your environment:

    ```sh
    # Create environment
    conda create --name taxonomizr-env

    # Activate and install R
    conda activate taxonomizr-env
    conda install -c conda-forge r-base

    # Install R packages
    R
    install.packages("tidyverse")
    install.packages("taxonomizr")
    q()  # Exit R
    ```

=== "Duke DCC"

    Install Miniconda to your lab directory:

    ```sh
    mkdir -p /hpc/group/ldavidlab/users/[NetID]
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    sh Miniconda3-latest-Linux-x86_64.sh
    ```

    When prompted, set the install location to `/hpc/group/ldavidlab/users/[NetID]/miniconda3`.

    Create and set up your environment:

    ```sh
    # Create environment
    conda create --name qiime2-2022.8

    # Activate and install R
    conda activate qiime2-2022.8
    conda install -c conda-forge r-base

    # Install R packages
    R
    install.packages("tidyverse")
    install.packages("taxonomizr")
    q()  # Exit R
    ```

## Running the Scripts

=== "General"

    1. Navigate to your scripts directory:
        ```sh
        cd /path/to/your/working-directory
        ```

    2. Set the temporary directory:
        ```sh
        export TMPDIR=/path/to/your/working-directory/tempdir
        ```

    3. Submit the job:
        ```sh
        sbatch taxonomizr.sh /path/to/your/working-directory
        ```

    4. After completion, copy the `accessionTaxa.sql` file to your shared storage location.

=== "Duke DCC"

    1. Navigate to your scripts directory:
        ```sh
        cd /hpc/group/ldavidlab/users/[NetID]/sql-creation
        ```

    2. Set the temporary directory:
        ```sh
        export TMPDIR=/hpc/group/ldavidlab/users/[NetID]/sql-creation/tempdir
        ```

    3. Submit the job:
        ```sh
        sbatch --mail-user=[NetID]@duke.edu taxonomizr.sh /hpc/group/ldavidlab/users/[NetID]/sql-creation
        ```

    4. After completion, upload the `accessionTaxa.sql` file to Isilon. Given its size (~80GB), this will take a while:
        ```sh
        cp accessionTaxa.sql /path/to/isilon/localreference/ncbi_taxonomy/
        ```

!!! warning "Large File"
    The resulting `accessionTaxa.sql` file is approximately 80GB. Ensure you have sufficient storage space.
