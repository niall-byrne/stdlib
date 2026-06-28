#!/bin/bash

test_stdlib_string_split_map_format_pipe__default_delimiter__single_line__applies_printf() {
  TEST_OUTPUT="$(echo "new line" | stdlib.string.split.map.format_pipe "# %s")"

  assert_equals "${TEST_OUTPUT}" "# new line"
}
