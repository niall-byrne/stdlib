#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_______returns_status_code_127;;127" \
    "extra_arg_____returns_status_code_127;AA|extra_arg;127" \
    "empty_string__returns_status_code_126;|;126" \
    "subshell______returns_status_code___1;\\\$(echo shell);1" \
    "ampersand_____returns_status_code___1;variable&name;1" \
    "dash__________returns_status_code___1;variable-name;1" \
    "glob__________returns_status_code___1;variable*name;1" \
    "space_________returns_status_code___1;variable name;1" \
    "valid_name____returns_status_code___0;variable_name;0"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args_____;;ARGUMENTS_INVALID" \
    "extra_args__;foo|bar;ARGUMENTS_INVALID" \
    "arg_is_null_;|;ARGUMENTS_INVALID" \
    "ampersand___;variable&name;VAR_NAME_INVALID|variable&name" \
    "space_______;variable name;VAR_NAME_INVALID|variable name"
}

# shellcheck disable=SC2153
test_stdlib_var_assert_is_valid_name__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.var.assert.is_valid_name "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_var_assert_is_valid_name__@vary

# shellcheck disable=SC2153
test_stdlib_var_assert_is_valid_name__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.var.assert.is_valid_name "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_var_assert_is_valid_name__@vary__logs_an_error
