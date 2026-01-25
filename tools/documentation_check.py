"""Validate BASH function documentation against a series of rules."""

import json
import re
import sys
from typing import Callable, Dict, List, Optional, Tuple


# Dataclasses
class BashFunction:
    """A parsed BASH function with it's documentation."""

    def __init__(
        self,
        name: str,
        doc_lines: List[str],
        body_lines: List[str],
        start_line: int,
        end_line: int,
    ):
        self.name = name
        self.doc_lines = doc_lines
        self.body_lines = body_lines
        self.start_line = start_line
        self.end_line = end_line
        self.derive_call: Optional["DeriveCall"] = None
        self.doc_tags: List["BashFunctionDocumentationTag"] = []
        self.global_var_lines: List[str] = []
        self._tag_map = {
            tag_def.name: tag_def
            for tag_def in Tags.get_sequence()
        }
        self._extract_documentation()

    def _extract_documentation(self):
        desc_started = False
        for line in self.doc_lines:
            tag_match = re.search(REGEX_DOC_TAGS, line)
            if tag_match:
                tag_name = tag_match.group(1)
                content = line.split("@" + tag_name, 1)[1].strip()
                self.doc_tags.append(
                    BashFunctionDocumentationTag(
                        tag_def=self._tag_map[tag_name],
                        content=content,
                        line=line))
                desc_started = tag_name == Tags.DESCRIPTION.name
            elif desc_started:
                if line.strip().startswith("#") and not line.startswith("# @"):
                    self.global_var_lines.append(line)
                elif line.startswith("# @"):
                    desc_started = False

    def contains_tag(self, tag_def: "TagDefinition") -> bool:
        """Evaluate if the function's documentation contains the given tag."""
        return any(doc_tag.tag_def == tag_def for doc_tag in self.doc_tags)

    def find_tags(
        self,
        tag_def: "TagDefinition",
    ) -> List["BashFunctionDocumentationTag"]:
        """Return all the function's documented instances of the given tag."""
        return [
            doc_tag for doc_tag in self.doc_tags if doc_tag.tag_def == tag_def
        ]

    def find_arg_by_index(
        self,
        index_str: str,
    ) -> Optional["BashFunctionDocumentationTag"]:
        """Return any defined argument tag by it's numerical index."""
        arg_tags = self.find_tags(Tags.ARG)
        if not index_str.lstrip("-").isdigit():
            return None
        idx = int(index_str)
        if idx > 0:
            prefix = f"${idx}"
            for tag in arg_tags:
                if tag.content.startswith(prefix):
                    return tag
        elif idx < 0:
            try:
                return arg_tags[idx]
            except IndexError:
                pass
        return None


class BashFunctionDocumentationTag:
    """A parsed documentation tag for a BASH function."""

    def __init__(self, tag_def: "TagDefinition", content: str, line: str):
        self.tag_def = tag_def
        self.content = content
        self.line = line


class DeriveCall:
    """A call to a derive function creating a derivitive function."""

    def __init__(
        self,
        definition: "DeriveDefinition",
        source: str,
        target: str,
        arg_index: str,
        line_number: int,
    ):
        self.definition = definition
        self.source = source
        self.target = target
        self.arg_index = arg_index
        self.line_number = line_number
        self.linked_function: Optional["BashFunction"] = None

    @classmethod
    def from_line(cls, line: str, line_number: int) -> Optional["DeriveCall"]:
        """Create an instance from a line in a script file."""
        for derive_def in DERIVE_DEFINITIONS:
            match = re.search(derive_def.regex, line)
            if match:
                return cls(
                    definition=derive_def,
                    source=derive_def.get_source(match),
                    target=derive_def.get_target(match),
                    arg_index=derive_def.get_arg_index(match),
                    line_number=line_number,
                )
        return None

    def link(self, functions: List["BashFunction"]):
        """Link the derived function call to a BashFunction stub instance."""
        for func in functions:
            if func.end_line == self.line_number - 1:
                func.derive_call = self
                self.linked_function = func
                break


