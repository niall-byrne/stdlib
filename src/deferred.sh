#!/bin/bash

# stdlib deferred library

builtin set -eo pipefail

STDLIB_DEFERRED_FN_ARRAY=("stdlib.fn.derive.pipeable" "stdlib.fn.derive.var")
STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY=()

# @description Creates a function that stores a deferred call and saves it to a global variable.
# @arg $1 string The target function whose call is being deferred.
# @arg $@ array The arguments to pass to the target function during execution.
# @exitcode 0 If the operations was successful.
# @set STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY array The array where the created functions are stored.
# @internal
stdlib.deferred.__defer() {
  # $1: the function to call
  # $@: arguments to pass to the function

  builtin local func="${1}"
  builtin local deferred_function_call="stdlib.__deferred.call.${#STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY[*]}"

  builtin shift

  builtin eval "$(
    "${_STDLIB_BINARY_CAT}" << EOF
${deferred_function_call}() {
  "${func}" ${@}
}
EOF
  )" # KCOV_EXCLUDE_LINE
  STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY+=("${deferred_function_call}")
}

# @description Executes all deferred function calls and cleans up the functions.
# @noargs
#   * STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY: The array where the created functions are stored (default=()).
# @exitcode 0 If the operations was successful.
# @set STDLIB_DEFERRED_FN_ARRAY array The array of functions to defer calls to.
# @set STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY array The array where the created functions are stored.
# @internal
stdlib.deferred.__execute() {
  builtin local func

  for func in "${STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY[@]}"; do
    "${func}"
    builtin unset -f "${func}"
  done

  STDLIB_DEFERRED_FN_ARRAY=()
  STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY=()
}

# @description Defers calls to critical functions during the bootstrap process.
# @noargs
#   * STDLIB_DEFERRED_FN_ARRAY: The array of functions to defer calls to (default=("stdlib.fn.derive.pipeable" "stdlib.fn.derive.var")).
# @exitcode 0 If the operations was successful.
# @internal
stdlib.deferred.__initialize() {
  builtin local func

  for func in "${STDLIB_DEFERRED_FN_ARRAY[@]}"; do
    builtin eval "$(
      "${_STDLIB_BINARY_CAT}" << EOF
${func}() {
  stdlib.deferred.__defer "${func}" "\${@}"
}
EOF
    )" # KCOV_EXCLUDE_LINE
  done
}
