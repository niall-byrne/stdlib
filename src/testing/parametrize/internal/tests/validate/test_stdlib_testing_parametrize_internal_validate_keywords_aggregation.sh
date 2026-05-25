#!/bin/bash

setup() {
  _mock.create _testing.error
}

@parametrize_with_keywords() {

  @parametrize \
    "${1}" \
    "TEST_KEYWORD_NAME;VALID_VALUE;INVALID_VALUE;MESSAGE_KEYWORD" \
    "parametrizer_prefix;STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX;valid_prefix;;IS_EMPTY_STRING"
}

# shellcheck disable=SC2034
test_parametrize_internal_validate_keywords_aggregation__@vary__valid_value____returns_status_code___0() {
  local "${TEST_KEYWORD_NAME}"

  printf -v "${TEST_KEYWORD_NAME}" "%s" "${VALID_VALUE}"

  _capture.rc @parametrize.__internal.validate.keywords_aggregation

  assert_rc "0"
}

@parametrize_with_keywords \
  test_parametrize_internal_validate_keywords_aggregation__@vary__valid_value____returns_status_code___0

# shellcheck disable=SC2034
test_parametrize_internal_validate_keywords_aggregation__@vary__valid_value____does_not_log_error() {
  local "${TEST_KEYWORD_NAME}"

  printf -v "${TEST_KEYWORD_NAME}" "%s" "${VALID_VALUE}"

  @parametrize.__internal.validate.keywords_aggregation

  _testing.error.mock.assert_not_called
}

@parametrize_with_keywords \
  test_parametrize_internal_validate_keywords_aggregation__@vary__valid_value____does_not_log_error

# shellcheck disable=SC2034
test_parametrize_internal_validate_keywords_aggregation__@vary__invalid_value__returns_status_code_125() {
  local "${TEST_KEYWORD_NAME}"

  printf -v "${TEST_KEYWORD_NAME}" "%s" "${INVALID_VALUE}"

  _capture.rc @parametrize.__internal.validate.keywords_aggregation

  assert_rc "125"
}

@parametrize_with_keywords \
  test_parametrize_internal_validate_keywords_aggregation__@vary__invalid_value__returns_status_code_125

# shellcheck disable=SC2034
test_parametrize_internal_validate_keywords_aggregation__@vary__invalid_value__logs_expected_error() {
  local prefix="${FUNCNAME[1]}"
  local "${TEST_KEYWORD_NAME}"

  printf -v "${TEST_KEYWORD_NAME}" "%s" "${INVALID_VALUE}"

  @parametrize.__internal.validate.keywords_aggregation

  _testing.error.mock.assert_called_once_with "1(${prefix}: $(stdlib.__message.get "${MESSAGE_KEYWORD}" "${INVALID_VALUE}")) 2(${prefix}: $(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID_DETAIL "${TEST_KEYWORD_NAME}"))"
}

@parametrize_with_keywords \
  test_parametrize_internal_validate_keywords_aggregation__@vary__invalid_value__logs_expected_error