class DeriveDefinition:
    """Defines a function that creates derivitives of functions."""

    def __init__(
        self,
        type_name: str,
        regex: str,
        expected_desc_template: str,
        get_source: Callable[[re.Match], str],
        get_target: Callable[[re.Match], str],
        get_arg_index: Callable[[re.Match], str],
        arg_desc_requirement: Optional[str] = None,
        arg_desc_suffix: Optional[str] = None,
        required_tags: Optional[List["TagDefinition"]] = None,
    ):
        self.type_name = type_name
        self.regex = regex
        self.expected_desc_template = expected_desc_template
        self.get_source = get_source
        self.get_target = get_target
        self.get_arg_index = get_arg_index
        self.arg_desc_requirement = arg_desc_requirement
        self.arg_desc_suffix = arg_desc_suffix
        self.required_tags = required_tags or []


class TagDefinition:
    """Defines a shdoc documentation tag."""

    def __init__(
        self,
        name: str,
        is_mandatory: bool = False,
        check_sentence_format: bool = False,
        has_types: bool = False,
    ):
        self.name = name
        self.is_mandatory = is_mandatory
        self.check_sentence_format = check_sentence_format
        self.has_types = has_types

    def __eq__(self, other):
        if not isinstance(other, TagDefinition):
            return False
        return self.name == other.name

    @property
    def description_pattern(self) -> str:
        """Return a regex for validating the description."""
        if self.has_types:
            return rf"@{self.name}\s+\S+\s+\S+\s+(.*)"
        if self.name == "exitcode":
            return rf"@{self.name}\s+\S+\s+(.*)"
        return rf"@{self.name}\s+(.*)"


class Tags:
    """All shdoc documentation tags."""

    DESCRIPTION = TagDefinition(
        name="description",
        is_mandatory=True,
        check_sentence_format=True,
    )
    ARG = TagDefinition(
        name="arg",
        check_sentence_format=True,
        has_types=True,
    )
    NOARGS = TagDefinition(
        name="noargs",
        check_sentence_format=True,
    )
    EXITCODE = TagDefinition(
        name="exitcode",
        check_sentence_format=True,
    )
    SET = TagDefinition(
        name="set",
        check_sentence_format=True,
        has_types=True,
    )
    STDIN = TagDefinition(
        name="stdin",
        check_sentence_format=True,
    )
    STDOUT = TagDefinition(
        name="stdout",
        check_sentence_format=True,
    )
    STDERR = TagDefinition(
        name="stderr",
        check_sentence_format=True,
    )
    INTERNAL = TagDefinition(name="internal")

    @classmethod
    def get_sequence(cls) -> List[TagDefinition]:
        """Return the ordered sequence of shdoc documentation tags."""
        return [
            cls.DESCRIPTION,
            cls.ARG,
            cls.NOARGS,
            cls.EXITCODE,
            cls.SET,
            cls.STDIN,
            cls.STDOUT,
            cls.STDERR,
            cls.INTERNAL,
        ]


# Configuration
DERIVE_DEFINITIONS: List[DeriveDefinition] = [
    DeriveDefinition(
        type_name="pipeable",
        regex=r'stdlib\.(?:fn\.)?derive\.pipeable\s+"([^"]+)"\s+"([^"]+)"',
        expected_desc_template=
        "A derivative of {source} that can read from stdin.",
        get_source=lambda match: match.group(1),
        get_target=lambda match: match.group(1) + "_pipe",
        get_arg_index=lambda match: match.group(2),
        arg_desc_suffix=", by default this function reads from stdin.",
        required_tags=[Tags.STDIN],
    ),
    DeriveDefinition(
        type_name="var",
        regex=r'stdlib\.(?:fn\.)?derive\.var\s+"([^"]+)"(?:\s+"([^"]+)")?'
        r'(?:\s+"([^"]+)")?',
        expected_desc_template=
        "A derivative of {source} that can read from and write to a variable.",
        get_source=lambda match: match.group(1),
        get_target=lambda match: match.group(2) or (match.group(1) + "_var"),
        get_arg_index=lambda match: match.group(3) or "-1",
        arg_desc_requirement=
        "The name of the variable to read from and write to.",
    ),
]
GLOBAL_VARIABLE_PREFIX = r"#   * "
MANDATORY_EXIT_CODES = ["0"]
MANDATORY_TAGS = [
    tag_def for tag_def in Tags.get_sequence() if tag_def.is_mandatory
]
REGEX_DOC_TAGS = (
    rf"^#\s*@({'|'.join([tag_def.name for tag_def in Tags.get_sequence()])})")
