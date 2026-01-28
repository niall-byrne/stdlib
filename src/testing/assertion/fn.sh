#!/bin/bash

# stdlib fn extensions to bash_unit assertions

builtin set -eo pipefail

# @description Asserts that a value is a function.
# @arg $1 string The function name to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @stderr The error message if the assertion fails.
assert_is_fn() {
  builtin local _stdlib_assertion_output
  builtin local _stdlib_return_code=0

  _stdlib_assertion_output="$(_testing.__protected stdlib.fn.assert.is_fn "${@}" 2>&1)" || _stdlib_return_code="$?"

  _stdlib_assertion_output="${_stdlib_assertion_output/$'\n'/$'\n '}"
  [[ "${_stdlib_return_code}" == "0" ]] || fail " ${_stdlib_assertion_output}"
}

# @description Asserts that a value is not a function.
# @arg $1 string The function name to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @stderr The error message if the assertion fails.
assert_not_fn() {
  builtin local _stdlib_assertion_output
  builtin local _stdlib_return_code=0

  _stdlib_assertion_output="$(_testing.__protected stdlib.fn.assert.not_fn "${@}" 2>&1)" || _stdlib_return_code="$?"

  _stdlib_assertion_output="${_stdlib_assertion_output/$'\n'/$'\n '}"
  [[ "${_stdlib_return_code}" == "0" ]] || fail " ${_stdlib_assertion_output}"
}
