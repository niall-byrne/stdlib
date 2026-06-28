#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_args_and_status_codes() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args__________________returns_status_code_127;;127" \
    "extra_arg________________returns_status_code_127;%s|input _string|extra_arg;127" \
    "null_format_string_______returns_status_code_126;|input string|;126" \
    "format_string_and_input__returns_status_code___0;%s|input string;0" \
    "null_input_______________returns_status_code___0;%s||;0"
}

test_stdlib_string_split_map_format__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.split.map.format "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_string_split_map_format__@vary

test_stdlib_string_split_map_format__valid_args_______________default_delimiter________single_line__applies_printf() {
  _capture.output_raw stdlib.string.split.map.format "# %s" "new line"

  assert_output "# new line"$'\n'
}

test_stdlib_string_split_map_format__valid_args_______________default_delimiter________single_hang__applies_printf() {
  _capture.output_raw stdlib.string.split.map.format "# %s" "new line"$'\n'

  assert_output "# new line"$'\n'"# "$'\n'
}

test_stdlib_string_split_map_format__null_args________________default_delimiter________single_line__applies_printf() {
  _capture.output_raw stdlib.string.split.map.format "# %s" ""

  assert_output "# "$'\n'
}

test_stdlib_string_split_map_format__valid_args_______________default_delimiter________multi_line___applies_printf() {
  _capture.output_raw stdlib.string.split.map.format "# %s" "new line"$'\n'"delimited"$'\n'"line"

  assert_output "# new line"$'\n'"# delimited"$'\n'"# line"$'\n'
}

test_stdlib_string_split_map_format__valid_args_______________default_delimiter________multi_hang___applies_printf() {
  _capture.output_raw stdlib.string.split.map.format "# %s" "new line"$'\n'"delimited"$'\n'"line"$'\n'

  assert_output "# new line"$'\n'"# delimited"$'\n'"# line"$'\n'"# "$'\n'
}

test_stdlib_string_split_map_format__valid_args_______________custom__delimiter________single_line__applies_printf() {
  STDLIB_LINE_BREAK_DELIMITER=$'\r\n' _capture.output_raw stdlib.string.split.map.format "# %s" "new line"

  assert_output "# new line"$'\n'
}

test_stdlib_string_split_map_format__valid_args_______________custom__delimiter________single_hang__applies_printf() {
  STDLIB_LINE_BREAK_DELIMITER=$'\r\n' _capture.output_raw stdlib.string.split.map.format "# %s" "new line"$'\r\n'

  assert_output "# new line"$'\r\n'"# "$'\n'
}

test_stdlib_string_split_map_format__valid_args_______________custom__delimiter________multi_line___applies_printf() {
  STDLIB_LINE_BREAK_DELIMITER=$'\r\n' _capture.output_raw stdlib.string.split.map.format "# %s" "windows"$'\r\n'"delimited"$'\r\n'"line"

  assert_output "# windows"$'\r\n'"# delimited"$'\r\n'"# line"$'\n'
}

test_stdlib_string_split_map_format__valid_args_______________custom__delimiter________multi_hang___applies_printf() {
  STDLIB_LINE_BREAK_DELIMITER=$'\r\n' _capture.output_raw stdlib.string.split.map.format "# %s" "windows"$'\r\n'"delimited"$'\r\n'"line"$'\r\n'

  assert_output "# windows"$'\r\n'"# delimited"$'\r\n'"# line"$'\r\n'"# "$'\n'
}

test_stdlib_string_split_map_format__valid_args_______________invalid_placeholder______returns_status_code_125() {
  STDLIB_LINE_BREAK_PLACEHOLDER="||" _capture.rc stdlib.string.split.map.format "# %s" "pipe|delimited|line"

  assert_rc 125
}

test_stdlib_string_split_map_format__valid_args_______________invalid_placeholder______logs_expected_error() {
  STDLIB_LINE_BREAK_PLACEHOLDER="||" _capture.rc stdlib.string.split.map.format "# %s" "pipe|delimited|line"

  stdlib.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get IS_NOT_CHAR "||"))" \
    "1($(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID_DETAIL STDLIB_LINE_BREAK_PLACEHOLDER))"
}
