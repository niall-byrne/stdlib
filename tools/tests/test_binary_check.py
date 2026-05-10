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
    def test_get_bash_builtins__returns_set_of_builtins(self, mock_run):
        mock_run.return_value = MagicMock(stdout="ls\ncd\necho\n", check=True)
        mock_walk_patch = patch("os.walk", return_value=[])
        mock_exists_patch = patch("os.path.exists", return_value=False)
        mock_open_patch = patch("builtins.open", mock_open(read_data=""))

        with mock_walk_patch, mock_exists_patch, mock_open_patch:
            context = ProjectContext()

        self.assertIn("ls", context.builtins)
        self.assertIn("cd", context.builtins)
        self.assertIn("echo", context.builtins)

    @patch("os.walk")
    def test_get_project_functions__returns_set_of_function_names(self, mock_walk):
        mock_walk.return_value = [("src", [], ["file.sh"])]
        file_content = "func1() { :; }\nstdlib.func2() {\n  :;\n}\n${1}.func3() { :; }"
        mock_run_patch = patch("subprocess.run", return_value=MagicMock(stdout=""))
        mock_exists_patch = patch("os.path.exists", return_value=False)
        mock_open_patch = patch("builtins.open", mock_open(read_data=file_content))

        with mock_run_patch, mock_exists_patch, mock_open_patch:
            context = ProjectContext()

        self.assertIn("func1", context.functions)
        self.assertIn("stdlib.func2", context.functions)
        self.assertIn("${1}.func3", context.functions)

    @patch("os.path.exists")
    def test_get_defined_binaries__returns_set_of_binary_names(self, mock_exists):
        mock_exists.return_value = True
        binary_content = '_STDLIB_BINARY_CAT="$(builtin command -v cat)"\n_STDLIB_BINARY_GREP="$(builtin command -v grep)"'
        mock_run_patch = patch("subprocess.run", return_value=MagicMock(stdout=""))
        mock_walk_patch = patch("os.walk", return_value=[])
        mock_open_patch = patch("builtins.open", mock_open(read_data=binary_content))

        with mock_run_patch, mock_walk_patch, mock_open_patch:
            context = ProjectContext()

        self.assertIn("cat", context.defined_binaries)
        self.assertIn("grep", context.defined_binaries)


class TestLineAuditor(unittest.TestCase):

    def test__sanitize__redirection_syntax__returns_line_without_redirections(self):
        auditor = LineAuditor("ls > file; cat < input")

        result = auditor._sanitize()

        self.assertEqual(result, "ls   cat  ")

    def test__sanitize__trailing_comment__returns_line_without_comments(self):
        auditor = LineAuditor("ls # comment")

        result = auditor._sanitize()

        self.assertEqual(result, "ls")

    def test__sanitize__arithmetic_block__returns_empty_string(self):
        auditor = LineAuditor("(( i++ ))")

        result = auditor._sanitize()

        self.assertEqual(result, "")

    def test__sanitize__arithmetic_variable_expansion__returns_sanitized_expansion(self):
        auditor = LineAuditor("ls $(( 1+1 ))")

        result = auditor._sanitize()

        self.assertEqual(result, "ls $  1+1  ")

    def test__sanitize__case_pattern__returns_empty_string(self):
        auditor = LineAuditor("  pattern)")

        result = auditor._sanitize()

        self.assertEqual(result, "")

    def test__sanitize__quoted_strings__returns_line_with_empty_strings(self):
        auditor = LineAuditor('echo "hello" \'world\'')

        result = auditor._sanitize()

        self.assertEqual(result, "echo    ")

    def test__split_segments__multiple_delimiters__returns_list_of_segments(self):
        auditor = LineAuditor("ls | grep foo; echo hi & wait")

        result = auditor._split_segments(auditor.line)

        self.assertEqual(result, ["ls ", " grep foo", " echo hi ", " wait"])

    def test__split_segments__nested_variable_expansion__returns_undivided_segment(self):
        auditor = LineAuditor("echo ${VAR:-default}")

        result = auditor._split_segments(auditor.line)

        self.assertEqual(result, ["echo ${VAR:-default}"])

    def test__clean__shell_special_characters__returns_clean_command_string(self):
        auditor = LineAuditor("")

        self.assertEqual(auditor._clean("ls;"), "ls")
        self.assertEqual(auditor._clean("{ls}"), "ls")
        self.assertEqual(auditor._clean("!grep"), "grep")
        self.assertEqual(auditor._clean("(ls)"), "ls")
        self.assertEqual(auditor._clean("'ls'"), "ls")
        self.assertEqual(auditor._clean('"ls"'), "ls")
        self.assertEqual(auditor._clean("var="), "var")

    def test_find_commands__control_flow_keywords__returns_list_of_keywords_and_commands(self):
        auditor = LineAuditor("if ls; then echo hi; fi")

        result = auditor.find_commands()

        self.assertEqual(result, ["if", "ls", "then", "echo", "fi"])

    def test_find_commands__negation_operator__returns_list_of_command_only(self):
        auditor = LineAuditor("! grep -q foo")

        result = auditor.find_commands()

        self.assertEqual(result, ["grep"])

    def test_find_commands__variable_assignment_with_subshell__returns_list_of_commands(self):
        auditor = LineAuditor("var=$(cat file)")

        result = auditor.find_commands()

        self.assertEqual(result, ["var", "cat"])


