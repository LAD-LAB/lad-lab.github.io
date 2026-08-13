# Creating the SQL File

These instructions will help you create a `taxonomizr`-prepared SQLite database for use in creating the references.

??? info

    The SQL file is no longer required for phyloseq creation. The current `assignment_trnL()` and `assignment_12S()` functions in `foodseq.tools` assign taxonomy directly from taxonomy headers in the reference FASTA, bypassing the accession-to-taxid lookup that previously depended on this file. These instructions are retained for reference, as the SQL file is still used when [creating the references](references.md).

## Download Scripts

You will need four scripts: `conda.sh`, `taxonomizr.sh`, `taxonomizr.R`, and `Rscript-echo.R`. The last three can be downloaded from the [mb-pipeline repository](https://github.com/LAD-LAB/mb-pipeline/tree/main/reference/sql-creation); `conda.sh` is user-specific and must be created manually (see below). Download or create all four scripts in the same folder on your computing cluster, and add a subfolder called `tempdir`.

The first script initializes conda; update the paths to match your conda installation:

=== "Duke"

    ``` sh title="conda.sh"
    export CONDA_EXE='/hpc/group/ldavidlab/users/[NetID]/miniconda3/bin/conda'
    export _CE_M=''
    export _CE_CONDA=''
    export CONDA_PYTHON_EXE='/hpc/group/ldavidlab/users/[NetID]/miniconda3/bin/python'

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

=== "General"

    ``` sh title="conda.sh"
    export CONDA_EXE='[/path/to/miniconda3]/bin/conda'
    export _CE_M=''
    export _CE_CONDA=''
    export CONDA_PYTHON_EXE='[/path/to/miniconda3]/bin/python'

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

The second script is the Slurm batch script that sources the conda environment and runs the R script:

=== "Duke"

    ``` sh title="taxonomizr.sh"
    #!/bin/bash
    #SBATCH --job-name=taxonomizr
    #SBATCH --partition common-old,scavenger
    #SBATCH --mem=64000
    #SBATCH -n 2  # Number of cores
    #SBATCH --out=taxonomizr-%j.out
    #SBATCH --error=taxonomizr-%j.err
    #SBATCH --mail-user=[NetID]@duke.edu
    #SBATCH --mail-type=FAIL
    #SBATCH --mail-type=END

    # Usage: taxonomizr.sh [/path/to/SQL/directory]

    # source QIIME2 environment
    source [/path/to/conda.sh]
    conda activate [qiime2-2022.8]

    # load R and run taxonomizr script
    Rscript Rscript-echo.R taxonomizr.R $1
    ```

=== "General"

    ``` sh title="taxonomizr.sh"
    #!/bin/bash
    #SBATCH --job-name=taxonomizr
    #SBATCH --partition [your-partition]
    #SBATCH --mem=64000
    #SBATCH -n 2  # Number of cores
    #SBATCH --out=taxonomizr-%j.out
    #SBATCH --error=taxonomizr-%j.err
    #SBATCH --mail-user=[username]@[your-email]
    #SBATCH --mail-type=FAIL
    #SBATCH --mail-type=END

    # Usage: taxonomizr.sh [/path/to/SQL/directory]

    # source conda environment
    source [/path/to/conda.sh]
    conda activate [your-conda-env]

    # load R and run taxonomizr script
    Rscript Rscript-echo.R taxonomizr.R $1
    ```

???+ note

    Note that you must create a conda environment for use here:

    ``` sh hl_lines="3"
    # source conda environment
    source [/path/to/conda.sh]
    conda activate [your-conda-env]
    ```

    You will learn how to set this up in the next section; don't forget to add the name of the environment you create back into `taxonomizr.sh`!

The third script is the R script that builds the SQL database:

``` r title="taxonomizr.R"
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

The fourth script redirects Rscript output to an `.Rout` file:

``` r title="Rscript-echo.R"
# Using a combination of source() and sink(), get Rscript to produce an .Rout file like that
# produced by R CMD BATCH.

# Command-line usage: Rscript Rscript-echo.R [Primary script name] [Primary script args]
# Remember to adjust args indices of receiving script accordingly!

args <- commandArgs(TRUE)
srcfile <- args[1]

outfile <- file.path(args[2], paste0(make.names(date()), '.Rout'))

sink(outfile, split=TRUE)
source(srcfile, echo=TRUE)
```

## Setting Up a Conda Environment

Next, you must set up a `conda` environment. Log into your computing cluster and run the following code to install MiniConda3, following the instructions when prompted:

=== "Duke"

    Give the MiniConda install location as `/hpc/group/ldavidlab/users/[NetID]/miniconda3`:

    ``` sh
    mkdir -p /hpc/group/ldavidlab/users/[NetID]
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    sh Miniconda3-latest-Linux-x86_64.sh
    ```

=== "General"

    Give the MiniConda install location as a path within your cluster directory:

    ``` sh
    mkdir -p [/hpc/path/to/lab/directory]/users/[username]
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    sh Miniconda3-latest-Linux-x86_64.sh
    ```

Next, create a `conda` environment:

``` sh
conda create --name [qiime2-YYYY.MM]
```

and follow the instructions. Install R to this environment by running:

``` sh
conda activate [qiime2-YYYY.MM]
conda install -c conda-forge r-base
```

and following the instructions. Next, activate R and install the necessary packages:

``` sh
R
install.packages("tidyverse")
install.packages("taxonomizr")
```

and after these packages are installed, run `q()` to exit R.

## Running the Scripts

Navigate into the folder in which you have downloaded the above scripts. Make sure you update `taxonomizr.sh` with the name of your environment and path to `conda.sh` and make sure you update `conda.sh` with your paths!

=== "Duke"

    ``` sh
    cd /hpc/group/ldavidlab/users/[NetID]/[script-folder]
    ```

    Next, set the `tempdir` subfolder as your temporary directory:

    ``` sh
    export TMPDIR=/hpc/group/ldavidlab/users/[NetID]/[script-folder]/tempdir
    ```

    And now you can run the scripts:

    ``` sh
    sbatch --mail-user=[NetID]@duke.edu /hpc/group/ldavidlab/users/[NetID]/[script-folder]/taxonomizr.sh /hpc/group/ldavidlab/users/[NetID]/[script-folder]
    ```

    Last, make sure to upload the SQL file to Isilon! Given its size, this will take a while.

=== "General"

    ``` sh
    cd [/hpc/path/to/lab/directory]/users/[username]/[script-folder]
    ```

    Next, set the `tempdir` subfolder as your temporary directory:

    ``` sh
    export TMPDIR=[/hpc/path/to/lab/directory]/users/[username]/[script-folder]/tempdir
    ```

    And now you can run the scripts:

    ``` sh
    sbatch --mail-user=[username]@[your-email] [/hpc/path/to/lab/directory]/users/[username]/[script-folder]/taxonomizr.sh [/hpc/path/to/lab/directory]/users/[username]/[script-folder]
    ```

    Last, make sure to copy the SQL file to your shared storage so it can be accessed from R. Given its size, this will take a while.
