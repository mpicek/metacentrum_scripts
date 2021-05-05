#!/usr/bin/env bash

#Just crops the output of the output files so that one sees only the last
#and most important lines of the file.

for f in qsub_script.o*; do
	echo $f
	tail -6 $f | head -2
done
