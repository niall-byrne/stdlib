import json
import os
import re
import sys
from typing import Dict, List, NamedTuple, Optional, Set


sys.path.append(os.path.dirname(__file__))
from documentation_check import parse_file, Tags, MODIFIER_VARIABLE_PREFIX


class ModifierVariableMetadata(NamedTuple):
    name: str
    var_type: Optional[str]
    modifier: Optional[str]
    description: str
    filepath: str
    function_name: str
    tag_type: str


class ModifierVariableInconsistencyError:

    def __init__(self, var_name: str, instances: List[ModifierVariableMetadata]):
        self.var_name = var_name
        self.instances = instances

    def __str__(self) -> str:
        first = self.instances[0]
        other = self._find_first_inconsistent_instance()

        message = f"Inconsistent documentation for '{self.var_name}':\n"
        message += self._format_instance(first)
        message += self._format_instance(other)
        return message

    def _find_first_inconsistent_instance(self) -> ModifierVariableMetadata:
        first = self.instances[0]
        for inst in self.instances[1:]:
            if self.is_inconsistent(first, inst):
                return inst
        return self.instances[1]

    @staticmethod
    def is_inconsistent(
        first: ModifierVariableMetadata,
        other: ModifierVariableMetadata,
    ) -> bool:
        if first.var_type is not None and other.var_type is not None:
            if first.var_type != other.var_type:
                return True

        if first.description != other.description:
            return True

        if first.modifier is not None and other.modifier is not None:
            if first.modifier != other.modifier:
                return True

        return False

    def _format_instance(self, instance: ModifierVariableMetadata) -> str:
        var_type = instance.var_type if instance.var_type else "None"
        if instance.tag_type == "description":
            modifier = instance.modifier if instance.modifier else "None"
            return (
                f"  {instance.filepath} ({instance.function_name}, @description): "
                f"type='{var_type}', "
                f"modifier='{modifier}', "
                f"description='{instance.description}'\n")
        return (
            f"  {instance.filepath} ({instance.function_name}, @set): "
            f"type='{var_type}', "
            f"description='{instance.description}'\n")


class ModifierVariableConsistencyChecker:

    DESC_WITH_TYPE_PATTERN = (
        rf"^{re.escape(MODIFIER_VARIABLE_PREFIX)}"
        r"(__\$\{2\}[a-z_]+|[A-Z0-9_]+)\s+(\S+)\s+(\S+):\s+(.*)$"
    )

    DESC_SIMPLE_PATTERN = (
        rf"^{re.escape(MODIFIER_VARIABLE_PREFIX)}"
        r"(__\$\{2\}[a-z_]+|[A-Z0-9_]+):\s+(.*)$"
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
        for root, _, filenames in os.walk("src"):
            for filename in filenames:
                if filename.endswith(".sh") or filename.endswith(".snippet"):
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
        match = re.search(self.DESC_WITH_TYPE_PATTERN, line)
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

        match = re.search(self.DESC_SIMPLE_PATTERN, line)
        if match:
            var_name, description = match.groups()
            return ModifierVariableMetadata(
                name=var_name,
                var_type=None,
                modifier=None,
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
        output: Dict[str, List[str]] = {}
        for error in errors:
            message = str(error)
            involved_files = {inst.filepath for inst in error.instances}

            files_to_attribute = set()
            if self.modified_files:
                files_to_attribute = involved_files & self.modified_files
            else:
                files_to_attribute = involved_files

            for filepath in sorted(files_to_attribute):
                if filepath not in output:
                    output[filepath] = []
                output[filepath].append(message)

        if output:
            print(json.dumps(output, indent=2))


def main():
    checker = ModifierVariableConsistencyChecker(sys.argv[1:])
    checker.run()


if __name__ == "__main__":
    main()
