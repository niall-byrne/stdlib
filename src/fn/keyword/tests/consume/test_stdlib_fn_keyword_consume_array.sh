#!/bin/bash

setup() {
  _mock.create stdlib.logger.error

  _TEST_SCALAR_KW=0
  _TEST_POPULATED_ARRAY_KW=("value1" "value2")
  _TEST_EMPTY_ARRAY_KW=()
  _TEST_DEFAULT_ARRAY=("default1" "default2")
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC;TEST_MESSAGE_ARG_DEFINITIONS" \
    "no_args_____________________________________________status_code_127;;127;ARGUMENT_REQUIREMENTS_VIOLATION|2|1 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|0" \
    "valid_output_var____extra_arg_______________________status_code_127;_TEST_OUTPUT_VAR|_TEST_POPULATED_ARRAY_KW|_TEST_DEFAULT_ARRAY|extra_arg;127;ARGUMENT_REQUIREMENTS_VIOLATION|2|1 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|4" \
    "valid_output_var____array_unset____no_default_______status_code_126;_TEST_OUTPUT_VAR|_NOT_SET_ARRAY;126;IS_NOT_ARRAY|_NOT_SET_ARRAY" \
    "valid_output_var____array_unset____unset_default____status_code_126;_TEST_OUTPUT_VAR|_NOT_SET_ARRAY|_NOT_SET_DEFAULT;126;IS_NOT_ARRAY|_NOT_SET_DEFAULT" \
    "valid_output_var____array_unset____valid_default____status_code___0;_TEST_OUTPUT_VAR|_NOT_SET_ARRAY|_TEST_DEFAULT_ARRAY;0;;" \
    "valid_output_var____array_unset____invalid_default__status_code_126;_TEST_OUTPUT_VAR|_NOT_SET_ARRAY|_TEST_SCALAR_KW;126;IS_NOT_ARRAY|_TEST_SCALAR_KW" \
    "valid_output_var____invalid_array__no_default_______status_code_126;_TEST_OUTPUT_VAR|_TEST_SCALAR_KW;126;IS_NOT_ARRAY|_TEST_SCALAR_KW" \
    "valid_output_var____invalid_array__unset_default____status_code_126;_TEST_OUTPUT_VAR|_TEST_SCALAR_KW|_NOT_SET_DEFAULT;126;IS_NOT_ARRAY|_TEST_SCALAR_KW" \
    "valid_output_var____invalid_array__valid_default____status_code_126;_TEST_OUTPUT_VAR|_TEST_SCALAR_KW|_TEST_DEFAULT_ARRAY;126;IS_NOT_ARRAY|_TEST_SCALAR_KW" \
    "valid_output_var____invalid_array__invalid_default__status_code_126;_TEST_OUTPUT_VAR|_TEST_SCALAR_KW|_TEST_SCALAR_KW;126;IS_NOT_ARRAY|_TEST_SCALAR_KW" \
    "valid_output_var____valid_array____no_default_______status_code___0;_TEST_OUTPUT_VAR|_TEST_POPULATED_ARRAY_KW;0;;" \
    "valid_output_var____valid_array____unset_default____status_code_126;_TEST_OUTPUT_VAR|_TEST_POPULATED_ARRAY_KW|_NOT_SET_DEFAULT;126;IS_NOT_ARRAY|_NOT_SET_DEFAULT" \
    "valid_output_var____valid_array____valid_default____status_code___0;_TEST_OUTPUT_VAR|_TEST_POPULATED_ARRAY_KW|_TEST_DEFAULT_ARRAY;0;;" \
    "valid_output_var____valid_array____invalid_default__status_code_126;_TEST_OUTPUT_VAR|_TEST_POPULATED_ARRAY_KW|_TEST_SCALAR_KW;126;IS_NOT_ARRAY|_TEST_SCALAR_KW" \
    "invalid_output_var__extra_arg_______________________status_code_127;_INVALID!OUTPUT_VAR|_TEST_POPULATED_ARRAY_KW|_TEST_DEFAULT_ARRAY|extra_arg;127;ARGUMENT_REQUIREMENTS_VIOLATION|2|1 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|4" \
    "invalid_output_var__array_unset____no_default_______status_code_126;_INVALID!OUTPUT_VAR|_NOT_SET_ARRAY;126;VAR_NAME_INVALID|_INVALID!OUTPUT_VAR" \
    "invalid_output_var__array_unset____unset_default____status_code_126;_INVALID!OUTPUT_VAR|_NOT_SET_ARRAY|_NOT_SET_DEFAULT;126;VAR_NAME_INVALID|_INVALID!OUTPUT_VAR" \
    "invalid_output_var__array_unset____valid_default____status_code_126;_INVALID!OUTPUT_VAR|_NOT_SET_ARRAY|_TEST_DEFAULT_ARRAY;126;VAR_NAME_INVALID|_INVALID!OUTPUT_VAR" \
    "invalid_output_var__array_unset____invalid_default__status_code_126;_INVALID!OUTPUT_VAR|_NOT_SET_ARRAY|_TEST_SCALAR_KW;126;VAR_NAME_INVALID|_INVALID!OUTPUT_VAR" \
    "invalid_output_var__invalid_array__no_default_______status_code_126;_INVALID!OUTPUT_VAR|_TEST_SCALAR_KW;126;VAR_NAME_INVALID|_INVALID!OUTPUT_VAR" \
    "invalid_output_var__invalid_array__unset_default____status_code_126;_INVALID!OUTPUT_VAR|_TEST_SCALAR_KW|_NOT_SET_DEFAULT;126;VAR_NAME_INVALID|_INVALID!OUTPUT_VAR" \
    "invalid_output_var__invalid_array__valid_default____status_code_126;_INVALID!OUTPUT_VAR|_TEST_SCALAR_KW|_TEST_DEFAULT_ARRAY;126;VAR_NAME_INVALID|_INVALID!OUTPUT_VAR" \
    "invalid_output_var__invalid_array__invalid_default__status_code_126;_INVALID!OUTPUT_VAR|_TEST_SCALAR_KW|_TEST_SCALAR_KW;126;VAR_NAME_INVALID|_INVALID!OUTPUT_VAR" \
    "invalid_output_var__valid_array____no_default_______status_code_126;_INVALID!OUTPUT_VAR|_TEST_POPULATED_ARRAY_KW;126;VAR_NAME_INVALID|_INVALID!OUTPUT_VAR" \
    "invalid_output_var__valid_array____unset_default____status_code_126;_INVALID!OUTPUT_VAR|_TEST_POPULATED_ARRAY_KW|__NOT_SET_DEFAULT;126;VAR_NAME_INVALID|_INVALID!OUTPUT_VAR" \
    "invalid_output_var__valid_array____valid_default____status_code_126;_INVALID!OUTPUT_VAR|_TEST_POPULATED_ARRAY_KW|_TEST_DEFAULT_ARRAY;126;VAR_NAME_INVALID|_INVALID!OUTPUT_VAR" \
    "invalid_output_var__valid_array____invalid_default__status_code_126;_INVALID!OUTPUT_VAR|_TEST_POPULATED_ARRAY_KW|_TEST_SCALAR_KW;126;VAR_NAME_INVALID|_INVALID!OUTPUT_VAR"
}

