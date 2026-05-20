#!/bin/bash

setup() {
  _mock.create stdlib.logger.error

  # shellcheck disable=SC2178
  {
    declare -gA _TEST_SET_HASH
    declare -gA _TEST_SET_HASH_EDGE_CASE
    declare -gA _TEST_EMPTY_HASH
    _TEST_SET_HASH=([key1]="value1" [key2]="value2")
    _TEST_SET_HASH_EDGE_CASE=([key1]="")
  } || {
    _TEST_SET_HASH="associative arrays not supported"
    _TEST_SET_HASH_EDGE_CASE="associative arrays not supported"
    _TEST_EMPTY_HASH=""
  }

  _TEST_SET_ARRAY=("exists")
  _TEST_SET_ARRAY_EDGE_CASE=("")

  _TEST_SET_VAR="exists"

  _TEST_EMPTY_ARRAY=()
  _TEST_EMPTY_VAR=""
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args___________________returns_status_code_127;;127" \
    "extra_arg_________________returns_status_code_127;_TEST_SET_VAR|extra_arg;127" \
    "invalid_name______________returns_status_code_126;not a valid name;126" \
    "not_set___________________returns_status_code___0;_NOT_SET_VAR;0" \
    "not_empty_____string______returns_status_code___1;_TEST_SET_VAR;1" \
    "not_empty_____array_______returns_status_code___1;_TEST_SET_VAR;1" \
    "not_empty_____null_array__returns_status_code___1;_TEST_SET_ARRAY_EDGE_CASE;1" \
    "not_empty_____hash________returns_status_code___1;_TEST_SET_HASH;1" \
    "not_empty_____null_hash__returns_status_code____1;_TEST_SET_HASH_EDGE_CASE;1" \
    "empty_________string______returns_status_code___0;_TEST_EMPTY_VAR;0" \
    "empty_________array_______returns_status_code___0;_TEST_EMPTY_ARRAY;0" \
    "empty_________hash________returns_status_code___0;_TEST_EMPTY_HASH;0"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args_________________;;ARGUMENTS_INVALID" \
    "extra_arg_______________;_TEST_EMPTY_VAR|extra_arg;ARGUMENTS_INVALID" \
    "invalid_name____________;not a valid name;ARGUMENTS_INVALID" \
    "not_empty_______________;_TEST_SET_VAR;VAR_VALUE_NOT_EMPTY|_TEST_SET_VAR"
}

# shellcheck disable=SC2153
test_stdlib_var_assert_is_empty__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.var.assert.is_empty "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_var_assert_is_empty__@vary

# shellcheck disable=SC2153
test_stdlib_var_assert_is_empty__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.var.assert.is_empty "${args[@]}"

  stdlib.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_var_assert_is_empty__@vary__logs_an_error

test_stdlib_var_assert_is_empty__is_empty__________________logs_no_error_message() {
  stdlib.var.assert.is_empty _TEST_EMPTY_VAR

  stdlib.logger.error.mock.assert_not_called
}
