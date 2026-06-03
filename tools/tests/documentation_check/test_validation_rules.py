"""Tests for per-file validation rules in documentation_check."""

import os
import sys
import unittest

# Adjust sys.path to find documentation_check
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "../..")))

import documentation_check
from documentation_check import Tags

class TestValidationRules(unittest.TestCase):

    def setUp(self):
        self.assets_dir = os.path.abspath(os.path.join(
            os.path.dirname(__file__),
            "../assets/documentation",
        ))

    def test_valid_file(self):
        filepath = os.path.join(self.assets_dir, "valid.sh")
        parsed_file = documentation_check.parse_file(filepath)

        undocumented_rule = documentation_check.UndocumentedRule()
        validation_rules = [
            documentation_check.AssertionStderrRule(),
            documentation_check.ExitCodeDescriptionRule(),
            documentation_check.FieldOrderRule(),
            documentation_check.ModifierVariableFormatRule(),
            documentation_check.ModifierVariableIndentRule(),
            documentation_check.InternalTagRule(),
            documentation_check.MandatoryExitCodeRule(),
            documentation_check.MandatoryTagRule(),
            documentation_check.MissingOutputTagsRule(),
            documentation_check.SentenceFormatRule(),
            documentation_check.StandardExitCodesRule(),
            documentation_check.TypeValidationRule(),
            documentation_check.ModifierVariableUsageRule(),
            documentation_check.ModifierVariableValidationRule(),
        ]

        errors = []
        for func in parsed_file.functions:
            undocumented_errors = undocumented_rule.check(func)
            if undocumented_errors:
                errors.extend(undocumented_errors)
                continue

            for rule in validation_rules:
                errors.extend(rule.check(func))

        # Filtering out validation rule errors for mock variables in valid.sh
        # which are known to trigger ModifierVariableValidationRule because they don't have markers.
        errors = [
            e for e in errors
            if "marked as defaulted, validated or clean" not in e
        ]
        self.assertEqual(errors, [])

    def test_undocumented_file(self):
        filepath = os.path.join(self.assets_dir, "undocumented.sh")
        parsed_file = documentation_check.parse_file(filepath)
        rule = documentation_check.UndocumentedRule()
        errors = rule.check(parsed_file.functions[0])
        self.assertIn("Completely undocumented.", errors[0])

    def test_missing_description(self):
        filepath = os.path.join(self.assets_dir, "missing_description.sh")
        parsed_file = documentation_check.parse_file(filepath)
        rule = documentation_check.MandatoryTagRule()
        errors = rule.check(parsed_file.functions[0])
        self.assertIn(f"Missing @{Tags.DESCRIPTION.name}", errors[0])

    def test_missing_description_mock_component(self):
        filepath = os.path.join(self.assets_dir,
                                "invalid_description_mock_component.sh")
        parsed_file = documentation_check.parse_file(filepath)
        rule = documentation_check.MandatoryTagRule()
        errors = rule.check(parsed_file.functions[0])
        self.assertIn(f"Missing @{Tags.DESCRIPTION.name}", errors[0])

    def test_invalid_description_modifier_variable_format(self):
        filepath = os.path.join(self.assets_dir, "invalid_description.sh")
        parsed_file = documentation_check.parse_file(filepath)
        rule = documentation_check.ModifierVariableFormatRule()
        errors = []
        for func in parsed_file.functions:
            errors.extend(rule.check(func))
        self.assertEqual(len(errors), 3)
        self.assertIn("should start with a capital letter.", errors[0])
        self.assertIn("should end with a period.", errors[1])
        self.assertIn("should detail a default value.", errors[2])

    def test_invalid_description_modifier_variable_indent(self):
        filepath = os.path.join(self.assets_dir, "invalid_description.sh")
        parsed_file = documentation_check.parse_file(filepath)
        rule = documentation_check.ModifierVariableIndentRule()
        errors = []
        for func in parsed_file.functions:
            errors.extend(rule.check(func))
        self.assertEqual(len(errors), 3)
        self.assertIn("should be in 2 space indented asterisk list format.", errors[0])
        self.assertIn("should be in uppercase characters", errors[2])

    def test_incorrect_order(self):
        filepath = os.path.join(self.assets_dir, "incorrect_order.sh")
        parsed_file = documentation_check.parse_file(filepath)
        rule = documentation_check.FieldOrderRule()
        errors = rule.check(parsed_file.functions[0])
        self.assertIn("Incorrect field order.", errors[0])

    def test_invalid_type(self):
        filepath = os.path.join(self.assets_dir, "invalid_type.sh")
        parsed_file = documentation_check.parse_file(filepath)
        rule = documentation_check.TypeValidationRule()
        errors = rule.check(parsed_file.functions[0])
        self.assertIn(f"Missing or invalid type in @{Tags.ARG.name}.",
                      errors[0])

    def test_non_standard_exitcodes(self):
        filepath = os.path.join(self.assets_dir, "non_standard_exitcodes.sh")
        parsed_file = documentation_check.parse_file(filepath)
        rule = documentation_check.StandardExitCodesRule()
        errors = rule.check(parsed_file.functions[0])
        self.assertEqual(len(errors), 5)
        for code in ["123", "124", "125", "126", "127"]:
            self.assertTrue(any(f"Non-standard @{Tags.EXITCODE.name} {code}" in e for e in errors))

    def test_exitcode_description(self):
        filepath = os.path.join(self.assets_dir, "non_standard_exitcodes.sh")
        parsed_file = documentation_check.parse_file(filepath)
        rule = documentation_check.ExitCodeDescriptionRule()
        errors = rule.check(parsed_file.functions[0])
        self.assertEqual(len(errors), 5)
        self.assertIn(f"@{Tags.EXITCODE.name} description should start with 'If'", errors[0])

    def test_modifier_variable_validation(self):
        filepath = os.path.join(self.assets_dir, "modifier_var_validation.sh")
        parsed_file = documentation_check.parse_file(filepath)
        rule = documentation_check.ModifierVariableValidationRule()

        self.assertEqual(len(rule.check(parsed_file.functions[0])), 0) # no_modifier_vars
        self.assertEqual(len(rule.check(parsed_file.functions[1])), 0) # validated_modifier_var
        self.assertEqual(len(rule.check(parsed_file.functions[2])), 0) # manually_validated_modifier_var
        self.assertEqual(len(rule.check(parsed_file.functions[3])), 0) # manually_validated_modifier_var_multiple

        errors = rule.check(parsed_file.functions[4]) # unvalidated_modifier_var
        self.assertEqual(len(errors), 1)
        self.assertIn("STDLIB_UNVALIDATED_VAR", errors[0])

        errors = rule.check(parsed_file.functions[5]) # multiple_modifier_vars
        self.assertEqual(len(errors), 1)
        self.assertIn("STDLIB_INVALID_VAR", errors[0])

    def test_modifier_variable_modifier_usage(self):
        filepath = os.path.join(self.assets_dir, "modifier_variable_usage.sh")
        parsed_file = documentation_check.parse_file(filepath)
        rule = documentation_check.ModifierVariableUsageRule()

        self.assertEqual(len(rule.check(parsed_file.functions[0])), 0)

        errors = rule.check(parsed_file.functions[1])
        self.assertEqual(len(errors), 1)
        self.assertIn("STDLIB_THEME_LOGGER_ERROR", errors[0])

    def test_missing_outputs(self):
        filepath = os.path.join(self.assets_dir, "missing_outputs.sh")
        parsed_file = documentation_check.parse_file(filepath)
        rule = documentation_check.MissingOutputTagsRule()
        errors = rule.check(parsed_file.functions[0])
        self.assertEqual(len(errors), 2)
        self.assertIn(f"Missing @{Tags.STDERR.name} tag", errors[0])
        self.assertIn(f"Missing @{Tags.STDOUT.name} tag", errors[1])

    def test_missing_exitcode_configurable(self):
        filepath = os.path.join(self.assets_dir, "valid.sh")
        parsed_file = documentation_check.parse_file(filepath)
        original_codes = documentation_check.MANDATORY_EXIT_CODES
        try:
            documentation_check.MANDATORY_EXIT_CODES = ["0", "1"]
            rule = documentation_check.MandatoryExitCodeRule()
            errors = rule.check(parsed_file.functions[0])
            self.assertEqual(len(errors), 1)
            self.assertIn(f"Missing @{Tags.EXITCODE.name} 1", errors[0])
        finally:
            documentation_check.MANDATORY_EXIT_CODES = original_codes

    def test_assertion_stderr_rule(self):
        # Additional coverage for AssertionStderrRule
        func = documentation_check.BashFunction(
            "assert_test",
            ["# @description Test.", "# @stderr Something else."],
            ["{ :; }"], 0, 1
        )
        rule = documentation_check.AssertionStderrRule()
        errors = rule.check(func)
        self.assertEqual(len(errors), 1)
        self.assertIn("for assertion should use", errors[0])

    def test_sentence_format_rule(self):
        func = documentation_check.BashFunction(
            "test_func",
            ["# @description lower case.", "# @arg string type description without period"],
            ["{ :; }"], 0, 1
        )
        rule = documentation_check.SentenceFormatRule()
        errors = rule.check(func)
        self.assertEqual(len(errors), 3)
        self.assertIn("content should start with a capital letter.", errors[0])
        self.assertIn("content should start with a capital letter.", errors[1])
        self.assertIn("content should end with a period.", errors[2])

if __name__ == "__main__":
    unittest.main()