REGEX_ECHO_ASSIGNMENT = r"=\s*\"?builtin echo"
REGEX_FUNCTION_DEFINITION = r"^([a-zA-Z_@][a-zA-Z0-9._]*) *\(\) *\{"
REGEX_GLOBAL_VARIABLE_MODIFIER_NAME = r"[A-Z_]+: "
REGEX_GLOBAL_VARIABLE_MODIFIER_DESCRIPTION = (
    rf"^{re.escape(GLOBAL_VARIABLE_PREFIX)}[A-Z_]+: (.+)$")
REGEX_GLOBAL_VARIABLE_MODIFIER_DESCRIPTION_DEFAULT = r"^.+\(default=.+\)\.*$"
REGEX_PROCESS_SUBSTITUTION = r"[\$=]\(builtin echo"
SENTENCE_FORMAT_TAGS = [
    tag_def for tag_def in Tags.get_sequence() if tag_def.check_sentence_format
]
STANDARDIZED_EXIT_CODES = {
    "126":
    rf"@{Tags.EXITCODE.name} 126 If an invalid "
    r"argument has been provided\.",
    "127":
    rf"@{Tags.EXITCODE.name} 127 If the wrong "
    r"number of arguments were provided\.",
}
STDERR_TRIGGERS = ["stdlib.logger.error", "stdlib.logger.warning", ">&2"]
STDOUT_TRIGGERS = [
    "stdlib.logger.info",
    "stdlib.logger.success",
    "stdlib.logger.notice",
    "builtin echo",
]
TRIGGER_IGNORE_COMMENT = "# noqa"
TYPE_TAGS = [tag_def for tag_def in Tags.get_sequence() if tag_def.has_types]
VARIABLE_TYPES = ["string", "integer", "boolean", "array"]


# Rule Bases
class DeriveRule:
    """A base class for validating calls to derived functions."""

    def check(self, call: DeriveCall) -> List[str]:
        """Validate the given derive function call."""
        raise NotImplementedError


class Rule:
    """A base class for validation rules."""

    def check(self, func: BashFunction) -> List[str]:
        """Validate the given BASH function."""
        raise NotImplementedError


# Rules
class AssertionStderrRule(Rule):
    """A rule that checks assertion functions for stderr documentation."""

    def check(self, func: BashFunction) -> List[str]:
        """Validate the given BASH function."""
        if "assert" not in func.name:
            return []

        msg = "The error message if the assertion fails."
        return [
            f"{func.name}: @{Tags.STDERR.name} for assertion should use "
            f"'{msg}'. Found: '{doc_tag.line.strip()}'"
            for doc_tag in func.find_tags(Tags.STDERR)
            if msg not in doc_tag.content
        ]


