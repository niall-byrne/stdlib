#!/bin/bash

# stdlib fn query is library

builtin set -eo pipefail

# @description Checks if a function exists.
# @arg $1 The name of the function to check.
# @exitcode 0 If the function exists.
# @exitcode 1 If the function does not exist.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
stdlib.fn.query.is_fn() {
  [[ "${#@}" == "1" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126

  if ! builtin declare -f "${1}" > /dev/null; then
    builtin return 1
  fi
  builtin return 0
}

# @description Checks if a string is a valid function name.
# @arg $1 The string to check.
# @exitcode 0 If the string is a valid function name.
# @exitcode 1 If the string is not a valid function name.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
stdlib.fn.query.is_valid_name() {
  [[ "${#@}" == "1" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126

  # shellcheck disable=SC1001
  case "${1}" in
    *[!A-Za-z0-9_.@\-]*)
      builtin return 1
      ;;
    *)
      builtin return 0
      ;;
  esac
}
