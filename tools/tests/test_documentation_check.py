import unittest
import os
import sys
import json
from io import StringIO
from unittest.mock import patch

# Add the tools directory to the path so we can import the script
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import documentation_check

class TestDocumentationCheck(unittest.TestCase):
    def setUp(self):
        self.assets_dir = os.path.join(os.path.dirname(__file__), "assets")

    def test_valid_file(self):
        filepath = os.path.join(self.assets_dir, "valid.sh")
        functions = documentation_check.parse_file(filepath)
        self.assertEqual(len(functions), 1)

        errors = []
        rules = [
            documentation_check.UndocumentedRule(),
            documentation_check.FieldOrderRule(),
            documentation_check.MandatoryFieldsRule(),
            documentation_check.MissingExitCodeRule(),
            documentation_check.StandardExitCodesRule(),
            documentation_check.ExitCodeDescriptionRule(),
            documentation_check.TypeValidationRule(),
            documentation_check.GlobalIndentationRule(),
            documentation_check.AssertionStderrRule(),
            documentation_check.MissingOutputTagsRule(),
            documentation_check.SentenceFormatRule(),
            documentation_check.InternalTagRule(),
        ]

        for func in functions:
            undocumented_rule = next((r for r in rules if isinstance(r, documentation_check.UndocumentedRule)), None)
            if undocumented_rule:
                undocumented_errors = undocumented_rule.check(func)
                if undocumented_errors:
                    errors.extend(undocumented_errors)
                    continue

            for rule in rules:
                if isinstance(rule, documentation_check.UndocumentedRule):
                    continue
                errors.extend(rule.check(func))

        self.assertEqual(errors, [])

    def test_undocumented_file(self):
        filepath = os.path.join(self.assets_dir, "undocumented.sh")
        functions = documentation_check.parse_file(filepath)
        rule = documentation_check.UndocumentedRule()
        errors = rule.check(functions[0])
        self.assertIn("Completely undocumented.", errors[0])

    def test_missing_description(self):
        filepath = os.path.join(self.assets_dir, "missing_description.sh")
        functions = documentation_check.parse_file(filepath)
        rule = documentation_check.MandatoryFieldsRule()
        errors = rule.check(functions[0])
        self.assertIn("Missing @description", errors[0])

    def test_incorrect_order(self):
        filepath = os.path.join(self.assets_dir, "incorrect_order.sh")
        functions = documentation_check.parse_file(filepath)
        rule = documentation_check.FieldOrderRule()
        errors = rule.check(functions[0])
        self.assertIn("Incorrect field order.", errors[0])

    def test_invalid_type(self):
        filepath = os.path.join(self.assets_dir, "invalid_type.sh")
        functions = documentation_check.parse_file(filepath)
        rule = documentation_check.TypeValidationRule()
        errors = rule.check(functions[0])
        self.assertIn("Missing or invalid type in @arg.", errors[0])

    def test_non_standard_exitcodes(self):
        filepath = os.path.join(self.assets_dir, "non_standard_exitcodes.sh")
        functions = documentation_check.parse_file(filepath)

        # Test standard exit codes rule
        rule_std = documentation_check.StandardExitCodesRule()
        errors_std = rule_std.check(functions[0])
        self.assertEqual(len(errors_std), 2)
        self.assertIn("Non-standard @exitcode 126", errors_std[0])
        self.assertIn("Non-standard @exitcode 127", errors_std[1])

    def test_exitcode_description(self):
        filepath = os.path.join(self.assets_dir, "non_standard_exitcodes.sh")
        functions = documentation_check.parse_file(filepath)

        rule_if = documentation_check.ExitCodeDescriptionRule()
        errors_if = rule_if.check(functions[0])
        # exitcode 126 and 127 in assets don't start with "If"
        # exitcode 0 does.
        self.assertEqual(len(errors_if), 2)
        self.assertIn("@exitcode description should start with 'If'", errors_if[0])
        self.assertIn("@exitcode description should start with 'If'", errors_if[1])

    def test_missing_outputs(self):
        filepath = os.path.join(self.assets_dir, "missing_outputs.sh")
        functions = documentation_check.parse_file(filepath)
        rule = documentation_check.MissingOutputTagsRule()
        errors = rule.check(functions[0])
        self.assertEqual(len(errors), 2)
        self.assertIn("Missing @stderr tag", errors[0])
        self.assertIn("Missing @stdout tag", errors[1])

    def test_missing_exitcode_configurable(self):
        filepath = os.path.join(self.assets_dir, "valid.sh")
        functions = documentation_check.parse_file(filepath)

        # Override REQUIRED_EXIT_CODES
        original_codes = documentation_check.REQUIRED_EXIT_CODES
        try:
            documentation_check.REQUIRED_EXIT_CODES = ["0", "1"]
            rule = documentation_check.MissingExitCodeRule()
            errors = rule.check(functions[0])
            self.assertEqual(len(errors), 1)
            self.assertIn("Missing @exitcode 1", errors[0])
        finally:
            documentation_check.REQUIRED_EXIT_CODES = original_codes

    @patch('sys.exit')
    @patch('sys.stdout', new_callable=StringIO)
    def test_main_with_errors(self, mock_stdout, mock_exit):
        filepath = os.path.join(self.assets_dir, "undocumented.sh")
        with patch('sys.argv', ['documentation_check.py', filepath]):
            documentation_check.main()

        mock_exit.assert_called_with(1)
        output = json.loads(mock_stdout.getvalue())
        self.assertIn(filepath, output)
        self.assertIn("Completely undocumented.", output[filepath][0])

if __name__ == "__main__":
    unittest.main()
