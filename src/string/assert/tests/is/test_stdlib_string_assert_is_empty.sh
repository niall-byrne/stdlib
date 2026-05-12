#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args___________returns_status_code_127;;127" \
    "extra_arg_________returns_status_code_127;AA|extra_arg;127" \
    "multiple_chars____returns_status_code___1;!2jfA0;1" \
    "symbol____________returns_status_code___1;@;1" \
    "alpha_____________returns_status_code___1;A;1" \
    "numeric___________returns_status_code___1;3;1" \
    "empty_string______returns_status_code___0;|;0"
}

@parametrize_with_error_messages() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "non_empty_string;abc;IS_NOT_EMPTY_STRING|abc" \
    "no_args_________;;ARGUMENTS_INVALID" \
    "extra_arg_______;a|b;ARGUMENTS_INVALID"
}

# shellcheck disable=SC2034
test_stdlib_string_assert_is_empty__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.assert.is_empty "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_assert_is_empty__@vary

test_stdlib_string_assert_is_empty__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.string.assert.is_empty "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_string_assert_is_empty__@vary__logs_an_error
