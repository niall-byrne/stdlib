#!/bin/bash

# stdlib fn extensions to bash_unit assertions

builtin set -eo pipefail

assert_is_fn() {
  # $1: the function name to check

  builtin local _stdlib_assertion_output
  builtin local _stdlib_return_code=0

  _stdlib_assertion_output="$(_testing.__protected stdlib.fn.assert.is_fn "${@}" 2>&1)" || _stdlib_return_code="$?"

  _stdlib_assertion_output="${_stdlib_assertion_output/$'\n'/$'\n '}"
  [[ "${_stdlib_return_code}" == "0" ]] || fail " ${_stdlib_assertion_output}"
}

assert_not_fn() {
  # $1: the function name to check

  builtin local _stdlib_assertion_output
  builtin local _stdlib_return_code=0

  _stdlib_assertion_output="$(_testing.__protected stdlib.fn.assert.not_fn "${@}" 2>&1)" || _stdlib_return_code="$?"

  _stdlib_assertion_output="${_stdlib_assertion_output/$'\n'/$'\n '}"
  [[ "${_stdlib_return_code}" == "0" ]] || fail " ${_stdlib_assertion_output}"
}
