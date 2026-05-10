import json
import os
import subprocess
import sys
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

    @patch("subprocess.run")
    def test_get_bash_builtins__subprocess_error__returns_empty_set(self, mock_run):
        mock_run.side_effect = subprocess.CalledProcessError(1, "cmd")
        mock_walk_patch = patch("os.walk", return_value=[])
        mock_exists_patch = patch("os.path.exists", return_value=False)
        mock_open_patch = patch("builtins.open", mock_open(read_data=""))

        with mock_walk_patch, mock_exists_patch, mock_open_patch:
            context = ProjectContext()

        self.assertEqual(context.builtins, set())

    @patch("os.walk")
    def test_get_project_functions__skip_tests_directories__excludes_test_functions(self, mock_walk):
        mock_walk.return_value = [
            ("src/core", [], ["func.sh"]),
            ("src/core/tests", [], ["test_func.sh"]),
        ]

        # We need to handle multiple open calls. For simplicity, we can mock open to return
        # a function definition only for the non-test file.
        def mocked_open(path, *args, **kwargs):
            if "tests" in path:
                return mock_open(read_data="test_func() { :; }")()
            return mock_open(read_data="real_func() { :; }")()

        mock_run_patch = patch("subprocess.run", return_value=MagicMock(stdout=""))
        mock_exists_patch = patch("os.path.exists", return_value=False)

        with mock_run_patch, mock_exists_patch, patch("builtins.open", side_effect=mocked_open):
            context = ProjectContext()

        self.assertIn("real_func", context.functions)
        self.assertNotIn("test_func", context.functions)


class TestLineAuditor(unittest.TestCase):

    def test_sanitize__redirection_syntax__returns_line_without_redirections(self):
        auditor = LineAuditor("ls > file; cat < input")

        result = auditor._sanitize()

        self.assertEqual(result, "ls   cat  ")

    def test_sanitize__trailing_comment__returns_line_without_comments(self):
        auditor = LineAuditor("ls # comment")

        result = auditor._sanitize()

        self.assertEqual(result, "ls")

    def test_sanitize__arithmetic_block__returns_empty_string(self):
        auditor = LineAuditor("(( i++ ))")

        result = auditor._sanitize()

        self.assertEqual(result, "")

    def test_sanitize__arithmetic_variable_expansion__returns_sanitized_expansion(self):
        auditor = LineAuditor("ls $(( 1+1 ))")

        result = auditor._sanitize()

        self.assertEqual(result, "ls $  1+1  ")

    def test_sanitize__case_pattern__returns_empty_string(self):
        auditor = LineAuditor("  pattern)")

        result = auditor._sanitize()

        self.assertEqual(result, "")

    def test_sanitize__quoted_strings__returns_line_with_empty_strings(self):
        auditor = LineAuditor('echo "hello" \'world\'')

        result = auditor._sanitize()

        self.assertEqual(result, "echo    ")

    def test_split_segments__multiple_delimiters__returns_list_of_segments(self):
        auditor = LineAuditor("ls | grep foo; echo hi & wait")

        result = auditor._split_segments(auditor.line)

        self.assertEqual(result, ["ls ", " grep foo", " echo hi ", " wait"])

    def test_split_segments__nested_variable_expansion__returns_undivided_segment(self):
        auditor = LineAuditor("echo ${VAR:-default}")

        result = auditor._split_segments(auditor.line)

        self.assertEqual(result, ["echo ${VAR:-default}"])

    def test_clean__shell_special_characters__returns_clean_command_string(self):
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
        self.assets_dir = os.path.join(os.path.dirname(__file__), "assets", "binary_check")

    def test_update_scope__local_declaration__adds_variable_to_local_scope(self):
        auditor = FileAuditor("mock.sh", self.context)

        auditor._update_scope("builtin local var1")

        self.assertIn("var1", auditor.local_scope)

    def test_update_scope__variable_assignment__adds_variable_to_local_scope(self):
        auditor = FileAuditor("mock.sh", self.context)

        auditor._update_scope("var2=value")

        self.assertIn("var2", auditor.local_scope)

    def test_is_exempt__shell_keyword__returns_true(self):
        auditor = FileAuditor("mock.sh", self.context)

        result = auditor._is_exempt("if")

        self.assertTrue(result)

    def test_is_exempt__bash_builtin__returns_true(self):
        auditor = FileAuditor("mock.sh", self.context)

        result = auditor._is_exempt("echo")

        self.assertTrue(result)

    def test_is_exempt__project_defined_function__returns_true(self):
        auditor = FileAuditor("mock.sh", self.context)

        result = auditor._is_exempt("my_func")

        self.assertTrue(result)

    def test_is_exempt__local_variable__returns_true(self):
        auditor = FileAuditor("mock.sh", self.context)
        auditor.local_scope.add("local_var")

        result = auditor._is_exempt("local_var")

        self.assertTrue(result)

    def test_is_exempt__stdlib_function_prefix__returns_true(self):
        auditor = FileAuditor("mock.sh", self.context)

        self.assertTrue(auditor._is_exempt("stdlib.foo"))
        self.assertTrue(auditor._is_exempt("_stdlib_foo"))
        self.assertTrue(auditor._is_exempt("_testing.foo"))
        self.assertTrue(auditor._is_exempt("docs.foo"))
        self.assertTrue(auditor._is_exempt("__foo"))
        self.assertTrue(auditor._is_exempt("_STDLIB_BINARY_FOO"))
        self.assertTrue(auditor._is_exempt("$FOO"))
        self.assertTrue(auditor._is_exempt("-foo"))

    def test_is_exempt__numeric_literal__returns_true(self):
        auditor = FileAuditor("mock.sh", self.context)

        result = auditor._is_exempt("123")

        self.assertTrue(result)

    def test_is_exempt__arithmetic_operator_suffix__returns_true(self):
        auditor = FileAuditor("mock.sh", self.context)

        self.assertTrue(auditor._is_exempt("foo++"))
        self.assertTrue(auditor._is_exempt("foo--"))

    def test_is_exempt__disallowed_shell_characters__returns_true(self):
        auditor = FileAuditor("mock.sh", self.context)

        result = auditor._is_exempt("[foo]")

        self.assertTrue(result)

    def test_is_exempt__unregistered_external_binary__returns_false(self):
        auditor = FileAuditor("mock.sh", self.context)

        result = auditor._is_exempt("ls")

        self.assertFalse(result)

    def test_check__unauthorized_absolute_path__adds_violation(self):
        auditor = FileAuditor("mock.sh", self.context)

        auditor._check("/usr/bin/ls", 10)
        self.assertIn("Line 10: Direct call to absolute path '/usr/bin/ls'.", auditor.violations)

        auditor.violations = []
        auditor._check("/bin/sh", 11)
        self.assertIn("Line 11: Direct call to absolute path '/bin/sh'.", auditor.violations)

    def test_check__exempted_absolute_path__adds_no_violation(self):
        auditor = FileAuditor("mock.sh", self.context)

        auditor._check("/dev/null", 11)

        self.assertEqual(len(auditor.violations), 0)

    def test_check__defined_binary__adds_violation(self):
        auditor = FileAuditor("mock.sh", self.context)

        auditor._check("cat", 12)

        self.assertIn("Line 12: Direct call to defined binary 'cat'. Use _STDLIB_BINARY_CAT instead.", auditor.violations)

    def test_check__unknown_binary__adds_violation(self):
        auditor = FileAuditor("mock.sh", self.context)

        auditor._check("ls", 13)

        self.assertIn("Line 13: Direct call to unknown binary 'ls'. Define it in src/binary.sh first.", auditor.violations)

    def test_audit__returns_expected_violations(self):
        mock_sh_path = os.path.join(self.assets_dir, "mock.sh")
        auditor = FileAuditor(mock_sh_path, self.context)

        violations = auditor.audit()

        self.assertEqual(len(violations), 3)
        self.assertIn("Line 2: Direct call to unknown binary 'ls'", violations[0])
        self.assertIn("Line 3: Direct call to defined binary 'cat'", violations[1])
        self.assertIn("Line 5: Direct call to unknown binary 'grep'", violations[2])


