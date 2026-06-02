"""Validate consistency of modifier variables across stdlib documentation."""

import json
import os
import re
import sys
from collections import defaultdict
from typing import Dict, List, NamedTuple, Optional, Set

sys.path.append(os.path.dirname(__file__))
from documentation_check import MODIFIER_VARIABLE_PREFIX, Tags, parse_file

SOURCE_DIRECTORY = "src"
SHELL_EXTENSION = ".sh"
SNIPPET_EXTENSION = ".snippet"
VARIABLE_TYPES = ["string", "integer", "boolean", "array"]


class ModifierVariableMetadata(NamedTuple):
    """Metadata extracted from a modifier variable's documentation."""

    name: str
    var_type: Optional[str]
    modifier: Optional[str]
    description: str
    filepath: str
    function_name: str
    tag_type: str
    is_well_formed: bool


class ModifierVariableInconsistencyError:
    """Represents an inconsistency error in a modifier variable."""

    def __init__(
        self,
        var_name: str,
        instances: List[ModifierVariableMetadata],
    ):
        """Initialize the error with variable name and instances."""
        self.var_name = var_name
        self.instances = instances

    @staticmethod
    def is_inconsistent(
        first: ModifierVariableMetadata,
        other: ModifierVariableMetadata,
    ) -> bool:
        """Check if two metadata instances are inconsistent."""
        if first.var_type != other.var_type:
            return True

        if ModifierVariableInconsistencyError.get_normalized_description(
                first.description
        ) != ModifierVariableInconsistencyError.get_normalized_description(
                other.description):
            return True

        if first.tag_type == "description" and other.tag_type == "description":
            if first.modifier != other.modifier:
                return True

        return False

    @staticmethod
    def get_normalized_description(description: str) -> str:
        """Normalize a description by removing defaults and ensuring period."""
        description = re.sub(r"\s*\(default=.*\)\.*$", "", description)
        if not description.endswith("."):
            description += "."
        return description

    @staticmethod
    def format_instance_details(instance: ModifierVariableMetadata) -> str:
        """Format instance details for error reporting."""
        if not instance.is_well_formed:
            return f"MALFORMED: '{instance.description}'"

        if instance.tag_type == "description":
            return (f"type='{instance.var_type}', "
                    f"modifier='{instance.modifier}', "
                    f"description='{instance.description}'")
        return (f"type='{instance.var_type}', "
                f"description='{instance.description}'")


class ModifierVariableInconsistencyReport(Dict):
    """Represents a report for an inconsistent variable.
    
    {tag: [{ output: {file_name: [ function_name ] } } ] }
    """

    def __init__(self, instances: List[ModifierVariableMetadata]):
        """Initialize the report from a list of metadata instances."""
        super().__init__({})
        self._build_report(instances)

    def _build_report(self, instances: List[ModifierVariableMetadata]):
        """Build the hierarchical report structure from metadata instances."""
        tag_groups = defaultdict(
            lambda: defaultdict(lambda: defaultdict(list)))
        for instance in instances:
            tag_key = f"@{instance.tag_type}"
            details = ModifierVariableInconsistencyError.format_instance_details(
                instance)
            tag_groups[tag_key][details][instance.filepath].append(
                instance.function_name)

        # Convert to requested list-based hierarchy
        for tag, details_map in sorted(tag_groups.items()):
            self[tag] = []
            for details, file_map in sorted(details_map.items()):
                # Sort file map keys and ensure function names are sorted
                sorted_file_map = {
                    fp: sorted(file_map[fp])
                    for fp in sorted(file_map.keys())
                }
                self[tag].append({details: sorted_file_map})


