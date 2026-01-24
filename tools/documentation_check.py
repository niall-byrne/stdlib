import json
import re
import sys
from dataclasses import dataclass
from typing import List, Optional, Dict


# Configuration
@dataclass(frozen=True)
class TagDefinition:
    name: str
    is_mandatory: bool = False
    check_sentence_format: bool = False
    has_types: bool = False

    @property
    def description_pattern(self) -> str:
        if self.has_types:
            return rf"@{self.name}\s+\S+\s+\S+\s+(.*)"
        if self.name == "exitcode":
            return rf"@{self.name}\s+\S+\s+(.*)"
        return rf"@{self.name}\s+(.*)"


class Tags:
    DESCRIPTION = TagDefinition(
        name="description", is_mandatory=True, check_sentence_format=True
    )
    ARG = TagDefinition(name="arg", check_sentence_format=True, has_types=True)
    NOARGS = TagDefinition(name="noargs", check_sentence_format=True)
    EXITCODE = TagDefinition(name="exitcode", check_sentence_format=True)
    SET = TagDefinition(name="set", check_sentence_format=True, has_types=True)
    STDIN = TagDefinition(name="stdin", check_sentence_format=True)
    STDOUT = TagDefinition(name="stdout", check_sentence_format=True)
    STDERR = TagDefinition(name="stderr", check_sentence_format=True)
    INTERNAL = TagDefinition(name="internal")

    @classmethod
    @property
    def sequence(cls) -> List[TagDefinition]:
        return [v for v in cls.__dict__.values() if isinstance(v, TagDefinition)]


MANDATORY_EXIT_CODES = ["0"]
REGEX_DOC_TAGS = rf"@({'|'.join([t.name for t in Tags.sequence])})"
REGEX_ECHO_ASSIGNMENT = r"=\s*\"?builtin echo"
REGEX_FUNCTION_DEFINITION = r"^([a-zA-Z_@][a-zA-Z0-9._]*) *\(\) *\{"
REGEX_PROCESS_SUBSTITUTION = r"[\$=]\(builtin echo"
STANDARDIZED_EXIT_CODES = {
    "126": rf"@{Tags.EXITCODE.name} 126 If an invalid argument has been provided\.",
    "127": rf"@{Tags.EXITCODE.name} 127 If the wrong number of arguments were provided\.",
}
STDERR_TRIGGERS = ["stdlib.logger.error", "stdlib.logger.warning", ">&2"]
STDOUT_TRIGGERS = [
    "stdlib.logger.info",
    "stdlib.logger.success",
    "stdlib.logger.notice",
    "builtin echo",
]
TRIGGER_IGNORE_COMMENT = "# noqa"
VARIABLE_TYPES = ["string", "integer", "boolean", "array"]


@dataclass
class DocTag:
    tag: TagDefinition
    content: str
    line: str


class BashFunction:
    def __init__(
        self,
        name: str,
        doc_lines: List[str],
        body_lines: List[str],
    ):
        self.name = name
        self.doc_lines = doc_lines
        self.body_lines = body_lines
        self.tags: List[DocTag] = []
        self.global_var_lines: List[str] = []
        self._extract_documentation()

    def _extract_documentation(self):
        desc_started = False
        tag_map = {t.name: t for t in Tags.sequence}
        for line in self.doc_lines:
            tag_match = re.search(REGEX_DOC_TAGS, line)
            if tag_match:
                tag_name = tag_match.group(1)
                content = line.split("@" + tag_name, 1)[1].strip()
                self.tags.append(
                    DocTag(tag=tag_map[tag_name], content=content, line=line)
                )
                desc_started = tag_name == Tags.DESCRIPTION.name
            elif desc_started:
                if (
                    ":" in line
                    and line.strip().startswith("#")
                    and not line.startswith("# @")
                ):
                    self.global_var_lines.append(line)
                elif line.startswith("# @"):
                    desc_started = False

    def contains_tag(self, tag_name: str) -> bool:
        return any(t.tag.name == tag_name for t in self.tags)

    def find_tags(self, tag_name: str) -> List[DocTag]:
        return [t for t in self.tags if t.tag.name == tag_name]


class Rule:
    def check(self, func: BashFunction) -> List[str]:
        raise NotImplementedError


