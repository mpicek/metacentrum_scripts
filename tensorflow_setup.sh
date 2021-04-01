#!/usr/bin/env bash

set -ueo pipefail

#PBS -N tensorflow_setup
#PBS -l select=1:ncpus=4:mem=4gb:scratch_local=5gb
#PBS -l walltime=1:00:00
#PBS -m bae

DATADIR=/storage/budejovice1/home/$(whoami)

echo "$PBS_JOBID is running on node `hostname -f` in a scratch directory $SCRATCHDIR" >> $DATADIR/jobs_info.txt

module add python/3.8.0-gcc-rab6t
module add cudnn-7.6.4-cuda10.0 cudnn-7.6.4-cuda10.1

# test if scratch directory is set
# if scratch directory is not set, issue error message and exit
test -n "$SCRATCHDIR" || { echo >&2 "Variable SCRATCHDIR is not set!"; exit 1; }

# if the copy operation fails, issue error message and exit
cp $DATADIR/to_be_run.sh  $SCRATCHDIR || { echo >&2 "Error while copying input file(s)!"; exit 2; }

# move into scratch directory
cd $SCRATCHDIR 

# run Gaussian 03 with h2o.com as input and save the results into h2o.out file
# if the calculation ends with an error, issue error message an exit
./to_be_run.sh > to_be_run_out || { echo >&2 "Calculation ended up erroneously (with a code $?) !!"; exit 3; }

# move the output to user's DATADIR or exit in case of failure
cp to_be_run_out $DATADIR/ || { echo >&2 "Result file(s) copying failed (with a code $?) !!"; exit 4; }

# clean the SCRATCH directory
clean_scratch