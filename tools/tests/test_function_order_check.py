import unittest
import os
import sys
import json
from io import StringIO
from unittest.mock import patch

# Add the tools directory to the path so we can import the script
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import function_order_check


class TestFunctionOrderCheck(unittest.TestCase):
    def setUp(self):
        self.assets_dir = os.path.join(
            os.path.dirname(__file__), "assets", "function_order"
        )

    def test_custom_sort_key(self):
        # Letters < _ < a-z < . < __
        # _ maps to itself
        # . maps to } (125)
        # __ maps to ~ (126)

        # _ < Letters
        self.assertTrue(
            function_order_check.BashFile._custom_sort_key("_")
            < function_order_check.BashFile._custom_sort_key("a")
        )
        self.assertTrue(
            function_order_check.BashFile._custom_sort_key("_")
            < function_order_check.BashFile._custom_sort_key("z")
        )

        # _ < .
        self.assertTrue(
            function_order_check.BashFile._custom_sort_key("_")
            < function_order_check.BashFile._custom_sort_key(".")
        )

        # . < __
        self.assertTrue(
            function_order_check.BashFile._custom_sort_key(".")
            < function_order_check.BashFile._custom_sort_key("__")
        )

        # Complex cases
        self.assertTrue(
            function_order_check.BashFile._custom_sort_key("stdlib.a")
            < function_order_check.BashFile._custom_sort_key("stdlib.a_pipe")
        )
        self.assertTrue(
            function_order_check.BashFile._custom_sort_key("stdlib.a_pipe")
            < function_order_check.BashFile._custom_sort_key("stdlib.a.b")
        )
        self.assertTrue(
            function_order_check.BashFile._custom_sort_key("stdlib.a.b")
            < function_order_check.BashFile._custom_sort_key("stdlib.a__private")
        )

    def test_bash_file_parse(self):
        filepath = os.path.join(self.assets_dir, "sorted.sh")
        bash_file = function_order_check.BashFile(filepath)
        self.assertEqual(len(bash_file.functions), 3)
        self.assertEqual(bash_file.functions[0].name, "stdlib.a")
        self.assertEqual(bash_file.functions[1].name, "stdlib.b")
        self.assertEqual(bash_file.functions[2].name, "stdlib.__private")

    def test_sorted_file(self):
        filepath = os.path.join(self.assets_dir, "sorted.sh")
        bash_file = function_order_check.BashFile(filepath)
        errors = bash_file.get_sorting_errors()
        self.assertEqual(errors, [])

    def test_unsorted_file(self):
        filepath = os.path.join(self.assets_dir, "unsorted.sh")
        bash_file = function_order_check.BashFile(filepath)
        errors = bash_file.get_sorting_errors()
        self.assertTrue(len(errors) > 0)
        self.assertIn("Functions are not in alphabetical order", errors[0])

    def test_underscores_file(self):
        filepath = os.path.join(self.assets_dir, "underscores.sh")
        bash_file = function_order_check.BashFile(filepath)
        errors = bash_file.get_sorting_errors()
        self.assertEqual(errors, [])

    def test_private_at_bottom(self):
        filepath = os.path.join(self.assets_dir, "private_at_bottom.sh")
        bash_file = function_order_check.BashFile(filepath)
        errors = bash_file.get_sorting_errors()
        self.assertEqual(errors, [])

    @patch("sys.exit")
    @patch("sys.stdout", new_callable=StringIO)
    def test_main_with_errors(self, mock_stdout, mock_exit):
        filepath = os.path.join(self.assets_dir, "unsorted.sh")
        with patch("sys.argv", ["function_order_check.py", filepath]):
            function_order_check.main()

        mock_exit.assert_called_with(1)
        output = json.loads(mock_stdout.getvalue())
        self.assertIn(filepath, output)

    @patch("sys.exit")
    @patch("sys.stdout", new_callable=StringIO)
    def test_main_no_errors(self, mock_stdout, mock_exit):
        filepath = os.path.join(self.assets_dir, "sorted.sh")
        with patch("sys.argv", ["function_order_check.py", filepath]):
            function_order_check.main()

        mock_exit.assert_not_called()
        self.assertEqual(mock_stdout.getvalue(), "")

    @patch("sys.exit")
    @patch("sys.stderr", new_callable=StringIO)
    def test_main_no_args(self, mock_stderr, mock_exit):
        with patch("sys.argv", ["function_order_check.py"]):
            function_order_check.main()

        mock_exit.assert_called_with(1)
        self.assertIn("Error: No files provided", mock_stderr.getvalue())


if __name__ == "__main__":
    unittest.main()