class DeriveStubArgRule(Rule):
    """A rule for validating a derived function stub's argument tags."""

    def check(self, func: BashFunction) -> List[str]:
        """Validate the given BASH function."""
        if not func.derive_call:
            return []
        call = func.derive_call
        derive_def = call.definition
        if not (derive_def.arg_desc_requirement or derive_def.arg_desc_suffix):
            return []
        target_tag = func.find_arg_by_index(call.arg_index)
        if not target_tag:
            return self._check_fallback(func, derive_def)
        errors = []
        if (derive_def.arg_desc_requirement
                and derive_def.arg_desc_requirement not in target_tag.content):
            errors.append(
                f"{func.name}: @arg at index {call.arg_index} "
                f"description should match '{derive_def.arg_desc_requirement}'"
            )
        if derive_def.arg_desc_suffix and not target_tag.content.strip(
        ).endswith(derive_def.arg_desc_suffix):
            errors.append(
                f"{func.name}: @arg at index {call.arg_index} "
                f"description should end with '{derive_def.arg_desc_suffix}'")
        return errors

    def _check_fallback(self, func: BashFunction,
                        derive_def: DeriveDefinition) -> List[str]:
        arg_tags = func.find_tags(Tags.ARG)
        if derive_def.arg_desc_requirement:
            if not any(derive_def.arg_desc_requirement in tag.content
                       for tag in arg_tags):
                return [
                    f"{func.name}: Missing @arg with description "
                    f"'{derive_def.arg_desc_requirement}'"
                ]
        elif derive_def.arg_desc_suffix:
            if not any(tag.content.strip().endswith(derive_def.arg_desc_suffix)
                       for tag in arg_tags):
                return [
                    f"{func.name}: Missing @arg ending with "
                    f"'{derive_def.arg_desc_suffix}'"
                ]
        return []


class DeriveStubDescriptionRule(Rule):
    """A rule for validating a derived function stub's description tag."""

    def check(self, func: BashFunction) -> List[str]:
        """Validate the given derive function call."""
        if not func.derive_call:
            return []
        call = func.derive_call
        derive_def = call.definition
        expected_desc = derive_def.expected_desc_template.format(
            source=call.source)
        desc_tags = func.find_tags(Tags.DESCRIPTION)
        if not any(expected_desc in tag.content for tag in desc_tags):
            return [
                f"{func.name}: Derived {derive_def.type_name} description "
                f"should match '{expected_desc}'"
            ]
        return []


class DeriveStubRequiredTagsRule(Rule):
    """A rule for validating a derived function stub's required tags."""

    def check(self, func: BashFunction) -> List[str]:
        """Validate the given BASH function."""
        if not func.derive_call:
            return []
        call = func.derive_call
        errors = []
        for tag_def in call.definition.required_tags:
            if not func.contains_tag(tag_def):
                errors.append(f"{func.name}: Missing @{tag_def.name} tag for "
                              f"{call.definition.type_name} derivative")
        return errors


class DeriveStubNamingRule(DeriveRule):
    """A rule for validating a documented stub is correctly named."""

    def check(self, call: DeriveCall) -> List[str]:
        """Validate the given call to a derive function."""
        if not call.linked_function:
            return []
        if call.linked_function.name != call.target:
            return [
                f"Line {call.line_number + 1}: Stub function name "
                f"'{call.linked_function.name}' does not match expected "
                f"target '{call.target}'."
            ]
        return []


class ExitCodeDescriptionRule(Rule):
    """A rule that checks the exit code documention."""

    def check(self, func: BashFunction) -> List[str]:
        """Validate the given BASH function."""
        errors = []
        for doc_tag in func.find_tags(Tags.EXITCODE):
            m = re.search(doc_tag.tag_def.description_pattern, doc_tag.line)
            if m:
                text = m.group(1).strip()
                if text and not text.startswith("If"):
                    errors.append(
                        f"{func.name}: @{Tags.EXITCODE.name} description "
                        f"should start with 'If'. Found: '{text}'")
        return errors


class FieldOrderRule(Rule):
    """A rule that checks the documentation tags are in the correct order."""

    def check(self, func: BashFunction) -> List[str]:
        """Validate the given BASH function."""
        tag_names = [tag_def.name for tag_def in Tags.get_sequence()]
        actual_order = [
            doc_tag.tag_def.name for doc_tag in func.doc_tags
            if doc_tag.tag_def.name in tag_names
        ]
        seen = []
        for tag_name in actual_order:
            if tag_name not in seen:
                seen.append(tag_name)

        expected = [tag_name for tag_name in tag_names if tag_name in seen]
        if seen != expected:
            return [
                f"{func.name}: Incorrect field order. "
                f"Found: {seen}, Expected: {expected}"
            ]
        return []


