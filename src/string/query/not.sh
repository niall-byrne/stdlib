#!/bin/bash

# stdlib string query not library

builtin set -eo pipefail

# @description Checks if a value is not an empty string.
# @arg $1 string The value to check.
# @exitcode 0 If the value is not an empty string.
# @exitcode 1 If the value is an empty string.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.string.query.not_empty() {
  [[ "${#@}" == "1" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 1
}
