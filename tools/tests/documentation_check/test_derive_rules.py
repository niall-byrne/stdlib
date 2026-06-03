"""Tests for derive function rules in documentation_check."""

import os
import sys
import unittest

# Adjust sys.path to find documentation_check
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "../..")))

import documentation_check

class TestDeriveRules(unittest.TestCase):

    def setUp(self):
        self.assets_dir = os.path.abspath(os.path.join(
            os.path.dirname(__file__),
            "../assets/documentation",
        ))

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

        error_patterns = [
            "description should match",
            "description should end with",
            "Missing @stdin tag",
            "Missing stub function",
            "does not match expected target",
        ]

        for pattern in error_patterns:
            self.assertTrue(
                any(pattern in e for e in all_errors),
                f"Pattern '{pattern}' not found in errors",
            )

if __name__ == "__main__":
    unittest.main()
