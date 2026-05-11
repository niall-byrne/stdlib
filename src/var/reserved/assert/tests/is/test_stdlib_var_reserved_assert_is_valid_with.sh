#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
  _mock.create _mock_validator_passes
  _mock.create _mock_validator_fails

  _mock_validator_fails.mock.set.rc 1

  _TEST_ARRAY=("with value")
  _TEST_VAR="string"

  _TEST_EMPTY_VAR=""
  _TEST_EMPTY_ARRAY=()

  _TEST_DEFAULT_VAR="default"
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC_WITH_VALID_KW;TEST_MESSAGE_ARG_DEFINITION_WITH_VALID_KW;TEST_EXPECTED_RC_WITH_INVALID_KW;TEST_MESSAGE_ARG_DEFINITION_WITH_INVALID_KW" \
    "no_args_____________________________________________;;127;ARGUMENTS_INVALID;127;ARGUMENTS_INVALID" \
    "passing_validator__extra_arg________________________;_mock_validator_passes|_TEST_VAR|value|extra_arg;127;ARGUMENTS_INVALID;127;ARGUMENTS_INVALID" \
    "failing_validator__extra_arg________________________;_mock_validator_fails|_TEST_VAR|value|extra_arg;127;ARGUMENTS_INVALID;127;ARGUMENTS_INVALID" \
    "invalid_validator__extra_arg________________________;_non_existent_validator|_TEST_VAR|value|extra_arg;127;ARGUMENTS_INVALID;127;ARGUMENTS_INVALID" \
    "passing_validator__invalid_var_name__implicit_source;_mock_validator_passes|not a valid var;126;ARGUMENTS_INVALID;126;ARGUMENTS_INVALID" \
    "failing_validator__invalid_var_name__implicit_source;_mock_validator_fails|not a valid var;126;ARGUMENTS_INVALID;126;ARGUMENTS_INVALID" \
    "invalid_validator__invalid_var_name__implicit_source;_non_existent_validator|not a valid var;126;ARGUMENTS_INVALID;126;ARGUMENTS_INVALID" \
    "passing_validator__invalid_var_name__name_source____;_mock_validator_passes|not a valid var|name;126;ARGUMENTS_INVALID;126;ARGUMENTS_INVALID" \
    "failing_validator__invalid_var_name__name_source____;_mock_validator_fails|not a valid var|name;126;ARGUMENTS_INVALID;126;ARGUMENTS_INVALID" \
    "invalid_validator__invalid_var_name__name_source____;_non_existent_validator|not a valid var|name;126;ARGUMENTS_INVALID;126;ARGUMENTS_INVALID" \
    "passing_validator__invalid_var_name__value_source___;_mock_validator_passes|not a valid var|value;126;ARGUMENTS_INVALID;126;ARGUMENTS_INVALID" \
    "failing_validator__invalid_var_name__value_source___;_mock_validator_fails|not a valid var|value;126;ARGUMENTS_INVALID;126;ARGUMENTS_INVALID" \
    "invalid_validator__invalid_var_name__value_source___;_non_existent_validator|not a valid var|value;126;ARGUMENTS_INVALID;126;ARGUMENTS_INVALID" \
    "passing_validator__invalid_var_name__invalid_source_;_mock_validator_passes|not a valid var|invalid;126;ARGUMENTS_INVALID;126;ARGUMENTS_INVALID" \
    "failing_validator__invalid_var_name__invalid_source_;_mock_validator_fails|not a valid var|invalid;126;ARGUMENTS_INVALID;126;ARGUMENTS_INVALID" \
    "invalid_validator__invalid_var_name__invalid_source_;_non_existent_validator|not a valid var|invalid;126;ARGUMENTS_INVALID;126;ARGUMENTS_INVALID" \
    "passing_validator__valid_var_name____implicit_source;_mock_validator_passes|_TEST_VAR;0;;126;ARGUMENTS_INVALID" \
    "failing_validator__valid_var_name____implicit_source;_mock_validator_fails|_TEST_VAR;1;VAR_VALUE_INVALID_RESERVED_DETAIL|_TEST_VAR;126;ARGUMENTS_INVALID" \
    "invalid_validator__valid_var_name____implicit_source;_non_existent_validator|_TEST_VAR;126;ARGUMENTS_INVALID;126;ARGUMENTS_INVALID" \
    "passing_validator__valid_var_name____name_source____;_mock_validator_passes|_TEST_VAR|name;0;;126;ARGUMENTS_INVALID" \
    "failing_validator__valid_var_name____name_source____;_mock_validator_fails|_TEST_VAR|name;1;VAR_VALUE_INVALID_RESERVED_DETAIL|_TEST_VAR;126;ARGUMENTS_INVALID" \
    "invalid_validator__valid_var_name____name_source____;_non_existent_validator|_TEST_VAR|name;126;ARGUMENTS_INVALID;126;ARGUMENTS_INVALID" \
    "passing_validator__valid_var_name____value_source___;_mock_validator_passes|_TEST_VAR|value;0;;126;ARGUMENTS_INVALID" \
    "failing_validator__valid_var_name____value_source___;_mock_validator_fails|_TEST_VAR|value;1;VAR_VALUE_INVALID_RESERVED_DETAIL|_TEST_VAR;126;ARGUMENTS_INVALID" \
    "invalid_validator__valid_var_name____value_source___;_non_existent_validator|_TEST_VAR|value;126;ARGUMENTS_INVALID;126;ARGUMENTS_INVALID" \
    "passing_validator__valid_var_name____invalid_source_;_mock_validator_passes|_TEST_VAR|invalid;126;ARGUMENTS_INVALID;126;ARGUMENTS_INVALID" \
    "failing_validator__valid_var_name____invalid_source_;_mock_validator_fails|_TEST_VAR|invalid;126;ARGUMENTS_INVALID;126;ARGUMENTS_INVALID" \
    "invalid_validator__valid_var_name____invalid_source_;_non_existent_validator|_TEST_VAR|invalid;126;ARGUMENTS_INVALID;126;ARGUMENTS_INVALID"
}

