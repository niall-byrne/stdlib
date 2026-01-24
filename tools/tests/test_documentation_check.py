import unittest
import os
import sys
import json
from io import StringIO
from unittest.mock import patch

# Add the tools directory to the path so we can import the script
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import documentation_check
from documentation_check import Tags


class TestDocumentationCheck(unittest.TestCase):
    def setUp(self):
        self.assets_dir = os.path.join(os.path.dirname(__file__), "assets")

    def test_valid_file(self):
        filepath = os.path.join(self.assets_dir, "valid.sh")
        functions, _ = documentation_check.parse_file(filepath)
        self.assertEqual(len(functions), 1)

        undocumented_rule = documentation_check.UndocumentedRule()
        validation_rules = [
            documentation_check.AssertionStderrRule(),
            documentation_check.ExitCodeDescriptionRule(),
            documentation_check.FieldOrderRule(),
            documentation_check.GlobalIndentationRule(),
            documentation_check.InternalTagRule(),
            documentation_check.MandatoryExitCodeRule(),
            documentation_check.MandatoryFieldsRule(),
            documentation_check.MissingOutputTagsRule(),
            documentation_check.SentenceFormatRule(),
            documentation_check.StandardExitCodesRule(),
            documentation_check.TypeValidationRule(),
        ]

        errors = []
        for func in functions:
            undocumented_errors = undocumented_rule.check(func)
            if undocumented_errors:
                errors.extend(undocumented_errors)
                continue

            for rule in validation_rules:
                errors.extend(rule.check(func))

        self.assertEqual(errors, [])

    def test_undocumented_file(self):
        filepath = os.path.join(self.assets_dir, "undocumented.sh")
        functions, _ = documentation_check.parse_file(filepath)
        rule = documentation_check.UndocumentedRule()
        errors = rule.check(functions[0])
        self.assertIn("Completely undocumented.", errors[0])

    def test_missing_description(self):
        filepath = os.path.join(self.assets_dir, "missing_description.sh")
        functions, _ = documentation_check.parse_file(filepath)
        rule = documentation_check.MandatoryFieldsRule()
        errors = rule.check(functions[0])
        self.assertIn(f"Missing @{Tags.DESCRIPTION.name}", errors[0])

    def test_incorrect_order(self):
        filepath = os.path.join(self.assets_dir, "incorrect_order.sh")
        functions, _ = documentation_check.parse_file(filepath)
        rule = documentation_check.FieldOrderRule()
        errors = rule.check(functions[0])
        self.assertIn("Incorrect field order.", errors[0])

    def test_invalid_type(self):
        filepath = os.path.join(self.assets_dir, "invalid_type.sh")
        functions, _ = documentation_check.parse_file(filepath)
        rule = documentation_check.TypeValidationRule()
        errors = rule.check(functions[0])
        self.assertIn(f"Missing or invalid type in @{Tags.ARG.name}.", errors[0])

    def test_non_standard_exitcodes(self):
        filepath = os.path.join(self.assets_dir, "non_standard_exitcodes.sh")
        functions, _ = documentation_check.parse_file(filepath)

        # Test standard exit codes rule
        rule_std = documentation_check.StandardExitCodesRule()
        errors_std = rule_std.check(functions[0])
        self.assertEqual(len(errors_std), 2)
        self.assertIn(f"Non-standard @{Tags.EXITCODE.name} 126", errors_std[0])
        self.assertIn(f"Non-standard @{Tags.EXITCODE.name} 127", errors_std[1])

    def test_exitcode_description(self):
        filepath = os.path.join(self.assets_dir, "non_standard_exitcodes.sh")
        functions, _ = documentation_check.parse_file(filepath)

        rule_if = documentation_check.ExitCodeDescriptionRule()
        errors_if = rule_if.check(functions[0])
        # exitcode 126 and 127 in assets don't start with "If"
        # exitcode 0 does.
        self.assertEqual(len(errors_if), 2)
        self.assertIn(
            f"@{Tags.EXITCODE.name} description should start with 'If'", errors_if[0]
        )
        self.assertIn(
            f"@{Tags.EXITCODE.name} description should start with 'If'", errors_if[1]
        )

    def test_missing_outputs(self):
        filepath = os.path.join(self.assets_dir, "missing_outputs.sh")
        functions, _ = documentation_check.parse_file(filepath)
        rule = documentation_check.MissingOutputTagsRule()
        errors = rule.check(functions[0])
        self.assertEqual(len(errors), 2)
        self.assertIn(f"Missing @{Tags.STDERR.name} tag", errors[0])
        self.assertIn(f"Missing @{Tags.STDOUT.name} tag", errors[1])

    def test_missing_exitcode_configurable(self):
        filepath = os.path.join(self.assets_dir, "valid.sh")
        functions, _ = documentation_check.parse_file(filepath)

        # Override MANDATORY_EXIT_CODES
        original_codes = documentation_check.MANDATORY_EXIT_CODES
        try:
            documentation_check.MANDATORY_EXIT_CODES = ["0", "1"]
            rule = documentation_check.MandatoryExitCodeRule()
            errors = rule.check(functions[0])
            self.assertEqual(len(errors), 1)
            self.assertIn(f"Missing @{Tags.EXITCODE.name} 1", errors[0])
        finally:
            documentation_check.MANDATORY_EXIT_CODES = original_codes

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

    def test_derive_valid(self):
        filepath = os.path.join(self.assets_dir, "derive_valid.sh")
        functions, derive_calls = documentation_check.parse_file(filepath)

        rules = [
            documentation_check.DeriveStubDescriptionRule(),
            documentation_check.DeriveStubArgRule(),
            documentation_check.DeriveStubRequiredTagsRule(),
        ]
        derive_rules = [
            documentation_check.MissingDeriveStubRule(),
            documentation_check.DeriveStubNamingRule(),
        ]

        errors = []
        for func in functions:
            for rule in rules:
                errors.extend(rule.check(func))

        for call in derive_calls:
            for rule in derive_rules:
                errors.extend(rule.check(call))

        self.assertEqual(errors, [])

    def test_derive_invalid(self):
        filepath = os.path.join(self.assets_dir, "derive_invalid.sh")
        functions, derive_calls = documentation_check.parse_file(filepath)

        rules = [
            documentation_check.DeriveStubDescriptionRule(),
            documentation_check.DeriveStubArgRule(),
            documentation_check.DeriveStubRequiredTagsRule(),
        ]
        derive_rules = [
            documentation_check.MissingDeriveStubRule(),
            documentation_check.DeriveStubNamingRule(),
        ]

        all_errors = []
        for func in functions:
            for rule in rules:
                all_errors.extend(rule.check(func))

        for call in derive_calls:
            for rule in derive_rules:
                all_errors.extend(rule.check(call))

        self.assertEqual(len(all_errors), 8)

        # We check that all expected error patterns are present
        error_patterns = [
            "description should match",  # Description error for left_pipe
            "description should end with",  # Arg error for left_pipe
            "Missing @stdin tag",  # Stdin error for left_pipe
            "description should match",  # Arg error for left_var
            "Missing stub function",  # Missing stub for right_pipe
            "does not match expected target",  # Naming error for wrong_name_var
            "Missing @stdin tag",  # Stdin error for left_pipe_no_stdin
            "does not match expected target",  # Naming error for left_pipe_no_stdin
        ]

        for pattern in error_patterns:
            self.assertTrue(
                any(pattern in e for e in all_errors),
                f"Pattern '{pattern}' not found in errors",
            )


if __name__ == "__main__":
    unittest.main()
