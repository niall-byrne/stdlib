#!/bin/bash

# stdlib testing protect component

builtin set -eo pipefail

STDLIB_TESTING_PROTECT_PREFIX=""

# @description Protects the stdlib by creating internal copies of functions.
#   * STDLIB_TESTING_PROTECT_PREFIX: The prefix of the library to protect (default="stdlib").
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

# @description Calls a protected stdlib function.
# @arg $1 string The name of the stdlib function to call.
# @arg $@ array (optional) The arguments to pass to the function.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The output of the called function.
# @stderr The error output of the called function.
# @internal
_testing.__protected() {
  STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN=1 \
    "$(_testing.__protected_name "${1}")" "${@:2}"
}

# @description Retrieves the name of a protected stdlib function.
#   * STDLIB_TESTING_PROTECT_PREFIX: The prefix of the library to protect (default="stdlib").
# @arg $1 string The name of the stdlib function.
# @exitcode 0 If the operation succeeded.
# @stdout The name of the protected function.
# @internal
_testing.__protected_name() {
  builtin local stdlib_library_prefix="${STDLIB_TESTING_PROTECT_PREFIX:-"stdlib"}"

  builtin echo "${1//"${stdlib_library_prefix}."/"${stdlib_library_prefix}.testing.internal."}"
}
