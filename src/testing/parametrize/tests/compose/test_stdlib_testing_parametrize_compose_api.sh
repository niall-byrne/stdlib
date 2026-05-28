#!/bin/bash

setup() {
  _mock.create stdlib.testing.internal.logger.error
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
    "TEST_KEYWORD_NAME;VALID_VALUE;INVALID_VALUE;INVALID_RC;MESSAGE_KEYWORD" \
    "debug_boolean____;STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN;1;non_boolean;125;IS_NOT_BOOLEAN" \
    "field_seperator__;STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR;|;too_many_chars;125;IS_NOT_CHAR" \
    "command_prefix___;STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX;valid_prefix;;0;;" \
    "test_name_boolean;STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN;1;non_boolean;125;IS_NOT_BOOLEAN" \
    "variant_tag______;STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG;valid_tag;;0;;" \
    "parametrizer_prefix;STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX;;@parametrize_with_;0;;"
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
test_parametrize_compose__api_test__invalid_scalar__@vary__returns_expected_status_code() {
  local "${TEST_KEYWORD_NAME}"="${INVALID_VALUE}"

  @parametrize.__internal.default.keywords
  @parametrize.__internal.default.keywords_aggregation

  _capture.rc @parametrize.compose \
    test_function_mock_@vary__@vary \
    @parametrize_with_mock1 \
    @parametrize_with_mock2

  assert_rc "${INVALID_RC}"
}

@parametrize_with_keywords \
  test_parametrize_compose__api_test__invalid_scalar__@vary__returns_expected_status_code

# shellcheck disable=SC2034
test_parametrize_compose__api_test__invalid_scalar__@vary__logs_error_message() {
  local "${TEST_KEYWORD_NAME}"="${INVALID_VALUE}"

  @parametrize.__internal.default.keywords
  @parametrize.__internal.default.keywords_aggregation

  @parametrize.compose \
    test_function_mock_@vary__@vary \
    @parametrize_with_mock1 \
    @parametrize_with_mock2

  assert_mocked_logger_error_matches "${MESSAGE_KEYWORD}"
}

@parametrize_with_keywords \
  test_parametrize_compose__api_test__invalid_scalar__@vary__logs_error_message
