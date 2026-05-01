#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args______________returns_status_code_127;;127" \
    "extra_arg____________returns_status_code_127;AA|extra_arg;127" \
    "empty_string_________returns_status_code_126;|;126" \
    "symbol_______________returns_status_code___1;@#!;1" \
    "mixed________________returns_status_code___1;Aa@33aaB;1" \
    "trailing_underscore__returns_status_code___1;ABCD_1234_;1" \
    "leading_underscore___returns_status_code___1;_ABCD_1234;1" \
    "repeat_underscores___returns_status_code___1;ABCD__1234;1" \
    "lowercase____________returns_status_code___1;abcd_1234;1" \
    "valid________________returns_status_code___0;ABCD_1234;0"
}

@parametrize_with_error_messages() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args____________;;ARGUMENTS_INVALID" \
    "extra_arg__________;1|extra_arg;ARGUMENTS_INVALID" \
    "empty_string_______;|;IS_NOT_SNAKE_CASE_UPPER||" \
    "trailing_underscore;ABCD_1234_;IS_NOT_SNAKE_CASE_UPPER|ABCD_1234_"
}

# shellcheck disable=SC2034
test_stdlib_string_assert_is_snake_case_upper__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.assert.is_snake_case_upper "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_assert_is_snake_case_upper__@vary

test_stdlib_string_assert_is_snake_case_upper__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.string.assert.is_snake_case_upper "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_string_assert_is_snake_case_upper__@vary__logs_an_error
