#!/usr/bin/env bash

#set -ueo pipefail

#PBS -N tensorflow_setup
#PBS -l select=1:ncpus=6:ngpus=1:mem=16gb:scratch_local=10gb
#PBS -q gpu
#PBS -l walltime=3:00:00

DATADIR="/storage/budejovice1/home/$(whoami)"


#module add python36-modules-gcc
module add python/3.8.0-gcc-rab6t
module add cuda-10.1 cudnn-7.6.4-cuda10.1
#module add cudnn-7.6.4-cuda10.0 cudnn-7.6.4-cuda10.1

# test if scratch directory is set
# if scratch directory is not set, issue error message and exit
test -n "$SCRATCHDIR" || { echo >&2 "Variable SCRATCHDIR is not set!"; exit 1; }

# if the copy operation fails, issue error message and exit
cp $DATADIR/metacentrum_scripts/to_be_run.sh $SCRATCHDIR || { echo >&2 "Error while copying input file(s)!"; exit 2; }
cp -r $DATADIR/npfl114-solutions/labs $SCRATCHDIR || { echo >&2 "Error while copying input file(s)!"; exit 2; }

# move into scratch directory
cd $SCRATCHDIR 

python -m venv venv
. ./venv/bin/activate

venv/bin/pip3 install --upgrade pip setuptools
# warning - using tensorflow 2.3.1 due to CUDA drivers
venv/bin/pip3 install tensorflow==2.3.1 tensorflow-addons==0.12.1

# run Gaussian 03 with h2o.com as input and save the results into h2o.out file
# if the calculation ends with an error, issue error message an exit



cd labs/06
$(PRIKAZ) # TODO
# python3 3d_recognition.py --epochs=100 --epochs2=200 --seed=$SEED

DATADIR="/storage/budejovice1/home/$(whoami)"
# cp -r submodel$SEED $DATADIR/cags/models/submodel$SEED

# ./to_be_run.sh $SEED > to_be_run_out || { echo >&2 "Calculation ended up erroneously (with a code $?) !!"; exit 3; }

# move the output to user's DATADIR or exit in case of failure
# cp to_be_run_out $DATADIR/ || { echo >&2 "Result file(s) copying failed (with a code $?) !!"; exit 4; }

# clean the SCRATCH directory
clean_scratch