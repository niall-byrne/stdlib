import json
import re
import sys
from dataclasses import dataclass
from typing import List, Optional, Set


@dataclass
class DocTag:
    name: str  # e.g., "arg", "description"
    content: str  # The rest of the line after the tag name
    line: str  # The full original line


class BashFunction:
    def __init__(
        self,
        name: str,
        doc_lines: List[str],
        body_lines: List[str],
        start_line_index: int,
    ):
        self.name = name
        self.doc_lines = doc_lines
        self.body_lines = body_lines
        self.start_line_index = start_line_index
        self.tags: List[DocTag] = []
        self.global_var_lines: List[str] = []
        self._parse_doc()

    def _parse_doc(self):
        desc_started = False
        for line in self.doc_lines:
            tag_match = re.search(
                r"@(description|arg|noargs|exitcode|set|stdin|stdout|stderr|internal)",
                line,
            )
            if tag_match:
                tag_name = tag_match.group(1)
                # content is everything after the tag name
                content = line.split("@" + tag_name, 1)[1].strip()
                self.tags.append(DocTag(name=tag_name, content=content, line=line))
                if tag_name == "description":
                    desc_started = True
                else:
                    desc_started = False
            elif desc_started:
                # Check if it's a global variable description (indented)
                if ":" in line and line.strip().startswith("#") and not line.startswith("# @"):
                    self.global_var_lines.append(line)
                elif line.startswith("# @"):
                    desc_started = False

    def has_tag(self, tag_name: str) -> bool:
        return any(t.name == tag_name for t in self.tags)

    def get_tags(self, tag_name: str) -> List[DocTag]:
        return [t for t in self.tags if t.name == tag_name]


class Rule:
    def check(self, func: BashFunction) -> List[str]:
        raise NotImplementedError


class UndocumentedRule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        if not any("@" in l for l in func.doc_lines):
            return [f"{func.name}: Completely undocumented."]
        return []


class FieldOrderRule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        expected_order = [
            "description",
            "arg",
            "noargs",
            "exitcode",
            "set",
            "stdin",
            "stdout",
            "stderr",
            "internal",
        ]
        actual_order = [t.name for t in func.tags if t.name in expected_order]

        seen = set()
        order_to_check = []
        for f in actual_order:
            if f not in seen:
                order_to_check.append(f)
                seen.add(f)

        filtered_expected = [f for f in expected_order if f in seen]
        if order_to_check != filtered_expected:
            return [
                f"{func.name}: Incorrect field order. Found: {order_to_check}, Expected: {filtered_expected}"
            ]
        return []


class MandatoryFieldsRule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        errors = []
        if not func.has_tag("description"):
            errors.append(f"{func.name}: Missing @description")
        if not (func.has_tag("arg") or func.has_tag("noargs")):
            errors.append(f"{func.name}: Missing @arg or @noargs")
        return errors


class ExitCode0Rule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        if not any(re.search(r"@exitcode 0", t.line) for t in func.get_tags("exitcode")):
            return [f"{func.name}: Missing @exitcode 0"]
        return []


class StandardExitCodesRule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        errors = []
        for tag in func.get_tags("exitcode"):
            if "126" in tag.content:
                if not re.search(
                    r"@exitcode 126 If an invalid argument has been provided\.",
                    tag.line,
                ):
                    errors.append(
                        f"{func.name}: Non-standard @exitcode 126 message. Found: '{tag.line.strip()}'"
                    )
            if "127" in tag.content:
                if not re.search(
                    r"@exitcode 127 If the wrong number of arguments were provided\.",
                    tag.line,
                ):
                    errors.append(
                        f"{func.name}: Non-standard @exitcode 127 message. Found: '{tag.line.strip()}'"
                    )
        return errors


class TypeValidationRule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        valid_types = ["string", "integer", "boolean", "array"]
        errors = []
        for tag in func.get_tags("arg"):
            # @arg $1 type Description
            parts = tag.content.split()
            if len(parts) >= 2:
                arg_type = parts[1].split("(")[0]
                if arg_type not in valid_types:
                    errors.append(
                        f"{func.name}: Missing or invalid type in @arg. Found: '{tag.line.strip()}'"
                    )
            else:
                errors.append(
                    f"{func.name}: Missing type in @arg. Found: '{tag.line.strip()}'"
                )

        for tag in func.get_tags("set"):
            # @set VAR type Description
            parts = tag.content.split()
            if len(parts) >= 2:
                set_type = parts[1].split("(")[0]
                if set_type not in valid_types:
                    errors.append(
                        f"{func.name}: Missing or invalid type in @set. Found: '{tag.line.strip()}'"
                    )
            else:
                errors.append(
                    f"{func.name}: Missing or invalid type in @set. Found: '{tag.line.strip()}'"
                )
        return errors


class GlobalIndentationRule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        errors = []
        for line in func.global_var_lines:
            if not line.startswith("#     "):
                errors.append(
                    f"{func.name}: Global variable in @description should be indented with 4 spaces. Found: '{line.strip()}'"
                )
        return errors


class AssertionStderrRule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        errors = []
        if "assert" in func.name:
            for tag in func.get_tags("stderr"):
                if "The error message if the assertion fails." not in tag.content:
                    errors.append(
                        f"{func.name}: @stderr for assertion should use 'The error message if the assertion fails.'. Found: '{tag.line.strip()}'"
                    )
        return errors


