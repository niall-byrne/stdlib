#!/bin/bash

setup() {
  _mock.create _mock_validator
  _mock.create stdlib.logger.error

  _TEST_VAR="string"
  _TEST_EMPTY_VAR=""
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args___________returns_status_code_127;;127" \
    "extra_arg_________returns_status_code_127;_mock_validator|_TEST_VAR|extra_arg;127" \
    "invalid_var_name__returns_status_code_126;|_mock_validator;126" \
    "invalid_fn_name___returns_status_code___1;_TEST_VAR|_non_existent_validator;126"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args_________;;ARGUMENTS_INVALID" \
    "extra_arg_______;_mock_validator|_TEST_VAR|extra_arg;ARGUMENTS_INVALID" \
    "invalid_var_name;_mock_validator|not a valid var;ARGUMENTS_INVALID" \
    "invalid_fn_name_;_non_existent_validator|_TEST_VAR;ARGUMENTS_INVALID"
}

@parametrize_with_call_types() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_CALL_TYPE" \
    "by_name;1" \
    "by_value;0"
}

# shellcheck disable=SC2153
test_stdlib_var_assert_reserved_is_valid_with__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.var.assert.__reserved.is_valid_with "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_var_assert_reserved_is_valid_with__@vary

# shellcheck disable=SC2153
test_stdlib_var_assert_reserved_is_valid_with__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.var.assert.__reserved.is_valid_with "${args[@]}"

  stdlib.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_var_assert_reserved_is_valid_with__@vary__logs_an_error

# shellcheck disable=SC2034
test_stdlib_var_assert_reserved_is_valid_with__valid_args________no_default__by_name___calls_validator_as_expected() {
  _mock_validator.mock.set.rc 0

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN=1 \
    stdlib.var.assert.__reserved.is_valid_with _mock_validator _TEST_VAR

  _mock_validator.mock.assert_called_once_with "1(_TEST_VAR)"
}

# shellcheck disable=SC2034
test_stdlib_var_assert_reserved_is_valid_with__valid_args________no_default__by_value__calls_validator_as_expected() {
  _mock_validator.mock.set.rc 0

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN=0 \
    stdlib.var.assert.__reserved.is_valid_with _mock_validator _TEST_VAR

  _mock_validator.mock.assert_called_once_with "1(${_TEST_VAR})"
}

# shellcheck disable=SC2034
test_stdlib_var_assert_reserved_is_valid_with__valid_args________no_default__@vary__validator_passes__return_status_code___0() {
  _mock_validator.mock.set.rc 0

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN="${TEST_CALL_TYPE}" \
    _capture.rc stdlib.var.assert.__reserved.is_valid_with _mock_validator _TEST_VAR

  assert_rc "0"
}

@parametrize_with_call_types \
  test_stdlib_var_assert_reserved_is_valid_with__valid_args________no_default__@vary__validator_passes__return_status_code___0

# shellcheck disable=SC2034
test_stdlib_var_assert_reserved_is_valid_with__valid_args________no_default__@vary__validator_passes__logs_no_error_message() {
  _mock_validator.mock.set.rc 0

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN="${TEST_CALL_TYPE}" \
    stdlib.var.assert.__reserved.is_valid_with _mock_validator _TEST_VAR

  stdlib.logger.error.mock.assert_not_called
}

@parametrize_with_call_types \
  test_stdlib_var_assert_reserved_is_valid_with__valid_args________no_default__@vary__validator_passes__logs_no_error_message

# shellcheck disable=SC2034
test_stdlib_var_assert_reserved_is_valid_with__valid_args________no_default__@vary__validator_fails___validation_error__return_status_code___1() {
  _mock_validator.mock.set.rc 1

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN="${TEST_CALL_TYPE}" \
    _capture.rc stdlib.var.assert.__reserved.is_valid_with _mock_validator _TEST_VAR

  assert_rc "1"
}

@parametrize_with_call_types \
  test_stdlib_var_assert_reserved_is_valid_with__valid_args________no_default__@vary__validator_fails___validation_error__return_status_code___1

# shellcheck disable=SC2034
test_stdlib_var_assert_reserved_is_valid_with__valid_args________no_default__@vary__validator_fails___validation_error__logs_error_message() {
  _mock_validator.mock.set.rc 1

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN="${TEST_CALL_TYPE}" \
    stdlib.var.assert.__reserved.is_valid_with _mock_validator _TEST_VAR

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get VAR_VALUE_INVALID_RESERVED_DETAIL _TEST_VAR))"
}

@parametrize_with_call_types \
  test_stdlib_var_assert_reserved_is_valid_with__valid_args________no_default__@vary__validator_fails___validation_error__logs_error_message

# shellcheck disable=SC2034
test_stdlib_var_assert_reserved_is_valid_with__valid_args________no_default__@vary__validator_fails___validation_args___return_status_code_127() {
  _mock_validator.mock.set.rc 127

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN="${TEST_CALL_TYPE}" \
    _capture.rc stdlib.var.assert.__reserved.is_valid_with _mock_validator _TEST_VAR

  assert_rc "127"
}

@parametrize_with_call_types \
  test_stdlib_var_assert_reserved_is_valid_with__valid_args________no_default__@vary__validator_fails___validation_args___return_status_code_127

# shellcheck disable=SC2034
test_stdlib_var_assert_reserved_is_valid_with__valid_args________no_default__@vary__validator_fails___validation_args___logs_error_message() {
  _mock_validator.mock.set.rc 127

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN="${TEST_CALL_TYPE}" \
    stdlib.var.assert.__reserved.is_valid_with _mock_validator _TEST_VAR

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get ARGUMENTS_INVALID))"
}

