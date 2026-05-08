#!/bin/bash

# stdlib var query is library

builtin set -eo pipefail

# @description Checks if a variable is an empty value (unset variables, empty arrays, empty associative arrays, empty strings and empty integers).
# @arg $1 string The name of the variable to check.
# @exitcode 0 If the variable is an empty value.
# @exitcode 1 If the variable is not an empty value.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.var.query.is_empty() {
  builtin local variable_declaration

  [[ "${#@}" == "1" ]] || builtin return 127
  stdlib.var.query.is_valid_name "${1}" || builtin return 126

  variable_declaration="$(builtin declare -p "${1}" 2> /dev/null)" || builtin return 0

  case "${variable_declaration}" in
    # 1. Empty arrays
    *"-a "*'=()' | *"-a ${1}")
      builtin return 0
      ;;
    # 2. Empty associative arrays.
    *"-A "*'=()' | *"-A ${1}")
      builtin return 0
      ;;
    # 3. Populated arrays and associative arrays.
    *"-a "* | *"-A "*)
      builtin return 1
      ;;
    # 4. Scalar strings, integers, or other types.
    *)
      [[ -z "${!1}" ]] && builtin return 0
      builtin return 1
      ;;
  esac
}

# @description Checks if a variable is set.
# @arg $1 string The name of the variable to check.
# @exitcode 0 If the variable is set.
# @exitcode 1 If the variable is not set.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.var.query.is_set() {
  [[ "${#@}" == "1" ]] || builtin return 127
  stdlib.var.query.is_valid_name "${1}" || builtin return 126

  if ! builtin declare -p "${1}" > /dev/null 2>&1; then
    builtin return 1
  fi
  builtin return 0
}

# @description Checks if a string is a valid variable name.
# @arg $1 string The string to check.
# @exitcode 0 If the string is a valid variable name.
# @exitcode 1 If the string is not a valid variable name.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.var.query.is_valid_name() {
  [[ "${#@}" == "1" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126

  # shellcheck disable=SC1001
  case "${1}" in
    *[!A-Za-z0-9_]*)
      builtin return 1
      ;;
    *)
      builtin return 0
      ;;
  esac
}
