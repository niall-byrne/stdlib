#!/bin/bash

setup() {
  _mock.create _mock_validator

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
    "invalid_var_name__returns_status_code_126;_mock_validator|not a valid var;126" \
    "invalid_fn_name___returns_status_code_126;_non_existent_validator|_TEST_VAR;126"
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
test_stdlib_var_query_is_valid_with__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.var.query.is_valid_with "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_var_query_is_valid_with__@vary

# shellcheck disable=SC2034
test_stdlib_var_query_is_valid_with__valid_args________no_default__by_name___calls_validator_as_expected() {
  _mock_validator.mock.set.rc 0

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN=1 \
    stdlib.var.query.is_valid_with _mock_validator _TEST_VAR

  _mock_validator.mock.assert_called_once_with "1(_TEST_VAR)"
}

# shellcheck disable=SC2034
test_stdlib_var_query_is_valid_with__valid_args________no_default__by_value__calls_validator_as_expected() {
  _mock_validator.mock.set.rc 0

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN=0 \
    stdlib.var.query.is_valid_with _mock_validator _TEST_VAR

  _mock_validator.mock.assert_called_once_with "1(${_TEST_VAR})"
}

# shellcheck disable=SC2034
test_stdlib_var_query_is_valid_with__valid_args________no_default__@vary__validator_passes________________return_status_code___0() {
  _mock_validator.mock.set.rc 0

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN="${TEST_CALL_TYPE}" \
    _capture.rc stdlib.var.query.is_valid_with _mock_validator _TEST_VAR

  assert_rc "0"
}

@parametrize_with_call_types \
  test_stdlib_var_query_is_valid_with__valid_args________no_default__@vary__validator_passes________________return_status_code___0

# shellcheck disable=SC2034
test_stdlib_var_query_is_valid_with__valid_args________no_default__@vary__validator_fails_________________validation_error__return_status_code___1() {
  _mock_validator.mock.set.rc 1

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN="${TEST_CALL_TYPE}" \
    _capture.rc stdlib.var.query.is_valid_with _mock_validator _TEST_VAR

  assert_rc "1"
}

@parametrize_with_call_types \
  test_stdlib_var_query_is_valid_with__valid_args________no_default__@vary__validator_fails_________________validation_error__return_status_code___1

# shellcheck disable=SC2034
test_stdlib_var_query_is_valid_with__valid_args________no_default__@vary__validator_fails_________________validation_args___return_status_code_127() {
  _mock_validator.mock.set.rc 127

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN="${TEST_CALL_TYPE}" \
    _capture.rc stdlib.var.query.is_valid_with _mock_validator _TEST_VAR

  assert_rc "127"
}

@parametrize_with_call_types \
  test_stdlib_var_query_is_valid_with__valid_args________no_default__@vary__validator_fails_________________validation_args___return_status_code_127

# shellcheck disable=SC2034
test_stdlib_var_query_is_valid_with__valid_args________default_____@vary__unset_variable__________________returns_status_code_126() {
  _mock_validator.mock.set.rc 0

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN="${TEST_CALL_TYPE}" \
    STDLIB_VAR_VALIDATE_DEFAULT_VAR="NON_EXISTENT" \
    _capture.rc stdlib.var.query.is_valid_with _mock_validator _TEST_EMPTY_VAR

  assert_rc "126"
}

@parametrize_with_call_types \
  test_stdlib_var_query_is_valid_with__valid_args________default_____@vary__unset_variable__________________returns_status_code_126

# shellcheck disable=SC2034
test_stdlib_var_query_is_valid_with__valid_args________default_____by_name___calls_validator_as_expected() {
  _mock_validator.mock.set.rc 0

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN=1 \
    STDLIB_VAR_VALIDATE_DEFAULT_VAR="_TEST_VAR" \
    stdlib.var.query.is_valid_with _mock_validator _TEST_EMPTY_VAR

  _mock_validator.mock.assert_called_once_with "1(_TEST_VAR)"
}

# shellcheck disable=SC2034
test_stdlib_var_query_is_valid_with__valid_args________default_____by_value__calls_validator_as_expected() {
  _mock_validator.mock.set.rc 0

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN=0 \
    STDLIB_VAR_VALIDATE_DEFAULT_VAR="_TEST_VAR" \
    stdlib.var.query.is_valid_with _mock_validator _TEST_EMPTY_VAR

  _mock_validator.mock.assert_called_once_with "1(string)"
}

# shellcheck disable=SC2034
test_stdlib_var_query_is_valid_with__valid_args________default_____@vary__validator_passes________________return_status_code___0() {
  _mock_validator.mock.set.rc 0

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN="${TEST_CALL_TYPE}" \
    STDLIB_VAR_VALIDATE_DEFAULT_VAR="_TEST_VAR" \
    _capture.rc stdlib.var.query.is_valid_with _mock_validator _TEST_EMPTY_VAR

  assert_rc "0"
}

@parametrize_with_call_types \
  test_stdlib_var_query_is_valid_with__valid_args________default_____@vary__validator_passes________________return_status_code___0

# shellcheck disable=SC2034
test_stdlib_var_query_is_valid_with__valid_args________default_____@vary__validator_fails_________________validation_error__return_status_code___1() {
  _mock_validator.mock.set.rc 1

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN="${TEST_CALL_TYPE}" \
    STDLIB_VAR_VALIDATE_DEFAULT_VAR="_TEST_VAR" \
    _capture.rc stdlib.var.query.is_valid_with _mock_validator _TEST_EMPTY_VAR

  assert_rc "1"
}

@parametrize_with_call_types \
  test_stdlib_var_query_is_valid_with__valid_args________default_____@vary__validator_fails_________________validation_error__return_status_code___1

# shellcheck disable=SC2034
test_stdlib_var_query_is_valid_with__valid_args________default_____@vary__validator_fails_________________validation_args___return_status_code_127() {
  _mock_validator.mock.set.rc 127

  STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN="${TEST_CALL_TYPE}" \
    STDLIB_VAR_VALIDATE_DEFAULT_VAR="_TEST_VAR" \
    _capture.rc stdlib.var.query.is_valid_with _mock_validator _TEST_EMPTY_VAR

  assert_rc "127"
}

@parametrize_with_call_types \
  test_stdlib_var_query_is_valid_with__valid_args________default_____@vary__validator_fails_________________validation_args___return_status_code_127
