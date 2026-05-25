#!/bin/bash

setup() {
  _mock.create _testing.error
}

@parametrize_with_scenarios() {
  @parametrize \
    "${1}" \
    "TEST_INPUT;TEST_ARGS;TEST_EXPECTED_RC;TEST_EXPECTED_CALLS" \
    "no_input__no_args_________returns_rc_0;;;0;" \
    "no_input__arg_125________returns_rc_0;;125;0;" \
    "input_____no_args_________returns_rc_1;input;;1;1(input)" \
    "input_____arg_125________returns_rc_125;input;125;125;125(input)" \
    "input_____invalid_arg_____returns_rc_126;input;not_digit;126;" \
    "input_____too_many_args___returns_rc_127;input;1 2;127;" \
    "multiline_input___________returns_rc_1;line1\nline2;;1;1(line1)|1(line2)"
}

# shellcheck disable=SC2034
test_testing_error_pipe__rc__@vary() {
  builtin local -a args=()
  builtin local input

  stdlib.array.make.from_string args " " "${TEST_ARGS}"
  builtin printf -v input "%b" "${TEST_INPUT}"

  _testing.error_pipe "${args[@]}" <<< "${input}" > /dev/null 2>&1
  TEST_RC="${?}"

  assert_rc "${TEST_EXPECTED_RC}"
}

# shellcheck disable=SC2034
test_testing_error_pipe__calls__@vary() {
  builtin local -a args=()
  builtin local -a expected_calls=()
  builtin local input

  stdlib.array.make.from_string args " " "${TEST_ARGS}"
  stdlib.array.make.from_string expected_calls "|" "${TEST_EXPECTED_CALLS}"
  builtin printf -v input "%b" "${TEST_INPUT}"

  _testing.error_pipe "${args[@]}" <<< "${input}" > /dev/null 2>&1

  _testing.error.mock.assert_calls_are "${expected_calls[@]}"
}

@parametrize_with_scenarios \
  test_testing_error_pipe__rc__@vary

@parametrize_with_scenarios \
  test_testing_error_pipe__calls__@vary
