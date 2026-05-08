#!/bin/bash

# stdlib var query is library

builtin set -eo pipefail

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