class AssertionStderrRule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        if "assert" not in func.name:
            return []

        msg = "The error message if the assertion fails."
        return [
            f"{func.name}: @{Tags.STDERR.name} for assertion should use '{msg}'. Found: '{tag.line.strip()}'"
            for tag in func.find_tags(Tags.STDERR.name)
            if msg not in tag.content
        ]


class ExitCodeDescriptionRule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        errors = []
        for tag in func.find_tags(Tags.EXITCODE.name):
            m = re.search(tag.tag.description_pattern, tag.line)
            if m:
                text = m.group(1).strip()
                if text and not text.startswith("If"):
                    errors.append(
                        f"{func.name}: @{Tags.EXITCODE.name} description should start with 'If'. Found: '{text}'"
                    )
        return errors


class FieldOrderRule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        tag_names = [t.name for t in Tags.sequence]
        actual_order = [t.tag.name for t in func.tags if t.tag.name in tag_names]
        seen = []
        for f in actual_order:
            if f not in seen:
                seen.append(f)

        expected = [f for f in tag_names if f in seen]
        if seen != expected:
            return [
                f"{func.name}: Incorrect field order. Found: {seen}, Expected: {expected}"
            ]
        return []


class GlobalIndentationRule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        return [
            f"{func.name}: Global variable in @{Tags.DESCRIPTION.name} should be indented with 4 spaces. Found: '{line.strip()}'"
            for line in func.global_var_lines
            if not line.startswith("#     ")
        ]


class InternalTagRule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        if "__" in func.name and not func.contains_tag(Tags.INTERNAL.name):
            return [f"{func.name}: Missing @{Tags.INTERNAL.name}"]
        return []


class MandatoryExitCodeRule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        errors = []
        for code in MANDATORY_EXIT_CODES:
            if not any(
                re.search(rf"@{Tags.EXITCODE.name} {code}", t.line)
                for t in func.find_tags(Tags.EXITCODE.name)
            ):
                errors.append(f"{func.name}: Missing @{Tags.EXITCODE.name} {code}")
        return errors


class MandatoryFieldsRule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        errors = [
            f"{func.name}: Missing @{tag.name}"
            for tag in Tags.sequence
            if tag.is_mandatory and not func.contains_tag(tag.name)
        ]
        if not (
            func.contains_tag(Tags.ARG.name) or func.contains_tag(Tags.NOARGS.name)
        ):
            errors.append(
                f"{func.name}: Missing @{Tags.ARG.name} or @{Tags.NOARGS.name}"
            )
        return errors


class MissingOutputTagsRule(Rule):
    def _has_trigger(
        self, body: List[str], triggers: List[str], is_stdout: bool = False
    ) -> bool:
        for line in body:
            if any(t in line for t in triggers):
                # Specific check for stdout to avoid false positives
                if is_stdout and "builtin echo" in line:
                    if (
                        ">&2" in line
                        or "/dev/null" in line
                        or line.strip().endswith(TRIGGER_IGNORE_COMMENT)
                    ):
                        continue
                    if re.search(REGEX_PROCESS_SUBSTITUTION, line) or re.search(
                        REGEX_ECHO_ASSIGNMENT, line
                    ):
                        continue
                elif "/dev/null" in line or line.strip().endswith(
                    TRIGGER_IGNORE_COMMENT
                ):
                    continue
                return True
        return False

    def check(self, func: BashFunction) -> List[str]:
        errors = []
        if not func.contains_tag(Tags.STDERR.name) and self._has_trigger(
            func.body_lines, STDERR_TRIGGERS, is_stdout=False
        ):
            errors.append(f"{func.name}: Missing @{Tags.STDERR.name} tag")

        if not func.contains_tag(Tags.STDOUT.name) and self._has_trigger(
            func.body_lines, STDOUT_TRIGGERS, is_stdout=True
        ):
            errors.append(f"{func.name}: Missing @{Tags.STDOUT.name} tag")
        return errors


