# Setting Up

This page is intended to help you set up and familiarize yourself with the lab's biostatistics essentials, such as GitHub, the Duke Compute Cluster, and Isilon.

## Duke Compute Cluster

The Duke Compute Cluster (DCC) is a high-performance computing cluster, a group of large and powerful servers (nodes) connected by a high-speed network that is able to handle massive amounts of data at high speeds. The DCC uses Slurm for cluster management and job scheduling. For further information, visit [https://oit-rc.pages.oit.duke.edu/rcsupportdocs/](https://oit-rc.pages.oit.duke.edu/rcsupportdocs/).

The DCC has two directories, `/hpc/home` and `/hpc/group`; as the former has limited storage, much of our work with the DCC is done in the latter, particularly within `/hpc/group/ldavidlab`. Create a folder for yourself at `/hpc/group/ldavidlab/users/[NetID]`.

### Logging In

To use the Duke Compute Cluster, open the terminal and log in with `ssh [NetID]@dcc-login.oit.duke.edu`. This will require multi-factor authentication. Here is an example of what this should look like:

``` sh
(base) ams292@MGM-C6LXGRQV ~ % ssh ams292@dcc-login.oit.duke.edu
(ams292@dcc-login.oit.duke.edu) Password: 
(ams292@dcc-login.oit.duke.edu) Duo two-factor login for ams292

Enter a passcode or select one of the following options:

 1. Duo Push to XXX-XXX-0389
 2. Duo Push to ipad (iOS)
 3. Phone call to XXX-XXX-0389
 4. SMS passcodes to XXX-XXX-0389

Passcode or option (1-4): 1
Success. Logging you in...
Success. Logging you in...
Last login: Tue Oct  1 10:26:19 2024 from 152.16.191.138
################################################################################
# Please report any issues or questions to: oitresearchsupport@duke.edu        #
#                                                                              #
# Duke Research Computing info and documentation: https://rc.duke.edu          #
#                                                                              #
# My next patch run is Wednesday (10-02-2024) at  7 PM                         #
################################################################################
ams292@dcc-login-04  ~ $ 
```

### SSH Keys

You can set up ssh keys as a secure workaround to using your password with multi-factor authentication. To generate a key pair, first run:

``` sh
ssh-keygen -t ed25519
```

Save the file to the default location and choose a secure passphrase when prompted; your public key will be stored in the file `~/.ssh/id_ed25519.pub`.

Next, view your *public* key by running:

``` sh
cat ~/.ssh/id_ed25519.pub 
# Make sure to include .pub
```

and copy the contents to your Duke profile at [https://idms-web-selfservice.oit.duke.edu/advanced](https://idms-web-selfservice.oit.duke.edu/advanced) under "Manage Your Public SSH Keys." Next time you log in, you can use your secure passphrase without using MFA! 

Next, set up a key manager or `ssh-agent` to allow you to authenticate without re-entering your passphrase; Linux does this automatically, but for Mac users, run:

``` sh
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

and enter your passphrase. Then, edit `~/.ssh/config` with the following lines:

``` sh
Host *
UseKeychain yes
AddKeysToAgent yes
IdentityFile ~/.ssh/id_ed25519
```

 For Windows users, follow [these instructions](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement).

### Command-Line Alternatives

You can also access the DCC from [DCC OnDemand](https://dcc-ondemand-01.oit.duke.edu/) (accessible via NetID login) or Cyberduck (instructions for use are below). You may find these alternatives helpful for their intuitive interfaces, but I would recommend developing a familiarity with using the DCC through the command line nevertheless.

!!! to-do

    Add instructions for setting up and using Cyberduck.

### Common Commands

Some Slurm commands commonly used in lab scripts include or that otherwise may prove useful include:

* `sbatch [file.sh]` — this submits a batch job to run an inputted shell script; the output should look like `Submitted batch job [jobid]`. 
    * you can receive an email notification when the job finishes running by inserting `--mail-user=[NetID]@duke.edu` after `sbatch`.
    * you can schedule a job to run after another job completes by inserting `--dependency=afterok:[jobid]` after `sbatch`, where `[jobid]` is the job ID of the previous job.
* `squeue -u [NetID]` — this shows a list of jobs submitted under your NetID.
* `scancel [jobid]` — this cancels a job.

## Isilon

We use Isilon for high-volume storage, including sequencing data and the SQL file necessary for phyloseq creation. To connect to Isilon on Windows:

1. Open This PC. On the File Explorer ribbon, select More (the three dots) and then Map network drive.
2. In the Drive list, select any available letter. In the Folder box, enter `\\duhsnas-pri.dhe.duke.edu\dusom_mgm-david\All_Staff`. Select Reconnect at sign-in and then select Finish.
3. If prompted to sign in, enter `DHE\[NetID]` as your username.

To connect to Isilon on a Mac:

1. Open Finder and, under Go, select Connect to server... (or <kbd>⌘ K</kbd>)
2. Enter `smb://DHE;[NetID]@duhsnas-pri.dhe.duke.edu/dusom_mgm-david\All_Staff`; add this to Favorite Servers under + and then select Connect.

## Terminal

### Common Commands

## R

R is the programming language most commonly used in academia for statistical computing and data visualization, including in many of the biostatistical tools and analyses used by the lab. 

To download R, visit https://cran.r-project.org/ and follow the instructions and prompts for your operating system. You may need to download an older version of R for compatibility with some packages; you can do this [here](https://cran.r-project.org/bin/macosx/big-sur-arm64/base/) for computers running macOS with Apple silicon and [here](https://cran.r-project.org/bin/windows/base/old/) for computers running Windows. A majority of the lab currently uses R 4.4.1.

### Setting Up RStudio

RStudio is an IDE, or integrated development environment, that creates a user-friendly interface with helpful developer tools for coding in R. Follow the instructions at https://posit.co/download/rstudio-desktop/ to download RStudio.

### Common Commands

## Box

## GitHub

!!! to-do

    Add GitHub instructions.

### Common Commands

!!! to-do

    Add common `git` commands.
