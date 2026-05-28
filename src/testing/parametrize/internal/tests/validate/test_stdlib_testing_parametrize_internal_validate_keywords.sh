#!/bin/bash

setup() {
  _mock.create stdlib.testing.internal.logger.error
}

# shellcheck disable=SC2034
tearDown() {
  STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN=""
  STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR=""
  STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX=""
  STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN=""
  STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG=""
}

@parametrize_with_keywords() {

  @parametrize \
    "${1}" \
    "TEST_KEYWORD_NAME;VALID_VALUE;INVALID_VALUE;VALID_RC;INVALID_RC;MESSAGE_KEYWORD" \
    "debug_boolean____;STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN;1;non_boolean;0;125;IS_NOT_BOOLEAN" \
    "field_seperator__;STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR;|;too_many_chars;0;125;IS_NOT_CHAR" \
    "command_prefix___;STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX;valid_prefix;;0;0;;" \
    "test_name_boolean;STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN;1;non_boolean;0;125;IS_NOT_BOOLEAN" \
    "variant_tag______;STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG;valid_tag;;0;0;;"
}

assert_mocked_logger_error_matches() {
  local MESSAGE_KEYWORD="${1}"

  if ! stdlib.string.query.is_empty "${MESSAGE_KEYWORD}"; then
    stdlib.testing.internal.logger.error.mock.assert_calls_are \
      "1($(stdlib.__message.get "${MESSAGE_KEYWORD}" "${INVALID_VALUE}"))" \
      "1($(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID_DETAIL "${TEST_KEYWORD_NAME}"))"
  else
    stdlib.testing.internal.logger.error.mock.assert_not_called
  fi
}

# shellcheck disable=SC2034
test_parametrize_internal_validate_keywords__@vary__valid_value____returns_expected_status_code() {
  local "${TEST_KEYWORD_NAME}"

  printf -v "${TEST_KEYWORD_NAME}" "%s" "${VALID_VALUE}"
  @parametrize.__internal.default.keywords

  _capture.rc @parametrize.__internal.validate.keywords

  assert_rc "${VALID_RC}"
}

@parametrize_with_keywords \
  test_parametrize_internal_validate_keywords__@vary__valid_value____returns_expected_status_code

# shellcheck disable=SC2034
test_parametrize_internal_validate_keywords__@vary__valid_value____does_not_log_error() {
  local "${TEST_KEYWORD_NAME}"

  printf -v "${TEST_KEYWORD_NAME}" "%s" "${VALID_VALUE}"
  @parametrize.__internal.default.keywords

  @parametrize.__internal.validate.keywords

  stdlib.testing.internal.logger.error.mock.assert_not_called
}

@parametrize_with_keywords \
  test_parametrize_internal_validate_keywords__@vary__valid_value____does_not_log_error

# shellcheck disable=SC2034
test_parametrize_internal_validate_keywords__@vary__invalid_value__returns_expected_status_code() {
  local "${TEST_KEYWORD_NAME}"

  printf -v "${TEST_KEYWORD_NAME}" "%s" "${INVALID_VALUE}"
  @parametrize.__internal.default.keywords

  _capture.rc @parametrize.__internal.validate.keywords

  assert_rc "${INVALID_RC}"
}

@parametrize_with_keywords \
  test_parametrize_internal_validate_keywords__@vary__invalid_value__returns_expected_status_code

# shellcheck disable=SC2034
test_parametrize_internal_validate_keywords__@vary__invalid_value__logs_expected_error() {
  local "${TEST_KEYWORD_NAME}"

  printf -v "${TEST_KEYWORD_NAME}" "%s" "${INVALID_VALUE}"
  @parametrize.__internal.default.keywords

  @parametrize.__internal.validate.keywords

  assert_mocked_logger_error_matches "${MESSAGE_KEYWORD}"
}

@parametrize_with_keywords \
  test_parametrize_internal_validate_keywords__@vary__invalid_value__logs_expected_error
