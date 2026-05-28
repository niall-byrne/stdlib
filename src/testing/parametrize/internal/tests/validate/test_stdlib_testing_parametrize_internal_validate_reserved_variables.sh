#!/bin/bash

setup() {
  _mock.create stdlib.testing.internal.logger.error
}

@parametrize_with_reserved_arrays() {

  @parametrize \
    "${1}" \
    "TEST_ARRAY_KEYWORD_NAME" \
    "generated_functions_array;__STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY"
}

# shellcheck disable=SC2034
test_parametrize_internal_validate_reserved_variables__arrays__@vary__valid_value____returns_status_code___0() {
  declare -a "${TEST_ARRAY_KEYWORD_NAME}"

  _capture.rc @parametrize.__internal.validate.reserved_variables

  assert_rc "0"
}

@parametrize_with_reserved_arrays \
  test_parametrize_internal_validate_reserved_variables__arrays__@vary__valid_value____returns_status_code___0

# shellcheck disable=SC2034
test_parametrize_internal_validate_reserved_variables__arrays__@vary__valid_value____does_not_log_error() {
  declare -a "${TEST_ARRAY_KEYWORD_NAME}"

  @parametrize.__internal.validate.reserved_variables

  stdlib.testing.internal.logger.error.mock.assert_not_called
}

@parametrize_with_reserved_arrays \
  test_parametrize_internal_validate_reserved_variables__arrays__@vary__valid_value____does_not_log_error

# shellcheck disable=SC2034
test_parametrize_internal_validate_reserved_variables__arrays__@vary__invalid_value__returns_status_code_123() {
  declare "${TEST_ARRAY_KEYWORD_NAME}"

  _capture.rc @parametrize.__internal.validate.reserved_variables

  assert_rc "123"
}

@parametrize_with_reserved_arrays \
  test_parametrize_internal_validate_reserved_variables__arrays__@vary__invalid_value__returns_status_code_123

# shellcheck disable=SC2034
test_parametrize_internal_validate_reserved_variables__arrays__@vary__invalid_value__logs_expected_error() {
  declare "${TEST_ARRAY_KEYWORD_NAME}"

  @parametrize.__internal.validate.reserved_variables

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get IS_NOT_ARRAY "${TEST_ARRAY_KEYWORD_NAME}"))" \
    "1($(stdlib.__message.get VAR_VALUE_INVALID_RESERVED_DETAIL "${TEST_ARRAY_KEYWORD_NAME}"))"
}

@parametrize_with_reserved_arrays \
  test_parametrize_internal_validate_reserved_variables__arrays__@vary__invalid_value__logs_expected_error
