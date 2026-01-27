#!/bin/bash

# stdlib null extensions to bash_unit assertions

builtin set -eo pipefail

# @description Asserts that a value is not null.
# @arg $1 string The value to check.
# @exitcode 0 If the value is not null.
# @exitcode 1 If the value is null.
# @stderr The error message if the assertion fails.
assert_not_null() {
  builtin local _stdlib_test_value="${1}"

  assert_not_equals "" \
    "${_stdlib_test_value}" \
    " $(_testing.assert.__message.get ASSERT_ERROR_VALUE_NULL)"
}

# @description Asserts that a value is null.
# @arg $1 string The value to check.
# @exitcode 0 If the value is null.
# @exitcode 1 If the value is not null.
# @stderr The error message if the assertion fails.
assert_null() {
  builtin local _stdlib_test_value="${1}"

  assert_equals "" \
    "${_stdlib_test_value}" \
    " $(_testing.assert.__message.get ASSERT_ERROR_VALUE_NOT_NULL "${_stdlib_test_value}")"
}