class SentenceFormatRule(Rule):
    def _get_description_text(self, tag: DocTag) -> str:
        m = re.search(tag.tag.description_pattern, tag.line)
        return m.group(1).strip() if m else ""

    def check(self, func: BashFunction) -> List[str]:
        errors = []
        sentence_tags = [t.name for t in Tags.sequence if t.check_sentence_format]
        for tag in func.tags:
            if tag.tag.name not in sentence_tags:
                continue

            text = self._get_description_text(tag)
            if not text or text.startswith("("):
                continue

            if not text[0].isupper():
                errors.append(
                    f"{func.name}: @{tag.tag.name} content should start with a capital letter. Found: '{text}'"
                )
            if not text.endswith("."):
                errors.append(
                    f"{func.name}: @{tag.tag.name} content should end with a period. Found: '{text}'"
                )
        return errors


class StandardExitCodesRule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        errors = []
        for tag in func.find_tags(Tags.EXITCODE.name):
            for code, pattern in STANDARDIZED_EXIT_CODES.items():
                if code in tag.content and not re.search(pattern, tag.line):
                    errors.append(
                        f"{func.name}: Non-standard @{Tags.EXITCODE.name} {code} message. Found: '{tag.line.strip()}'"
                    )
        return errors


class TypeValidationRule(Rule):
    def _validate_type(self, func_name: str, tag: DocTag) -> Optional[str]:
        parts = tag.content.split()
        if len(parts) < 2:
            return f"{func_name}: Missing or invalid type in @{tag.tag.name}. Found: '{tag.line.strip()}'"

        tag_type = parts[1].split("(")[0]
        if tag_type not in VARIABLE_TYPES:
            return f"{func_name}: Missing or invalid type in @{tag.tag.name}. Found: '{tag.line.strip()}'"
        return None

    def check(self, func: BashFunction) -> List[str]:
        errors = []
        type_tags = [t.name for t in Tags.sequence if t.has_types]
        for tag_name in type_tags:
            for tag in func.find_tags(tag_name):
                error = self._validate_type(func.name, tag)
                if error:
                    errors.append(error)
        return errors


class UndocumentedRule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        if not any("@" in l for l in func.doc_lines):
            return [f"{func.name}: Completely undocumented."]
        return []


def parse_file(filepath: str) -> List[BashFunction]:
    with open(filepath, "r") as f:
        lines = f.read().splitlines()

    functions = []
    for i, line in enumerate(lines):
        match = re.match(REGEX_FUNCTION_DEFINITION, line)
        if not match:
            continue

        func_name = match.group(1)
        doc_lines = []
        j = i - 1
        while j >= 0:
            prev_line = lines[j].strip()
            if prev_line.startswith("#"):
                doc_lines.insert(0, lines[j])
                j -= 1
            elif prev_line in ["", "# shellcheck"] or prev_line.startswith(
                "builtin source"
            ):
                j -= 1
            else:
                break

        body_lines = []
        depth = 0
        for k in range(i, len(lines)):
            body_lines.append(lines[k])
            depth += lines[k].count("{")
            depth -= lines[k].count("}")
            if depth == 0 and k > i:
                break

        functions.append(BashFunction(func_name, doc_lines, body_lines))
    return functions


def main():
    undocumented_rule = UndocumentedRule()
    validation_rules = [
        AssertionStderrRule(),
        ExitCodeDescriptionRule(),
        FieldOrderRule(),
        GlobalIndentationRule(),
        InternalTagRule(),
        MandatoryExitCodeRule(),
        MandatoryFieldsRule(),
        MissingOutputTagsRule(),
        SentenceFormatRule(),
        StandardExitCodesRule(),
        TypeValidationRule(),
    ]

    all_discrepancies: Dict[str, List[str]] = {}
    for file in sys.argv[1:]:
        try:
            functions = parse_file(file)
            file_errors = []
            for func in functions:
                undocumented_errors = undocumented_rule.check(func)
                if undocumented_errors:
                    file_errors.extend(undocumented_errors)
                    continue

                for rule in validation_rules:
                    file_errors.extend(rule.check(func))

            if file_errors:
                all_discrepancies[file] = file_errors
        except Exception as e:
            all_discrepancies[file] = [f"File could not be parsed: {str(e)}"]

    if all_discrepancies:
        print(json.dumps(all_discrepancies, indent=2))
        sys.exit(1)


if __name__ == "__main__":
    main()
