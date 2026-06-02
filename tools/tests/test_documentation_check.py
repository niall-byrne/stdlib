import json
import os
import sys
import unittest
from io import StringIO
from unittest.mock import patch

# Add the tools directory to the path so we can import the script
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import documentation_check
from documentation_check import Tags


class TestDocumentationCheck(unittest.TestCase):

    def setUp(self):
        self.assets_dir = os.path.join(os.path.dirname(__file__),
                                       "assets/documentation")

    def test_valid_file(self):
        filepath = os.path.join(self.assets_dir, "valid.sh")
        parsed_file = documentation_check.parse_file(filepath)
        self.assertEqual(len(parsed_file.functions), 2)

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
        ]

        errors = []
        for func in parsed_file.functions:
            undocumented_errors = undocumented_rule.check(func)
            if undocumented_errors:
                errors.extend(undocumented_errors)
                continue

            for rule in validation_rules:
                errors.extend(rule.check(func))

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
        self.assertIn(
            f"stdlib.invalid_description_no_modifier_variable_capital: Modifier variable description in "  # noqa: E501
            f"@{Tags.DESCRIPTION.name} "
            f"should start with a capital letter. "
            f"Found: '#   * INVALID_MODIFIER_VARIABLE string global: this variable is not formatted correctly (default=1).'",  # noqa: E501
            errors[0],
        )
        self.assertIn(
            f"stdlib.invalid_description_no_modifier_variable_period: Modifier variable description in "  # noqa: E501
            f"@{Tags.DESCRIPTION.name} "
            f"should end with a period. "
            f"Found: '#   * INVALID_MODIFIER_VARIABLE string global: This variable is not formatted correctly (default=1)'",  # noqa: E501
            errors[1],
        )
        self.assertIn(
            f"stdlib.invalid_description_no_modifier_variable_default: Modifier variable description in "  # noqa: E501
            f"@{Tags.DESCRIPTION.name} "
            f"should detail a default value. "
            f"Found: '#   * INVALID_MODIFIER_VARIABLE string global: This variable is not formatted correctly.'",  # noqa: E501
            errors[2],
        )

    def test_invalid_description_modifier_variable_indent(self):
        filepath = os.path.join(self.assets_dir, "invalid_description.sh")
        parsed_file = documentation_check.parse_file(filepath)
        rule = documentation_check.ModifierVariableIndentRule()
        errors = []
        for func in parsed_file.functions:
            errors.extend(rule.check(func))
        self.assertEqual(len(errors), 3)
        self.assertIn(
            f"stdlib.invalid_description_no_modifier_variable_list: Modifier variable in @{Tags.DESCRIPTION.name} "  # noqa: E501
            f"should be in 2 space indented asterisk list format. "
            f"Found: '#     INVALID_MODIFIER_VARIABLE: This variable is not formatted correctly.'",  # noqa: E501
            errors,
        )
        self.assertIn(
            f"stdlib.invalid_description_no_modifier_variable_colon: Modifier variable in @{Tags.DESCRIPTION.name} "  # noqa: E501
            f"should be in uppercase characters, followed by a variable type, a modifier type, and a colon. "  # noqa: E501
            f"Found: '#   * INVALID_MODIFIER_VARIABLE This variable is not formatted correctly.'",  # noqa: E501
            errors,
        )

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

        # Test standard exit codes rule
        rule_std = documentation_check.StandardExitCodesRule()
        errors_std = rule_std.check(parsed_file.functions[0])
        self.assertEqual(len(errors_std), 5)
        self.assertIn(f"Non-standard @{Tags.EXITCODE.name} 123", errors_std[0])
        self.assertIn(f"Non-standard @{Tags.EXITCODE.name} 124", errors_std[1])
        self.assertIn(f"Non-standard @{Tags.EXITCODE.name} 125", errors_std[2])
        self.assertIn(f"Non-standard @{Tags.EXITCODE.name} 126", errors_std[3])
        self.assertIn(f"Non-standard @{Tags.EXITCODE.name} 127", errors_std[4])

    def test_exitcode_description(self):
        filepath = os.path.join(self.assets_dir, "non_standard_exitcodes.sh")
        parsed_file = documentation_check.parse_file(filepath)

        rule_if = documentation_check.ExitCodeDescriptionRule()
        errors_if = rule_if.check(parsed_file.functions[0])
        # exitcode 123, 124, 125, 126 and 127 in assets don't start with "If"
        # exitcode 0 does.
        self.assertEqual(len(errors_if), 5)
        self.assertIn(
            f"@{Tags.EXITCODE.name} description should start with 'If'",
            errors_if[0])
        self.assertIn(
            f"@{Tags.EXITCODE.name} description should start with 'If'",
            errors_if[1])

    def test_modifier_variable_validation(self):
        filepath = os.path.join(self.assets_dir, "modifier_var_validation.sh")
        parsed_file = documentation_check.parse_file(filepath)
        rule = documentation_check.ModifierVariableValidationRule()

        # stdlib.no_modifier_vars
        self.assertEqual(len(rule.check(parsed_file.functions[0])), 0)

        # stdlib.validated_modifier_var
        self.assertEqual(len(rule.check(parsed_file.functions[1])), 0)

        # stdlib.manually_validated_modifier_var
        self.assertEqual(len(rule.check(parsed_file.functions[2])), 0)

        # stdlib.manually_validated_modifier_var_multiple
        self.assertEqual(len(rule.check(parsed_file.functions[3])), 0)

        # stdlib.unvalidated_modifier_var
        errors = rule.check(parsed_file.functions[4])
        self.assertEqual(len(errors), 1)
        self.assertIn("Modifier Variable 'STDLIB_UNVALIDATED_VAR'", errors[0])

        # stdlib.multiple_modifier_vars
        errors = rule.check(parsed_file.functions[5])
        self.assertEqual(len(errors), 1)
        self.assertIn("STDLIB_INVALID_VAR", errors[0])

        # stdlib.dynamic_validated_modifier_var
        self.assertEqual(len(rule.check(parsed_file.functions[6])), 0)

        # stdlib.dynamic_unvalidated_modifier_var
        errors = rule.check(parsed_file.functions[7])
        self.assertEqual(len(errors), 1)
        self.assertIn("__${2}_mock_rc", errors[0])

        # stdlib.commented_validation
        errors = rule.check(parsed_file.functions[8])
        self.assertEqual(len(errors), 1)
        self.assertIn("STDLIB_COMMENTED_VAR", errors[0])

        # stdlib.prefix_match_validation
        errors = rule.check(parsed_file.functions[9])
        self.assertEqual(len(errors), 1)
        self.assertIn("STDLIB_PREFIX_VAR", errors[0])

        # stdlib.__internal_unvalidated_var
        errors = rule.check(parsed_file.functions[10])
        self.assertEqual(len(errors), 1)
        self.assertIn("STDLIB_INTERNAL_UNVALIDATED_VAR", errors[0])

        # stdlib.already_clean
        self.assertEqual(len(rule.check(parsed_file.functions[11])), 0)

    def test_modifier_variable_modifier_usage(self):
        filepath = os.path.join(self.assets_dir, "modifier_variable_usage.sh")
        parsed_file = documentation_check.parse_file(filepath)
        rule = documentation_check.ModifierVariableUsageRule()

        # stdlib.documented_modifier_var
        self.assertEqual(len(rule.check(parsed_file.functions[0])), 0)

        # stdlib.undocumented_modifier_var
        errors = rule.check(parsed_file.functions[1])
        self.assertEqual(len(errors), 1)
        self.assertIn("STDLIB_THEME_LOGGER_ERROR", errors[0])

        # stdlib.local_var_usage
        self.assertEqual(len(rule.check(parsed_file.functions[2])), 0)

        # stdlib.documented_via_set
        self.assertEqual(len(rule.check(parsed_file.functions[3])), 0)

        # stdlib.__undocumented_internal_var
        errors = rule.check(parsed_file.functions[4])
        self.assertEqual(len(errors), 1)
        self.assertIn("__STDLIB_LOGGING_DECORATORS_ARRAY", errors[0])

        # stdlib.__documented_internal_var
        self.assertEqual(len(rule.check(parsed_file.functions[5])), 0)

        # stdlib.binary_var_usage
        errors = rule.check(parsed_file.functions[6])
        self.assertEqual(len(errors), 0)

        # stdlib.noqa_usage
        self.assertEqual(len(rule.check(parsed_file.functions[7])), 0)

        # stdlib.var_name_as_arg
        errors = rule.check(parsed_file.functions[8])
        self.assertEqual(len(errors), 1)
        self.assertIn("STDLIB_THEME_LOGGER_ERROR", errors[0])

        # ${1}.mock.documented
        self.assertEqual(len(rule.check(parsed_file.functions[9])), 0)

        # ${1}.mock.undocumented
        errors = rule.check(parsed_file.functions[10])
        self.assertEqual(len(errors), 1)
        self.assertIn("__${2}_mock_rc", errors[0])

        # stdlib.inline_assignment_usage
        errors = rule.check(parsed_file.functions[11])

        # STDLIB_KW_SOURCE_VAR should NOT be in errors
        self.assertFalse(any("STDLIB_KW_SOURCE_VAR" in e for e in errors))

        # STDLIB_LOCK_PERMISSION_OCTAL SHOULD be in errors (used as an arg)
        self.assertTrue(
            any("STDLIB_LOCK_PERMISSION_OCTAL" in e for e in errors))

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

        # Override MANDATORY_EXIT_CODES
        original_codes = documentation_check.MANDATORY_EXIT_CODES
        try:
            documentation_check.MANDATORY_EXIT_CODES = ["0", "1"]
            rule = documentation_check.MandatoryExitCodeRule()
            errors = rule.check(parsed_file.functions[0])
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
        parsed_file = documentation_check.parse_file(filepath)

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
        for func in parsed_file.functions:
            for rule in rules:
                errors.extend(rule.check(func))

        for call in parsed_file.derive_calls:
            for rule in derive_rules:
                errors.extend(rule.check(call))

        self.assertEqual(errors, [])

    def test_derive_invalid(self):
        filepath = os.path.join(self.assets_dir, "derive_invalid.sh")
        parsed_file = documentation_check.parse_file(filepath)

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
        for func in parsed_file.functions:
            for rule in rules:
                all_errors.extend(rule.check(func))

        for call in parsed_file.derive_calls:
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
            "does not match expected target",
            # Naming error for left_pipe_no_stdin
        ]

        for pattern in error_patterns:
            self.assertTrue(
                any(pattern in e for e in all_errors),
                f"Pattern '{pattern}' not found in errors",
            )

    def test_invalid_set_tag_format(self):
        filepath = os.path.join(self.assets_dir, "modifier_variable_usage.sh")
        # Temporary modify file content for test
        with open(filepath, "r") as f:
            orig_content = f.read()

        try:
            with open(filepath, "w") as f:
                f.write("# @description Test.\n"
                        "# @set VAR invalid_type Description.\n"
                        "stdlib.test() { :; }")

            parsed_file = documentation_check.parse_file(filepath)
            rule = documentation_check.TypeValidationRule()
            errors = rule.check(parsed_file.functions[0])
            self.assertEqual(len(errors), 1)
            self.assertIn("Invalid type in @set", errors[0])
        finally:
            with open(filepath, "w") as f:
                f.write(orig_content)

    def test_modifier_variable_rules__reserved_modifier__no_errors(self):
        """Test that the 'reserved' modifier type is recognized without errors."""
        filepath = os.path.join(self.assets_dir, "reserved_modifier.sh")
        parsed_file = documentation_check.parse_file(filepath)
        func = parsed_file.functions[0]
        rules = [
            documentation_check.ModifierVariableFormatRule(),
            documentation_check.ModifierVariableIndentRule(),
            documentation_check.ModifierVariableValidationRule(),
        ]

        errors = []
        for rule in rules:
            errors.extend(rule.check(func))

        self.assertEqual(errors, [])


if __name__ == "__main__":
    unittest.main()