@parametrize_with_call_types \
  test_stdlib_var_assert_reserved_is_valid_with__valid_args________no_default__@vary__validator_fails___validation_args___logs_error_message

# shellcheck disable=SC2034
test_stdlib_var_assert_reserved_is_valid_with__valid_args________default_____by_name___calls_validator_as_expected() {
  _mock_validator.mock.set.rc 0

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN=1 \
    STDLIB_VAR_VALIDATE_DEFAULT_VAR="_TEST_VAR" \
    stdlib.var.assert.__reserved.is_valid_with _mock_validator _TEST_EMPTY_VAR

  _mock_validator.mock.assert_called_once_with "1(_TEST_VAR)"
}

# shellcheck disable=SC2034
test_stdlib_var_assert_reserved_is_valid_with__valid_args________default_____by_value__calls_validator_as_expected() {
  _mock_validator.mock.set.rc 0

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN=0 \
    STDLIB_VAR_VALIDATE_DEFAULT_VAR="_TEST_VAR" \
    stdlib.var.assert.__reserved.is_valid_with _mock_validator _TEST_EMPTY_VAR

  _mock_validator.mock.assert_called_once_with "1(string)"
}

# shellcheck disable=SC2034
test_stdlib_var_assert_reserved_is_valid_with__valid_args________default_____@vary__validator_passes__return_status_code___0() {
  _mock_validator.mock.set.rc 0

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN="${TEST_CALL_TYPE}" \
    STDLIB_VAR_VALIDATE_DEFAULT_VAR="_TEST_VAR" \
    _capture.rc stdlib.var.assert.__reserved.is_valid_with _mock_validator _TEST_EMPTY_VAR

  assert_rc "0"
}

@parametrize_with_call_types \
  test_stdlib_var_assert_reserved_is_valid_with__valid_args________default_____@vary__validator_passes__return_status_code___0

# shellcheck disable=SC2034
test_stdlib_var_assert_reserved_is_valid_with__valid_args________default_____@vary__validator_passes__logs_no_error_message() {
  _mock_validator.mock.set.rc 0

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN="${TEST_CALL_TYPE}" \
    STDLIB_VAR_VALIDATE_DEFAULT_VAR="_TEST_VAR" \
    stdlib.var.assert.__reserved.is_valid_with _mock_validator _TEST_EMPTY_VAR

  stdlib.logger.error.mock.assert_not_called
}

@parametrize_with_call_types \
  test_stdlib_var_assert_reserved_is_valid_with__valid_args________default_____@vary__validator_passes__logs_no_error_message

# shellcheck disable=SC2034
test_stdlib_var_assert_reserved_is_valid_with__valid_args________default_____@vary__validator_fails___validation_error__return_status_code___1() {
  _mock_validator.mock.set.rc 1

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN="${TEST_CALL_TYPE}" \
    STDLIB_VAR_VALIDATE_DEFAULT_VAR="_TEST_VAR" \
    _capture.rc stdlib.var.assert.__reserved.is_valid_with _mock_validator _TEST_EMPTY_VAR

  assert_rc "1"
}

@parametrize_with_call_types \
  test_stdlib_var_assert_reserved_is_valid_with__valid_args________default_____@vary__validator_fails___validation_error__return_status_code___1

# shellcheck disable=SC2034
test_stdlib_var_assert_reserved_is_valid_with__valid_args________default_____@vary__validator_fails___validation_error__logs_error_message() {
  _mock_validator.mock.set.rc 1

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN="${TEST_CALL_TYPE}" \
    STDLIB_VAR_VALIDATE_DEFAULT_VAR="_TEST_VAR" \
    stdlib.var.assert.__reserved.is_valid_with _mock_validator _TEST_EMPTY_VAR

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get VAR_VALUE_INVALID_RESERVED_DETAIL _TEST_EMPTY_VAR))"
}

@parametrize_with_call_types \
  test_stdlib_var_assert_reserved_is_valid_with__valid_args________default_____@vary__validator_fails___validation_error__logs_error_message

# shellcheck disable=SC2034
test_stdlib_var_assert_reserved_is_valid_with__valid_args________default_____@vary__validator_fails___validation_args___return_status_code_127() {
  _mock_validator.mock.set.rc 127

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN="${TEST_CALL_TYPE}" \
    STDLIB_VAR_VALIDATE_DEFAULT_VAR="_TEST_VAR" \
    _capture.rc stdlib.var.assert.__reserved.is_valid_with _mock_validator _TEST_EMPTY_VAR

  assert_rc "127"
}

@parametrize_with_call_types \
  test_stdlib_var_assert_reserved_is_valid_with__valid_args________default_____@vary__validator_fails___validation_args___return_status_code_127

# shellcheck disable=SC2034
test_stdlib_var_assert_reserved_is_valid_with__valid_args________default_____@vary__validator_fails___validation_args___logs_error_message() {
  _mock_validator.mock.set.rc 127

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN="${TEST_CALL_TYPE}" \
    STDLIB_VAR_VALIDATE_DEFAULT_VAR="_TEST_VAR" \
    stdlib.var.assert.__reserved.is_valid_with _mock_validator _TEST_EMPTY_VAR

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get ARGUMENTS_INVALID))"
}

@parametrize_with_call_types \
  test_stdlib_var_assert_reserved_is_valid_with__valid_args________default_____@vary__validator_fails___validation_args___logs_error_message
