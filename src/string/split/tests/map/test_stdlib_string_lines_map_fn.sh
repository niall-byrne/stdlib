#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/string/split/tests/map/__fixtures__/map_fn.sh"

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_args_and_status_codes() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_______________returns_status_code_127;;127" \
    "extra_arg_____________returns_status_code_127;_uppercase|input string|extra_arg;127" \
    "null_fn_______________returns_status_code_126;|input string;126" \
    "invalid_fn_and_input__returns_status_code_126;_invalid_fn_name|input string;126" \
    "null_input____________returns_status_code___0;_uppercase||;0" \
    "valid_fn_and_input____returns_status_code___0;_uppercase|input string;0"
}

test_stdlib_string_split_map_fn__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.split.map.fn "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_string_split_map_fn__@vary

test_stdlib_string_split_map_fn__valid_args____________default_delimiter________single_line__applies_fn() {
  _capture.output_raw stdlib.string.split.map.fn _uppercase "new line"

  assert_output "UPPERCASE: NEW LINE"$'\n'
}

test_stdlib_string_split_map_fn__valid_args____________default_delimiter________single_hang__applies_fn() {
  _capture.output_raw stdlib.string.split.map.fn _uppercase "new line"$'\n'

  assert_output "UPPERCASE: NEW LINE"$'\n'"UPPERCASE: "$'\n'
}

test_stdlib_string_split_map_fn__null_input____________default_delimiter________single_line__applies_fn() {
  _capture.output_raw stdlib.string.split.map.fn _uppercase ""

  assert_output "UPPERCASE: "$'\n'
}

test_stdlib_string_split_map_fn__valid_args____________default_delimiter________multi_line___applies_fn() {
  _capture.output_raw stdlib.string.split.map.fn _uppercase "new line"$'\n'"delimited"$'\n'"line"

  assert_output "UPPERCASE: NEW LINE"$'\n'"UPPERCASE: DELIMITED"$'\n'"UPPERCASE: LINE"$'\n'
}

test_stdlib_string_split_map_fn__valid_args____________default_delimiter________multi_hang___applies_fn() {
  _capture.output_raw stdlib.string.split.map.fn _uppercase "new line"$'\n'"delimited"$'\n'"line"$'\n'

  assert_output "UPPERCASE: NEW LINE"$'\n'"UPPERCASE: DELIMITED"$'\n'"UPPERCASE: LINE"$'\n'"UPPERCASE: "$'\n'
}

test_stdlib_string_split_map_fn__valid_args____________custom__delimiter________single_line__applies_fn() {
  STDLIB_FIELD_DELIMITER=$'\r\n' _capture.output_raw stdlib.string.split.map.fn _uppercase "new line"

  assert_output "UPPERCASE: NEW LINE"$'\n'
}

test_stdlib_string_split_map_fn__valid_args____________custom__delimiter________single_hang__applies_fn() {
  STDLIB_FIELD_DELIMITER=$'\r\n' _capture.output_raw stdlib.string.split.map.fn _uppercase "new line"$'\r\n'

  assert_output "UPPERCASE: NEW LINE"$'\r\n'"UPPERCASE: "$'\n'
}

test_stdlib_string_split_map_fn__valid_args____________custom__delimiter________multi_line___applies_fn() {
  STDLIB_FIELD_DELIMITER=$'\r\n' _capture.output_raw stdlib.string.split.map.fn _uppercase "windows"$'\r\n'"delimited"$'\r\n'"line"

  assert_output "UPPERCASE: WINDOWS"$'\r\n'"UPPERCASE: DELIMITED"$'\r\n'"UPPERCASE: LINE"$'\n'
}

test_stdlib_string_split_map_fn__valid_args____________custom__delimiter________multi_hang__applies_fn() {
  STDLIB_FIELD_DELIMITER=$'\r\n' _capture.output_raw stdlib.string.split.map.fn _uppercase "windows"$'\r\n'"delimited"$'\r\n'"line"$'\r\n'

  assert_output "UPPERCASE: WINDOWS"$'\r\n'"UPPERCASE: DELIMITED"$'\r\n'"UPPERCASE: LINE"$'\r\n'"UPPERCASE: "$'\n'
}

test_stdlib_string_split_map_fn__valid_args____________invalid_placeholder______returns_status_code_125() {
  STDLIB_FIELD_DELIMITER_ENCODE_CHAR="||" _capture.rc stdlib.string.split.map.fn _uppercase "new line"

  assert_rc 125
}

test_stdlib_string_split_map_fn__valid_args____________invalid_placeholder______logs_expected_error() {
  STDLIB_FIELD_DELIMITER_ENCODE_CHAR="||" _capture.rc stdlib.string.split.map.fn _uppercase "new line"

  stdlib.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get IS_NOT_CHAR "||"))" \
    "1($(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID_DETAIL STDLIB_FIELD_DELIMITER_ENCODE_CHAR))"
}