class TestMain(unittest.TestCase):

    @patch("sys.exit")
    @patch("sys.stdout", new_callable=StringIO)
    @patch("binary_check.ProjectContext")
    @patch("binary_check.FileAuditor")
    def test_main__no_arguments__returns_immediately(self, mock_auditor, mock_context, mock_stdout, mock_exit):
        with patch("sys.argv", ["binary_check.py"]):
            import binary_check
            binary_check.main()

        mock_context.assert_not_called()
        mock_exit.assert_not_called()

    @patch("sys.exit")
    @patch("sys.stdout", new_callable=StringIO)
    @patch("binary_check.ProjectContext")
    def test_main__violations_found__exits_with_error_and_json_output(self, mock_context, mock_stdout, mock_exit):
        # We need to mock FileAuditor properly to return violations
        with patch("binary_check.FileAuditor") as mock_auditor:
            mock_auditor.return_value.audit.return_value = ["Violation 1"]

            with patch("sys.argv", ["binary_check.py", "file1.sh"]):
                import binary_check
                binary_check.main()

        mock_exit.assert_called_with(1)
        output = json.loads(mock_stdout.getvalue())
        self.assertIn("file1.sh", output)
        self.assertEqual(output["file1.sh"], ["Violation 1"])

    @patch("sys.exit")
    @patch("sys.stdout", new_callable=StringIO)
    @patch("binary_check.ProjectContext")
    def test_main__no_violations__exits_normally(self, mock_context, mock_stdout, mock_exit):
        with patch("binary_check.FileAuditor") as mock_auditor:
            mock_auditor.return_value.audit.return_value = []

            with patch("sys.argv", ["binary_check.py", "file1.sh"]):
                import binary_check
                binary_check.main()

        mock_exit.assert_not_called()
        self.assertEqual(mock_stdout.getvalue(), "")


if __name__ == "__main__":
    unittest.main()
