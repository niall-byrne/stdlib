import json
import os
import sys
import tempfile
import unittest
from io import StringIO
from unittest.mock import patch, mock_open, MagicMock

# Add the tools directory to the path so we can import the script
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from binary_check import ProjectContext, LineAuditor, FileAuditor


class TestProjectContext(unittest.TestCase):

    @patch("subprocess.run")
    def test_get_bash_builtins(self, mock_run):
        mock_run.return_value = MagicMock(stdout="ls\ncd\necho\n", check=True)
        # ProjectContext calls _get_bash_builtins, _get_project_functions, _get_defined_binaries in __init__
        with patch("os.walk") as mock_walk, \
             patch("os.path.exists") as mock_exists, \
             patch("builtins.open", mock_open(read_data="")):
            mock_walk.return_value = []
            mock_exists.return_value = False
            context = ProjectContext()

        self.assertIn("ls", context.builtins)
        self.assertIn("cd", context.builtins)
        self.assertIn("echo", context.builtins)

    @patch("os.walk")
    def test_get_project_functions(self, mock_walk):
        mock_walk.return_value = [("src", [], ["file.sh"])]
        file_content = "func1() { :; }\nstdlib.func2() {\n  :;\n}\n${1}.func3() { :; }"

        with patch("subprocess.run") as mock_run, \
             patch("os.path.exists") as mock_exists, \
             patch("builtins.open", mock_open(read_data=file_content)):
            mock_run.return_value = MagicMock(stdout="")
            mock_exists.return_value = False
            context = ProjectContext()

        self.assertIn("func1", context.functions)
        self.assertIn("stdlib.func2", context.functions)
        self.assertIn("${1}.func3", context.functions)

    @patch("os.path.exists")
    def test_get_defined_binaries(self, mock_exists):
        mock_exists.return_value = True
        binary_content = '_STDLIB_BINARY_CAT="$(builtin command -v cat)"\n_STDLIB_BINARY_GREP="$(builtin command -v grep)"'

        with patch("subprocess.run") as mock_run, \
             patch("os.walk") as mock_walk, \
             patch("builtins.open", mock_open(read_data=binary_content)):
            mock_run.return_value = MagicMock(stdout="")
            mock_walk.return_value = []
            context = ProjectContext()

        self.assertIn("cat", context.defined_binaries)
        self.assertIn("grep", context.defined_binaries)


class TestLineAuditor(unittest.TestCase):

    def test_sanitize(self):
        # Redirections
        self.assertEqual(LineAuditor("ls > file")._sanitize(), "ls  ")
        self.assertEqual(LineAuditor("ls >> file")._sanitize(), "ls  ")
        self.assertEqual(LineAuditor("cat < file")._sanitize(), "cat  ")

        # Comments
        self.assertEqual(LineAuditor("ls # comment")._sanitize(), "ls")

        # Arithmetic expansions
        self.assertEqual(LineAuditor("(( i++ ))")._sanitize(), "")
        self.assertEqual(LineAuditor("for (( i=0; i<10; i++ ))")._sanitize(), "")
        self.assertEqual(LineAuditor("ls $(( 1+1 ))")._sanitize(), "ls $  1+1  ")

        # Case pattern
        self.assertEqual(LineAuditor("  pattern)")._sanitize(), "")

        # Quoted strings
        self.assertEqual(LineAuditor('echo "hello"')._sanitize(), "echo  ")
        self.assertEqual(LineAuditor("echo 'world'")._sanitize(), "echo  ")

    def test_split_segments(self):
        # Basic delimiters
        self.assertEqual(LineAuditor("ls | grep foo")._split_segments("ls | grep foo"), ["ls ", " grep foo"])
        self.assertEqual(LineAuditor("ls; echo hi")._split_segments("ls; echo hi"), ["ls", " echo hi"])
        self.assertEqual(LineAuditor("ls & echo hi")._split_segments("ls & echo hi"), ["ls ", " echo hi"])

        # Nested expansions
        segments = LineAuditor("echo ${VAR:-default}")._split_segments("echo ${VAR:-default}")
        self.assertEqual(segments, ["echo ${VAR:-default}"])

        segments = LineAuditor("echo ${VAR}|grep")._split_segments("echo ${VAR}|grep")
        self.assertEqual(segments, ["echo ${VAR}", "grep"])

    def test_clean(self):
        auditor = LineAuditor("")
        self.assertEqual(auditor._clean("ls;"), "ls")
        self.assertEqual(auditor._clean("{ls}"), "ls")
        self.assertEqual(auditor._clean("!grep"), "grep")
        self.assertEqual(auditor._clean("(ls)"), "ls")
        self.assertEqual(auditor._clean("'ls'"), "ls")
        self.assertEqual(auditor._clean('"ls"'), "ls")
        self.assertEqual(auditor._clean("var="), "var")

    def test_find_commands(self):
        # Basic
        self.assertEqual(LineAuditor("ls -l").find_commands(), ["ls"])

        # Multiple segments
        self.assertEqual(LineAuditor("ls | grep foo").find_commands(), ["ls", "grep"])

        # Keywords
        self.assertEqual(LineAuditor("if ls; then echo hi; fi").find_commands(), ["if", "ls", "then", "echo", "fi"])
        self.assertEqual(LineAuditor("while true; do sleep 1; done").find_commands(), ["while", "true", "do", "sleep", "done"])
        self.assertEqual(LineAuditor("! grep -q foo").find_commands(), ["grep"])

        # Subshells and assignments
        self.assertEqual(LineAuditor("var=$(cat file)").find_commands(), ["var", "cat"])


