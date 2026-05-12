#!/bin/bash
#SBATCH --job-name=pacbio16s
#SBATCH --partition=dmcshared
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32  
#SBATCH --mem=256G
#SBATCH --time=5-00:00:00
#SBATCH --out=logs/%x-%j.out
#SBATCH --error=logs/%x-%j.err
#SBATCH --mail-type=END,FAIL  # Only notify on completion/failure

IMG=/hpc/group/ldavidlab/metabarcoding.sif
WORK=/hpc/group/ldavidlab/[path/to/project/folder]

mkdir -p "$WORK/logs" "$WORK/output"

# UNCOMMENT these - they're important for controlling thread usage!
export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK:-32}
export OPENBLAS_NUM_THREADS=$OMP_NUM_THREADS
export MKL_NUM_THREADS=$OMP_NUM_THREADS

# Add scratch space for temp files (faster I/O)
export TMPDIR=/scratch/$SLURM_JOB_ID
mkdir -p $TMPDIR

apptainer exec --bind "$WORK:/work,/scratch:/scratch" "$IMG" \
  Rscript /work/PacBio_16S_pipeline.R

# Cleanup
rm -rf $TMPDIR

