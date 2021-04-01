#!/usr/bin/env bash

set -ueo pipefail

#PBS -N basic_job
#PBS -l select=1:ncpus=4:mem=4gb:scratch_local=5gb
#PBS -l walltime=1:00:00
#PBS -m bae

DATADIR=/storage/budejovice1/home/$(whoami)

echo "$PBS_JOBID is running on node `hostname -f` in a scratch directory $SCRATCHDIR" >> $DATADIR/jobs_info.txt

module add python/3.8.0-gcc-rab6t
module add cudnn-7.6.4-cuda10.0 cudnn-7.6.4-cuda10.1

pip3 install --user --upgrade pip setuptools
pip3 install --user tensorflow==2.4.1 tensorflow-addons==0.12.1 tensorflow-probability==0.12.1 tensorflow-hub==0.11.0 gym==0.18.0

# test if scratch directory is set
# if scratch directory is not set, issue error message and exit
test -n "$SCRATCHDIR" || { echo >&2 "Variable SCRATCHDIR is not set!"; exit 1; }

# copy input file "h2o.com" to scratch directory
# if the copy operation fails, issue error message and exit
cp $DATADIR/something.py  $SCRATCHDIR || { echo >&2 "Error while copying input file(s)!"; exit 2; }

# move into scratch directory
cd $SCRATCHDIR 

# run Gaussian 03 with h2o.com as input and save the results into h2o.out file
# if the calculation ends with an error, issue error message an exit
something.py <inp >out || { echo >&2 "Calculation ended up erroneously (with a code $?) !!"; exit 3; }

# move the output to user's DATADIR or exit in case of failure
cp out $DATADIR/ || { echo >&2 "Result file(s) copying failed (with a code $?) !!"; exit 4; }

# clean the SCRATCH directory
clean_scratch
