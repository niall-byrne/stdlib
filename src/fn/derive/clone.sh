#!/bin/bash

# stdlib fn derive clone library

builtin set -eo pipefail

# @description Clones a function by creating a new reference with a different name.
# @arg $1 string The name of the original function.
# @arg $2 string The name of the new function reference.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
stdlib.fn.derive.clone() {
  builtin local function_name="${1}"
  builtin local function_reference="${2}"

  [[ "${#@}" == 2 ]] || builtin return 127
  stdlib.fn.assert.is_fn "${function_name}" || builtin return 126
  [[ -n "${function_reference}" ]] || builtin return 126
  stdlib.fn.assert.is_valid_name "${function_reference}" || builtin return 126

  builtin eval "$(
    builtin echo "${function_reference}()"
    builtin declare -f "${function_name}" | "${_STDLIB_BINARY_TAIL}" -n +2
  )"
}