@parametrize_with_expected_values() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_ARRAY_DEFINITION" \
    "valid_output_var____array_unset____valid_default____status_code___0;_TEST_OUTPUT_VAR|_NOT_SET_ARRAY|_TEST_DEFAULT_ARRAY;default1|default2" \
    "valid_output_var____empty_array____no_default_______status_code___0;_TEST_OUTPUT_VAR|_TEST_EMPTY_ARRAY_KW;;" \
    "valid_output_var____empty_array____valid_default____status_code___0;_TEST_OUTPUT_VAR|_TEST_EMPTY_ARRAY_KW|_TEST_DEFAULT_ARRAY;default1|default2;" \
    "valid_output_var____valid_array____no_default_______status_code___0;_TEST_OUTPUT_VAR|_TEST_POPULATED_ARRAY_KW;value1|value2" \
    "valid_output_var____valid_array____valid_default____status_code___0;_TEST_OUTPUT_VAR|_TEST_POPULATED_ARRAY_KW|_TEST_DEFAULT_ARRAY;value1|value2"
}

_fixture_unpack_message_args() {
  local message_args=()

  stdlib.array.make.from_string message_args "|" "${1}"
  messages+=("$(stdlib.__message.get "${message_args[@]}")")
}

assert_array_is_zeroed() {
  local array_name="${1}"

  if stdlib.array.query.is_array "${array_name}"; then
    assert_array_length "0" "${array_name}"
  fi
}

test_stdlib_fn_keyword_consume_array__@vary__returns_expected_status_code() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.fn.keyword.consume_array "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_fn_keyword_consume_array__@vary__returns_expected_status_code

# shellcheck disable=SC2034
test_stdlib_fn_keyword_consume_array__@vary__logs_expected_error_messages() {
  local args=()
  local message_args_sets=()
  local messages=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args_sets " " "${TEST_MESSAGE_ARG_DEFINITIONS}"

  stdlib.array.map.fn _fixture_unpack_message_args message_args_sets

  stdlib.fn.keyword.consume_array "${args[@]}"

  assert_logger_error_matches "${messages[@]}"
}

@parametrize_with_arg_combos \
  test_stdlib_fn_keyword_consume_array__@vary__logs_expected_error_messages

# shellcheck disable=SC2034
test_stdlib_fn_keyword_consume_array__@vary__returns_expected_value() {
  local _TEST_OUTPUT_VAR=()
  local args=()
  local expected_array=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string expected_array "|" "${TEST_EXPECTED_ARRAY_DEFINITION}"

  stdlib.fn.keyword.consume_array "${args[@]}"

  assert_array_equals "_TEST_OUTPUT_VAR" "expected_array"
}

@parametrize_with_expected_values \
  test_stdlib_fn_keyword_consume_array__@vary__returns_expected_value

# shellcheck disable=SC2034
test_stdlib_fn_keyword_consume_array__@vary__resets_keyword_to_empty_array() {
  local args=()
  local reference_array=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  stdlib.fn.keyword.consume_array "${args[@]}"

  assert_array_is_zeroed "${args[1]}"
}

@parametrize_with_expected_values \
  test_stdlib_fn_keyword_consume_array__@vary__resets_keyword_to_empty_array
