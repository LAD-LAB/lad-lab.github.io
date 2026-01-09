# Creating the SQL File

These instructions will help you create a `taxonomizr`-prepared SQLite database on Isilon for use in creating the references and phyloseq objects.

## Download Scripts

!!! to-do

    Add instructions on downloading these scripts from GitHub once they are uploaded there.

You will need to download the following four scripts to a folder in the DCC under `/hpc/group/ldavidlab/users/[NetID]`. To this same DCC folder, also add a subfolder called `tempdir`:

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
        # Handle transition from shell activated with conda <= 4.3 to a subsequent activation
        # after conda updated to >= 4.4. See issue #6173.
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
    # In dev-mode CONDA_EXE is python.exe and on Windows
    # it is in a different relative location to condabin.
    if [ -n "${_CE_CONDA:+x}" ] && [ -n "${WINDIR+x}" ]; then
        PATH="$(\dirname "$CONDA_EXE")/condabin${PATH:+":${PATH}"}"
    else
        PATH="$(\dirname "$(\dirname "$CONDA_EXE")")/condabin${PATH:+":${PATH}"}"
    fi
    \export PATH

    # We're not allowing PS1 to be unbound. It must at least be set.
    # However, we're not exporting it, which can cause problems when starting a second shell
    # via a first shell (i.e. starting zsh from bash).
    if [ -z "${PS1+x}" ]; then
        PS1=
    fi
fi
```

``` sh title="taxonomizr.sh"
#!/bin/bash
#SBATCH --job-name=taxonomizr
#SBATCH --partition common-old,scavenger 
#SBATCH --mem=64000
#SBATCH -n 2  # Number of cores
#SBATCH --out=taxonomizr-%j.out
#SBATCH --error=taxonomizr-%j.err
#SBATCH --mail-user=blp23@duke.edu
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END

# Usage: taxonomizr.sh [/path/to/SQL/directory]

# source QIIME2 environment
source [/path/to/conda.sh]
conda activate [qiime2-2022.8]

# load R and run taxonomizr script
Rscript Rscript-echo.R taxonomizr.R $1

```

???+ note

    Note that you must create a conda environment for use here:

    ``` sh hl_lines="3"
    # source QIIME2 environment
    source [/path/to/conda.sh]
    conda activate [qiime2-2022.8]
    ```

    You will learn how to do set this up in the next section; don't forget to add the name of the environment you create back into `taxonomizr.sh`!

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

Next, you must set up a `conda` environment. First, log into the DCC and run the following code to install MiniConda3 by following the instructions; give the MiniConda install location as `/hpc/group/ldavidlab/users/[NetID]/miniconda3`:

``` sh
mkdir -p /hpc/group/ldavidlab/users/[NetID]
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

Navigate into the DCC folder in which you have downloaded the above scripts. Make sure you update `taxonomizr.sh` with the name of your environment and path to `conda.sh` and make sure you update `conda.sh` with your NetID!

``` sh
cd [/hpc/group/ldavidlab/users/[NetID/script-folder]]
```

Next, set the `tempdir` subfolder as your temporary directory:

``` sh
export TMPDIR=[/hpc/group/ldavidlab/users/[NetID/script-folder]/tempdir]
```

And now you can run the scripts:

``` sh
sbatch --mail-user=[NetID]@duke.edu /hpc/group/ldavidlab/users/[NetID/script-folder]/taxonomizr.sh /hpc/group/ldavidlab/users/[NetID/script-folder]
```

Last, make sure to upload the SQL file to Isilon! Given its size, this will take a while.