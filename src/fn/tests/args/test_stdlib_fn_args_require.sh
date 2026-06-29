#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
  stdlib.logger.error.mock.set.keywords "STDLIB_LOGGING_MESSAGE_PREFIX"
}

@parametrize_with_required_arg_returns_codes() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_REQUIRED;TEST_ARGS_OPTIONAL;TEST_ARGS_NULL_SAFE_DEFINITION;TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "0_required____0_optional_args__no_null____1_given__no_null_args;0;0;;arg1;127;" \
    "0_required____0_optional_args__no_null____0_given__no_null_args;0;0;;;0;" \
    "2_required____0_optional_args__no_null____2_given__no_null_args;2;0;;arg1|arg2;0;" \
    "2_required____0_optional_args__no_null____2_given__2_null_arg__;2;0;;arg1||;126;" \
    "2_required____0_optional_args__no_null____3_given__no_null_args;2;0;;arg1|arg2|arg3;127;" \
    "2_required____0_optional_args__1_null_ok__2_given__1_null_arg__;2;0;1;|arg2|;0;" \
    "2_required____0_optional_args__2_null_ok__2_given__2_null_arg_0;2;0;2;arg1||;0;" \
    "2_required____0_optional_args__1_null_ok__2_given__all_null_arg;2;0;1;||;126;" \
    "2_required____0_optional_args__1_null_ok__1_given__no_null_args;2;0;1;arg1;127;"
}

@parametrize_with_optional_arg_return_codes() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_REQUIRED;TEST_ARGS_OPTIONAL;TEST_ARGS_NULL_SAFE_DEFINITION;TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "2_required____1_optional_args__no_null____2_given__no_null_args;2;1;;arg1|arg2;0;" \
    "2_required____1_optional_args__no_null____2_given__1_null_arg__;2;1;;arg1|;127;" \
    "2_required____1_optional_args__3_null_ok__2_given__3_null_arg__;2;1;3;arg1|arg2||;0;" \
    "2_required____1_optional_args__no_null____3_given__no_null_args;2;1;;arg1|arg2|arg3;0;" \
    "2_required____1_optional_args__no_null____3_given__1_null_arg__;2;1;;arg1|arg2||;126;" \
    "2_required__inf_optional_args__no_null____2_given__no_null_args;2;-1;;arg1|arg2;0;" \
    "2_required__inf_optional_args__no_null____5_given__no_null_args;2;-1;;arg1|arg2|arg3|arg4|arg5;0;" \
    "2_required__inf_optional_args__no_null____5_given__1_null_arg__;2;-1;;arg1|arg2||arg4|arg5;126;"
}

@parametrize_with_error_logs() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_REQUIRED;TEST_ARGS_OPTIONAL;TEST_ARGS_NULL_SAFE_DEFINITION;TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITIONS" \
    "2_required____0_optional_args__no_null____1_given__no_null_args;2;0;;arg1;ARGUMENT_REQUIREMENTS_VIOLATION|2|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|1" \
    "2_required____0_optional_args__no_null____2_given__1_null_arg__;2;0;;|arg2;ARGUMENT_REQUIREMENTS_VIOLATION|2|0 ARGUMENT_REQUIREMENTS_VIOLATION_NULL|1" \
    "2_required____0_optional_args__1_null_ok__2_given__2_null_args;2;0;1;||;ARGUMENT_REQUIREMENTS_VIOLATION|2|0 ARGUMENT_REQUIREMENTS_VIOLATION_NULL|2" \
    "2_required__inv_optional_args__no_null____2_given__no_null_args;2;-8;;||;IS_NOT_INTEGER_IN_RANGE|-1|100|-8"
}

