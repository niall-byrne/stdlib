#!/bin/bash

@parametrize_with_custom_prefix_fn_names() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_FUNCTION_NAME;TEST_FN_PROTECTED_NAME" \
    "function_1;custom.fn1;custom.testing.internal.fn1" \
    "function_2;custom.fn2;custom.testing.internal.fn2"
}

@parametrize_with_default_prefix_fn_names() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_FUNCTION_NAME;TEST_FN_PROTECTED_NAME" \
    "function_1;stdlib.fn1;stdlib.testing.internal.fn1" \
    "function_2;stdlib.fn2;stdlib.testing.internal.fn2"
}

test_stdlib_testing_protected_name__custom__prefix__@vary__generates_correct_transformed_name() {
  local _STDLIB_TESTING_STDLIB_PROTECT_PREFIX="custom"

  _capture.output _testing.__protected_name "${TEST_FUNCTION_NAME}"

  assert_output "${TEST_FN_PROTECTED_NAME}"
}

@parametrize_with_custom_prefix_fn_names \
  test_stdlib_testing_protected_name__custom__prefix__@vary__generates_correct_transformed_name

test_stdlib_testing_protected_name__default_prefix__@vary__generates_correct_transformed_name() {
  _capture.output _testing.__protected_name "${TEST_FUNCTION_NAME}"

  assert_output "${TEST_FN_PROTECTED_NAME}"
}

@parametrize_with_default_prefix_fn_names \
  test_stdlib_testing_protected_name__default_prefix__@vary__generates_correct_transformed_name
