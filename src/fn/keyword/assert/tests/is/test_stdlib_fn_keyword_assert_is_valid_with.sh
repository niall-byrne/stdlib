#!/bin/bash

setup() {
  _mock.create stdlib.fn.keyword.query.is_valid_with
  _mock.create stdlib.logger.error

  _TEST_VAR="string"
}

@parametrize_with_query_function_errors() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_QUERY_FUNCTION_RC;TEST_MESSAGE_ARG_DEFINITION" \
    "query_fn_127;127;ARGUMENTS_INVALID" \
    "query_fn_126;126;ARGUMENTS_INVALID" \
    "query_fn_125;125;ARGUMENTS_KEYWORD_INVALID" \
    "query_fn___1;1;ARGUMENTS_KEYWORD_INVALID_DETAIL|_TEST_VAR"
}

# shellcheck disable=SC2153
test_stdlib_fn_keyword_assert_is_valid_with__query_fn___0__returns_expected_status_code() {
  stdlib.fn.keyword.query.is_valid_with.mock.set.rc "0"

  _capture.rc stdlib.fn.keyword.assert.is_valid_with _mock_validator _TEST_VAR

  assert_rc "0"
}

# shellcheck disable=SC2153
test_stdlib_fn_keyword_assert_is_valid_with__query_fn___0__logs_no_error() {
  stdlib.fn.keyword.query.is_valid_with.mock.set.rc "0"

  stdlib.fn.keyword.assert.is_valid_with _mock_validator _TEST_VAR

  stdlib.logger.error.mock.assert_not_called
}

# shellcheck disable=SC2153
test_stdlib_fn_keyword_assert_is_valid_with__@vary__returns_expected_status_code() {
  stdlib.fn.keyword.query.is_valid_with.mock.set.rc "${TEST_QUERY_FUNCTION_RC}"

  _capture.rc stdlib.fn.keyword.assert.is_valid_with _mock_validator _TEST_VAR

  assert_rc "${TEST_QUERY_FUNCTION_RC}"
}

@parametrize_with_query_function_errors \
  test_stdlib_fn_keyword_assert_is_valid_with__@vary__returns_expected_status_code

# shellcheck disable=SC2153
test_stdlib_fn_keyword_assert_is_valid_with__@vary__logs_expected_message() {
  local message_args=()

  stdlib.fn.keyword.query.is_valid_with.mock.set.rc "${TEST_QUERY_FUNCTION_RC}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.fn.keyword.assert.is_valid_with _mock_validator _TEST_VAR

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get "${message_args[@]}"))"
}

@parametrize_with_query_function_errors \
  test_stdlib_fn_keyword_assert_is_valid_with__@vary__logs_expected_message
