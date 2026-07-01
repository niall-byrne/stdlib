#!/bin/bash

# stdlib deferred library

builtin set -eo pipefail

# @description Creates a function that stores a deferred call and saves it to a global variable.
# @arg $1 string The target function whose call is being deferred.
# @arg $@ array The arguments to pass to the target function during execution.
# @exitcode 0 If the operations was successful.
# @set __STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY array An array where each deferred function call is stored as a closure.
# @internal
stdlib.deferred.__defer() {
  # $1: the function to call
  # $@: arguments to pass to the function

  builtin local func="${1}"
  builtin local deferred_function_call="stdlib.__deferred.call.${#__STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY[*]}"

  builtin shift

  builtin eval "$(
    "${_STDLIB_BINARY_CAT}" << EOF
${deferred_function_call}() {
  "${func}" ${@}
}
EOF
  )" # KCOV_EXCLUDE_LINE
  __STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY+=("${deferred_function_call}")
}

# @description Executes all deferred function calls and cleans up the functions.
#   * __STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY array reserved: An array where each deferred function call is stored as a closure (default=()).
# @noargs
# @exitcode 0 If the operations was successful.
# @set __STDLIB_DEFERRED_FN_ARRAY array An array storing the names of functions that have their calls intercepted and deferred.
# @set __STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY array  An array where each deferred function call is stored as a closure.
# @internal
stdlib.deferred.__execute() {
  builtin local func

  # clean __STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY

  for func in "${__STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY[@]}"; do
    "${func}"
    builtin unset -f "${func}"
  done

  __STDLIB_DEFERRED_FN_ARRAY=()
  __STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY=()
}

# @description Defers calls to critical functions during the bootstrap process.
#   * __STDLIB_DEFERRED_FN_ARRAY array reserved: An array storing the names of functions that have their calls intercepted and deferred (default=("stdlib.fn.derive.pipeable" "stdlib.fn.derive.var")). An array storing the names of functions that have their calls intercepted and deferred (default=("stdlib.fn.derive.pipeable" "stdlib.fn.derive.var")).
# @noargs
# @exitcode 0 If the operations was successful.
# @internal
stdlib.deferred.__initialize() {
  builtin local func

  # clean __STDLIB_DEFERRED_FN_ARRAY

  for func in "${__STDLIB_DEFERRED_FN_ARRAY[@]}"; do
    builtin eval "$(
      "${_STDLIB_BINARY_CAT}" << EOF
${func}() {
  stdlib.deferred.__defer "${func}" "\${@}"
}
EOF
    )" # KCOV_EXCLUDE_LINE
  done
}
