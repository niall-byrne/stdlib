#!/bin/bash

# stdlib var query is library

builtin set -eo pipefail

stdlib.var.query.is_valid_name() {
  # $1: the string to check for var compatibility

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
