#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
  _TEST_SET_VAR="exists"
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args__________returns_status_code_127;;127" \
    "extra_arg________returns_status_code_127;_TEST_SET_VAR|extra_arg;127" \
    "invalid_name_____returns_status_code_126;not a valid name;126" \
    "not_set__________returns_status_code___1;_NOT_SET_VAR;1" \
    "is_set___________returns_status_code___0;_TEST_SET_VAR;0"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args_________;;ARGUMENTS_INVALID" \
    "extra_arg_______;_TEST_SET_VAR|extra_arg;ARGUMENTS_INVALID" \
    "invalid_name____;not a valid name;ARGUMENTS_INVALID" \
    "not_set_________;_NOT_SET_VAR;VAR_NOT_SET|_NOT_SET_VAR"
}

# shellcheck disable=SC2153
test_stdlib_var_assert_is_set__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.var.assert.is_set "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_var_assert_is_set__@vary

# shellcheck disable=SC2153
test_stdlib_var_assert_is_set__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.var.assert.is_set "${args[@]}"

  stdlib.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_var_assert_is_set__@vary__logs_an_error

test_stdlib_var_assert_is_set__is_set___________logs_no_error_message() {
  stdlib.var.assert.is_set _TEST_SET_VAR

  stdlib.logger.error.mock.assert_not_called
}
