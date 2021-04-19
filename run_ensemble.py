#!/usr/bin/env python3
"""
Parses the commands from a file - ignores # and each command is separated by newline (at least one) or # (=comment)
"""

import sys
import os
import argparse

import subprocess

parser = argparse.ArgumentParser()
parser.add_argument("--command_file", default="commands", type=str, help="File with commands.")
parser.add_argument("--script", default=None, type=str, help="File with a qsub script.")
parser.add_argument("--models", default=15, type=int, help="Number of files in an ensemble.")

def parse(filename):

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

    command = parse(args.command_file) # there will be just one command!
    command = command[0]

    for i in range(args.models):
        seed = i + 1 # I don't know wheter seed can be 0
        command_with_seed = command + " --seed=" + str(seed)
        variables = "SEED=" + str(seed) + ",CMD=\"" + command_with_seed + "\""
        print(variables)
        list_files = subprocess.run(["qsub", "-v", variables, args.script])

    
if __name__ == "__main__":
    args = parser.parse_args()
    main(args)