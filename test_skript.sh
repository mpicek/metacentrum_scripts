#!/usr/bin/env bash

#PBS -N test_skript
#PBS -l select=1:ncpus=1:mem=2gb:scratch_local=2gb
#PBS -l walltime=0:10:00

module add python/3.8.0-gcc-rab6t


$PRIKAZ # TODO
echo "prikaz byl spusten"

clean_scratch
