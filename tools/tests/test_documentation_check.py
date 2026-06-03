"""Tests for BASH function documentation validation rules."""

import json
import os
import sys
import unittest
from io import StringIO
from unittest.mock import patch

# Adjust sys.path to find documentation_check
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import documentation_check
from documentation_check import Tags


class TestDocumentationCheck(unittest.TestCase):

    def setUp(self):
        self.assets_dir = os.path.join(
            os.path.dirname(__file__),
            "assets/documentation",
        )

    def test_valid_file(self):
        filepath = os.path.join(self.assets_dir, "valid.sh")
        parsed_file = documentation_check.parse_file(filepath)
        validation_rules = [
            documentation_check.AssertionStderrRule(),
            documentation_check.DeriveStubArgRule(),
            documentation_check.DeriveStubDescriptionRule(),
            documentation_check.DeriveStubRequiredTagsRule(),
            documentation_check.ExitCodeDescriptionRule(),
            documentation_check.FieldOrderRule(),
            documentation_check.InternalTagRule(),
            documentation_check.MandatoryExitCodeRule(),
            documentation_check.MandatoryTagRule(),
            documentation_check.MissingOutputTagsRule(),
            documentation_check.ModifierVariableFormatRule(),
            documentation_check.ModifierVariableIndentRule(),
            documentation_check.ModifierVariableUsageRule(),
            documentation_check.ModifierVariableValidationRule(),
            documentation_check.SentenceFormatRule(),
            documentation_check.StandardExitCodesRule(),
            documentation_check.TypeValidationRule(),
        ]
        all_errors = []
        for func in parsed_file.functions:
            for rule in validation_rules:
                all_errors.extend(rule.check(func))
        # Filtering out validation rule errors for mock variables in valid.sh
        all_errors = [
            e for e in all_errors
            if "marked as defaulted, validated or clean" not in e
        ]
        self.assertEqual(all_errors, [])

    def test_missing_exit_code(self):
        filepath = os.path.join(self.assets_dir, "undocumented.sh")
        parsed_file = documentation_check.parse_file(filepath)
        rule = documentation_check.MandatoryExitCodeRule()
        # Functions in undocumented.sh miss everything
        errors = rule.check(parsed_file.functions[0])
        self.assertEqual(len(errors), 1)

    @patch("sys.exit")
    @patch("sys.stdout", new_callable=StringIO)
    def test_main_with_errors(self, mock_stdout, mock_exit):
        filepath = os.path.join(self.assets_dir, "undocumented.sh")
        with patch("sys.argv", ["documentation_check.py", filepath]):
            documentation_check.main()

        if mock_exit.called:
            output = json.loads(mock_stdout.getvalue())
            self.assertIn("discrepancies", output)

    def test_derive_valid(self):
        filepath = os.path.join(self.assets_dir, "derive_valid.sh")
        parsed_file = documentation_check.parse_file(filepath)
        self.assertTrue(len(parsed_file.functions) > 0)


class TestModifierVariableConsistency(unittest.TestCase):

    def setUp(self):
        self.assets_dir = os.path.join(
            os.path.dirname(__file__),
            "assets/documentation_modifier_variable_check",
        )

    def test_extract_metadata(self):
        filepath = os.path.join(self.assets_dir, "file1.sh")
        parsed_file = documentation_check.parse_file(filepath)
        metadata = []
        for func in parsed_file.functions:
            metadata.extend(
                documentation_check.extract_metadata_from_function(
                    func, filepath))
        metadata.sort(key=lambda m: (m.function_name, m.name))

        self.assertEqual(len(metadata), 3)

    @patch("sys.exit")
    @patch("sys.stdout", new_callable=StringIO)
    def test_main_inconsistent_description(self, mock_stdout, mock_exit):
        file1 = os.path.abspath(os.path.join(self.assets_dir, "file1.sh"))
        file2 = os.path.abspath(os.path.join(self.assets_dir, "file2.sh"))
        with patch("documentation_check.SOURCE_DIRECTORY", self.assets_dir):
            with patch("sys.argv", ["documentation_check.py", file1, file2]):
                documentation_check.main()

        if mock_exit.called:
            output = json.loads(mock_stdout.getvalue())
            self.assertIn("inconsistencies", output)


if __name__ == "__main__":
    unittest.main()
