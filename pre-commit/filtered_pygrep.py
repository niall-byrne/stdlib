#!/usr/bin/env python

"""Custom pygrep implementation with a filter regex."""

import sys
import re


def check_args():
    if len(sys.argv) < 4:
        print(
            "Usage: filtered_pygrep.py <filter_pattern> <match_pattern> "
            "<filename1> <filename2> ..."
        )
        sys.exit(1)


def main():
    filter_pattern_str = sys.argv[1]
    match_pattern_str = sys.argv[2]
    filenames = sys.argv[3:]

    filter_pattern = re.compile(r"{}".format(filter_pattern_str))
    match_pattern = re.compile(r"{}".format(match_pattern_str))

    for filename in filenames:
        try:
            with open(filename, 'r') as file_to_read:
                for index, line in enumerate(file_to_read):
                    if filter_pattern.match(line):
                        continue
                    if match_pattern.search(line):
                        sys.stdout.write(
                            "%s - line: %d\n" %
                            (filename, index + 1)
                        )
                        sys.stdout.write(line)
                        sys.exit(1)
        except FileNotFoundError:
            print(f"Error: File not found - {filename}")
            sys.exit(1)


if __name__ == "__main__":
    check_args()
    main()
