#!/usr/bin/env bash

for f in tensorflow_setup.o*; do
	echo $f
	tail -6 $f | head -2
done
