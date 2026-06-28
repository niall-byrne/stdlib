#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args______________returns_status_code_127;;127" \
    "extra_arg____________returns_status_code_127;ARRAY1|#|input_string|extra_arg;127" \
    "null_array_name______returns_status_code_126;|#|input string;126" \
    "null_separator_______returns_status_code_126;test||input string;126" \
    "invalid_array_name___returns_status_code_126;INVALID!NAME|#|input string;126" \
    "null_source_string___returns_status_code___0;test|#||;0"
}

test_stdlib_array_make_from_string__@vary() {
  local args=()

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.make.from_string "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_array_make_from_string__@vary

test_stdlib_array_make_from_string__invalid_keyword______returns_status_code_125() {
  STDLIB_FIELD_DELIMITER_ENCODE_CHAR="##" \
    _capture.rc stdlib.array.make.from_string \
    "array_name" \
    "|" \
    "field1|field2|field3"

  assert_rc "125"
}

test_stdlib_array_make_from_string__invalid_keyword______generates_expected_logging_message() {
  STDLIB_FIELD_DELIMITER_ENCODE_CHAR="##" \
    stdlib.array.make.from_string \
    "array_name" \
    "|" \
    "field1|field2|field3"

  stdlib.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get IS_NOT_CHAR "##"))" \
    "1($(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID_DETAIL STDLIB_FIELD_DELIMITER_ENCODE_CHAR))"
}

test_stdlib_array_make_from_string__valid_arguments______stops_keyword_propagation() {
  _mock.create stdlib.fn.keyword.consume
  # shellcheck disable=SC2016
  stdlib.fn.keyword.consume.mock.set.subcommand 'printf -v "$1" "%s" "${!2}"'

  stdlib.array.make.from_string \
    "array_name" \
    "|" \
    "field1|field2|field3"

  stdlib.fn.keyword.consume.mock.assert_called_once_with \
    "1(placeholder) 2(STDLIB_FIELD_DELIMITER_ENCODE_CHAR) 3("$'\x1e'")"
}

test_stdlib_array_make_from_string__valid_arguments______returns_status_code___0() {
  _capture.rc stdlib.array.make.from_string \
    "array_name" \
    "|" \
    "field1|field2|field3"

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_array_make_from_string__valid_arguments______creates_new_array() {
  local expected_array=("field1" "field2" "field3")

  _capture.rc stdlib.array.make.from_string \
    "array_name" \
    "||" \
    "field1||field2||field3"

  assert_array_equals expected_array array_name
}

# shellcheck disable=SC2034
test_stdlib_array_make_from_string__null_source_string___creates_empty_array() {
  local expected_array=()

  _capture.rc stdlib.array.make.from_string \
    "array_name" \
    "|" \
    ""

  assert_is_array array_name
  assert_array_equals expected_array array_name
}

# shellcheck disable=SC2034
test_stdlib_array_make_from_string__string_with_newline__creates_new_array() {
  local expected_array=("string with"$'\n'"newline" "and other stuff")

  stdlib.array.make.from_string \
    "array_name" \
    "|" \
    "string with"$'\n'"newline|and other stuff"

  assert_array_equals expected_array array_name
}

# shellcheck disable=SC2034
test_stdlib_array_make_from_string__string_with_newline__returns_status_code___0() {
  _capture.rc stdlib.array.make.from_string \
    "array_name" \
    "|" \
    "string with"$'\n'"newline|and other stuff"

  assert_rc "0"
}
