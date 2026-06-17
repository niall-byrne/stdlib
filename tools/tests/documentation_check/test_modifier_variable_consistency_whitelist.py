"""Tests for modifier variable consistency whitelist in documentation_check."""

import json
import os
import sys
import unittest
from io import StringIO
from typing import Tuple
from unittest.mock import patch

sys.path.append(
    os.path.abspath(os.path.join(os.path.dirname(__file__), "../..")),
)

import documentation_check


class TestWhitelistConsistency(unittest.TestCase):
    """Tests for modifier variable consistency whitelist."""

    def setUp(self) -> None:
        """Set up test assets directory."""
        self.assets_dir = os.path.abspath(
            os.path.join(
                os.path.dirname(__file__),
                "../assets/documentation",
            ),
        )

    def _run_check(self, filepath: str) -> Tuple[int, str]:
        """Run the documentation check main function with mocks."""
        with patch(
            "sys.argv",
            ["documentation_check.py"] + [filepath],
        ):
            with patch("sys.stdout", new=StringIO()) as mock_stdout:
                try:
                    documentation_check.main()
                    return 0, mock_stdout.getvalue()
                except SystemExit as cm:
                    if cm.code is None:
                        exit_code = 0
                    elif isinstance(cm.code, int):
                        exit_code = cm.code
                    else:
                        exit_code = 1
                    return exit_code, mock_stdout.getvalue()

    def test_main__consistent_whitelisted_variable__success(self) -> None:
        filepath = os.path.join(
            self.assets_dir, "modifier_var_whitelist_consistent.sh"
        )

        exit_code, _ = self._run_check(filepath)

        self.assertEqual(exit_code, 0)

    def test_main__malformed_whitelisted_variable__returns_error(self) -> None:
        filepath = os.path.join(
            self.assets_dir, "modifier_var_whitelist_malformed.sh"
        )

        with patch(
            "documentation_check.PATH_SOURCE_DIRECTORY",
            self.assets_dir,
        ):
            exit_code, stdout = self._run_check(filepath)

        self.assertEqual(exit_code, 1)
        output = json.loads(stdout)
        self.assertIn(filepath, output)
        errors = output[filepath]
        self.assertTrue(
            any("Invalid type in @set" in err for err in errors),
        )

    def test_main__malformed_whitelisted_variable__includes_consistency_error(
        self,
    ) -> None:
        """Malformed whitelisted variables should include consistency error."""
        filepath = os.path.join(
            self.assets_dir, "modifier_var_whitelist_malformed.sh"
        )

        with patch(
            "documentation_check.PATH_SOURCE_DIRECTORY",
            self.assets_dir,
        ):
            _, stdout = self._run_check(filepath)

        output = json.loads(stdout)
        errors = output[filepath]
        self.assertTrue(
            any(
                isinstance(err, dict) and "variable_inconsistency" in err
                for err in errors
            ),
        )


if __name__ == "__main__":
    unittest.main()
