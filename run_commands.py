#!/usr/bin/env python3

import sys
import os
import argparse
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument("--command_file", default="commands", type=str, help="File with commands to be run.")
parser.add_argument("--script", default=None, type=str, help="File with a qsub script.")
parser.add_argument("--repository", default="npfl114-solutions/labs", type=str, help="Repository with code in DATADIR.")
parser.add_argument("--program_path", default="labs/08", type=str, help="Path to the executed program from DATADIR.")
parser.add_argument("--ensemble", action='store_true', help="Create ensemble.")
parser.add_argument("--models", default=10, type=int, help="Number of models in an ensemble.")

def parse(filename):
    """
    Parses the commands from a file:
        - ignores # (=comments) 
        - each command has to be separated either by a newline (at least one) 
        or # (a comment)
    
    Returns:
        List of commands to be run.
    """

    commands = []
    command = ""
    with open(filename, 'r') as file:
        for line in file:
            line = line.strip()
            if len(line) == 0:
                if len(command) > 0:
                    commands.append(command)
                command = ""
                continue

            if line[0] == "#":
                if len(command) > 0:
                    commands.append(command)
                command = ""
                continue

            command += " " + line

        if len(command) > 0:
            commands.append(command)        

    return commands


def main(args):
    if args.script == None:
        raise ValueError("No script defined.")

    commands = parse(args.command_file)

    if args.ensemble:
        # if creating an ensemble, we use just the first command
        command = commands[0]

        for i in range(args.models):
            seed = i + 1 # I don't know whether seed can be 0
            command_with_seed = command + " --seed=" + str(seed)
            seed_var = "SEED=" + str(seed)
            cmd_var = ",CMD=\"" + command_with_seed + "\""
            program_path_var = ",PROGRAM_PATH=\"" + args.program_path + "\""
            ensemble_var = ",ENSEMBLE=\"" + str(0) + "\""
            repository_var = ",REPOSITORY=\"" + args.repository + "\""
            variables = seed_var + cmd_var + ensemble_var + repository_var + program_path_var
            print(variables)
            list_files = subprocess.run(["qsub", "-v", variables, args.script])

    else:
        for command in commands:
            seed = 42
            command_with_seed = command + " --seed=" + str(seed)
            seed_var = "SEED=" + str(seed)
            cmd_var = ",CMD=\"" + command_with_seed + "\""
            program_path_var = ",PROGRAM_PATH=\"" + args.program_path + "\""
            ensemble_var = ",ENSEMBLE=\"" + str(0) + "\""
            repository_var = ",REPOSITORY=\"" + args.repository + "\""
            variables = seed_var + cmd_var + ensemble_var + repository_var + program_path_var
            print(variables)
            list_files = subprocess.run(["qsub", "-v", variables, args.script])

    
if __name__ == "__main__":
    args = parser.parse_args()
    main(args)