#!/bin/bash

# stdlib return code extensions to bash_unit assertions

builtin set -eo pipefail

# @description Asserts that the captured return code matches the expected value.
# @arg $1 integer The expected return code.
# @exitcode 0 If the operation succeeded.
# @stderr The error message if the assertion fails.
assert_rc() {
  if [[ -z "${TEST_RC}" ]]; then
    fail " $(_testing.assert.__message.get ASSERT_ERROR_RC_NULL)"
  fi

  assert_equals "${1}" \
    "${TEST_RC}" \
    " $(_testing.assert.__message.get ASSERT_ERROR_RC_NON_MATCHING)"
}
