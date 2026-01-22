#!/bin/bash

# shellcheck disable=SC2034
setup() {
  not_builtin_string="not a function"
  not_builtin_array=()

  _mock.create stdlib.logger.error
}

not_builtin_fn() {
  echo "test"
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_____________returns_status_code_127;;127" \
    "arg_is_null_________returns_status_code_126;|;126" \
    "extra_arg___________returns_status_code_127;echo|extra_arg;127" \
    "arg_is_string_______returns_status_code___1;test_string;1" \
    "arg_is_array________returns_status_code___1;test_array;1" \
    "arg_does_not_exist__returns_status_code___1;nothing_at_all;1" \
    "arg_is_fn___________returns_status_code___1;not_builtin_fn;1" \
    "arg_is_builtin______returns_status_code___0;echo;0"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "arg_is_null_______;|;IS_NOT_BUILTIN||" \
    "arg_is_string_____;not_builtin_string;IS_NOT_BUILTIN|not_builtin_string" \
    "arg_is_array______;not_builtin_array;IS_NOT_BUILTIN|not_builtin_array" \
    "arg_is_fn_________;not_builtin_fn;IS_NOT_BUILTIN|not_builtin_fn"
}

test_stdlib_fn_assert_is_builtin__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.fn.assert.is_builtin "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_fn_assert_is_builtin__@vary

test_stdlib_fn_assert_is_builtin__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  _capture.rc stdlib.fn.assert.is_builtin "${args[@]}" > /dev/null

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_fn_assert_is_builtin__@vary__logs_an_error