test_stdlib_fn_args_require__@vary__@vary__returns_expected_status_code() {
  local STDLIB_ARGS_NULL_SAFE_ARRAY=()
  local args=()

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"
  IFS="|" read -ra STDLIB_ARGS_NULL_SAFE_ARRAY <<< "${TEST_ARGS_NULL_SAFE_DEFINITION}"

  _capture.rc stdlib.fn.args.require "${TEST_ARGS_REQUIRED}" "${TEST_ARGS_OPTIONAL}" "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize.apply \
  test_stdlib_fn_args_require__@vary__@vary__returns_expected_status_code \
  @parametrize_with_required_arg_returns_codes \
  @parametrize_with_optional_arg_return_codes

test_stdlib_fn_args_require__@vary__@vary__resets_keywords() {
  local STDLIB_ARGS_NULL_SAFE_ARRAY=()
  local args=()

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"
  IFS="|" read -ra STDLIB_ARGS_NULL_SAFE_ARRAY <<< "${TEST_ARGS_NULL_SAFE_DEFINITION}"

  stdlib.fn.args.require "${TEST_ARGS_REQUIRED}" "${TEST_ARGS_OPTIONAL}" "${args[@]}"

  assert_array_length 0 STDLIB_ARGS_NULL_SAFE_ARRAY
}

@parametrize.apply \
  test_stdlib_fn_args_require__@vary__@vary__resets_keywords \
  @parametrize_with_required_arg_returns_codes \
  @parametrize_with_optional_arg_return_codes

test_stdlib_fn_args_require__@vary__default_function_name_____generates_correct_error_logs() {
  local STDLIB_ARGS_NULL_SAFE_ARRAY=()
  local STDLIB_ARGS_CALLER_FN_NAME=""
  local args=()
  local message_arg_definition
  local message_arg_definitions=()
  local message_args=()

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"
  IFS="|" read -ra STDLIB_ARGS_NULL_SAFE_ARRAY <<< "${TEST_ARGS_NULL_SAFE_DEFINITION}"
  IFS=" " read -ra message_arg_definitions <<< "${TEST_MESSAGE_ARG_DEFINITIONS}"
  for message_arg_definition in "${message_arg_definitions[@]}"; do
    IFS="|" read -ra message_args <<< "${message_arg_definition}"
    expected_log_messages+=("1($(stdlib.__message.get "${message_args[@]}")) STDLIB_LOGGING_MESSAGE_PREFIX(${FUNCNAME[0]})")
  done

  stdlib.fn.args.require "${TEST_ARGS_REQUIRED}" "${TEST_ARGS_OPTIONAL}" "${args[@]}"

  stdlib.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_error_logs \
  test_stdlib_fn_args_require__@vary__default_function_name_____generates_correct_error_logs

# shellcheck disable=SC2178
test_stdlib_fn_args_require__1_required____0_optional_args__invalid_null_safe_array___________returns_status_code_125() {
  local STDLIB_ARGS_NULL_SAFE_ARRAY="not_an_array"
  local STDLIB_ARGS_CALLER_FN_NAME=""
  local args=()
  local message_arg_definition
  local message_arg_definitions=()
  local message_args=()

  _capture.rc stdlib.fn.args.require 1 0 "one"

  assert_rc "125"
}

# shellcheck disable=SC2178
test_stdlib_fn_args_require__1_required____0_optional_args__invalid_null_safe_array___________generates_correct_error_logs() {
  local STDLIB_ARGS_NULL_SAFE_ARRAY="not_an_array"
  local STDLIB_ARGS_CALLER_FN_NAME=""
  local args=()
  local message_arg_definition
  local message_arg_definitions=()
  local message_args=()

  stdlib.fn.args.require 1 0 "one"

  stdlib.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get IS_NOT_ARRAY STDLIB_ARGS_NULL_SAFE_ARRAY)) STDLIB_LOGGING_MESSAGE_PREFIX(${FUNCNAME[0]})" \
    "1($(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID_DETAIL STDLIB_ARGS_NULL_SAFE_ARRAY)) STDLIB_LOGGING_MESSAGE_PREFIX(${FUNCNAME[0]})"
}

# shellcheck disable=SC2034
test_stdlib_fn_args_require__1_required____0_optional_args__invalid_null_safe_all_boolean_____returns_status_code_125() {
  local STDLIB_ARGS_NULL_SAFE_ALL_BOOLEAN="not_a_boolean"

  _capture.rc stdlib.fn.args.require 1 0 "one"

  assert_rc "125"
}

# shellcheck disable=SC2034
test_stdlib_fn_args_require__1_required____0_optional_args__invalid_null_safe_all_boolean_____generates_correct_error_logs() {
  local STDLIB_ARGS_NULL_SAFE_ALL_BOOLEAN="not_a_boolean"

  stdlib.fn.args.require 1 0 "one"

  stdlib.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get IS_NOT_BOOLEAN not_a_boolean)) STDLIB_LOGGING_MESSAGE_PREFIX(${FUNCNAME[0]})" \
    "1($(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID_DETAIL STDLIB_ARGS_NULL_SAFE_ALL_BOOLEAN)) STDLIB_LOGGING_MESSAGE_PREFIX(${FUNCNAME[0]})"
}

# shellcheck disable=SC2034
test_stdlib_fn_args_require__2_required____0_optional_args__valid_null_safe_all_boolean_______overrides_null_safe_array() {
  local STDLIB_ARGS_NULL_SAFE_ALL_BOOLEAN="1"

  _capture.rc stdlib.fn.args.require 2 0 "" ""

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_fn_args_require__2_required____0_optional_args__valid_null_safe_all_boolean_______resets_keyword() {
  local STDLIB_ARGS_NULL_SAFE_ALL_BOOLEAN="1"

  stdlib.fn.args.require 2 0 "" ""

  assert_null "${STDLIB_ARGS_NULL_SAFE_ALL_BOOLEAN}"
}

# shellcheck disable=SC2034
test_stdlib_fn_args_require__@vary__overridden_function_name__generates_correct_error_logs() {
  local STDLIB_ARGS_NULL_SAFE_ARRAY=()
  local STDLIB_ARGS_CALLER_FN_NAME="override logging message prefix"
  local args=()
  local message_arg_definition
  local message_arg_definitions=()
  local message_args=()

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"
  IFS="|" read -ra STDLIB_ARGS_NULL_SAFE_ARRAY <<< "${TEST_ARGS_NULL_SAFE_DEFINITION}"
  IFS=" " read -ra message_arg_definitions <<< "${TEST_MESSAGE_ARG_DEFINITIONS}"
  for message_arg_definition in "${message_arg_definitions[@]}"; do
    IFS="|" read -ra message_args <<< "${message_arg_definition}"
    expected_log_messages+=("1($(stdlib.__message.get "${message_args[@]}")) STDLIB_LOGGING_MESSAGE_PREFIX(override logging message prefix)")
  done

  stdlib.fn.args.require "${TEST_ARGS_REQUIRED}" "${TEST_ARGS_OPTIONAL}" "${args[@]}"

  stdlib.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_error_logs \
  test_stdlib_fn_args_require__@vary__overridden_function_name__generates_correct_error_logs
