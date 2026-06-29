#!/bin/bash

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_________returns_status_code_127;;127" \
    "extra_arg_______returns_status_code_127;a|a|extra_arg;127" \
    "empty_strings___returns_status_code___1;||;1" \
    "equal_strings___returns_status_code___1;a|a;1" \
    "unequal_values__returns_status_code___0;a|b;0"
}

# shellcheck disable=SC2034
test_stdlib_string_query_not_equal__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.query.not_equal "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_query_not_equal__@vary
