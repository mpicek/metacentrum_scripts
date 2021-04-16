#!/usr/bin/env python3
"""
Parses the commands from a file - ignores # and each command is separated by newline (at least one) or # (=comment)
"""

import sys
import os
import argparse

import subprocess

parser = argparse.ArgumentParser()
parser.add_argument("--filename", default="commands", type=str, help="File with commands.")
parser.add_argument("--script", default=None, type=str, help="File with a qsub script.")

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

    script = parse(args.script)
    commands = parse(args.filename)

    for command in commands:
        seed = 42
        variables = "SEED=" + str(seed) + ",CMD=\"" + command + "\""
        # print(variables)
        list_files = subprocess.run(["qsub", "-v", variables, script])
        # list_files = subprocess.run(["qsub", "-v", variables, "boss_script.sh"])
    # print("The exit code was: %d" % list_files.returncode)
    
if __name__ == "__main__":
    args = parser.parse_args()
    main(args)