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
        self.assets_dir = os.path.join(os.path.dirname(__file__), "assets", "function_order")

    def test_custom_sort_key(self):
        self.assertTrue(function_order_check.custom_sort_key("a") < function_order_check.custom_sort_key("_"))
        self.assertTrue(function_order_check.custom_sort_key("z") < function_order_check.custom_sort_key("_"))
        self.assertTrue(function_order_check.custom_sort_key("stdlib.a") < function_order_check.custom_sort_key("stdlib.__b"))

    def test_sorted_file(self):
        filepath = os.path.join(self.assets_dir, "sorted.sh")
        errors = function_order_check.check_order(filepath)
        self.assertEqual(errors, [])

    def test_unsorted_file(self):
        filepath = os.path.join(self.assets_dir, "unsorted.sh")
        errors = function_order_check.check_order(filepath)
        self.assertTrue(len(errors) > 0)
        self.assertIn("Functions are not in alphabetical order", errors[0])

    def test_private_at_bottom(self):
        filepath = os.path.join(self.assets_dir, "private_at_bottom.sh")
        errors = function_order_check.check_order(filepath)
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


if __name__ == "__main__":
    unittest.main()