class GlobalVariableModifierFormatRule(Rule):
    """A rule that checks formatting of global variable mod descriptions."""

    def check(self, func: BashFunction) -> List[str]:
        """Validate the given BASH function."""
        errors = []
        for line in func.global_var_lines:
            match = re.match(REGEX_GLOBAL_VARIABLE_MODIFIER_DESCRIPTION,
                             line.strip(), re.DOTALL)
            if match:
                if not match.group(1)[0].isupper():
                    errors.append(
                        f"{func.name}: Global variable description in "
                        f"@{Tags.DESCRIPTION.name} "
                        f"should start with a capital letter. "
                        f"Found: '{line.strip()}'")
                if not match.group(1).endswith("."):
                    errors.append(
                        f"{func.name}: Global variable description in "
                        f"@{Tags.DESCRIPTION.name} "
                        f"should end with a period. Found: '{line.strip()}'")
                if not re.match(
                        REGEX_GLOBAL_VARIABLE_MODIFIER_DESCRIPTION_DEFAULT,
                        match.group(1)):
                    errors.append(
                        f"{func.name}: Global variable description in "
                        f"@{Tags.DESCRIPTION.name} "
                        f"should detail a default value. "
                        f"Found: '{line.strip()}'")
        return errors


class GlobalVariableModifierIndentRule(Rule):
    """A rule that checks indentation of global variable mod descriptions."""

    def check(self, func: BashFunction) -> List[str]:
        """Validate the given BASH function."""
        errors = []
        for line in func.global_var_lines:
            if not line.startswith(GLOBAL_VARIABLE_PREFIX):
                errors.append(
                    f"{func.name}: Global variable in @{Tags.DESCRIPTION.name} "
                    f"should be in 2 space indented asterisk list format. "
                    f"Found: '{line.strip()}'")
            if not re.search(REGEX_GLOBAL_VARIABLE_MODIFIER_NAME,
                             line.strip()):
                errors.append(
                    f"{func.name}: Global variable in @{Tags.DESCRIPTION.name} "
                    f"should be in uppercase characters followed by a colon. "
                    f"Found: '{line.strip()}'")
        return errors


class InternalTagRule(Rule):
    """A rule that checks private functions have an internal tag."""

    def check(self, func: BashFunction) -> List[str]:
        """Validate the given BASH function."""
        if "__" in func.name and not func.contains_tag(Tags.INTERNAL):
            return [f"{func.name}: Missing @{Tags.INTERNAL.name}"]
        return []


class MandatoryExitCodeRule(Rule):
    """A rule that checks all mandatory exit codes are present."""

    def check(self, func: BashFunction) -> List[str]:
        """Validate the given BASH function."""
        errors = []
        for code in MANDATORY_EXIT_CODES:
            if not any(
                    re.search(rf"@{Tags.EXITCODE.name} {code}", doc_tag.line)
                    for doc_tag in func.find_tags(Tags.EXITCODE)):
                errors.append(
                    f"{func.name}: Missing @{Tags.EXITCODE.name} {code}")
        return errors


class MandatoryTagRule(Rule):
    """A rule that checks all mandatory tags are present."""

    def check(self, func: BashFunction) -> List[str]:
        """Validate the given BASH function."""
        errors = [
            f"{func.name}: Missing @{tag_def.name}"
            for tag_def in MANDATORY_TAGS if not func.contains_tag(tag_def)
        ]
        if not (func.contains_tag(Tags.ARG) or func.contains_tag(Tags.NOARGS)):
            errors.append(
                f"{func.name}: Missing @{Tags.ARG.name} or @{Tags.NOARGS.name}"
            )
        return errors


class MissingDeriveStubRule(DeriveRule):
    """A rule that checks if a call to a derived function is missing a stub."""

    def check(self, call: DeriveCall) -> List[str]:
        """Validate the given call to a derive function."""
        if not call.linked_function:
            return [
                f"Line {call.line_number + 1}: Missing stub "
                "function for derive call."
            ]
        return []


