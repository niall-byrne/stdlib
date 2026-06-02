import json
import os
import re
import sys
from typing import Dict, List, NamedTuple, Optional, Set


sys.path.append(os.path.dirname(__file__))
from documentation_check import parse_file, Tags, MODIFIER_VARIABLE_PREFIX


SOURCE_DIRECTORY = "src"
SHELL_EXTENSION = ".sh"
SNIPPET_EXTENSION = ".snippet"


class ModifierVariableMetadata(NamedTuple):
    name: str
    var_type: str
    modifier: Optional[str]
    description: str
    filepath: str
    function_name: str
    tag_type: str


class ModifierVariableInconsistencyError:

    def __init__(self, var_name: str, instances: List[ModifierVariableMetadata]):
        self.var_name = var_name
        self.instances = instances

    @staticmethod
    def is_inconsistent(
        first: ModifierVariableMetadata,
        other: ModifierVariableMetadata,
    ) -> bool:
        return (first.var_type != other.var_type or
                first.modifier != other.modifier or
                first.description != other.description)

    @staticmethod
    def format_instance_details(instance: ModifierVariableMetadata) -> str:
        if instance.tag_type == "description":
            return (f"type='{instance.var_type}', "
                    f"modifier='{instance.modifier}', "
                    f"description='{instance.description}'")
        return (f"type='{instance.var_type}', "
                f"description='{instance.description}'")


class ModifierVariableFileReport(Dict):
    """Represents a report for a specific file: {file_name: [ {function_name: [ {tag: details} ] } ] }."""

    def __init__(self, filepath: str):
        super().__init__({filepath: []})
        self.filepath = filepath

    def add_instance(self, instance: ModifierVariableMetadata):
        details = ModifierVariableInconsistencyError.format_instance_details(instance)
        tag_key = f"@{instance.tag_type}"
        self[self.filepath].append({
            instance.function_name: [{
                tag_key: details
            }],
        })


class ModifierVariableConsistencyChecker:

    DESCRIPTION_TAG_PATTERN = (
        rf"^{re.escape(MODIFIER_VARIABLE_PREFIX)}"
        r"(__\$\{2\}[a-z_]+|[A-Z0-9_]+)\s+(\S+)\s+(\S+):\s+(.*)$"
    )

    def __init__(self, modified_files: List[str]):
        self.modified_files = set(modified_files)
        self.all_metadata: Dict[str, List[ModifierVariableMetadata]] = {}

    def run(self):
        relevant_files = self._get_all_relevant_files()
        self._collect_metadata_from_files(relevant_files)

        errors = self._identify_consistency_errors()
        if errors:
            self._report_errors(errors)
            sys.exit(1)

    def _get_all_relevant_files(self) -> Set[str]:
        files = set()
        for root, _, filenames in os.walk(SOURCE_DIRECTORY):
            for filename in filenames:
                if filename.endswith(SHELL_EXTENSION) or filename.endswith(
                        SNIPPET_EXTENSION):
                    files.add(os.path.join(root, filename))

        if os.path.exists("dist/docs.sh"):
            files.add("dist/docs.sh")

        for arg in self.modified_files:
            if os.path.isfile(arg):
                files.add(arg)

        return files

    def _collect_metadata_from_files(self, filepaths: Set[str]):
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
        file_metadata: Dict[str, List[ModifierVariableMetadata]] = {}
        try:
            parsed_file = parse_file(filepath)
            for function in parsed_file.functions:
                for metadata in self._extract_function_metadata(function, filepath):
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
        return (self._extract_from_description_block(function, filepath) +
                self._extract_from_set_tags(function, filepath))

    def _extract_from_description_block(
        self,
        function,
        filepath: str,
    ) -> List[ModifierVariableMetadata]:
        metadata_list = []
        for line in function.modifier_var_lines:
            metadata = self._parse_description_line(line, function.name, filepath)
            if metadata:
                metadata_list.append(metadata)
        return metadata_list

    def _parse_description_line(
        self,
        line: str,
        function_name: str,
        filepath: str,
    ) -> Optional[ModifierVariableMetadata]:
        match = re.search(self.DESCRIPTION_TAG_PATTERN, line)
        if match:
            var_name, var_type, modifier, description = match.groups()
            return ModifierVariableMetadata(
                name=var_name,
                var_type=var_type,
                modifier=modifier,
                description=description.strip(),
                filepath=filepath,
                function_name=function_name,
                tag_type="description",
            )
        return None

    def _extract_from_set_tags(
        self,
        function,
        filepath: str,
    ) -> List[ModifierVariableMetadata]:
        metadata_list = []
        for tag in function.find_tags(Tags.SET):
            parts = tag.content.split(maxsplit=2)
            if len(parts) >= 3:
                var_name, var_type, description = parts
                metadata_list.append(
                    ModifierVariableMetadata(
                        name=var_name,
                        var_type=var_type,
                        modifier=None,
                        description=description.strip(),
                        filepath=filepath,
                        function_name=function.name,
                        tag_type="set",
                    ))
        return metadata_list

    def _identify_consistency_errors(self) -> List[ModifierVariableInconsistencyError]:
        errors = []
        for var_name, instances in self.all_metadata.items():
            if len(instances) < 2:
                continue

            if self._has_inconsistency(instances):
                if self._should_report_inconsistency(instances):
                    errors.append(ModifierVariableInconsistencyError(var_name, instances))
        return errors

    def _has_inconsistency(self, instances: List[ModifierVariableMetadata]) -> bool:
        first = instances[0]
        for other in instances[1:]:
            if ModifierVariableInconsistencyError.is_inconsistent(first, other):
                return True
        return False

    def _should_report_inconsistency(
        self,
        instances: List[ModifierVariableMetadata],
    ) -> bool:
        if not self.modified_files:
            return True
        involved_files = {inst.filepath for inst in instances}
        return bool(involved_files & self.modified_files)

    def _report_errors(self, errors: List[ModifierVariableInconsistencyError]):
        # { variable_name: [ {file_name: [ {function_name: [ {tag: output} ] } ] } ] }
        output: Dict[str, List[ModifierVariableFileReport]] = {}

        for error in errors:
            output[error.var_name] = self._build_variable_report(error.instances)

        if output:
            print(json.dumps(output, indent=2))

    def _build_variable_report(
        self,
        instances: List[ModifierVariableMetadata],
    ) -> List[ModifierVariableFileReport]:
        files_to_reports: Dict[str, ModifierVariableFileReport] = {}
        for instance in instances:
            if instance.filepath not in files_to_reports:
                files_to_reports[instance.filepath] = ModifierVariableFileReport(
                    instance.filepath)
            files_to_reports[instance.filepath].add_instance(instance)

        return [files_to_reports[filepath] for filepath in sorted(files_to_reports.keys())]


def main():
    checker = ModifierVariableConsistencyChecker(sys.argv[1:])
    checker.run()


if __name__ == "__main__":
    main()
