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
                "../assets/documentation_modifier_variable_check",
            ))
        self.file1 = os.path.join(self.assets_dir, "whitelist_file1.sh")
        self.file2 = os.path.join(self.assets_dir, "whitelist_file2.sh")
        self.malformed = os.path.join(self.assets_dir, "whitelist_malformed.sh")

    def test_main_consistent_whitelisted_variable(self):
        if os.path.exists(self.malformed):
            os.remove(self.malformed)

        with patch("documentation_check.PATH_SOURCE_DIRECTORY", self.assets_dir):
            with patch("sys.argv", ["documentation_check.py", self.file1, self.file2]):
                try:
                    documentation_check.main()
                except SystemExit as cm:
                    self.assertNotEqual(cm.code, 1)

    def test_main_malformed_whitelisted_variable(self):
        with open(self.malformed, "w") as f:
            f.write("#!/bin/bash\n")
            f.write("# @description Malformed.\n")
            f.write("# @noargs\n")
            f.write("# @exitcode 0 If successful.\n")
            f.write("# @set TEST_OUTPUT malformed_type Description.\n")
            f.write("stdlib.malformed() {\n  :\n}\n")

        with patch("documentation_check.PATH_SOURCE_DIRECTORY", self.assets_dir):
            with patch("sys.argv", ["documentation_check.py", self.malformed]):
                with patch("sys.stdout", new=StringIO()) as mock_stdout:
                    with self.assertRaises(SystemExit) as cm:
                        documentation_check.main()
                    self.assertEqual(cm.exception.code, 1)
                    output = json.loads(mock_stdout.getvalue())
                    self.assertIn(self.malformed, output)
                    errors = output[self.malformed]
                    self.assertTrue(any("Invalid type in @set" in err for err in errors))
                    self.assertTrue(any(isinstance(err, dict) and "variable_inconsistency" in err for err in errors))

if __name__ == "__main__":
    unittest.main()
