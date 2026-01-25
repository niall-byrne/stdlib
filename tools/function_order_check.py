import json
import re
import sys
import os
from typing import List, Tuple, Dict


# Configuration
REGEX_FUNCTION_DEFINITION = r"^([a-zA-Z_@][a-zA-Z0-9._]*) *\(\) *\{"


class BashFunction:
    def __init__(self, name: str, line_number: int):
        self.name = name
        self.line_number = line_number


def custom_sort_key(name: str) -> str:
    """
    Custom sort key to ensure: Letters < _ < . < __
    We map these to characters following 'z' (ASCII 122):
    - _  -> | (ASCII 124)
    - .  -> } (ASCII 125)
    - __ -> ~ (ASCII 126)
    """
    return name.replace("__", "~").replace("_", "|").replace(".", "}")


def parse_functions(filepath: str) -> List[BashFunction]:
    """
    Parses a shell script and extracts function definitions.
    """
    functions: List[BashFunction] = []
    try:
        with open(filepath, "r") as file_handle:
            lines = file_handle.read().splitlines()
    except Exception as e:
        raise Exception(f"Could not read file {filepath}: {str(e)}")

    for index, line in enumerate(lines):
        match = re.match(REGEX_FUNCTION_DEFINITION, line)
        if match:
            functions.append(BashFunction(name=match.group(1), line_number=index + 1))

    return functions


def check_order(filepath: str) -> List[str]:
    """
    Checks if functions in a file are in the correct custom alphabetical order.
    Returns a list of error messages if out of order.
    """
    functions = parse_functions(filepath)
    if not functions:
        return []

    func_names = [f.name for f in functions]
    sorted_names = sorted(func_names, key=custom_sort_key)

    if func_names != sorted_names:
        return [
            f"Functions are not in alphabetical order (refining: Letters < _ < . < __).",
            f"Current: {func_names}",
            f"Expected: {sorted_names}"
        ]

    return []


def main():
    """
    Main entry point for the script.
    """
    files_to_check = sys.argv[1:]

    if not files_to_check:
        print("Error: No files provided for auditing. Please provide at least one file path.", file=sys.stderr)
        sys.exit(1)

    all_discrepancies: Dict[str, List[str]] = {}

    for filepath in files_to_check:
        try:
            errors = check_order(filepath)
            if errors:
                all_discrepancies[filepath] = errors
        except Exception as e:
            all_discrepancies[filepath] = [f"File could not be parsed: {str(e)}"]

    if all_discrepancies:
        # Sort keys for deterministic output
        sorted_output = {k: all_discrepancies[k] for k in sorted(all_discrepancies.keys())}
        print(json.dumps(sorted_output, indent=2))
        sys.exit(1)


if __name__ == "__main__":
    if sys.version_info < (3, 6):
        raise SystemExit("Python 3.6 or greater is required.")
    main()