class TestFileAuditor(unittest.TestCase):

    def setUp(self):
        self.context = MagicMock()
        self.context.builtins = {"echo", "builtin", "local"}
        self.context.functions = {"my_func"}
        self.context.defined_binaries = {"cat"}

    def test__update_scope__local_declaration__adds_variable_to_local_scope(self):
        auditor = FileAuditor("dummy.sh", self.context)

        auditor._update_scope("builtin local var1")

        self.assertIn("var1", auditor.local_scope)

    def test__update_scope__variable_assignment__adds_variable_to_local_scope(self):
        auditor = FileAuditor("dummy.sh", self.context)

        auditor._update_scope("var2=value")

        self.assertIn("var2", auditor.local_scope)

    def test__is_exempt__shell_keyword__returns_true(self):
        auditor = FileAuditor("dummy.sh", self.context)

        result = auditor._is_exempt("if")

        self.assertTrue(result)

    def test__is_exempt__bash_builtin__returns_true(self):
        auditor = FileAuditor("dummy.sh", self.context)

        result = auditor._is_exempt("echo")

        self.assertTrue(result)

    def test__is_exempt__project_defined_function__returns_true(self):
        auditor = FileAuditor("dummy.sh", self.context)

        result = auditor._is_exempt("my_func")

        self.assertTrue(result)

    def test__is_exempt__local_variable__returns_true(self):
        auditor = FileAuditor("dummy.sh", self.context)
        auditor.local_scope.add("local_var")

        result = auditor._is_exempt("local_var")

        self.assertTrue(result)

    def test__is_exempt__stdlib_function_prefix__returns_true(self):
        auditor = FileAuditor("dummy.sh", self.context)

        result = auditor._is_exempt("stdlib.foo")

        self.assertTrue(result)

    def test__is_exempt__numeric_literal__returns_true(self):
        auditor = FileAuditor("dummy.sh", self.context)

        result = auditor._is_exempt("123")

        self.assertTrue(result)

    def test__is_exempt__arithmetic_operator_suffix__returns_true(self):
        auditor = FileAuditor("dummy.sh", self.context)

        result = auditor._is_exempt("foo++")

        self.assertTrue(result)

    def test__is_exempt__disallowed_shell_characters__returns_true(self):
        auditor = FileAuditor("dummy.sh", self.context)

        result = auditor._is_exempt("[foo]")

        self.assertTrue(result)

    def test__is_exempt__unregistered_external_binary__returns_false(self):
        auditor = FileAuditor("dummy.sh", self.context)

        result = auditor._is_exempt("ls")

        self.assertFalse(result)

    def test__check__unauthorized_absolute_path__adds_violation(self):
        auditor = FileAuditor("dummy.sh", self.context)

        auditor._check("/usr/bin/ls", 10)

        self.assertIn("Line 10: Direct call to absolute path '/usr/bin/ls'.", auditor.violations)

    def test__check__exempted_absolute_path__adds_no_violation(self):
        auditor = FileAuditor("dummy.sh", self.context)

        auditor._check("/dev/null", 11)

        self.assertEqual(len(auditor.violations), 0)

    def test__check__defined_binary__adds_violation(self):
        auditor = FileAuditor("dummy.sh", self.context)

        auditor._check("cat", 12)

        self.assertIn("Line 12: Direct call to defined binary 'cat'. Use _STDLIB_BINARY_CAT instead.", auditor.violations)

    def test__check__unknown_binary__adds_violation(self):
        auditor = FileAuditor("dummy.sh", self.context)

        auditor._check("ls", 13)

        self.assertIn("Line 13: Direct call to unknown binary 'ls'. Define it in src/binary.sh first.", auditor.violations)

    def test_audit__returns_expected_violations(self):
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

            self.assertEqual(len(violations), 3)
            self.assertIn("Line 2: Direct call to unknown binary 'ls'", violations[0])
            self.assertIn("Line 3: Direct call to defined binary 'cat'", violations[1])
            self.assertIn("Line 5: Direct call to unknown binary 'grep'", violations[2])
        finally:
            os.remove(temp_path)


if __name__ == "__main__":
    unittest.main()
