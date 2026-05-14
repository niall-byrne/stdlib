#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
  _mock.create mocked.query.function
}

@parametrize_with_arg_combos() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_______________________returns_status_code__127;;127" \
    "extra_arg_____________________returns_status_code__127;mocked.query.function|IS_NOT_ARRAY|mocked.new.assert.functionl|extra_arg;127" \
    "invalid_target________________returns_status_code__126;mocked.query.function|IS_NOT_ARRAY|in valid target|extra_arg;127" \
    "null_fn_name_____target_name__returns_status_code__126;|IS_NOT_ARRAY|mocked.new.assert.function;126" \
    "null_fn_name_____default______returns_status_code__126;|IS_NOT_ARRAY;126" \
    "invalid_msg_key__target_name__returns_status_code__126;mocked.query.function|INVALID_MSG_KEY|mocked.new.assert.function;126" \
    "invalid_msg_key__default______returns_status_code__126;mocked.query.function|INVALID_MSG_KEY;126" \
    "valid_args_______target_name__returns_status_code____0;mocked.query.function|IS_NOT_ARRAY|mocked.new.assert.function;0" \
    "valid_args_______default______returns_status_code____0;mocked.query.function|IS_NOT_ARRAY;0"
}

@parametrize_with_created_fn() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_FN_NAME" \
    "valid_args_______target_name;mocked.query.function|IS_NOT_ARRAY|mocked.new.assert.function;mocked.new.assert.function" \
    "valid_args_______default____;mocked.query.function|IS_NOT_ARRAY;mocked.assert.function"
}

@parametrize_with_query_function_errors() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_QUERY_FUNCTION_RC;TEST_MESSAGE_ARG_DEFINITION" \
    "query_fn_127;127;ARGUMENTS_INVALID" \
    "query_fn_126;126;ARGUMENTS_INVALID" \
    "query_fn_125;125;ARGUMENTS_KEYWORD_INVALID" \
    "query_fn_124;124;VAR_VALUE_INVALID_GLOBAL" \
    "query_fn_123;123;VAR_VALUE_INVALID_RESERVED" \
    "query_fn___1;1;IS_NOT_ARRAY|1"
}

test_stdlib_fn_derive_assertion__@vary() {
  local args=()

  stdlib.array.make.from_string "args" "|" "${TEST_ARGS_DEFINITION}"

  # shellcheck disable=SC2154
  _capture.rc stdlib.fn.derive.assertion "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_fn_derive_assertion__@vary

test_stdlib_fn_derive_assertion__@vary__creates_new_function() {
  local args=()

  stdlib.array.make.from_string "args" "|" "${TEST_ARGS_DEFINITION}"

  stdlib.fn.derive.assertion "${args[@]}"

  assert_is_fn "${TEST_EXPECTED_FN_NAME}"
}

@parametrize_with_created_fn \
  test_stdlib_fn_derive_assertion__@vary__creates_new_function

test_stdlib_fn_derive_assertion__@vary__new_function_called_______passes_args_to_query() {
  local args=()

  stdlib.array.make.from_string "args" "|" "${TEST_ARGS_DEFINITION}"
  stdlib.fn.derive.assertion "${args[@]}"

  "${TEST_EXPECTED_FN_NAME}" 1 2 3 4

  mocked.query.function.mock.assert_called_once_with \
    "1(1) 2(2) 3(3) 4(4)"
}

@parametrize_with_created_fn \
  test_stdlib_fn_derive_assertion__@vary__new_function_called_______passes_args_to_query

# shellcheck disable=SC2153
test_stdlib_fn_derive_assertion__@vary__new_function_called_______query_fn___0__returns_query_rc() {
  local args=()

  mocked.query.function.mock.set.rc "0"
  stdlib.array.make.from_string "args" "|" "${TEST_ARGS_DEFINITION}"
  stdlib.fn.derive.assertion "${args[@]}"

  _capture.rc "${TEST_EXPECTED_FN_NAME}" 1 2 3 4

  assert_rc "0"
}

@parametrize_with_created_fn \
  test_stdlib_fn_derive_assertion__@vary__new_function_called_______query_fn___0__returns_query_rc

# shellcheck disable=SC2153
test_stdlib_fn_derive_assertion__@vary__new_function_called_______query_fn___0__logs_no_error_message() {
  local args=()

  mocked.query.function.mock.set.rc "0"
  stdlib.array.make.from_string "args" "|" "${TEST_ARGS_DEFINITION}"
  stdlib.fn.derive.assertion "${args[@]}"

  "${TEST_EXPECTED_FN_NAME}" 1 2 3 4

  stdlib.logger.error.mock.assert_not_called
}

@parametrize_with_created_fn \
  test_stdlib_fn_derive_assertion__@vary__new_function_called_______query_fn___0__logs_no_error_message

# shellcheck disable=SC2153
test_stdlib_fn_derive_assertion__@vary__new_function_called_______@vary__returns_query_rc() {
  local args=()

  mocked.query.function.mock.set.rc "${TEST_QUERY_FUNCTION_RC}"
  stdlib.array.make.from_string "args" "|" "${TEST_ARGS_DEFINITION}"
  stdlib.fn.derive.assertion "${args[@]}"

  _capture.rc "${TEST_EXPECTED_FN_NAME}" 1 2 3 4

  assert_rc "${TEST_QUERY_FUNCTION_RC}"
}

@parametrize.compose \
  test_stdlib_fn_derive_assertion__@vary__new_function_called_______@vary__returns_query_rc \
  @parametrize_with_created_fn \
  @parametrize_with_query_function_errors

# shellcheck disable=SC2153
test_stdlib_fn_derive_assertion__@vary__new_function_called_______@vary__logs_correct_error_message() {
  local args=()
  local message_args=()

  mocked.query.function.mock.set.rc "${TEST_QUERY_FUNCTION_RC}"
  stdlib.array.make.from_string "args" "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"
  stdlib.fn.derive.assertion "${args[@]}"

  "${TEST_EXPECTED_FN_NAME}" 1 2 3 4

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get "${message_args[@]}"))"
}

@parametrize.compose \
  test_stdlib_fn_derive_assertion__@vary__new_function_called_______@vary__logs_correct_error_message \
  @parametrize_with_created_fn \
  @parametrize_with_query_function_errors
