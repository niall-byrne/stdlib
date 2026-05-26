#!/bin/bash

# stdlib mock extensions to bash_unit assertions

builtin set -eo pipefail

# @description Asserts that a mock exists with the given name.
# @arg $1 string The name of an expected mock object.
# @exitcode 0 If the assertion passed.
# @exitcode 1 If the assertion fails, or if logger has not been mocked.
# @stderr The error message if the assertion fails.
assert_is_mock() {
  if builtin declare -f "${1}.mock.__controller" > /dev/null 2>&1; then
    builtin return 0
  fi

  fail " $(_testing.assert.__message.get ASSERT_ERROR_IS_NOT_MOCK "${1}")"
}
