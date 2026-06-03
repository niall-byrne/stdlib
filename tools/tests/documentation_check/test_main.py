"""Tests for main execution and reporting in documentation_check."""

import json
import os
import sys
import unittest
from io import StringIO
from unittest.mock import patch

# Adjust sys.path to find documentation_check
sys.path.append(
    os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
)

import documentation_check


class TestMain(unittest.TestCase):
    def setUp(self):
        self.assets_dir = os.path.abspath(
            os.path.join(
                os.path.dirname(__file__),
                "../assets/documentation",
            )
        )

    @patch("sys.exit")
    @patch("sys.stdout", new_callable=StringIO)
    def test_main_with_errors(self, mock_stdout, mock_exit):
        filepath = os.path.join(self.assets_dir, "undocumented.sh")

        with patch("sys.argv", ["documentation_check.py", filepath]):
            documentation_check.main()

        mock_exit.assert_called_with(1)
        output = json.loads(mock_stdout.getvalue())
        self.assertIn(filepath, output)
        self.assertIn("Completely undocumented.", output[filepath][0])

    @patch("sys.exit")
    @patch("sys.stdout", new_callable=StringIO)
    def test_main_with_parse_error(self, mock_stdout, mock_exit):
        filepath = "non_existent_file.sh"

        with patch("sys.argv", ["documentation_check.py", filepath]):
            documentation_check.main()

        mock_exit.assert_called_with(1)
        output = json.loads(mock_stdout.getvalue())
        self.assertIn(filepath, output)
        self.assertIn("File could not be parsed:", output[filepath][0])


if __name__ == "__main__":
    unittest.main()
