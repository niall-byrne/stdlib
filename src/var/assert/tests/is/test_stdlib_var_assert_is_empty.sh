#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
  _TEST_SET_VAR="exists"
  _TEST_EMPTY_VAR=""
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_______returns_status_code_127;;127" \
    "extra_arg_____returns_status_code_127;_TEST_EMPTY_VAR|extra_arg;127" \
    "invalid_name__returns_status_code_126;not a valid name;126" \
    "not_set_______returns_status_code_126;_NOT_SET_VAR;126" \
    "not_empty_____returns_status_code___1;_TEST_SET_VAR;1" \
    "empty_var_____returns_status_code___0;_TEST_EMPTY_VAR;0"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args_____;;ARGUMENTS_INVALID" \
    "extra_arg___;_TEST_EMPTY_VAR|extra_arg;ARGUMENTS_INVALID" \
    "invalid_name;not a valid name;ARGUMENTS_INVALID" \
    "not_set_____;_NOT_SET_VAR;ARGUMENTS_INVALID" \
    "not_empty___;_TEST_SET_VAR;VAR_VALUE_NOT_EMPTY|_TEST_SET_VAR"
}

# shellcheck disable=SC2153
test_stdlib_var_assert_is_empty__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.var.assert.is_empty "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_var_assert_is_empty__@vary

# shellcheck disable=SC2153
test_stdlib_var_assert_is_empty__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.var.assert.is_empty "${args[@]}"

  stdlib.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_var_assert_is_empty__@vary__logs_an_error

test_stdlib_var_assert_is_empty__is_empty______logs_no_error_message() {
  stdlib.var.assert.is_empty _TEST_EMPTY_VAR

  stdlib.logger.error.mock.assert_not_called
}
