#!/bin/bash

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args__________returns_status_code_127;;127" \
    "extra_arg________returns_status_code_127;AA|extra_arg;127" \
    "multiple_chars___returns_status_code___1;!2jfA0;1" \
    "symbol___________returns_status_code___1;@;1" \
    "alpha____________returns_status_code___1;A;1" \
    "numeric__________returns_status_code___1;3;1" \
    "empty_string_____returns_status_code___0;|;0"
}

# shellcheck disable=SC2034
test_stdlib_string_query_is_empty__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.query.is_empty "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_query_is_empty__@vary
