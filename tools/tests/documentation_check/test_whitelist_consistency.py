"""Tests for modifier variable consistency whitelist in documentation_check."""

import json
import os
import sys
import unittest
from io import StringIO
from typing import List, Tuple
from unittest.mock import patch

sys.path.append(
    os.path.abspath(os.path.join(os.path.dirname(__file__), "../..")),
)

import documentation_check  # type: ignore


class TestWhitelistConsistency(unittest.TestCase):
    """Tests for modifier variable consistency whitelist."""

    def setUp(self) -> None:
        """Set up test assets directory."""
        self.assets_dir = os.path.abspath(
            os.path.join(
                os.path.dirname(__file__),
                "../assets/documentation_check/whitelist",
            ),
        )

    def _run_check(self, source_dir: str, files: List[str]) -> Tuple[int, str]:
        """Run the documentation check main function with mocks."""
        with patch("documentation_check.PATH_SOURCE_DIRECTORY", source_dir):
            with patch("sys.argv", ["documentation_check.py"] + files):
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
        """Whitelisted variables should allow different descriptions."""
        consistent_dir = os.path.join(self.assets_dir, "consistent")
        file1 = os.path.join(consistent_dir, "whitelist_file1.sh")
        file2 = os.path.join(consistent_dir, "whitelist_file2.sh")

        exit_code, _ = self._run_check(consistent_dir, [file1, file2])

        self.assertEqual(exit_code, 0)

    def test_main__malformed_whitelisted_variable__returns_error(self) -> None:
        """Malformed whitelisted variables should still trigger errors."""
        malformed_dir = os.path.join(self.assets_dir, "malformed")
        filepath = os.path.join(malformed_dir, "whitelist_malformed.sh")

        exit_code, stdout = self._run_check(malformed_dir, [filepath])

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
        malformed_dir = os.path.join(self.assets_dir, "malformed")
        filepath = os.path.join(malformed_dir, "whitelist_malformed.sh")

        _, stdout = self._run_check(malformed_dir, [filepath])

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