class MissingOutputTagsRule(Rule):
    """A rule that checks for missing output tags."""

    def _has_trigger(
        self,
        body: List[str],
        triggers: List[str],
        is_stdout: bool = False,
    ) -> bool:
        for line in body:
            if any(t in line for t in triggers):
                if is_stdout and "builtin echo" in line:
                    if ">&2" in line or "/dev/null" in line or \
                            line.strip().endswith(TRIGGER_IGNORE_COMMENT):
                        continue
                    if re.search(
                            REGEX_PROCESS_SUBSTITUTION,
                            line,
                    ) or re.search(
                            REGEX_ECHO_ASSIGNMENT,
                            line,
                    ):
                        continue
                elif "/dev/null" in line or line.strip().endswith(
                        TRIGGER_IGNORE_COMMENT):
                    continue
                return True
        return False

    def check(self, func: BashFunction) -> List[str]:
        """Validate the given BASH function."""
        errors = []
        if not func.contains_tag(Tags.STDERR) and self._has_trigger(
                func.body_lines, STDERR_TRIGGERS, is_stdout=False):
            errors.append(f"{func.name}: Missing @{Tags.STDERR.name} tag")

        if not func.contains_tag(Tags.STDOUT) and self._has_trigger(
                func.body_lines, STDOUT_TRIGGERS, is_stdout=True):
            errors.append(f"{func.name}: Missing @{Tags.STDOUT.name} tag")
        return errors


class SentenceFormatRule(Rule):
    """A rule that checks the documentation is formatted as proper sentences."""

    def _get_description_text(
        self,
        doc_tag: BashFunctionDocumentationTag,
    ) -> str:
        m = re.search(doc_tag.tag_def.description_pattern, doc_tag.line)
        return m.group(1).strip() if m else ""

    def check(self, func: BashFunction) -> List[str]:
        """Validate the given BASH function."""
        errors = []
        for doc_tag in func.doc_tags:
            if doc_tag.tag_def not in SENTENCE_FORMAT_TAGS:
                continue

            text = self._get_description_text(doc_tag)
            if not text or text.startswith("("):
                continue

            if not text[0].isupper():
                errors.append(
                    f"{func.name}: @{doc_tag.tag_def.name} content should "
                    f"start with a capital letter. Found: '{text}'")
            if not text.endswith("."):
                errors.append(
                    f"{func.name}: @{doc_tag.tag_def.name} content should "
                    f"end with a period. Found: '{text}'")
        return errors


class StandardExitCodesRule(Rule):
    """A rule that checks documentation exit codes with a defined standard."""

    def check(self, func: BashFunction) -> List[str]:
        """Validate the given BASH function."""
        errors = []
        for doc_tag in func.find_tags(Tags.EXITCODE):
            for code, pattern in STANDARDIZED_EXIT_CODES.items():
                if code in doc_tag.content and not re.search(
                        pattern, doc_tag.line):
                    errors.append(
                        f"{func.name}: Non-standard @{Tags.EXITCODE.name} "
                        f"{code} message. Found: '{doc_tag.line.strip()}'")
        return errors


class TypeValidationRule(Rule):
    """A rule that checks the data types present in documentation tags."""

    def _validate_type(
        self,
        func_name: str,
        doc_tag: BashFunctionDocumentationTag,
    ) -> Optional[str]:
        parts = doc_tag.content.split()
        if len(parts) < 2:
            return (
                f"{func_name}: Missing or invalid type in "
                f"@{doc_tag.tag_def.name}. Found: '{doc_tag.line.strip()}'")

        tag_type = parts[1].split("(")[0]
        if tag_type not in VARIABLE_TYPES:
            return (
                f"{func_name}: Missing or invalid type in "
                f"@{doc_tag.tag_def.name}. Found: '{doc_tag.line.strip()}'")
        return None

    def check(self, func: BashFunction) -> List[str]:
        """Validate the given BASH function."""
        errors = []
        for tag_def in TYPE_TAGS:
            for doc_tag in func.find_tags(tag_def):
                error = self._validate_type(func.name, doc_tag)
                if error:
                    errors.append(error)
        return errors


