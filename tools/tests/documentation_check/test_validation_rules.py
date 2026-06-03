"""Tests for per-file validation rules in documentation_check."""

import os
import sys
import unittest

# Adjust sys.path to find documentation_check
sys.path.append(
    os.path.abspath(os.path.join(os.path.dirname(__file__), "../..")))

import documentation_check
from documentation_check import Tags


class TestValidationRules(unittest.TestCase):

    def setUp(self):
        self.assets_dir = os.path.abspath(
            os.path.join(
                os.path.dirname(__file__),
                "../assets/documentation",
            ))

    def _get_errors_for_file(self, filename, rules, func_index=None):
        filepath = os.path.join(self.assets_dir, filename)
        parsed_file = documentation_check.parse_file(filepath)

        errors = []
        functions = [parsed_file.functions[func_index]
                     ] if func_index is not None else parsed_file.functions

        for func in functions:
            for rule in rules:
                errors.extend(rule.check(func))
        return errors

    def test_valid_file(self):
        filename = "valid.sh"
        rules = [
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

        errors = self._get_errors_for_file(filename, rules)
        errors = [
            e for e in errors
            if "marked as defaulted, validated or clean" not in e
        ]

        self.assertEqual(errors, [])

    def test_undocumented_file(self):
        filename = "undocumented.sh"
        rule = documentation_check.UndocumentedRule()

        errors = self._get_errors_for_file(filename, [rule], func_index=0)

        self.assertIn("Completely undocumented.", errors[0])

    def test_missing_description(self):
        filename = "missing_description.sh"
        rule = documentation_check.MandatoryTagRule()

        errors = self._get_errors_for_file(filename, [rule], func_index=0)

        self.assertIn(f"Missing @{Tags.DESCRIPTION.name}", errors[0])

    def test_missing_description_mock_component(self):
        filename = "invalid_description_mock_component.sh"
        rule = documentation_check.MandatoryTagRule()

        errors = self._get_errors_for_file(filename, [rule], func_index=0)

        self.assertIn(f"Missing @{Tags.DESCRIPTION.name}", errors[0])

    def test_invalid_description_modifier_variable_format(self):
        filename = "invalid_description.sh"
        rule = documentation_check.ModifierVariableFormatRule()

        errors = self._get_errors_for_file(filename, [rule])

        self.assertEqual(len(errors), 3)
        self.assertIn("should start with a capital letter.", errors[0])
        self.assertIn("should end with a period.", errors[1])
        self.assertIn("should detail a default value.", errors[2])

    def test_invalid_description_modifier_variable_indent(self):
        filename = "invalid_description.sh"
        rule = documentation_check.ModifierVariableIndentRule()

        errors = self._get_errors_for_file(filename, [rule])

        self.assertEqual(len(errors), 3)
        self.assertIn("should be in 2 space indented asterisk list format.",
                      errors[0])
        self.assertIn("should be in uppercase characters", errors[2])

    def test_exitcode_sort_rule(self):
        func = documentation_check.BashFunction("test_func", [
            "# @description Test.",
            "# @exitcode 1 If error.",
            "# @exitcode 0 If success.",
        ], ["{ :; }"], 0, 1)
        rule = documentation_check.ExitCodeSortRule()

        errors = rule.check(func)

        self.assertEqual(len(errors), 1)
        self.assertIn("tags should be sorted numerically.", errors[0])

    def test_incorrect_order(self):
        filename = "incorrect_order.sh"
        rule = documentation_check.FieldOrderRule()

        errors = self._get_errors_for_file(filename, [rule], func_index=0)

        self.assertIn("Incorrect field order.", errors[0])

    def test_incorrect_order_interleaving(self):
        func = documentation_check.BashFunction("test_func", [
            "# @description Test.",
            "# @set VAR_A string Description A.",
            "# @exitcode 0 If success.",
            "# @set VAR_B string Description B.",
        ], ["{ :; }"], 0, 1)
        rule = documentation_check.FieldOrderRule()

        errors = rule.check(func)

        self.assertEqual(len(errors), 1)
        self.assertIn("Incorrect field order.", errors[0])

    def test_invalid_type(self):
        filename = "invalid_type.sh"
        rule = documentation_check.TypeValidationRule()

        errors = self._get_errors_for_file(filename, [rule], func_index=0)

        self.assertIn(f"Missing or invalid type in @{Tags.ARG.name}.",
                      errors[0])

    def test_non_standard_exitcodes(self):
        filename = "non_standard_exitcodes.sh"
        rule = documentation_check.StandardExitCodesRule()

        errors = self._get_errors_for_file(filename, [rule], func_index=0)

        self.assertEqual(len(errors), 5)
        for code in ["123", "124", "125", "126", "127"]:
            self.assertTrue(
                any(f"Non-standard @{Tags.EXITCODE.name} {code}" in e
                    for e in errors))

    def test_exitcode_description(self):
        filename = "non_standard_exitcodes.sh"
        rule = documentation_check.ExitCodeDescriptionRule()

        errors = self._get_errors_for_file(filename, [rule], func_index=0)

        self.assertEqual(len(errors), 5)
        self.assertIn(
            f"@{Tags.EXITCODE.name} description should start with 'If'",
            errors[0])

    def test_modifier_variable_sort_rule(self):
        func = documentation_check.BashFunction("test_func", [
            "# @description Test.",
            '#   * VAR_B string global: Description B. (default="b")',
            '#   * VAR_A string global: Description A. (default="a")',
        ], ["{ :; }"], 0, 1)
        rule = documentation_check.ModifierVariableSortRule()

        errors = rule.check(func)

        self.assertEqual(len(errors), 1)
        self.assertIn("Modifier variables should be sorted alphabetically.",
                      errors[0])

    def test_modifier_variable_validation(self):
        filename = "modifier_var_validation.sh"
        rule = documentation_check.ModifierVariableValidationRule()

        err0 = self._get_errors_for_file(filename, [rule], func_index=0)
        err1 = self._get_errors_for_file(filename, [rule], func_index=1)
        err2 = self._get_errors_for_file(filename, [rule], func_index=2)
        err3 = self._get_errors_for_file(filename, [rule], func_index=3)
        err4 = self._get_errors_for_file(filename, [rule], func_index=4)
        err5 = self._get_errors_for_file(filename, [rule], func_index=5)

        self.assertEqual(len(err0), 0)
        self.assertEqual(len(err1), 0)
        self.assertEqual(len(err2), 0)
        self.assertEqual(len(err3), 0)
        self.assertEqual(len(err4), 1)
        self.assertIn("STDLIB_UNVALIDATED_VAR", err4[0])
        self.assertEqual(len(err5), 1)
        self.assertIn("STDLIB_INVALID_VAR", err5[0])

    def test_modifier_variable_modifier_usage(self):
        filename = "modifier_variable_usage.sh"
        rule = documentation_check.ModifierVariableUsageRule()

        err0 = self._get_errors_for_file(filename, [rule], func_index=0)
        err1 = self._get_errors_for_file(filename, [rule], func_index=1)

        self.assertEqual(len(err0), 0)
        self.assertEqual(len(err1), 1)
        self.assertIn("STDLIB_THEME_LOGGER_ERROR", err1[0])

    def test_missing_outputs(self):
        filename = "missing_outputs.sh"
        rule = documentation_check.MissingOutputTagsRule()

        errors = self._get_errors_for_file(filename, [rule], func_index=0)

        self.assertEqual(len(errors), 2)
        self.assertIn(f"Missing @{Tags.STDERR.name} tag", errors[0])
        self.assertIn(f"Missing @{Tags.STDOUT.name} tag", errors[1])

    def test_missing_exitcode_configurable(self):
        filename = "valid.sh"
        rule = documentation_check.MandatoryExitCodeRule()
        original_codes = documentation_check.MANDATORY_EXIT_CODES
        documentation_check.MANDATORY_EXIT_CODES = ["0", "1"]

        try:
            errors = self._get_errors_for_file(filename, [rule], func_index=0)
        finally:
            documentation_check.MANDATORY_EXIT_CODES = original_codes

        self.assertEqual(len(errors), 1)
        self.assertIn(f"Missing @{Tags.EXITCODE.name} 1", errors[0])

    def test_assertion_stderr_rule(self):
        func = documentation_check.BashFunction(
            "assert_test",
            ["# @description Test.", "# @stderr Something else."], ["{ :; }"],
            0, 1)
        rule = documentation_check.AssertionStderrRule()

        errors = rule.check(func)

        self.assertEqual(len(errors), 1)
        self.assertIn("for assertion should use", errors[0])

    def test_sentence_format_rule(self):
        func = documentation_check.BashFunction("test_func", [
            "# @description lower case.",
            "# @arg string type description without period"
        ], ["{ :; }"], 0, 1)
        rule = documentation_check.SentenceFormatRule()

        errors = rule.check(func)

        self.assertEqual(len(errors), 3)
        self.assertIn("content should start with a capital letter.", errors[0])
        self.assertIn("content should start with a capital letter.", errors[1])
        self.assertIn("content should end with a period.", errors[2])

    def test_set_tag_sort_rule(self):
        func = documentation_check.BashFunction("test_func", [
            "# @description Test.",
            "# @set VAR_B string Description B.",
            "# @set VAR_A string Description A.",
        ], ["{ :; }"], 0, 1)
        rule = documentation_check.SetTagSortRule()

        errors = rule.check(func)

        self.assertEqual(len(errors), 1)
        self.assertIn("tags should be sorted alphabetically by variable name.",
                      errors[0])


if __name__ == "__main__":
    unittest.main()
