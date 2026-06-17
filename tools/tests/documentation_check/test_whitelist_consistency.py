"""Tests for modifier variable consistency whitelist in documentation_check."""

import json
import os
import sys
import unittest
from io import StringIO
from unittest.mock import patch

sys.path.append(
    os.path.abspath(os.path.join(os.path.dirname(__file__), "../..")))

import documentation_check


class TestWhitelistConsistency(unittest.TestCase):

    def setUp(self):
        self.assets_dir = os.path.abspath(
            os.path.join(
                os.path.dirname(__file__),
                "../assets/documentation_check/whitelist",
            ))

    def test_main__consistent_whitelisted_variable__success(self):
        consistent_dir = os.path.join(self.assets_dir, "consistent")
        file1 = os.path.join(consistent_dir, "whitelist_file1.sh")
        file2 = os.path.join(consistent_dir, "whitelist_file2.sh")

        with patch("documentation_check.PATH_SOURCE_DIRECTORY", consistent_dir):
            with patch("sys.argv", ["documentation_check.py", file1, file2]):
                try:
                    documentation_check.main()
                except SystemExit as cm:
                    self.assertNotEqual(cm.code, 1)

    def test_main__malformed_whitelisted_variable__returns_error(self):
        malformed_dir = os.path.join(self.assets_dir, "malformed")
        file = os.path.join(malformed_dir, "whitelist_malformed.sh")

        with patch("documentation_check.PATH_SOURCE_DIRECTORY", malformed_dir):
            with patch("sys.argv", ["documentation_check.py", file]):
                with patch("sys.stdout", new=StringIO()) as mock_stdout:
                    with self.assertRaises(SystemExit) as cm:
                        documentation_check.main()

                    self.assertEqual(cm.exception.code, 1)

                    output = json.loads(mock_stdout.getvalue())
                    self.assertIn(file, output)

                    errors = output[file]
                    self.assertTrue(any("Invalid type in @set" in err for err in errors))
                    self.assertTrue(any(isinstance(err, dict) and "variable_inconsistency" in err for err in errors))

if __name__ == "__main__":
    unittest.main()
