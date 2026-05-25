#!/bin/bash

setup_suite() {
  expected_colour="$(stdlib.setting.theme.get_colour "${STDLIB_TESTING_THEME_ERROR}")"
}

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_scenarios() {
  @parametrize \
    "${1}" \
    "TEST_INPUT;TEST_ARGS;TEST_EXPECTED_RC;TEST_EXPECTED_OUTPUT" \
    "no_input__no_args_________returns_rc_0;;;0;" \
    "no_input__arg_125________returns_rc_0;;125;0;" \
    "input_____no_args_________returns_rc_1;input;;1;${!expected_colour}input${STDLIB_COLOUR_NC}" \
    "input_____arg_125________returns_rc_125;input;125;125;${!expected_colour}input${STDLIB_COLOUR_NC}" \
    "input_____invalid_arg_____returns_rc_126;input;not_digit;126;" \
    "input_____too_many_args___returns_rc_127;input;1 2;127;"
}

# shellcheck disable=SC2034
test_stdlib_testing_error_pipe__@vary() {
  builtin local -a args=()

  stdlib.array.make.from_string args " " "${TEST_ARGS}"

  builtin printf "%s" "${TEST_INPUT}" | _testing.error_pipe "${args[@]}" > /dev/null 2>&1
  TEST_RC="${PIPESTATUS[1]}"
  TEST_OUTPUT="$(builtin printf "%s" "${TEST_INPUT}" | _testing.error_pipe "${args[@]}" 2>&1)"

  assert_rc "${TEST_EXPECTED_RC}"
  assert_output "${TEST_EXPECTED_OUTPUT}"
}

@parametrize_with_scenarios \
  test_stdlib_testing_error_pipe__@vary
