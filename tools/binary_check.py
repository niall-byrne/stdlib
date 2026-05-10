"""Audit BASH scripts for direct binary calls."""

import json
import os
import re
import subprocess
import sys
from typing import Dict, List, Set

# Configuration Constants
ABSOLUTE_PATH_EXEMPTIONS = ("/dev/",)
ALPHANUMERIC_COMMAND_PATTERN = r'^[a-z0-9_-]+$'
ALLOWED_PREFIXES = ("stdlib.", "_stdlib", "_testing.", "docs.", "__", "_STDLIB_BINARY_", "$", "-")
ALLOWED_SUFFIXES = ("--", "++")
ASSIGNMENT_PATTERN = r'^\s*([a-zA-Z0-9_]+)='
BINARY_DEFINITION_PATTERN = r'_STDLIB_BINARY_[A-Z0-9_]+\s*=\s*"\$\(builtin command -v ([a-z0-9_-]+)\)"'
BINARY_DEFINITIONS_FILE = os.path.join("src", "binary.sh")
CASE_PATTERN_PATTERN = r'^\s*[a-z0-9_-]+\)'
COMMAND_EXEMPTIONS = {
    "eval_gettext", "assert_equals", "assert_not_equals", "assert_status_code",
    "assert_matches", "assert_not_matches", "assert_null", "assert_not_null", "fail"
}
COMMAND_START_KEYWORDS = {"if", "then", "else", "elif", "do", "while", "until", "!"}
DISALLOWED_CHARS = "[]{} "
FUNCTION_DEFINITION_PATTERN = r"^(([a-zA-Z0-9._-]+|\$\{1\}\.[a-zA-Z0-9._-]+))\s*\(\)\s*\{"
LOCAL_DECLARATION_PATTERN = r'^\s*builtin local (?:-[a-zA-Z]+ )?([a-zA-Z0-9_]+)'
NO_QA_MARKER = "# noqa"
NUMERIC_PATTERN = r'^[0-9]+$'
SHELL_DELIMITERS = "|&;$(<{"
SHELL_KEYWORDS = {
    "if", "then", "else", "elif", "fi", "for", "while", "do", "done",
    "case", "esac", "function", "in", "!", "{", "}"
}
SOURCE_ROOT = "src"


class ProjectContext:
    """Manages discovery of project-defined entities."""

    def __init__(self):
        self.builtins = self._get_bash_builtins()
        self.functions = self._get_project_functions()
        self.defined_binaries = self._get_defined_binaries()

    def _get_bash_builtins(self) -> Set[str]:
        try:
            result = subprocess.run(["bash", "-c", "compgen -b"], capture_output=True, text=True, check=True)
            return set(result.stdout.splitlines())
        except (subprocess.CalledProcessError, FileNotFoundError):
            return set()

    def _get_project_functions(self) -> Set[str]:
        functions = set()
        for root, _, files in os.walk(SOURCE_ROOT):
            if "/tests" in root or root.endswith("/tests"):
                continue
            for filename in files:
                if filename.endswith((".sh", ".snippet")):
                    with open(os.path.join(root, filename), "r", encoding="utf-8") as f:
                        content = f.read()
                        matches = re.findall(FUNCTION_DEFINITION_PATTERN, content, re.MULTILINE)
                        for match in matches:
                            functions.add(match[0])
        return functions

    def _get_defined_binaries(self) -> Set[str]:
        binaries = set()
        if os.path.exists(BINARY_DEFINITIONS_FILE):
            with open(BINARY_DEFINITIONS_FILE, "r", encoding="utf-8") as f:
                content = f.read()
                matches = re.findall(BINARY_DEFINITION_PATTERN, content)
                binaries.update(matches)
        return binaries


