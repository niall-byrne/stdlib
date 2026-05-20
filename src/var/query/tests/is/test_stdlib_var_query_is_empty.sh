#!/bin/bash

setup() {
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

# shellcheck disable=SC2153
test_stdlib_var_query_is_empty__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.var.query.is_empty "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_var_query_is_empty__@vary
