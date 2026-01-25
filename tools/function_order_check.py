"""Validate the sequence of BASH function definitions inside a script file."""

import json
import re
import sys
from typing import Dict, List

# Configuration
REGEX_FUNCTION_DEFINITION = r"^([a-zA-Z_@][a-zA-Z0-9._]*) *\(\) *\{"


class BashFunction:
    """Represents a function definition in a BASH file."""

    def __init__(self, name: str, line_number: int):
        self.name = name
        self.line_number = line_number


class BashFile:
    """Represents a BASH file and its functions."""

    def __init__(self, filepath: str):
        self.filepath = filepath
        self.functions: List[BashFunction] = []
        self._parse()

    def _parse(self):
        """Parse the file and extracts function definitions."""
        try:
            with open(self.filepath, "r") as file_handle:
                lines = file_handle.read().splitlines()
        except Exception as e:
            raise Exception(f"Could not read file {self.filepath}: {str(e)}")

        for index, line in enumerate(lines):
            match = re.match(REGEX_FUNCTION_DEFINITION, line)
            if match:
                self.functions.append(
                    BashFunction(name=match.group(1), line_number=index + 1))

    @staticmethod
    def _custom_sort_key(name: str) -> str:
        """Transform the function into a sortable key.

        Custom sort key to ensure: Letters < _ < a-z < . < __
        We map these to characters as such:
        - _  -> itself (ASCII 95)
        - .  -> } (ASCII 125)
        - __ -> ~ (ASCII 126)
        """
        return name.replace("__", "~").replace(".", "}")

    def get_sorting_errors(self) -> List[str]:
        """Check if functions are in the correct custom alphabetical order."""
        if not self.functions:
            return []

        func_names = [f.name for f in self.functions]
        sorted_names = sorted(func_names, key=self._custom_sort_key)

        if func_names != sorted_names:
            return [
                "Functions are not in alphabetical order "
                "(refining: Letters < _ < a-z < . < __).",
                f"Current: {func_names}",
                f"Expected: {sorted_names}",
            ]

        return []


def main():
    """Validate the given list of input files."""
    files_to_check = sys.argv[1:]

    if not files_to_check:
        print(
            "Error: No files provided for auditing. "
            "Please provide at least one file path.",
            file=sys.stderr,
        )
        sys.exit(1)

    all_discrepancies: Dict[str, List[str]] = {}

    for filepath in files_to_check:
        try:
            bash_file = BashFile(filepath)
            errors = bash_file.get_sorting_errors()
            if errors:
                all_discrepancies[filepath] = errors
        except Exception as e:
            all_discrepancies[filepath] = [
                f"File could not be parsed: {str(e)}"
            ]

    if all_discrepancies:
        # Sort keys for deterministic output
        sorted_output = {
            k: all_discrepancies[k]
            for k in sorted(all_discrepancies.keys())
        }
        print(json.dumps(sorted_output, indent=2))
        sys.exit(1)


if __name__ == "__main__":
    if sys.version_info < (3, 6):
        raise SystemExit("Python 3.6 or greater is required.")
    main()
