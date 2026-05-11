#!/bin/bash

setup() {
  _mock.create _mock_validator

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
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args____________________________returns_status_code_127;;127" \
    "extra_arg__________________________returns_status_code_127;_mock_validator|_TEST_VAR|value|extra_arg;127" \
    "invalid_var_name__implicit_source__returns_status_code_126;_mock_validator|not a valid var;126" \
    "invalid_var_name__name_source______returns_status_code_126;_mock_validator|not a valid var|name;126" \
    "invalid_var_name__value_source_____returns_status_code_126;_mock_validator|not a valid var|value;126" \
    "invalid_var_name__invalid_source___returns_status_code_126;_mock_validator|not a valid var|invalid;126" \
    "invalid_fn_name___implicit_source__returns_status_code_126;_non_existent_validator|_TEST_VAR;126" \
    "invalid_fn_name___name_source______returns_status_code_126;_non_existent_validator|_TEST_VAR|name;126" \
    "invalid_fn_name___value_source_____returns_status_code_126;_non_existent_validator|_TEST_VAR|value;126" \
    "invalid_fn_name___invalid_source___returns_status_code_126;_non_existent_validator|_TEST_VAR|invalid;126" \
    "valid_fn_and_var__invalid_source___returns_status_code_126;_mock_validator|_TEST_VAR|invalid;126"
}

@parametrize_with_source_types_and_no_default_failover() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_VALIDATOR_CALL;TEST_DEFAULT_EXPECTED_VALIDATOR_CALL" \
    "name_source______string;_mock_validator|_TEST_VAR|name;1(_TEST_VAR);1(_TEST_VAR)" \
    "name_source______array_;_mock_validator|_TEST_ARRAY|name;1(_TEST_ARRAY);1(_TEST_ARRAY)" \
    "value_source_____string;_mock_validator|_TEST_VAR|value;1(string);1(string)" \
    "implicit_source__string;_mock_validator|_TEST_VAR;1(string);1(string)"
}

@parametrize_with_source_types_and_default_failover() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_VALIDATOR_CALL;TEST_DEFAULT_EXPECTED_VALIDATOR_CALL" \
    "name_source______string;_mock_validator|_TEST_EMPTY_VAR|name;1(_TEST_EMPTY_VAR);1(_TEST_DEFAULT_VAR)" \
    "name_source______array_;_mock_validator|_TEST_EMPTY_ARRAY|name;1(_TEST_EMPTY_ARRAY);1(_TEST_DEFAULT_VAR)" \
    "value_source_____string;_mock_validator|_TEST_EMPTY_VAR|value;1();1(default)" \
    "implicit_source__string;_mock_validator|_TEST_EMPTY_VAR;1();1(default)"
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
test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__no_default_______________calls_validator() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  _mock_validator.mock.set.rc 0

  stdlib.var.query.is_valid_with "${args[@]}"

  _mock_validator.mock.assert_called_once_with "${TEST_EXPECTED_VALIDATOR_CALL}"
}

@parametrize_with_source_types_and_no_default_failover \
  test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__no_default_______________calls_validator

test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__no_default_______________validator_passes____returns_status_code___0() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  _mock_validator.mock.set.rc 0

  _capture.rc stdlib.var.query.is_valid_with "${args[@]}"

  assert_rc "0"
}

@parametrize_with_source_types_and_no_default_failover \
  test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__no_default_______________validator_passes____returns_status_code___0

# shellcheck disable=SC2034
test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__no_default_______________validator_fails_____returns_status_code___1() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  _mock_validator.mock.set.rc 1

  _capture.rc stdlib.var.query.is_valid_with "${args[@]}"

  assert_rc "1"
}

@parametrize_with_source_types_and_no_default_failover \
  test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__no_default_______________validator_fails_____returns_status_code___1

