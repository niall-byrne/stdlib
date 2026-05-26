#!/bin/bash

setup() {
  _mock.create _testing.error
}

@parametrize_with_scenarios() {
  @parametrize \
    "${1}" \
    "TEST_INPUT;TEST_ARGS;TEST_EXPECTED_RC;TEST_EXPECTED_CALLS" \
    "no_input__no_args_________;;;0;;" \
    "no_input__rc_125__________;;125;0;;" \
    "input_____rc_default______;input;;1;1(input)" \
    "input_____rc_invalid______;input;not_digit;126;;" \
    "input_____too_many_args___;input;1 2;127;;" \
    "input_____rc_125__________;input;125;125;1(input)" \
    "multiline_________________;line1\nline2;;1;1(line1) 2(line2)"
}

assert_error_calls_match() {
  # $1: The expected call to check for.

  if [[ -n "${1}" ]]; then
    _testing.error.mock.assert_calls_are "${1}"
  else
    _testing.error.mock.assert_not_called
  fi
}

# shellcheck disable=SC2034
test_testing_error_pipe__@vary__returns_expected_status_code() {
  builtin local -a args
  builtin local input

  stdlib.array.make.from_string args " " "${TEST_ARGS}"
  builtin printf -v input "%b" "${TEST_INPUT}"

  _testing.error_pipe "${args[@]}" <<< "${input}" > /dev/null 2>&1
  TEST_RC="${?}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_scenarios \
  test_testing_error_pipe__@vary__returns_expected_status_code

# shellcheck disable=SC2034
test_testing_error_pipe__@vary__logs_expected_error_messages() {
  builtin local -a args
  builtin local -a expected_calls
  builtin local input

  stdlib.array.make.from_string args " " "${TEST_ARGS}"
  builtin printf -v input "%b" "${TEST_INPUT}"

  _testing.error_pipe "${args[@]}" <<< "${input}" > /dev/null 2>&1

  assert_error_calls_match "${TEST_EXPECTED_CALLS}"
}

@parametrize_with_scenarios \
  test_testing_error_pipe__@vary__logs_expected_error_messages

# shellcheck disable=SC2034
test_testing_error_pipe__no_nl_____rc_default________returns_expected_status_code() {
  echo -n "no newline" | _testing.error_pipe "${args[@]}" > /dev/null 2>&1
  TEST_RC="${?}"

  assert_rc "1"
}

# shellcheck disable=SC2034
test_testing_error_pipe__no_nl_____rc_default________logs_expected_error_messages() {
  echo -n "no newline" | _testing.error_pipe "${args[@]}" > /dev/null 2>&1

  assert_error_calls_match "1(no newline)"
}
