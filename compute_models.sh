#!/usr/bin/env bash

for i in {1..100}; do
	echo "seed je $i"
	qsub -v "SEED=$i" tensorflow_setup.sh
done
