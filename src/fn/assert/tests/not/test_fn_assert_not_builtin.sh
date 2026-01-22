#!/bin/bash

# shellcheck disable=SC2034
setup() {
  _mock.create stdlib.logger.error
}

_example_fn() {
  :
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args__________________returns_status_code_127;;127" \
    "extra_arg________________returns_status_code_127;echo|extra_arg;127" \
    "is_a_builtin_____________returns_status_code___1;echo;1" \
    "is_not_a_builtin_________returns_status_code___0;_example_fn;0"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args________________;;ARGUMENTS_INVALID" \
    "extra_arg______________;echo|extra_arg;ARGUMENTS_INVALID" \
    "is_a_builtin___________;echo;IS_BUILTIN|echo"
}

test_stdlib_fn_assert_not_builtin__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.fn.assert.not_builtin "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_fn_assert_not_builtin__@vary

test_stdlib_fn_assert_not_builtin__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.fn.assert.not_builtin "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.message.get "${message_args[@]}"))"
}
@parametrize_with_error_messages \
  test_stdlib_fn_assert_not_builtin__@vary__logs_an_error
