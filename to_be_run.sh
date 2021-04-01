#!/usr/bin/env bash

set -ueo pipefail

DATADIR=/storage/budejovice1/home/$(whoami)

cp -r $DATADIR/npfl114-solutions $SCRATCHDIR  # the repository has to be ready

cd npfl11-solutions/labs/03
python3 uppercase.py

cp uppercase_test.txt $DATADIR
