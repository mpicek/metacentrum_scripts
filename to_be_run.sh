#!/usr/bin/env bash

set -ueo pipefail

SEED=$1

cd labs/05
python3 cags_classification.py --epochs=100 --epochs2=200 --seed=$SEED

DATADIR="/storage/budejovice1/home/$(whoami)"
cp -r submodel$SEED $DATADIR/cags/models/submodel$SEED
#cp cags_classification.txt $DATADIR
