#!/bin/bash

setup() {
  _mock.create stdlib.logger.error

  _TEST_SCALAR_KW=0
  _TEST_EMPTY_KW=""
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args______________________________________returns_status_code_127;;127" \
    "invalid_output__extra_arg____________________returns_status_code_127;OUTPUT_VAR|_TEST_SCALAR_KW|default|extra_arg;127" \
    "invalid_output__scalar_unset__unset_default__returns_status_code_126;TEST_OUTPUT!VAR|_NOT_SET_VAR;126" \
    "invalid_output__scalar_unset__valid_default__returns_status_code_126;TEST_OUTPUT!VAR|_NOT_SET_VAR|default;126" \
    "invalid_output__valid_scalar__unset_default__returns_status_code___0;TEST_OUTPUT!VAR|_TEST_SCALAR_KW;126" \
    "invalid_output__valid_scalar__valid_default__returns_status_code___0;TEST_OUTPUT!VAR|_TEST_SCALAR_KW|default;126" \
    "valid_output____extra_arg____________________returns_status_code_127;OUTPUT_VAR|_TEST_SCALAR_KW|default|extra_arg;127" \
    "valid_output____scalar_unset__unset_default__returns_status_code_126;TEST_OUTPUT_VAR|_NOT_SET_VAR;126" \
    "valid_output____scalar_unset__valid_default__returns_status_code_126;TEST_OUTPUT_VAR|_NOT_SET_VAR|default;126" \
    "valid_output____valid_scalar__unset_default__returns_status_code___0;TEST_OUTPUT_VAR|_TEST_SCALAR_KW;0" \
    "valid_output____valid_scalar__valid_default__returns_status_code___0;TEST_OUTPUT_VAR|_TEST_SCALAR_KW|default;0"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITIONS" \
    "valid_output____no_args____________________;;ARGUMENT_REQUIREMENTS_VIOLATION|2|1 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|0" \
    "valid_output____extra_arg__________________;TEST_OUTPUT_VAR|_TEST_SCALAR_KW|default|extra_arg;ARGUMENT_REQUIREMENTS_VIOLATION|2|1 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|4" \
    "valid_output____scalar_unset__unset_default;TEST_OUTPUT_VAR|_NOT_SET_VAR;VAR_NOT_SET|_NOT_SET_VAR" \
    "valid_output____scalar_unset__valid_default;TEST_OUTPUT_VAR|_NOT_SET_VAR|default;VAR_NOT_SET|_NOT_SET_VAR"
}

@parametrize_with_expected_values() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_VALUE" \
    "valid_output____value_scalar__unset_default;TEST_OUTPUT_VAR|_TEST_SCALAR_KW;0" \
    "valid_output____value_scalar__valid_default;TEST_OUTPUT_VAR|_TEST_SCALAR_KW|default;0" \
    "valid_output____empty_scalar__unset_default;TEST_OUTPUT_VAR|_TEST_EMPTY_KW;;" \
    "valid_output____empty_scalar__valid_default;TEST_OUTPUT_VAR|_TEST_EMPTY_KW|default;default"
}

_fixture_unpack_message_args() {
  local message_args=()

  stdlib.array.make.from_string message_args "|" "${1}"
  messages+=("1($(stdlib.__message.get "${message_args[@]}"))")
}

test_stdlib_fn_keyword_consume__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.fn.keyword.consume "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_fn_keyword_consume__@vary

# shellcheck disable=SC2034
test_stdlib_fn_keyword_consume__@vary__logs_expected_error_messages() {
  local args=()
  local message_args_sets=()
  local messages=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args_sets " " "${TEST_MESSAGE_ARG_DEFINITIONS}"
  stdlib.array.map.fn _fixture_unpack_message_args message_args_sets

  stdlib.fn.keyword.consume "${args[@]}" > /dev/null

  stdlib.logger.error.mock.assert_calls_are "${messages[@]}"
}

@parametrize_with_error_messages \
  test_stdlib_fn_keyword_consume__@vary__logs_expected_error_messages

# shellcheck disable=SC2034
test_stdlib_fn_keyword_consume__@vary__assigns_correct_expected_value() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  stdlib.fn.keyword.consume "${args[@]}"

  assert_equals "${TEST_EXPECTED_VALUE}" "${TEST_OUTPUT_VAR}"
}

@parametrize_with_expected_values \
  test_stdlib_fn_keyword_consume__@vary__assigns_correct_expected_value

# shellcheck disable=SC2034
test_stdlib_fn_keyword_consume__@vary__resets_keyword_empty_value() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  stdlib.fn.keyword.consume "${args[@]}" > /dev/null

  assert_null "${!args[1]}"
}

@parametrize_with_expected_values \
  test_stdlib_fn_keyword_consume__@vary__resets_keyword_empty_value