class UndocumentedRule(Rule):
    """A rule that checks if the function is undocumented."""

    def check(self, func: BashFunction) -> List[str]:
        """Validate the given BASH function."""
        if not any("@" in line for line in func.doc_lines):
            return [f"{func.name}: Completely undocumented."]
        return []


def parse_file(filepath: str) -> Tuple[List[BashFunction], List[DeriveCall]]:
    """Parse BashFunction instances from the given filepath."""
    with open(filepath, "r") as file_handle:
        lines = file_handle.read().splitlines()
    functions: List[BashFunction] = []
    all_derive_calls: List[DeriveCall] = []
    doc_buffer: List[str] = []
    index = 0
    while index < len(lines):
        line = lines[index]
        if line.strip().startswith("#"):
            if not (line.strip().startswith("# shellcheck")
                    or line.strip().startswith("#!/")):
                doc_buffer.append(line)
            index += 1
            continue
        call = DeriveCall.from_line(line, index)
        if call:
            all_derive_calls.append(call)
            if functions and functions[-1].end_line == index - 1:
                functions[-1].derive_call = call
                call.linked_function = functions[-1]
            index += 1
            doc_buffer = []
            continue
        match = re.match(REGEX_FUNCTION_DEFINITION, line)
        if match:
            func_name = match.group(1)
            start_line = index
            body_lines = []
            depth = 0
            while index < len(lines):
                body_lines.append(lines[index])
                depth += lines[index].count("{")
                depth -= lines[index].count("}")
                if depth == 0:
                    break
                index += 1
            functions.append(
                BashFunction(
                    func_name,
                    doc_buffer,
                    body_lines,
                    start_line=start_line,
                    end_line=index,
                ))
            doc_buffer = []
            index += 1
            continue
        if line.strip() and not (line.strip().startswith("# shellcheck")
                                 or line.strip().startswith("builtin source")):
            doc_buffer = []
        index += 1
    return functions, all_derive_calls


def main():
    """Validate the given list of input files."""
    derive_rules = [
        DeriveStubNamingRule(),
        MissingDeriveStubRule(),
    ]
    undocumented_rule = [
        UndocumentedRule(),
    ]
    validation_rules = [
        AssertionStderrRule(),
        DeriveStubArgRule(),
        DeriveStubDescriptionRule(),
        DeriveStubRequiredTagsRule(),
        ExitCodeDescriptionRule(),
        FieldOrderRule(),
        GlobalVariableModifierFormatRule(),
        GlobalVariableModifierIndentRule(),
        InternalTagRule(),
        MandatoryExitCodeRule(),
        MandatoryTagRule(),
        MissingOutputTagsRule(),
        SentenceFormatRule(),
        StandardExitCodesRule(),
        TypeValidationRule(),
    ]
    all_discrepancies: Dict[str, List[str]] = {}
    for filepath in sys.argv[1:]:
        try:
            functions, derive_calls = parse_file(filepath)
            file_errors = []
            for func in functions:
                undocumented_errors = []
                for rule in undocumented_rule:
                    undocumented_errors.extend(rule.check(func))
                if undocumented_errors:
                    file_errors.extend(undocumented_errors)
                    continue
                for rule in validation_rules:
                    file_errors.extend(rule.check(func))
            for call in derive_calls:
                for rule in derive_rules:
                    file_errors.extend(rule.check(call))
            if file_errors:
                all_discrepancies[filepath] = file_errors
        except Exception as exception:
            all_discrepancies[filepath] = [
                f"File could not be parsed: {str(exception)}"
            ]
    if all_discrepancies:
        print(json.dumps(all_discrepancies, indent=2))
        sys.exit(1)


if __name__ == "__main__":
    if sys.version_info < (3, 6):
        raise SystemExit("Python 3.6 or greater is required.")
    main()
