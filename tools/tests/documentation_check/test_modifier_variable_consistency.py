"""Tests for modifier variable consistency in documentation_check."""

import json
import os
import sys
import unittest
from io import StringIO
from unittest.mock import patch

# Adjust sys.path to find documentation_check
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "../..")))

import documentation_check

class TestModifierVariableConsistency(unittest.TestCase):

    def setUp(self):
        self.assets_dir = os.path.abspath(os.path.join(
            os.path.dirname(__file__),
            "../assets/documentation_modifier_variable_check",
        ))

    def test_extract_metadata(self):
        filepath = os.path.join(self.assets_dir, "file1.sh")
        parsed_file = documentation_check.parse_file(filepath)
        metadata = []

        for func in parsed_file.functions:
            extractor = documentation_check.ModifierVariableMetadataExtractor(
                func, filepath)
            metadata.extend(extractor.extract())
        metadata.sort(key=lambda m: (m.function_name, m.name))

        self.assertEqual(len(metadata), 3)

    @patch("sys.exit")
    @patch("sys.stdout", new_callable=StringIO)
    def test_main_inconsistent_description(self, mock_stdout, mock_exit):
        file1 = os.path.abspath(os.path.join(self.assets_dir, "file1.sh"))
        file2 = os.path.abspath(os.path.join(self.assets_dir, "file2.sh"))

        with patch("documentation_check.PATH_SOURCE_DIRECTORY",
                   self.assets_dir):
            with patch("sys.argv", ["documentation_check.py", file1, file2]):
                documentation_check.main()

        if mock_exit.called:
            output = json.loads(mock_stdout.getvalue())
            self.assertIn(file1, output)
            self.assertIn(file2, output)

            # Check that at least one error is a variable inconsistency
            found_inconsistency = False
            for error in output[file1]:
                if isinstance(error, dict) and "variable_inconsistency" in error:
                    found_inconsistency = True
                    break
            self.assertTrue(found_inconsistency)

if __name__ == "__main__":
    unittest.main()