class LineAuditor:
    """Parses a line of BASH script to find commands."""

    def __init__(self, line: str):
        self.line = line

    def find_commands(self) -> List[str]:
        sanitized = self._sanitize()
        if not sanitized:
            return []

        commands = []
        for segment in self._split_segments(sanitized):
            words = segment.strip().split()
            if not words:
                continue

            cmd = self._clean(words[0])
            if cmd:
                commands.append(cmd)

            if words[0] in COMMAND_START_KEYWORDS and len(words) > 1:
                next_cmd = self._clean(words[1])
                if next_cmd:
                    commands.append(next_cmd)
        return commands

    def _sanitize(self) -> str:
        text = re.sub(r'[<>]+\s*\S+', ' ', self.line)
        text = re.sub(r'\s+#.*$', '', text)
        stripped = text.strip()
        if not stripped or stripped.startswith("((") or stripped.startswith("for (("):
            return ""
        text = re.sub(CASE_PATTERN_PATTERN, '', text)
        text = re.sub(r'\"(?:\\.|[^\"\\$])*\"', ' ', text)
        text = re.sub(r'\'(?:\\.|[^\'\\$])*\'', ' ', text)
        return text.replace("((", " ").replace("))", " ")

    def _split_segments(self, text: str) -> List[str]:
        segments, current, depth, i = [], "", 0, 0
        while i < len(text):
            if text[i:i+2] == "${":
                depth += 1
                current += text[i:i+2]
                i += 2
                continue
            if text[i] == "}" and depth > 0:
                depth -= 1
                current += "}"
                i += 1
                continue
            if depth == 0 and text[i] in SHELL_DELIMITERS:
                segments.append(current)
                current = ""
            else:
                current += text[i]
            i += 1
        segments.append(current)
        return segments

    def _clean(self, name: str) -> str:
        return name.strip(';{}()!<>\"\'=')


class FileAuditor:
    """Audits a single file for direct binary call violations."""

    def __init__(self, path: str, context: ProjectContext):
        self.path = path
        self.context = context
        self.local_scope = set()
        self.violations = []

    def audit(self) -> List[str]:
        with open(self.path, "r", encoding="utf-8") as f:
            for i, line in enumerate(f, 1):
                if NO_QA_MARKER in line:
                    continue
                self._update_scope(line)
                if line.strip().startswith("#"):
                    continue
                for command in LineAuditor(line).find_commands():
                    self._check(command, i)
        return self.violations

    def _update_scope(self, line: str):
        m = re.match(LOCAL_DECLARATION_PATTERN, line)
        if m:
            self.local_scope.add(m.group(1))
        m = re.match(ASSIGNMENT_PATTERN, line)
        if m:
            self.local_scope.add(m.group(1))

    def _check(self, cmd: str, line_no: int):
        if self._is_exempt(cmd):
            return

        if cmd.startswith("/"):
            if not any(cmd.startswith(p) for p in ABSOLUTE_PATH_EXEMPTIONS):
                self.violations.append(f"Line {line_no}: Direct call to absolute path '{cmd}'.")
            return

        if cmd in self.context.defined_binaries:
            self.violations.append(
                f"Line {line_no}: Direct call to defined binary '{cmd}'. "
                f"Use _STDLIB_BINARY_{cmd.upper()} instead."
            )
            return

        if re.match(ALPHANUMERIC_COMMAND_PATTERN, cmd):
            self.violations.append(
                f"Line {line_no}: Direct call to unknown binary '{cmd}'. "
                "Define it in src/binary.sh first."
            )

    def _is_exempt(self, cmd: str) -> bool:
        exemption_sources = [
            SHELL_KEYWORDS,
            self.context.builtins,
            self.local_scope,
            self.context.functions,
            COMMAND_EXEMPTIONS
        ]
        if any(cmd in source for source in exemption_sources):
            return True

        if cmd.startswith(ALLOWED_PREFIXES) or re.match(NUMERIC_PATTERN, cmd):
            return True

        if cmd.endswith(ALLOWED_SUFFIXES) or any(c in cmd for c in DISALLOWED_CHARS):
            return True

        return False


def main():
    if len(sys.argv) < 2:
        return
    context, results = ProjectContext(), {}
    for path in sys.argv[1:]:
        violations = FileAuditor(path, context).audit()
        if violations:
            results[path] = violations
    if results:
        print(json.dumps(results, indent=2))
        sys.exit(1)


if __name__ == "__main__":
    main()
