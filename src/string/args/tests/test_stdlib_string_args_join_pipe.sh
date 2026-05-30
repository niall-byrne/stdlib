#!/bin/bash

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_INPUT;TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args____________________________returns_status_code_127;;;127" \
    "valid_separator__and_input_________returns_status_code___0;input_string1|input_string2;!;0" \
    "null_separator___and_input_________returns_status_code___0;input_string1|input_string2;|;0"
}

@parametrize_with_expected_output() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_INPUT;TEST_ARGS_DEFINITION;TEST_EXPECTED_OUTPUT" \
    "valid_separator__and_double_input;input_string1|input_string2;!;input_string1!input_string2" \
    "null_separator___and_double_input;input_string1|input_string2;|;input_string1input_string2" \
    "valid_separator__and_single_input;input_string1;!;input_string1" \
    "valid_separator__and_white_space; input_string1 ;!; input_string1 "
}

# shellcheck disable=SC2034
test_stdlib_string_args_join_pipe__@vary() {
  local args=()

  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  TEST_INPUT="${TEST_INPUT//|/$'\n'}"

  echo "${TEST_INPUT}" | stdlib.string.args.join_pipe "${args[@]}" > /dev/null
  TEST_RC="$?"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_args_join_pipe__@vary

# shellcheck disable=SC2034
test_stdlib_string_args_join_pipe__@vary__generates_expected_output() {
  local args=()

  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  TEST_INPUT="${TEST_INPUT//|/$'\n'}"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | stdlib.string.args.join_pipe "${args[@]}")"

  assert_output "${TEST_EXPECTED_OUTPUT}"
}

@parametrize_with_expected_output \
  test_stdlib_string_args_join_pipe__@vary__generates_expected_output
