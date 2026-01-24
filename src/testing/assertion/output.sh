#!/bin/bash

# stdlib output extensions to bash_unit assertions

builtin set -eo pipefail

# @description Asserts that the captured output matches an expected value.
#     TEST_OUTPUT: The captured output to check.
# @arg $1 string The expected output.
# @exitcode 0 If the operation succeeded.
# @stderr The error message if the assertion fails.
assert_output() {
  if [[ -z "${TEST_OUTPUT}" ]]; then
    fail " $(_testing.assert.__message.get ASSERT_ERROR_OUTPUT_NULL)"
  fi

  assert_equals "${1}" \
    "${TEST_OUTPUT}" \
    " $(_testing.assert.__message.get ASSERT_ERROR_OUTPUT_NON_MATCHING)"
}

# @description Asserts that the captured output is null.
#     TEST_OUTPUT: The captured output to check.
# @noargs
# @exitcode 0 If the operation succeeded.
# @stderr The error message if the assertion fails.
assert_output_null() {
  assert_equals "" \
    "${TEST_OUTPUT}" \
    " $(_testing.assert.__message.get ASSERT_ERROR_VALUE_NOT_NULL "${TEST_OUTPUT}")"
}

# @description Asserts that the captured raw output matches an expected value.
#     TEST_OUTPUT: The captured output to check.
# @arg $1 string The expected output.
# @exitcode 0 If the operation succeeded.
# @stderr The error message if the assertion fails.
assert_output_raw() {
  if [[ -z "${TEST_OUTPUT}" ]]; then
    fail " $(_testing.assert.__message.get ASSERT_ERROR_OUTPUT_NULL)"
  fi

  assert_equals "${1}" \
    "${TEST_OUTPUT}" \
    " $(_testing.assert.__message.get ASSERT_ERROR_OUTPUT_NON_MATCHING)"
}