class ModifierVariableConsistencyChecker:
    """Check consistency of modifier variables across multiple files."""

    DESCRIPTION_BLOCK_REGEX = (
        rf"^{re.escape(MODIFIER_VARIABLE_PREFIX)}"
        r"(__\$\{2\}[a-z_]+|[A-Z0-9_]+)\s+(\S+)\s+(\S+):\s+(.*)$")

    DESCRIPTION_BLOCK_MALFORMED_REGEX = (
        rf"^{re.escape(MODIFIER_VARIABLE_PREFIX)}"
        r"(__\$\{2\}[a-z_]+|[A-Z0-9_]+).*")

    def __init__(self, modified_files: List[str]):
        """Initialize the checker with a list of modified files."""
        self.modified_files = set(modified_files)
        self.all_metadata: Dict[str, List[ModifierVariableMetadata]] = {}

    def run(self):
        """Execute the consistency check and report any errors."""
        relevant_files = self._get_all_relevant_files()
        self._collect_metadata_from_files(relevant_files)

        errors = self._identify_consistency_errors()
        if errors:
            self._report_errors(errors)
            sys.exit(1)

    def _get_all_relevant_files(self) -> Set[str]:
        """Get all shell script files to analyze."""
        files = set()
        for root, _, filenames in os.walk(SOURCE_DIRECTORY):
            for filename in filenames:
                if filename.endswith(SHELL_EXTENSION) or filename.endswith(
                        SNIPPET_EXTENSION):
                    files.add(os.path.join(root, filename))

        for arg in self.modified_files:
            if os.path.isfile(arg):
                files.add(arg)

        return files

    def _collect_metadata_from_files(self, filepaths: Set[str]):
        """Collect metadata from all provided filepaths."""
        for filepath in sorted(filepaths):
            file_metadata = self._parse_file_for_metadata(filepath)
            for var_name, instances in file_metadata.items():
                if var_name not in self.all_metadata:
                    self.all_metadata[var_name] = []
                self.all_metadata[var_name].extend(instances)

    def _parse_file_for_metadata(
        self,
        filepath: str,
    ) -> Dict[str, List[ModifierVariableMetadata]]:
        """Parse a file and extract all modifier variable metadata."""
        file_metadata: Dict[str, List[ModifierVariableMetadata]] = {}
        try:
            parsed_file = parse_file(filepath)
            for function in parsed_file.functions:
                for metadata in self._extract_function_metadata(
                        function, filepath):
                    if metadata.name not in file_metadata:
                        file_metadata[metadata.name] = []
                    file_metadata[metadata.name].append(metadata)
        except Exception:
            pass
        return file_metadata

    def _extract_function_metadata(
        self,
        function,
        filepath: str,
    ) -> List[ModifierVariableMetadata]:
        """Extract all modifier variable metadata from a function."""
        return (self._extract_from_description_block(function, filepath) +
                self._extract_from_set_tags(function, filepath))

    def _extract_from_description_block(
        self,
        function,
        filepath: str,
    ) -> List[ModifierVariableMetadata]:
        """Extract metadata from function description blocks."""
        metadata_list = []
        for line in function.modifier_var_lines:
            metadata = self._build_description_metadata(
                line, function.name, filepath)
            metadata_list.append(metadata)
        return metadata_list

    def _build_description_metadata(self, line: str, function_name: str,
                                    filepath: str) -> ModifierVariableMetadata:
        """Build metadata from a single description block line."""
        params = {
            "filepath": filepath,
            "function_name": function_name,
            "tag_type": "description",
        }

        match = re.search(self.DESCRIPTION_BLOCK_REGEX, line)
        if match:
            var_name, var_type, modifier, description = match.groups()
            return ModifierVariableMetadata(
                name=var_name,
                var_type=var_type,
                modifier=modifier,
                description=description.strip(),
                is_well_formed=True,
                **params,
            )
        else:
            match = re.search(self.DESCRIPTION_BLOCK_MALFORMED_REGEX, line)
            return ModifierVariableMetadata(
                name=match.group(1) if match else "UNKNOWN",
                var_type=None,
                modifier=None,
                description=line.strip(),
                is_well_formed=False,
                **params,
            )

    def _extract_from_set_tags(
        self,
        function,
        filepath: str,
    ) -> List[ModifierVariableMetadata]:
        """Extract metadata from @set tags in function documentation."""
        metadata_list = []
        for tag in function.find_tags(Tags.SET):
            metadata = self._build_set_metadata(tag, function.name, filepath)
            metadata_list.append(metadata)
        return metadata_list

    def _build_set_metadata(self, tag, function_name: str,
                            filepath: str) -> ModifierVariableMetadata:
        """Build metadata from a @set tag."""
        params = {
            "filepath": filepath,
            "function_name": function_name,
            "tag_type": "set",
        }

        parts = tag.content.split()
        if len(parts) >= 3 and parts[1] in VARIABLE_TYPES:
            parts = tag.content.split(maxsplit=2)
            return ModifierVariableMetadata(
                name=parts[0],
                var_type=parts[1],
                modifier=None,
                description=parts[2].strip(),
                is_well_formed=True,
                **params,
            )
        else:
            return ModifierVariableMetadata(
                name=parts[0] if parts else "UNKNOWN",
                var_type=None,
                modifier=None,
                description=tag.content.strip(),
                is_well_formed=False,
                **params,
            )

        return ModifierVariableMetadata(**params)

    def _identify_consistency_errors(
            self) -> List[ModifierVariableInconsistencyError]:
        """Identify all consistency errors among collected metadata."""
        errors = []
        for var_name, instances in self.all_metadata.items():
            if not self._should_report_inconsistency(instances):
                continue

            if self._has_inconsistency(instances):
                errors.append(
                    ModifierVariableInconsistencyError(var_name, instances))
        return errors

    def _has_inconsistency(self,
                           instances: List[ModifierVariableMetadata]) -> bool:
        """Check if metadata instances have any inconsistencies."""
        for i in range(len(instances)):
            if not instances[i].is_well_formed:
                return True

            for j in range(i + 1, len(instances)):
                if ModifierVariableInconsistencyError.is_inconsistent(
                        instances[i], instances[j]):
                    return True
        return False

    def _should_report_inconsistency(
        self,
        instances: List[ModifierVariableMetadata],
    ) -> bool:
        """Determine if an inconsistency should be reported."""
        if not self.modified_files:
            return True
        involved_files = {inst.filepath for inst in instances}
        return bool(involved_files & self.modified_files)

    def _report_errors(self, errors: List[ModifierVariableInconsistencyError]):
        """Report all identified errors to stdout as JSON."""
        output: Dict[str, List[Dict]] = {}

        for error in errors:
            report = ModifierVariableInconsistencyReport(error.instances)
            # { variable_name: [ {tag: [ {details: file_map} ] } ] }
            output[error.var_name] = [{
                tag: items
            } for tag, items in sorted(report.items())]

        if output:
            print(json.dumps(output, indent=2))


def main():
    """Run the modifier variable consistency checker on provided files."""
    checker = ModifierVariableConsistencyChecker(sys.argv[1:])
    checker.run()


if __name__ == "__main__":
    main()
