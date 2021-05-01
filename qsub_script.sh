#!/usr/bin/env bash

# VARIABLES PASSED TO THIS SCRIPT
#   - SEED ... seed to work with
#   - CMD  ... command to be run

# DEFINE RESOURCES:
#PBS -N qsub_script
#PBS -l select=1:ncpus=12:ngpus=1:mem=16gb:scratch_local=15gb:cuda_version=11.2:gpu_cap=cuda61
#PBS -q gpu
#PBS -l walltime=6:00:00

# Directory I use as a main storage
DATADIR="/storage/budejovice1/home/$(whoami)"

# test if scratch directory is set
test -n "$SCRATCHDIR" || { echo >&2 "Variable SCRATCHDIR is not set!"; exit 1; }

# Prepare scratch directory for singularity
chmod 700 $SCRATCHDIR
mkdir $SCRATCHDIR/tmp
export SINGULARITY_TMPDIR=$SCRATCHDIR/tmp

# Prepare NGC container
ls /cvmfs/singularity.metacentrum.cz

# Copy repository with code to be run
#TODO: TOO SPECIFIC
cp -r $DATADIR/$REPOSITORY $SCRATCHDIR || { echo >&2 "Error while copying input file(s)!"; exit 2; }

cd $SCRATCHDIR 

echo "cd $SCRATCHDIR" > my_new_script.sh
echo "cd $PROGRAM_PATH" > my_new_script.sh
echo "$CMD > out" >> my_new_script.sh

# --nv for gpu, bind scratch directory
singularity exec --bind $SCRATCHDIR --nv /cvmfs/singularity.metacentrum.cz/NGC/TensorFlow\:21.02-tf2-py3.SIF bash my_new_script.sh


echo "$CMD"
cd "$PROGRAM_PATH"
cat out

# if I want to copy the created model
if [ "$ENSEMBLE" -eq "1"]; then
    cp -r submodel$SEED $DATADIR/models/submodel$SEED
fi

clean_scratch
