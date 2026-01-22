#!/bin/bash

# stdlib fn query is library

builtin set -eo pipefail

stdlib.fn.query.is_builtin() {
  # $1: the function name to query

  [[ "${#@}" == "1" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126

  if [[ "$(builtin type -t "${1}")" != "builtin" ]]; then
    builtin return 1
  fi
  builtin return 0
}

stdlib.fn.query.is_fn() {
  # $1: the function name to query

  [[ "${#@}" == "1" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126

  if ! builtin declare -F "${1}" > /dev/null; then
    builtin return 1
  fi
  builtin return 0
}

stdlib.fn.query.is_valid_name() {
  # $1: the string to check for fn compatibility

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
