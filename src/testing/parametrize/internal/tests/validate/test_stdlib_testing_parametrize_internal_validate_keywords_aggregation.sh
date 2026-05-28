#!/bin/bash

setup() {
  _mock.create stdlib.testing.internal.logger.error
}

@parametrize_with_safe_keywords() {

  @parametrize \
    "${1}" \
    "TEST_KEYWORD_NAME;VALID_VALUE;INVALID_VALUE;MESSAGE_KEYWORD" \
    "parametrizer_prefix;STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX;valid_prefix;;IS_EMPTY_STRING"
}

# shellcheck disable=SC2034
test_parametrize_internal_validate_keywords_aggregation__@vary__valid_value____returns_status_code___0() {
  local "${TEST_KEYWORD_NAME}"

  printf -v "${TEST_KEYWORD_NAME}" "%s" "${VALID_VALUE}"
  @parametrize.__internal.default.keywords_aggregation

  _capture.rc @parametrize.__internal.validate.keywords_aggregation

  assert_rc "0"
}

@parametrize_with_safe_keywords \
  test_parametrize_internal_validate_keywords_aggregation__@vary__valid_value____returns_status_code___0

# shellcheck disable=SC2034
test_parametrize_internal_validate_keywords_aggregation__@vary__valid_value____does_not_log_error() {
  local "${TEST_KEYWORD_NAME}"

  printf -v "${TEST_KEYWORD_NAME}" "%s" "${VALID_VALUE}"
  @parametrize.__internal.default.keywords_aggregation

  @parametrize.__internal.validate.keywords_aggregation

  stdlib.testing.internal.logger.error.mock.assert_not_called
}

@parametrize_with_safe_keywords \
  test_parametrize_internal_validate_keywords_aggregation__@vary__valid_value____does_not_log_error

# shellcheck disable=SC2034
test_parametrize_internal_validate_keywords_aggregation__@vary__invalid_value__returns_status_code___0() {
  local "${TEST_KEYWORD_NAME}"

  printf -v "${TEST_KEYWORD_NAME}" "%s" "${INVALID_VALUE}"
  @parametrize.__internal.default.keywords_aggregation

  _capture.rc @parametrize.__internal.validate.keywords_aggregation

  assert_rc "0"
}

@parametrize_with_safe_keywords \
  test_parametrize_internal_validate_keywords_aggregation__@vary__invalid_value__returns_status_code___0

# shellcheck disable=SC2034
test_parametrize_internal_validate_keywords_aggregation__@vary__invalid_value__does_not_log_error() {
  local prefix="${FUNCNAME[1]}"
  local "${TEST_KEYWORD_NAME}"

  printf -v "${TEST_KEYWORD_NAME}" "%s" "${INVALID_VALUE}"
  @parametrize.__internal.default.keywords_aggregation

  @parametrize.__internal.validate.keywords_aggregation

  stdlib.testing.internal.logger.error.mock.assert_not_called
}

@parametrize_with_safe_keywords \
  test_parametrize_internal_validate_keywords_aggregation__@vary__invalid_value__does_not_log_error
