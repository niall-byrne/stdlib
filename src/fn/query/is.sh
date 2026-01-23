#!/bin/bash

# stdlib fn query is library

builtin set -eo pipefail

# @description Checks if a command is a bash builtin.
# @arg $1 string The command name to check.
# @exitcode 0 If the command is a builtin.
# @exitcode 1 If the command is not a builtin.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.fn.query.is_builtin() {
  [[ "${#@}" == "1" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126

  if [[ "$(builtin type -t "${1}")" != "builtin" ]]; then
    builtin return 1
  fi
  builtin return 0
}

# @description Checks if a function name is defined.
# @arg $1 string The function name to check.
# @exitcode 0 If the function is defined.
# @exitcode 1 If the function is not defined.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.fn.query.is_fn() {
  [[ "${#@}" == "1" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126

  if ! builtin declare -F "${1}" > /dev/null; then
    builtin return 1
  fi
  builtin return 0
}

# @description Checks if a string is a valid function name.
# @arg $1 string The string to check.
# @exitcode 0 If the name is valid.
# @exitcode 1 If the name is invalid.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
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
