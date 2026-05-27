#!/bin/bash

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_________returns_status_code_127;;127" \
    "extra_arg_______returns_status_code_127;AA|extra_arg;127" \
    "empty_string____returns_status_code___1;|;1" \
    "multiple_chars__returns_status_code___0;!2jfA0;0" \
    "symbol__________returns_status_code___0;@;0" \
    "alpha___________returns_status_code___0;A;0" \
    "numeric_________returns_status_code___0;3;0"
}

# shellcheck disable=SC2034
test_stdlib_string_query_not_empty__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.query.not_empty "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_query_not_empty__@vary
