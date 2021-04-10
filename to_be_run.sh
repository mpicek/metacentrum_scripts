#!/usr/bin/env bash

set -ueo pipefail

cd labs/05
python3 cags_classification.py --epochs=2 --epochs2=2 --threads=8

cp cifar_competition_test.txt $DATADIR
