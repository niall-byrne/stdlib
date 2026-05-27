#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_________returns_status_code_127;;127" \
    "extra_arg_______returns_status_code_127;AA|extra_arg;127" \
    "empty_string____returns_status_code___1;|;1" \
    "multiple_chars__returns_status_code___0;!2jfA0;0" \
    "symbol__________returns_status_code___0;@;0" \
    "alpha___________returns_status_code___0;A;0" \
    "numeric_________returns_status_code___0;3;0"
}

@parametrize_with_error_messages() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "empty_string__;|;IS_EMPTY_STRING||" \
    "no_args_______;;ARGUMENTS_INVALID" \
    "extra_arg_____;a|b;ARGUMENTS_INVALID"
}

# shellcheck disable=SC2034
test_stdlib_string_assert_not_empty__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.assert.not_empty "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_assert_not_empty__@vary

test_stdlib_string_assert_not_empty__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.string.assert.not_empty "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_string_assert_not_empty__@vary__logs_an_error
