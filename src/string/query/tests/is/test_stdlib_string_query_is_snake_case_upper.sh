#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args______________returns_status_code_127;;127" \
    "extra_arg____________returns_status_code_127;AA|extra_arg;127" \
    "empty_string_________returns_status_code_126;|;126" \
    "symbol_______________returns_status_code___1;@#!;1" \
    "mixed________________returns_status_code___1;Aa@33aaB;1" \
    "trailing_underscore__returns_status_code___1;ABCD_1234_;1" \
    "leading_underscore___returns_status_code___1;_ABCD_1234;1" \
    "repeat_underscores___returns_status_code___1;ABCD__1234;1" \
    "lowercase____________returns_status_code___1;abcd_1234;1" \
    "valid________________returns_status_code___0;ABCD_1234;0"
}

# shellcheck disable=SC2034
test_stdlib_string_query_is_snake_case_upper__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.query.is_snake_case_upper "${args[@]}" #> /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_query_is_snake_case_upper__@vary
