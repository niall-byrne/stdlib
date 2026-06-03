"""Tests for BASH function parsing in documentation_check."""

import os
import sys
import unittest

# Adjust sys.path to find documentation_check
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "../..")))

import documentation_check

class TestParsing(unittest.TestCase):

    def setUp(self):
        self.assets_dir = os.path.abspath(os.path.join(
            os.path.dirname(__file__),
            "../assets/documentation",
        ))

    def test_parse_file_valid(self):
        filepath = os.path.join(self.assets_dir, "valid.sh")
        parsed_file = documentation_check.parse_file(filepath)
        self.assertEqual(len(parsed_file.functions), 2)

    def test_derive_valid_parsing(self):
        filepath = os.path.join(self.assets_dir, "derive_valid.sh")
        parsed_file = documentation_check.parse_file(filepath)
        self.assertTrue(len(parsed_file.functions) > 0)
        self.assertTrue(len(parsed_file.derive_calls) > 0)

if __name__ == "__main__":
    unittest.main()
