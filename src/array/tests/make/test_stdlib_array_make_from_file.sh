#!/bin/bash

# shellcheck disable=SC2034
setup() {
  NON_EXISTENT_FILE="non_existent.txt"
  ARRAY_NAME="array_name"
  EXPECTED_ARRAY=("field1" "field2" "field3"$'\n')

  _mock.create stdlib.logger.error
}

@parametrize_with_return_codes() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS;TEST_EXPECTED_RC" \
    "no_args____________;;127" \
    "extra_arg__________;ARRAY_NAME|#|NON_EXISTENT_FILE|extra_arg;127" \
    "null_array_name____;|#|NON_EXISTENT_FILE;126" \
    "null_separator_____;ARRAY_NAME||NON_EXISTENT_FILE;126" \
    "invalid_array_name_;INVALID!NAME|#|NON_EXISTENT_FILE;126" \
    "null_file_name_____;ARRAY_NAME|#||;126" \
    "file_does_not_exist;ARRAY_NAME|#|NON_EXISTENT_FILE;126" \
    "file_exists________;ARRAY_NAME|#|__fixtures__/array_as_file.txt;0"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS;TEST_MESSAGE_DEFINITIONS" \
    "no_args____________;;ARGUMENT_REQUIREMENTS_VIOLATION|3|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|0" \
    "extra_arg__________;ARRAY_NAME|#|NON_EXISTENT_FILE|extra_arg;ARGUMENT_REQUIREMENTS_VIOLATION|3|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|4" \
    "null_array_name____;|#|NON_EXISTENT_FILE;ARGUMENT_REQUIREMENTS_VIOLATION|3|0 ARGUMENT_REQUIREMENTS_VIOLATION_NULL|1" \
    "null_separator_____;ARRAY_NAME||NON_EXISTENT_FILE;ARGUMENT_REQUIREMENTS_VIOLATION|3|0 ARGUMENT_REQUIREMENTS_VIOLATION_NULL|2" \
    "null_file_name_____;ARRAY_NAME|#||;ARGUMENT_REQUIREMENTS_VIOLATION|3|0 ARGUMENT_REQUIREMENTS_VIOLATION_NULL|3" \
    "invalid_array_name_;INVALID!NAME|#|NON_EXISTENT_FILE;VAR_NAME_INVALID|INVALID!NAME" \
    "file_does_not_exist;ARRAY_NAME|#|NON_EXISTENT_FILE;FS_PATH_IS_NOT_A_FILE|NON_EXISTENT_FILE"
}

@parametrize_with_success_outputs() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS" \
    "file_exists________;array_name_1|#|__fixtures__/array_as_file.txt"
}

test_stdlib_array_make_from_file__@vary__returns_expected_status_code() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS}"

  _capture.rc stdlib.array.make.from_file "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_return_codes \
  test_stdlib_array_make_from_file__@vary__returns_expected_status_code

test_stdlib_array_make_from_file__invalid_keyword______returns_status_code_125() {
  STDLIB_FIELD_DELIMITER_ENCODE_CHAR="##" \
    _capture.rc stdlib.array.make.from_file \
    "array_name_1" \
    "|" \
    "__fixtures__/array_as_file.txt"

  assert_rc "125"
}

test_stdlib_array_make_from_file__invalid_keyword______generates_expected_logging_message() {
  STDLIB_FIELD_DELIMITER_ENCODE_CHAR="##" \
    stdlib.array.make.from_file \
    "array_name" \
    "|" \
    "__fixtures__/array_as_file.txt"

  stdlib.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get IS_NOT_CHAR "##"))" \
    "1($(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID_DETAIL STDLIB_FIELD_DELIMITER_ENCODE_CHAR))"
}

test_stdlib_array_make_from_file__@vary__logs_error() {
  local args=()
  local expected_log_messages=()
  local message_arg_definition
  local message_arg_definitions=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS}"
  stdlib.array.make.from_string message_arg_definitions " " "${TEST_MESSAGE_DEFINITIONS}"
  for message_arg_definition in "${message_arg_definitions[@]}"; do
    stdlib.array.make.from_string message_args "|" "${message_arg_definition}"
    expected_log_messages+=("1($(stdlib.__message.get "${message_args[@]}"))")
  done

  _capture.rc stdlib.array.make.from_file "${args[@]}" > /dev/null

  stdlib.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_error_messages \
  test_stdlib_array_make_from_file__@vary__logs_error

test_stdlib_array_make_from_file__@vary__creates_array() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS}"

  stdlib.array.make.from_file "${args[@]}"

  assert_array_equals EXPECTED_ARRAY "${args[0]}"
}

@parametrize_with_success_outputs \
  test_stdlib_array_make_from_file__@vary__creates_array

test_stdlib_array_make_from_file__@vary__stops_keyword_propagation() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS}"
  _mock.create stdlib.fn.keyword.consume
  # shellcheck disable=SC2016
  stdlib.fn.keyword.consume.mock.set.subcommand 'printf -v "$1" "%s" "${!2}"'

  stdlib.array.make.from_file "${args[@]}"

  stdlib.fn.keyword.consume.mock.assert_called_once_with \
    "1(placeholder) 2(STDLIB_FIELD_DELIMITER_ENCODE_CHAR) 3("$'\x1e'")"
}

@parametrize_with_success_outputs \
  test_stdlib_array_make_from_file__@vary__stops_keyword_propagation