# shellcheck disable=SC2034
test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__no_default_______________validator_args______returns_status_code_127() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  _mock_validator.mock.set.rc 127

  _capture.rc stdlib.var.query.is_valid_with "${args[@]}"

  assert_rc "127"
}

@parametrize_with_source_types_and_no_default_failover \
  test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__no_default_______________validator_args______returns_status_code_127

test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__no_default_______________unset_source_var____returns_status_code_126() {
  local args=()

  TEST_ARGS_DEFINITION="${TEST_ARGS_DEFINITION//_TEST_VAR/_TEST_UNSET_VAR/}"
  TEST_ARGS_DEFINITION="${TEST_ARGS_DEFINITION//_TEST_ARRAY/_TEST_UNSET_VAR/}"

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  _mock_validator.mock.set.rc 0

  _capture.rc stdlib.var.query.is_valid_with "${args[@]}"

  assert_rc "126"
}

@parametrize_with_source_types_and_no_default_failover \
  test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__no_default_______________unset_source_var____returns_status_code_126

# shellcheck disable=SC2034
test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__default_failover_________calls_validator() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  _mock_validator.mock.set.rc 0

  STDLIB_VALIDATION_SOURCE_VAR="_TEST_DEFAULT_VAR" \
    stdlib.var.query.is_valid_with "${args[@]}"

  _mock_validator.mock.assert_called_once_with "${TEST_DEFAULT_EXPECTED_VALIDATOR_CALL}"
}

@parametrize_with_source_types_and_default_failover \
  test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__default_failover_________calls_validator

# shellcheck disable=SC2034
test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__default_failover_________unset_default_var___returns_status_code_125() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  _mock_validator.mock.set.rc 0

  STDLIB_VALIDATION_SOURCE_VAR="_UNSET_VAR" \
    _capture.rc stdlib.var.query.is_valid_with "${args[@]}"

  assert_rc "125"
}

@parametrize_with_source_types_and_default_failover \
  test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__default_failover_________unset_default_var___returns_status_code_125

test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__default_failover_________validator_passes____returns_status_code___0() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  _mock_validator.mock.set.rc 0

  STDLIB_VALIDATION_SOURCE_VAR="_TEST_DEFAULT_VAR" \
    _capture.rc stdlib.var.query.is_valid_with "${args[@]}"

  assert_rc "0"
}

@parametrize_with_source_types_and_default_failover \
  test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__default_failover_________validator_passes____returns_status_code___0

# shellcheck disable=SC2034
test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__default_failover_________validator_fails_____returns_status_code___1() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  _mock_validator.mock.set.rc 1

  STDLIB_VALIDATION_SOURCE_VAR="_TEST_DEFAULT_VAR" \
    _capture.rc stdlib.var.query.is_valid_with "${args[@]}"

  assert_rc "1"
}

@parametrize_with_source_types_and_default_failover \
  test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__default_failover_________validator_fails_____returns_status_code___1

# shellcheck disable=SC2034
test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__default_failover_________validator_args______returns_status_code_127() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  _mock_validator.mock.set.rc 127

  STDLIB_VALIDATION_SOURCE_VAR="_TEST_DEFAULT_VAR" \
    _capture.rc stdlib.var.query.is_valid_with "${args[@]}"

  assert_rc "127"
}

@parametrize_with_source_types_and_default_failover \
  test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__default_failover_________validator_args______returns_status_code_127

test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__default_failover_________unset_source_var____returns_status_code___0() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION//_TEST_VAR/_TEST_UNSET_VAR/}"
  _mock_validator.mock.set.rc 0

  STDLIB_VALIDATION_SOURCE_VAR="_TEST_DEFAULT_VAR" \
    _capture.rc stdlib.var.query.is_valid_with "${args[@]}"

  assert_rc "0"
}

@parametrize_with_source_types_and_default_failover \
  test_stdlib_var_query_is_valid_with__valid_fn_and_var__@vary__default_failover_________unset_source_var____returns_status_code___0
