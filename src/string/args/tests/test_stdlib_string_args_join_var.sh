#!/bin/bash

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_________________________________________returns_status_code_127;;127" \
    "invalid_var__valid_separator__no_input__________returns_status_code_127;INVALID VAR|!;127" \
    "valid___var__valid_separator__no_input__________returns_status_code_127;VALID_VAR|!;127" \
    "invalid_var__valid_separator__and_input_________returns_status_code_126;INVALID VAR|!|input_string1|input_string2;126" \
    "valid_var____valid_separator__and_input_________returns_status_code___0;VALID_VAR|!|input_string1|input_string2;0" \
    "invalid_var__null_separator___and_input_________returns_status_code_126;INVALID VAR||input_string1|input_string2;126" \
    "valid_var____null_separator___and_input_________returns_status_code___0;VALID_VAR||input_string1|input_string2;0"
}

@parametrize_with_expected_output() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_OUTPUT" \
    "valid_var____valid_separator__and_double_input;TEST_ACTUAL_OUTPUT|!|input_string1|input_string2;input_string1!input_string2" \
    "valid_var____null_separator___and_double_input;TEST_ACTUAL_OUTPUT||input_string1|input_string2;input_string1input_string2" \
    "valid_var____null_separator___and_white_space_;TEST_ACTUAL_OUTPUT|| input_string1 | input_string2 ; input_string1  input_string2 " \
    "valid_var____valid_separator__and_single_input;TEST_ACTUAL_OUTPUT|!|input_string1;input_string1" \
    "valid_var____valid_separator__and_white_space_;TEST_ACTUAL_OUTPUT|!| input_string1 ; input_string1 "
}

# shellcheck disable=SC2034
test_stdlib_string_args_join_var__@vary() {
  local args=()

  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.args.join_var "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_args_join_var__@vary

# shellcheck disable=SC2034
test_stdlib_string_args_join_var__@vary__sets_variable_correctly() {
  local args=()

  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  stdlib.string.args.join_var "${args[@]}" > /dev/null

  assert_equals "${TEST_ACTUAL_OUTPUT}" "${TEST_EXPECTED_OUTPUT}"
}

@parametrize_with_expected_output \
  test_stdlib_string_args_join_var__@vary__sets_variable_correctly
