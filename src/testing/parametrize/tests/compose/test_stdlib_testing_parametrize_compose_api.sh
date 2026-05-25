#!/bin/bash

setup() {
  _mock.create _testing.error
  _mock.create test_function_mock_@vary__@vary
}

@parametrize_with_mock1() {
  @parametrize "${1}" \
    "TEST_VALUE1" \
    "null_sceanrio;1"
}

@parametrize_with_mock2() {
  @parametrize "${1}" \
    "TEST_VALUE2" \
    "null_sceanrio;1"
}

@parametrize_with_keywords() {
  @parametrize \
    "${1}" \
    "TEST_KEYWORD_NAME;INVALID_VALUE;MESSAGE_KEYWORD" \
    "debug_boolean______;STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN;non_boolean;IS_NOT_BOOLEAN" \
    "field_seperator____;STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR;too_many_chars;IS_NOT_CHAR" \
    "command_prefix_____;STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX;;IS_EMPTY_STRING" \
    "test_name_boolean__;STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN;non_boolean;IS_NOT_BOOLEAN" \
    "variant_tag________;STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG;;IS_EMPTY_STRING" \
    "parametrizer_prefix;STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX;;IS_EMPTY_STRING"
}

# shellcheck disable=SC2034
test_parametrize_compose__api_test__invalid__@vary__returns_status_code_125() {
  local "${TEST_KEYWORD_NAME}"="${INVALID_VALUE}"

  _capture.rc @parametrize.compose \
    test_function_mock_@vary__@vary \
    @parametrize_with_mock1 \
    @parametrize_with_mock2

  assert_rc "125"
}

@parametrize_with_keywords \
  test_parametrize_compose__api_test__invalid__@vary__returns_status_code_125

# shellcheck disable=SC2034
test_parametrize_compose__api_test__invalid__@vary__logs_error_message() {
  local STDLIB_LOGGING_MESSAGE_PREFIX="prefix"
  local "${TEST_KEYWORD_NAME}"="${INVALID_VALUE}"

  @parametrize.compose \
    test_function_mock_@vary__@vary \
    @parametrize_with_mock1 \
    @parametrize_with_mock2

  _testing.error.mock.assert_called_once_with \
    "1(prefix: $(stdlib.__message.get "${MESSAGE_KEYWORD}" "${INVALID_VALUE}")) 2(prefix: $(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID_DETAIL "${TEST_KEYWORD_NAME}"))"
}

@parametrize_with_keywords \
  test_parametrize_compose__api_test__invalid__@vary__logs_error_message
