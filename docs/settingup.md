# Setting Up

This page covers the essentials for setting up your biostatistics environment: high-performance computing access, network storage, R/RStudio, and version control.

!!! info "About This Documentation"
    Instructions are written for general use. Duke-specific details appear in labeled tabs and callouts marked "Duke Lab."

## High-Performance Computing (HPC)

Most metabarcoding pipelines require access to a high-performance computing cluster—a group of powerful servers connected by a high-speed network that can handle large datasets. Common job schedulers include SLURM and PBS.

=== "General HPC"

    Contact your institution's research computing team to get access to their cluster. Typical setup involves:

    1. **Request an account** from your institution's HPC administrators
    2. **SSH access**: `ssh username@cluster.your-institution.edu`
    3. **Understand the directory structure**: Most clusters have a home directory (limited storage) and a group/project directory (larger storage for data)
    4. **Learn the job scheduler**: SLURM (`sbatch`, `squeue`, `scancel`) and PBS are common

    Create a working directory for yourself in your group's shared space:
    ```sh
    mkdir -p /path/to/group/users/your-username
    ```

=== "Duke DCC"

    The Duke Compute Cluster (DCC) uses SLURM for job scheduling. For full documentation, visit [Duke Research Computing](https://oit-rc.pages.oit.duke.edu/rcsupportdocs/).

    The DCC has two directories: `/hpc/home` (limited storage) and `/hpc/group` (project storage). Our lab works in `/hpc/group/ldavidlab`. Create your folder at:
    ```sh
    mkdir -p /hpc/group/ldavidlab/users/[NetID]
    ```

    ### Logging In

    Log in with `ssh [NetID]@dcc-login.oit.duke.edu`. This requires multi-factor authentication:

    ```sh
    (base) user@local ~ % ssh ams292@dcc-login.oit.duke.edu
    (ams292@dcc-login.oit.duke.edu) Password:
    (ams292@dcc-login.oit.duke.edu) Duo two-factor login for ams292

    Enter a passcode or select one of the following options:

     1. Duo Push to XXX-XXX-0389
     2. Duo Push to ipad (iOS)
     3. Phone call to XXX-XXX-0389
     4. SMS passcodes to XXX-XXX-0389

    Passcode or option (1-4): 1
    Success. Logging you in...
    ```

    ### SSH Keys (Bypass MFA)

    Set up SSH keys to avoid entering your password each time:

    1. Generate a key pair:
        ```sh
        ssh-keygen -t ed25519
        ```
        Save to the default location and choose a secure passphrase.

    2. View your public key:
        ```sh
        cat ~/.ssh/id_ed25519.pub
        ```

    3. Add it to your [Duke profile](https://idms-web-selfservice.oit.duke.edu/advanced) under "Manage Your Public SSH Keys."

    4. Set up a key manager. On Mac:
        ```sh
        ssh-add --apple-use-keychain ~/.ssh/id_ed25519
        ```
        Then edit `~/.ssh/config`:
        ```sh
        Host *
        UseKeychain yes
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_ed25519
        ```
        For Windows, follow [these instructions](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement).

    ### Web Interface

    You can also access the DCC via [DCC OnDemand](https://dcc-ondemand-01.oit.duke.edu/) (NetID login required).

### Common SLURM Commands

These commands work on most SLURM-based clusters:

* `sbatch [script.sh]` — Submit a batch job. Output: `Submitted batch job [jobid]`
    * Add `--mail-user=[YOUR_EMAIL]` to receive email notifications when jobs complete
    * Add `--dependency=afterok:[jobid]` to run a job after another completes
* `squeue -u [username]` — List your submitted jobs
* `scancel [jobid]` — Cancel a job

## Network Storage

High-volume storage is essential for sequencing data and reference databases. Most institutions provide network-attached storage (NAS) that can be mounted on your local machine.

=== "General"

    Contact your IT department about available network storage options. Common approaches:

    - **Institutional NAS**: Mounted via SMB/CIFS or NFS
    - **Cloud storage**: AWS S3, Google Cloud Storage, institutional Box/OneDrive
    - **Local NAS**: Lab-managed storage servers

    When mounting network storage, you'll typically need:

    - Server address (e.g., `storage.institution.edu`)
    - Share name or path
    - Your credentials (often institutional SSO)

=== "Duke (Isilon)"

    We use Isilon for high-volume storage, including sequencing data and reference databases.

    **Windows:**

    1. Open This PC. Select More (⋯) → Map network drive
    2. Choose any drive letter. Enter: `\\duhsnas-pri.dhe.duke.edu\dusom_mgm-david\All_Staff`
    3. Check "Reconnect at sign-in" → Finish
    4. Sign in with `DHE\[NetID]` as username

    **Mac:**

    1. Open Finder → Go → Connect to Server (<kbd>⌘ K</kbd>)
    2. Enter: `smb://DHE;[NetID]@duhsnas-pri.dhe.duke.edu/dusom_mgm-david\All_Staff`
    3. Add to Favorites (+) → Connect

## Terminal

### Common Commands

Basic terminal commands useful for pipeline work:

* `cd [path]` — Change directory
* `ls -la` — List files with details
* `cp [source] [dest]` — Copy files
* `mv [source] [dest]` — Move/rename files
* `rm [file]` — Remove files (use carefully!)
* `mkdir -p [path]` — Create directories
* `scp [source] [user@host:dest]` — Secure copy between machines

## R

R is the programming language most commonly used in academia for statistical computing and data visualization, including the biostatistical tools used in metabarcoding analysis.

### Installation

Download R from [https://cran.r-project.org/](https://cran.r-project.org/) and follow the instructions for your operating system. You may need an older version for package compatibility:

- [macOS (Apple Silicon)](https://cran.r-project.org/bin/macosx/big-sur-arm64/base/)
- [Windows (older versions)](https://cran.r-project.org/bin/windows/base/old/)

Most workflows in this handbook use **R 4.4.1**.

### Setting Up RStudio

RStudio is an IDE that provides a user-friendly interface for R. Download it from [https://posit.co/download/rstudio-desktop/](https://posit.co/download/rstudio-desktop/).

RStudio has four main panes:

- **Source** (top left): Write and edit R scripts
- **Console** (bottom left): Execute commands and view output
- **Environment** (top right): View loaded data and variables
- **Output** (bottom right): View plots, files, help, and packages

<figure markdown="span">
  ![RStudio](images/RStudio.png){ width="600" }
  <figcaption></figcaption>
</figure>

To get started:

1. Create a new project: File → New Project
2. Create a new R Markdown file: File → New File → R Markdown
3. R Markdown lets you run code chunks and interleave documentation

For more information, see the [RStudio IDE User Guide](https://docs.posit.co/ide/user/).

### Coding in R

Insert a code chunk with `` ```{r} `` and `` ``` `` or use <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>I</kbd> (Windows) / <kbd>Cmd</kbd> + <kbd>Option</kbd> + <kbd>I</kbd> (macOS).

Example:
```r
 ```{r}
print("This code will be run.") # This is a comment

# print("This code will not be run because it is commented out.")
 ```
```

**Common Data Structures:**

* **Vector**: One-dimensional list of same-type objects
* **List**: One-dimensional list of mixed-type objects
* **Matrix/Array**: Two/multi-dimensional table of same-type objects
* **Data frame**: Two-dimensional table of mixed-type objects

**Common Data Types:**

* Numeric: `3.14`, `42`
* Character (strings): `"Hello, World!"`, `"100"`
* Logical (booleans): `TRUE`, `FALSE`

### Common Commands and Packages

Packages are bundles of functions from repositories like CRAN, Bioconductor, or GitHub. Key packages for this workflow:

- `tidyverse` (includes `dplyr`, `ggplot2`) — Data manipulation and visualization
- `phyloseq` — Microbiome data handling
- `MButils` — Lab-developed utilities

Installing packages:

```r
# From CRAN:
install.packages("tidyverse")
library(tidyverse)

# From Bioconductor:
install.packages("BiocManager")
BiocManager::install("phyloseq")
library(phyloseq)

# From GitHub:
install.packages("devtools")
devtools::install_github("ammararuby/MButils")
library(MButils)
```

!!! note
    Install `BiocManager` and `devtools` first to access Bioconductor and GitHub packages. Package installation requires quotes; `library()` does not.

**Operators:**

* `?function` — Access help/documentation
* `<-` — Assignment (e.g., `x <- 10`)
* `%in%` — Check membership (e.g., `2 %in% c(1,2,3)` → `TRUE`)
* `%>%` — Pipe operator for chaining operations
* `!` — Negation
* `&`, `|` — AND, OR

**Base R Functions:**

| Category | Functions |
|----------|-----------|
| Creating objects | `c()`, `list()`, `data.frame()`, `character()` |
| Converting objects | `as.character()`, `as.data.frame()` |
| Names | `names()`, `colnames()`, `rownames()` |
| Inspection | `head()`, `dim()`, `length()`, `nrow()`, `ncol()`, `View()`, `print()` |
| Logic | `if()`, `ifelse()`, `any()`, `is.na()`, `is.null()` |
| Strings | `paste()`, `paste0()`, `gsub()` |
| Files | `read.csv()`, `write.csv()`, `file.path()`, `setwd()`, `source()` |
| Misc | `lapply()`, `unique()`, `setdiff()` |

**dplyr Functions:**

* `filter()` — Keep rows matching conditions
* `select()` — Choose columns
* `mutate()` — Add/modify columns
* `arrange()` — Sort rows
* `group_by()` + `summarise()` — Aggregate data
* `left_join()` — Merge data frames
* `bind_rows()` — Stack data frames

## Cloud Storage

Cloud storage is useful for project files, documentation, and backups.

=== "General"

    Common options include:

    - **Institutional cloud** (Box, OneDrive, Google Drive)
    - **Research-focused** (AWS S3, Google Cloud Storage, CyVerse)
    - **Version-controlled** (GitHub for code, DVC for data)

    Install your institution's cloud sync client to access files through your file browser.

=== "Duke (Box)"

    We use Duke Box for project files. Access at [https://duke.app.box.com/](https://duke.app.box.com/).

    To get access to `project_davidlab`, ask a co-owner (Anna, Lawrence, or Sharon) to add you as a collaborator.

    **Desktop Access:**

    Install Box Drive from [Duke Box Services](https://duke.app.box.com/services/browse/newest/box_drive) to access Box files through Finder/Explorer.

## GitHub

GitHub is a platform for version control and code collaboration. We use it to store pipeline scripts and reference files.

=== "General"

    1. Create a free account at [github.com](https://github.com)
    2. Install Git: [git-scm.com/downloads](https://git-scm.com/downloads)
    3. Configure Git:
        ```sh
        git config --global user.name "Your Name"
        git config --global user.email "your.email@institution.edu"
        ```

=== "Duke Lab"

    Create a GitHub account and contact a project owner to be added to [LAD-LAB](https://github.com/LAD-LAB). Current owners: Anna, Ashish, Ben, Dorothy, Lawrence, Sharon, and Teresa.

### Common Git Commands

* `git clone [url]` — Download a repository
* `git pull` — Update local copy with remote changes
* `git add [files]` — Stage changes for commit
* `git commit -m "message"` — Save staged changes
* `git push` — Upload commits to remote
* `git status` — Check current state
