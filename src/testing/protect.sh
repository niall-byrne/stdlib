#!/bin/bash

# stdlib testing protect component

builtin set -eo pipefail

STDLIB_TESTING_PROTECT_PREFIX=""

# @description Generates internal testing versions of all stdlib functions.
#     STDLIB_TESTING_PROTECT_PREFIX: The prefix of the stdlib library to protect.
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
_testing.__protect_stdlib() {
  builtin local stdlib_library_prefix="${STDLIB_TESTING_PROTECT_PREFIX:-"stdlib"}"
  builtin local stdlib_function_regex="${stdlib_library_prefix}\\..*"

  while IFS= builtin read -r stdlib_fn_name; do
    stdlib_fn_definition="$(builtin declare -f "${stdlib_fn_name/"declare -f "/}")"
    builtin eval "${stdlib_fn_definition//"${stdlib_library_prefix}."/"${stdlib_library_prefix}.testing.internal."}"
  done <<< "$(builtin declare -F | "${_STDLIB_BINARY_GREP}" -E "^declare -f ${stdlib_function_regex}")"
}

# @description Calls a protected version of a stdlib function.
# @arg $@ array The name of the function to call followed by its arguments.
# @exitcode 0 If the operation succeeded.
# @stdout The output of the called function.
# @stderr The error output of the called function.
# @internal
_testing.__protected() {
  _STDLIB_BUILTIN_BOOLEAN=1 \
    "$(_testing.__protected_name "${1}")" "${@:2}"
}

# @description Returns the name of the protected version of a stdlib function.
#     STDLIB_TESTING_PROTECT_PREFIX: The prefix of the stdlib library to protect.
# @arg $1 string The name of the stdlib function.
# @exitcode 0 If the operation succeeded.
# @stdout The name of the protected function.
# @internal
_testing.__protected_name() {
  builtin local stdlib_library_prefix="${STDLIB_TESTING_PROTECT_PREFIX:-"stdlib"}"

  builtin echo "${1//"${stdlib_library_prefix}."/"${stdlib_library_prefix}.testing.internal."}"
}