class MissingOutputTagsRule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        errors = []
        if not func.has_tag("stderr"):
            for line in func.body_lines:
                if (
                    "stdlib.logger.error" in line
                    or "stdlib.logger.warning" in line
                    or ">&2" in line
                ):
                    if "/dev/null" not in line and not line.strip().endswith("# noqa"):
                        errors.append(f"{func.name}: Missing @stderr tag")
                        break

        if not func.has_tag("stdout"):
            for line in func.body_lines:
                # Check if it's a logger call that goes to stdout
                if (
                    "stdlib.logger.info" in line
                    or "stdlib.logger.success" in line
                    or "stdlib.logger.notice" in line
                ):
                    errors.append(f"{func.name}: Missing @stdout tag")
                    break
                # Check for builtin echo, but ignore if it's in a process substitution or assignment
                if "builtin echo" in line:
                    if (
                        ">&2" in line
                        or "/dev/null" in line
                        or line.strip().endswith("# noqa")
                    ):
                        continue
                    # Simple check for process substitution or assignment
                    if re.search(r"[\$=]\(builtin echo", line) or re.search(
                        r"=\s*\"?builtin echo", line
                    ):
                        continue
                    errors.append(f"{func.name}: Missing @stdout tag")
                    break
        return errors


class SentenceFormatRule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        errors = []
        for tag in func.tags:
            if tag.name in [
                "description",
                "arg",
                "noargs",
                "exitcode",
                "set",
                "stdin",
                "stdout",
                "stderr",
            ]:
                text = ""
                parts = tag.content.split()
                if tag.name == "arg":
                    if len(parts) >= 2:
                        # Extract description after $1 and type
                        # @arg $1 type Description
                        m = re.search(r"@arg\s+\S+\s+\S+\s+(.*)", tag.line)
                        if m:
                            text = m.group(1).strip()
                elif tag.name == "set":
                    if len(parts) >= 2:
                        # @set VAR type Description
                        m = re.search(r"@set\s+\S+\s+\S+\s+(.*)", tag.line)
                        if m:
                            text = m.group(1).strip()
                elif tag.name == "exitcode":
                    if len(parts) >= 1:
                        # @exitcode 0 Description
                        m = re.search(r"@exitcode\s+\S+\s+(.*)", tag.line)
                        if m:
                            text = m.group(1).strip()
                else:
                    text = tag.content

                if text and not text.startswith("("):
                    if not text[0].isupper():
                        errors.append(
                            f"{func.name}: @{tag.name} content should start with a capital letter. Found: '{text}'"
                        )
                    if not text.endswith("."):
                        errors.append(
                            f"{func.name}: @{tag.name} content should end with a period. Found: '{text}'"
                        )
        return errors


class InternalTagRule(Rule):
    def check(self, func: BashFunction) -> List[str]:
        if "__" in func.name and not func.has_tag("internal"):
            return [f"{func.name}: Missing @internal"]
        return []


def parse_file(filepath: str) -> List[BashFunction]:
    with open(filepath, "r") as f:
        content = f.read()
        lines = content.splitlines()

    functions = []
    for i, line in enumerate(lines):
        # Match function definition: name () {
        match = re.match(r"^([a-zA-Z_@][a-zA-Z0-9._]*) *\(\) *\{", line)
        if match:
            func_name = match.group(1)

            # Extract doc comments above the function
            doc_lines = []
            j = i - 1
            while j >= 0:
                prev_line = lines[j].strip()
                if prev_line.startswith("#"):
                    doc_lines.insert(
                        0, lines[j]
                    )  # Keep original indentation for some checks
                    j -= 1
                elif (
                    prev_line == ""
                    or prev_line.startswith("builtin source")
                    or prev_line.startswith("# shellcheck")
                ):
                    j -= 1
                    continue
                else:
                    break

            # Extract function body
            body_lines = []
            depth = 0
            for k in range(i, len(lines)):
                body_lines.append(lines[k])
                depth += lines[k].count("{")
                depth -= lines[k].count("}")
                if depth == 0 and k > i:
                    break

            functions.append(BashFunction(func_name, doc_lines, body_lines, i))

    return functions


def main():
    rules = [
        UndocumentedRule(),
        FieldOrderRule(),
        MandatoryFieldsRule(),
        ExitCode0Rule(),
        StandardExitCodesRule(),
        TypeValidationRule(),
        GlobalIndentationRule(),
        AssertionStderrRule(),
        MissingOutputTagsRule(),
        SentenceFormatRule(),
        InternalTagRule(),
    ]

    all_discrepancies = {}

    for file in sys.argv[1:]:
        if not (file.endswith(".sh") or file.endswith(".snippet")):
            continue

        try:
            functions = parse_file(file)
            file_errors = []
            for func in functions:
                func_errors = []
                # If undocumented, report only that and skip other rules for this function
                undocumented_errors = rules[0].check(func)
                if undocumented_errors:
                    file_errors.extend(undocumented_errors)
                    continue

                for rule in rules[1:]:
                    errors = rule.check(func)
                    func_errors.extend(errors)

                file_errors.extend(func_errors)

            if file_errors:
                all_discrepancies[file] = file_errors
        except Exception as e:
            # Handle potential parsing errors if any
            pass

    if all_discrepancies:
        print(json.dumps(all_discrepancies, indent=2))
        sys.exit(1)


if __name__ == "__main__":
    main()
