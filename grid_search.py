#!/usr/bin/env python3
"""
Carries out grid search based on predefined dictionary of parameters.
"""

import sys
import os
import argparse
import subprocess
import itertools


def main(args):
    if args.script is None:
        raise ValueError("No script defined.")

    # WARNING - this grows exponentially! All combinations are tried!
    params = {
        "batch_size" : [64, 128],
        "epochs" : [30],
        "dropout" : [0.0, 0.1, 0.3, 0.5],
        "rnn" : ["R-SB-128-0,B-128-0E", "R-SB-128-0,B-128-0E,B-128-0", "R-SB-128-0.1,B-128-0.1E", "B-128-0,B-128-0"]
    }
    
    variables = params.keys()
    keys, values = zip(*params.items())
    permutations_dicts = [dict(zip(keys, v)) for v in itertools.product(*values)]

    print(f"There will be {str(len(permutations_dicts))} instances.")
    print("Do you wish to proceed? [y/n]")

    answer = None
    while answer != 'y' and answer != 'n':
        if answer != None:
            print("Wrong answer. Asking again: Do you wish to proceed? [y/n]")
        answer = input()

    if answer == 'n':
        sys.exit(0)

    for i, param_dict in enumerate(permutations_dicts):
        command = args.command_prefix
        for key, val in param_dict.items():
            command += " --" + key + "=" + str(val)

        seed = 42
        command_with_seed = command + ' --seed=' + str(seed)
        seed_var = 'SEED=' + str(seed)
        cmd_var = ',CMD="' + command_with_seed + '"'
        program_path_var = ',PROGRAM_PATH="' + args.program_path + '"'
        ensemble_var = ',ENSEMBLE="' + str(0) + '"'
        repository_var = ',REPOSITORY="' + args.repository + '"'
        variables = seed_var + cmd_var + ensemble_var + repository_var + program_path_var
        print(f"Program number: {str(i + 1)}")
        print(variables)
        print(command)

        list_files = subprocess.run(['qsub', '-v', variables, args.script])

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--command_file", default="commands", type=str, help="File with commands to be run.")
    parser.add_argument("--script", default=None, type=str, help="File with a qsub script.")
    parser.add_argument("--repository", default="npfl114-solutions/labs", type=str, help="Repository with code in DATADIR.")
    parser.add_argument("--program_path", default="labs/08", type=str, help="Path to the executed program from DATADIR.")
    parser.add_argument("--command_prefix", default="python3 competition_final.py", type=str, help="Beginning of the command executed.")

    args = parser.parse_args()
    main(args)
