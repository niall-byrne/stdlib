#!/bin/bash

# shellcheck disable=SC2034
setup() {
  _mock.create stdlib.logger.error

  TEST_POPULATED_ARRAY=(1 2 '' 3 $'\n')
  TEST_EMPTY_ARRAY=()
}

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args____________________returns_status_code_127;;127" \
    "extra_arg__________________returns_status_code_127;ARRAY1|TEST_POPULATED_ARRAY|extra_arg;127" \
    "null_target_array_name_____returns_status_code_126;|TEST_POPULATED_ARRAY;126" \
    "invalid_target_array_name__returns_status_code_126;|TEST_POPULATED_ARRAY;126" \
    "null_source_array_name_____returns_status_code_126;|TEST_POPULATED_ARRAY;126" \
    "non_existent_source________returns_status_code_126;ARRAY1|NON_EXISTENT;126" \
    "valid_populated_array______returns_status_code_126;ARRAY1|TEST_POPULATED_ARRAY;0" \
    "valid_empty_array__________returns_status_code_126;ARRAY1|TEST_EMPTY_ARRAY;0"
}

test_stdlib_array_make_from_array__@vary() {
  local args=()

  IFS="|" read -ra args <<< "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.array.make.from_array "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_array_make_from_array__@vary

test_stdlib_array_make_from_array__valid_populated_array______returns_status_code___0() {
  _capture.rc stdlib.array.make.from_array \
    array_name \
    TEST_POPULATED_ARRAY

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_array_make_from_array__valid_populated_array______creates_new_array() {
  stdlib.array.make.from_array \
    array_name \
    TEST_POPULATED_ARRAY

  assert_is_array array_name
  assert_array_equals TEST_POPULATED_ARRAY array_name
}

test_stdlib_array_make_from_array__valid_empty_array__________returns_status_code___0() {
  _capture.rc stdlib.array.make.from_array \
    array_name \
    TEST_EMPTY_ARRAY

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_array_make_from_array__valid_empty_array__________creates_empty_array() {
  stdlib.array.make.from_array \
    array_name \
    TEST_EMPTY_ARRAY

  assert_is_array array_name
  assert_array_equals TEST_EMPTY_ARRAY array_name
}
