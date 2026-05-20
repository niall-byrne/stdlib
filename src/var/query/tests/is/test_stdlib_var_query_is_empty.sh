#!/bin/bash

setup() {
  _TEST_SET_VAR="exists"
  _TEST_EMPTY_VAR=""
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_______returns_status_code_127;;127" \
    "extra_arg_____returns_status_code_127;_TEST_SET_VAR|extra_arg;127" \
    "invalid_name__returns_status_code_126;not a valid name;126" \
    "not_set_______returns_status_code_126;_NOT_SET_VAR;126" \
    "not_empty_____returns_status_code___1;_TEST_SET_VAR;1" \
    "empty_var_____returns_status_code___0;_TEST_EMPTY_VAR;0"
}

# shellcheck disable=SC2153
test_stdlib_var_query_is_empty__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.var.query.is_empty "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_var_query_is_empty__@vary
