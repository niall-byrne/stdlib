#!/bin/bash

# stdlib testing protect component

builtin set -eo pipefail

STDLIB_TESTING_PROTECT_PREFIX=""

_testing.__protect_stdlib() {
  builtin local stdlib_library_prefix="${STDLIB_TESTING_PROTECT_PREFIX:-"stdlib"}"
  builtin local stdlib_function_regex="${stdlib_library_prefix}\\..*"

  while IFS= builtin read -r stdlib_fn_name; do
    stdlib_fn_definition="$(builtin declare -f "${stdlib_fn_name/"declare -f "/}")"
    builtin eval "${stdlib_fn_definition//"${stdlib_library_prefix}."/"${stdlib_library_prefix}.testing.internal."}"
  done <<< "$(builtin declare -F | "${_STDLIB_BINARY_GREP}" -E "^declare -f ${stdlib_function_regex}")"
}

_testing.__protected() {
  # $@: the stdlib library to call

  _STDLIB_BUILTIN_BOOLEAN=1 \
    "$(_testing.__protected_name "${1}")" "${@:2}"
}

_testing.__protected_name() {
  # $@: the stdlib library to call

  builtin local stdlib_library_prefix="${STDLIB_TESTING_PROTECT_PREFIX:-"stdlib"}"

  builtin echo "${1//"${stdlib_library_prefix}."/"${stdlib_library_prefix}.testing.internal."}"
}