class TestFileAuditor(unittest.TestCase):

    def setUp(self):
        self.context = MagicMock()
        self.context.builtins = {"echo", "builtin", "local"}
        self.context.functions = {"my_func"}
        self.context.defined_binaries = {"cat"}

    def test_update_scope(self):
        auditor = FileAuditor("dummy.sh", self.context)
        auditor._update_scope("builtin local var1")
        self.assertIn("var1", auditor.local_scope)

        auditor._update_scope("var2=value")
        self.assertIn("var2", auditor.local_scope)

    def test_is_exempt(self):
        auditor = FileAuditor("dummy.sh", self.context)
        auditor.local_scope.add("local_var")

        self.assertTrue(auditor._is_exempt("if"))          # Keyword
        self.assertTrue(auditor._is_exempt("echo"))        # Builtin
        self.assertTrue(auditor._is_exempt("my_func"))     # Function
        self.assertTrue(auditor._is_exempt("local_var"))  # Local scope
        self.assertTrue(auditor._is_exempt("stdlib.foo"))  # Prefix
        self.assertTrue(auditor._is_exempt("123"))         # Numeric
        self.assertTrue(auditor._is_exempt("foo--"))       # Suffix
        self.assertTrue(auditor._is_exempt("[foo]"))       # Disallowed chars

        self.assertFalse(auditor._is_exempt("ls"))         # Not exempt

    def test_check(self):
        auditor = FileAuditor("dummy.sh", self.context)

        # Absolute path violation
        auditor._check("/usr/bin/ls", 10)
        self.assertIn("Line 10: Direct call to absolute path '/usr/bin/ls'.", auditor.violations)

        # Absolute path exemption
        auditor.violations = []
        auditor._check("/dev/null", 11)
        self.assertEqual(len(auditor.violations), 0)

        # Defined binary violation
        auditor._check("cat", 12)
        self.assertIn("Line 12: Direct call to defined binary 'cat'. Use _STDLIB_BINARY_CAT instead.", auditor.violations)

        # Unknown binary violation
        auditor._check("ls", 13)
        self.assertIn("Line 13: Direct call to unknown binary 'ls'. Define it in src/binary.sh first.", auditor.violations)

    def test_audit(self):
        content = """# comment
ls -l
cat file
# noqa
grep foo
my_func
"""
        with tempfile.NamedTemporaryFile(mode="w", suffix=".sh", delete=False) as f:
            f.write(content)
            temp_path = f.name

        try:
            auditor = FileAuditor(temp_path, self.context)
            violations = auditor.audit()

            # Line 2: ls (unknown)
            # Line 3: cat (defined)
            # Line 5: grep (unknown) - but line 4 has # noqa, wait.
            # audit() checks MARKER_NO_QA in line.
            # Line 4 has # noqa, so it is skipped.
            # grep is on line 5.

            self.assertEqual(len(violations), 3)
            self.assertIn("Line 2: Direct call to unknown binary 'ls'", violations[0])
            self.assertIn("Line 3: Direct call to defined binary 'cat'", violations[1])
            self.assertIn("Line 5: Direct call to unknown binary 'grep'", violations[2])
        finally:
            os.remove(temp_path)


if __name__ == "__main__":
    unittest.main()
