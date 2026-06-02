import json
import os
import sys
import unittest
from io import StringIO
from unittest.mock import patch

# Add the tools directory to the path so we can import the script
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import documentation_modifier_variable_check


class TestModifierVariableCheck(unittest.TestCase):

    def setUp(self):
        self.assets_dir = os.path.join(
            os.path.dirname(__file__),
            "assets/documentation_modifier_variable_check",
        )

    def test_extract_metadata(self):
        filepath = os.path.join(self.assets_dir, "file1.sh")
        checker = documentation_modifier_variable_check.ModifierVariableConsistencyChecker([])
        metadata_dict = checker._parse_file_for_metadata(filepath)
        metadata = []
        for instances in metadata_dict.values():
            metadata.extend(instances)
        metadata.sort(key=lambda m: (m.function_name, m.name))

        self.assertEqual(len(metadata), 3)

        self.assertEqual(metadata[0].name, "STDLIB_VAR1")
        self.assertEqual(metadata[0].var_type, "string")
        self.assertEqual(metadata[0].modifier, "global")
        self.assertEqual(metadata[0].description, "Description 1 (default=\"val1\").")
        self.assertEqual(metadata[0].function_name, "stdlib.fn1")
        self.assertEqual(metadata[0].tag_type, "description")

        self.assertEqual(metadata[1].name, "STDLIB_VAR2")
        self.assertEqual(metadata[1].function_name, "stdlib.fn1")

        self.assertEqual(metadata[2].name, "STDLIB_VAR1")
        self.assertEqual(metadata[2].function_name, "stdlib.fn2")

    def test_extract_metadata_set(self):
        filepath = os.path.join(self.assets_dir, "file2.sh")
        checker = documentation_modifier_variable_check.ModifierVariableConsistencyChecker([])
        metadata_dict = checker._parse_file_for_metadata(filepath)
        metadata = []
        for instances in metadata_dict.values():
            metadata.extend(instances)
        # VAR1, VAR2, VAR3
        self.assertEqual(len(metadata), 3)

        var3 = [m for m in metadata if m.name == "STDLIB_VAR3"][0]
        self.assertEqual(var3.var_type, "integer")
        self.assertEqual(var3.modifier, None)
        self.assertEqual(var3.description, "The count of items.")
        self.assertEqual(var3.tag_type, "set")

    @patch("sys.exit")
    @patch("sys.stdout", new_callable=StringIO)
    def test_main_consistent(self, mock_stdout, mock_exit):
        filepath = os.path.join(self.assets_dir, "file1.sh")
        with patch("sys.argv", ["documentation_modifier_variable_check.py", filepath]):
            documentation_modifier_variable_check.main()

        # Should not exit with 1
        mock_exit.assert_not_called()
        self.assertEqual(mock_stdout.getvalue(), "")

    @patch("sys.exit")
    @patch("sys.stdout", new_callable=StringIO)
    def test_main_inconsistent_description(self, mock_stdout, mock_exit):
        file1 = os.path.join(self.assets_dir, "file1.sh")
        file2 = os.path.join(self.assets_dir, "file2.sh")
        with patch("sys.argv", ["documentation_modifier_variable_check.py", file1, file2]):
            documentation_modifier_variable_check.main()

        mock_exit.assert_called_with(1)
        output = json.loads(mock_stdout.getvalue())
        self.assertIn(file1, output)
        self.assertIn(file2, output)

        # { filename: [ {variable_name: [ {function_name: [ {tag: output} ] } ] } ] }
        var2_entry = [e for e in output[file1] if "STDLIB_VAR2" in e][0]
        self.assertIn("STDLIB_VAR2", var2_entry)
        details = str(var2_entry["STDLIB_VAR2"])
        self.assertIn("Description 2", details)
        self.assertIn("Inconsistent description", details)

    @patch("sys.exit")
    @patch("sys.stdout", new_callable=StringIO)
    def test_main_inconsistent_set(self, mock_stdout, mock_exit):
        file3 = os.path.join(self.assets_dir, "file3.sh")
        with patch("sys.argv", ["documentation_modifier_variable_check.py", file3]):
            documentation_modifier_variable_check.main()

        mock_exit.assert_called_with(1)
        output = json.loads(mock_stdout.getvalue())
        self.assertIn(file3, output)
        var3_entry = output[file3][0]
        self.assertIn("STDLIB_VAR3", var3_entry)
        details = str(var3_entry["STDLIB_VAR3"])
        self.assertIn("The count of items.", details)
        self.assertIn("Inconsistent @set.", details)

    @patch("sys.exit")
    @patch("sys.stdout", new_callable=StringIO)
    def test_main_inconsistent_mixed(self, mock_stdout, mock_exit):
        file4 = os.path.join(self.assets_dir, "file4.sh")
        with patch("sys.argv", ["documentation_modifier_variable_check.py", file4]):
            documentation_modifier_variable_check.main()

        mock_exit.assert_called_with(1)
        output = json.loads(mock_stdout.getvalue())
        self.assertIn(file4, output)
        var4_entry = output[file4][0]
        self.assertIn("STDLIB_VAR4", var4_entry)


if __name__ == "__main__":
    unittest.main()
