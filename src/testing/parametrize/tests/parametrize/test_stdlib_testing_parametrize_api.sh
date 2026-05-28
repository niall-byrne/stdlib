#!/bin/bash

setup() {
  _mock.create _testing.error
  _mock.create test_function_mock_@vary
}

@parametrize_with_keywords() {
  @parametrize \
    "${1}" \
    "TEST_KEYWORD_NAME;VALID_VALUE;INVALID_VALUE;MESSAGE_KEYWORD" \
    "debug_boolean____;STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN;1;non_boolean;IS_NOT_BOOLEAN" \
    "field_seperator__;STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR;|;too_many_chars;IS_NOT_CHAR" \
    "command_prefix___;STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX;valid_prefix;;IS_EMPTY_STRING" \
    "test_name_boolean;STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN;1;non_boolean;IS_NOT_BOOLEAN" \
    "variant_tag______;STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG;valid_tag;;IS_EMPTY_STRING"
}

@parametrize_with_reserved_arrays() {

  @parametrize \
    "${1}" \
    "TEST_ARRAY_KEYWORD_NAME" \
    "functions_array__;__STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY"
}

# shellcheck disable=SC2034
test_parametrize__api_test__invalid__@vary__returns_status_code_125() {
  local "${TEST_KEYWORD_NAME}"="${INVALID_VALUE}"

  _capture.rc @parametrize test_function_mock_@vary \
    "TEST_VALUE" \
    "null_sceanrio;1"

  assert_rc "125"
}

@parametrize_with_keywords \
  test_parametrize__api_test__invalid__@vary__returns_status_code_125

# shellcheck disable=SC2034
test_parametrize__api_test__invalid__@vary__logs_error_message() {
  local STDLIB_LOGGING_MESSAGE_PREFIX="prefix"
  local "${TEST_KEYWORD_NAME}"="${INVALID_VALUE}"

  @parametrize test_function_mock_@vary \
    "TEST_VALUE" \
    "null_sceanrio;1"

  _testing.error.mock.assert_called_once_with \
    "1(prefix: $(stdlib.__message.get "${MESSAGE_KEYWORD}" "${INVALID_VALUE}")) 2(prefix: $(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID_DETAIL "${TEST_KEYWORD_NAME}"))"
}

@parametrize_with_keywords \
  test_parametrize__api_test__invalid__@vary__logs_error_message

# shellcheck disable=SC2034
test_parametrize__api_test__invalid__@vary__returns_status_code_123() {
  declare "${TEST_ARRAY_KEYWORD_NAME}"

  _capture.rc @parametrize test_function_mock_@vary \
    "TEST_VALUE" \
    "null_sceanrio;1"

  assert_rc "123"
}

@parametrize_with_reserved_arrays \
  test_parametrize__api_test__invalid__@vary__returns_status_code_123

# shellcheck disable=SC2034
test_parametrize__api_test__invalid__@vary__logs_expected_error() {
  local STDLIB_LOGGING_MESSAGE_PREFIX="prefix"
  declare "${TEST_ARRAY_KEYWORD_NAME}"

  @parametrize test_function_mock_@vary \
    "TEST_VALUE" \
    "null_sceanrio;1"

  _testing.error.mock.assert_called_once_with "1(prefix: $(stdlib.__message.get IS_NOT_ARRAY "${TEST_ARRAY_KEYWORD_NAME}")) 2(prefix: $(stdlib.__message.get VAR_VALUE_INVALID_RESERVED_DETAIL "${TEST_ARRAY_KEYWORD_NAME}"))"
}

@parametrize_with_reserved_arrays \
  test_parametrize__api_test__invalid__@vary__logs_expected_error