# shellcheck disable=SC2153
test_stdlib_var_reserved_assert_is_valid_with__no_kw_______@vary__returns_expected_status_code() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.var.reserved.assert.__is_valid_with "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC_WITH_VALID_KW}"
}

@parametrize_with_arg_combos \
  test_stdlib_var_reserved_assert_is_valid_with__no_kw_______@vary__returns_expected_status_code

# shellcheck disable=SC2153
test_stdlib_var_reserved_assert_is_valid_with__no_kw_______@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION_WITH_VALID_KW}"
  stdlib.array.query.is_empty message_args || message_args=("$(stdlib.__message.get "${message_args[@]}")")

  stdlib.var.reserved.assert.__is_valid_with "${args[@]}" > /dev/null

  assert_logger_error_matches "${message_args[@]}"
}

@parametrize_with_arg_combos \
  test_stdlib_var_reserved_assert_is_valid_with__no_kw_______@vary__logs_an_error

# shellcheck disable=SC2034
test_stdlib_var_reserved_assert_is_valid_with__invalid_kw__@vary__returns_expected_status_code() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  STDLIB_VALIDATION_SOURCE_VAR="_UNSET_VAR" \
    _capture.rc stdlib.var.reserved.assert.__is_valid_with "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC_WITH_INVALID_KW}"
}

@parametrize_with_arg_combos \
  test_stdlib_var_reserved_assert_is_valid_with__invalid_kw__@vary__returns_expected_status_code

# shellcheck disable=SC2153
test_stdlib_var_reserved_assert_is_valid_with__invalid_kw__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION_WITH_INVALID_KW}"
  stdlib.array.query.is_empty message_args || message_args=("$(stdlib.__message.get "${message_args[@]}")")

  STDLIB_VALIDATION_SOURCE_VAR="_UNSET_VAR" \
    stdlib.var.reserved.assert.__is_valid_with "${args[@]}"

  assert_logger_error_matches "${message_args[@]}"
}

@parametrize_with_arg_combos \
  test_stdlib_var_reserved_assert_is_valid_with__invalid_kw__@vary__logs_an_error
