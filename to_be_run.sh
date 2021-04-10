#!/usr/bin/env bash

set -ueo pipefail

cd labs/05
python3 cags_classification.py --epochs=2 --epochs2=2 --threads=8

DATADIR="/storage/budejovice1/home/$(whoami)"
cp cags_classification.txt $DATADIR
