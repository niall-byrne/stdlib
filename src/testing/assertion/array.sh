#!/bin/bash

# stdlib array extensions to bash_unit assertions

builtin set -eo pipefail

# @description Asserts that two arrays are equal.
# @arg $1 string The first array to compare.
# @arg $2 string The second array to compare.
# @exitcode 0 If the operation succeeded.
# @stderr The error message if the assertion fails.
assert_array_equals() {
  builtin local _stdlib_assertion_output
  builtin local _stdlib_return_code=0

  _stdlib_assertion_output="$(_testing.__protected stdlib.array.assert.is_equal "${@}" 2>&1)" || _stdlib_return_code="$?"

  _stdlib_assertion_output="${_stdlib_assertion_output/$'\n'/$'\n '}"
  [[ "${_stdlib_return_code}" == "0" ]] || fail " ${_stdlib_assertion_output}"
}

# @description Asserts that an array has the expected length.
# @arg $1 integer The expected length.
# @arg $2 string The name of the array variable.
# @exitcode 0 If the operation succeeded.
# @stderr The error message if the assertion fails.
assert_array_length() {
  if [[ $# -ne 2 ]]; then
    fail " $(_testing.assert.__message.get ASSERT_ERROR_INSUFFICIENT_ARGS assert_array_length)"
  fi

  builtin local _stdlib_expected_length="${1}"
  builtin local _stdlib_indirect_reference
  builtin local -a _stdlib_indirect_array
  builtin local _stdlib_variable_name="${2}"

  _testing.__assertion.value.check "${_stdlib_variable_name}"
  _testing.__protected assert_is_array "${_stdlib_variable_name}"

  _stdlib_indirect_reference="${_stdlib_variable_name}[@]"
  _stdlib_indirect_array=("${!_stdlib_indirect_reference}")

  assert_equals "${_stdlib_expected_length}" \
    "${#_stdlib_indirect_array[*]}" ||
    fail " $(_testing.assert.__message.get ASSERT_ERROR_ARRAY_LENGTH_NON_MATCHING "${_stdlib_expected_length}" "${#_stdlib_indirect_array[*]}")"
}

# @description Asserts that a variable is an array.
# @arg $1 string The name of the variable to check.
# @exitcode 0 If the operation succeeded.
# @stderr The error message if the assertion fails.
assert_is_array() {
  builtin local _stdlib_assertion_output
  builtin local _stdlib_return_code=0

  _stdlib_assertion_output="$(_testing.__protected stdlib.array.assert.is_array "${@}" 2>&1)" || _stdlib_return_code="$?"

  _stdlib_assertion_output="${_stdlib_assertion_output/$'\n'/$'\n '}"
  [[ "${_stdlib_return_code}" == "0" ]] || fail " ${_stdlib_assertion_output}"
}
