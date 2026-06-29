#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_______________returns_status_code_127;;127" \
    "extra_arg_____________returns_status_code_127;value1|value2|extra_arg;127" \
    "non_matching_strings__returns_status_code___1;value1|value2;1" \
    "empty_input_string____returns_status_code___1;value1||;1" \
    "empty_match_string____returns_status_code___1;|value2;1" \
    "both_empty_values_____returns_status_code___0;||;0" \
    "matching_values_______returns_status_code___0;value1|value1;0"
}

@parametrize_with_error_messages() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args_____________;;ARGUMENTS_INVALID" \
    "extra_arg___________;value1|value2|extra_arg;ARGUMENTS_INVALID" \
    "non_matching_strings;value1|value2;IS_NOT_EQUAL|value1|value2"
}

# shellcheck disable=SC2034
test_stdlib_string_assert_is_equal__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.assert.is_equal "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_assert_is_equal__@vary

test_stdlib_string_assert_is_equal__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.string.assert.is_equal "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_string_assert_is_equal__@vary__logs_an_error
