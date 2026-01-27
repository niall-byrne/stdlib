#!/bin/bash

# stdlib testing random fixtures

builtin set -eo pipefail

# @description Generates a random alphanumeric name.
# @arg $1 integer (optional, default=50) The length of the name to generate.
# @exitcode 0 If the operation succeeded.
# @stdout The generated random name.
_testing.fixtures.random.name() {
  builtin local random_name_length="${1:-50}"

  "${_STDLIB_BINARY_TR}" -dc A-Za-z0-9 < /dev/urandom |
    "${_STDLIB_BINARY_HEAD}" -c "${random_name_length}"
  builtin echo
}
