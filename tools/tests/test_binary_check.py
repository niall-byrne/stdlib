import os
import sys
import tempfile
import unittest

# Add the tools directory to the path so we can import the script
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from binary_check import FileAuditor, LineAuditor


class TestBinaryCheck(unittest.TestCase):

    def test_line_auditor(self):
        auditor = LineAuditor("ls -l")
        self.assertEqual(auditor.find_commands(), ["ls"])

        auditor = LineAuditor("ls -l | grep foo")
        self.assertEqual(auditor.find_commands(), ["ls", "grep"])

        auditor = LineAuditor("if ls; then echo hi; fi")
        self.assertIn("ls", auditor.find_commands())
        self.assertIn("echo", auditor.find_commands())

        auditor = LineAuditor("$(dirname foo)")
        self.assertEqual(auditor.find_commands(), ["dirname"])

        auditor = LineAuditor("var=$(cat file)")
        self.assertEqual(auditor.find_commands(), ["var", "cat"])

        auditor = LineAuditor("(( i++ ))")
        self.assertEqual(auditor.find_commands(), [])

        auditor = LineAuditor("! grep -q pattern file")
        self.assertIn("grep", auditor.find_commands())

    def test_file_auditor(self):

        class MockProjectContext:

            def __init__(self):
                self.builtins = {"echo", "builtin"}
                self.functions = {"my_func"}
                self.defined_binaries = {"cat", "grep"}

        context = MockProjectContext()

        content = """#!/bin/bash
my_func
builtin echo hi
cat file
ls file
_STDLIB_BINARY_CAT file
grep foo # noqa
local_var="foo"
local_var bar
"""

        with tempfile.NamedTemporaryFile(
                mode="w",
                suffix=".sh",
                delete=False,
        ) as f:
            f.write(content)
            temp_path = f.name

        try:
            auditor = FileAuditor(temp_path, context)
            violations = auditor.audit()

            # cat file -> Direct call to defined binary
            # ls file -> Direct call to unknown binary
            self.assertEqual(len(violations), 2)
            self.assertIn("Direct call to defined binary 'cat'", violations[0])
            self.assertIn("Direct call to unknown binary 'ls'", violations[1])
        finally:
            os.remove(temp_path)


if __name__ == "__main__":
    unittest.main()
