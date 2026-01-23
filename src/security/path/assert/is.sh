#!/bin/bash

# stdlib security path assert is library

builtin set -eo pipefail

# @description Asserts that a path is secure (correct ownership and permissions).
# @arg $1 string The filesystem path to check.
# @arg $2 string The required user name.
# @arg $3 string The required group name.
# @arg $4 string The permission octal value required.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout Success or suggestion messages.
# @stderr The error message if the assertion fails.
stdlib.security.path.assert.is_secure() {
  [[ "${#@}" == "4" ]] || builtin return 127

  stdlib.security.path.assert.has_owner "${1}" "${2}" || builtin return "$?"
  stdlib.security.path.assert.has_group "${1}" "${3}" || builtin return "$?"
  stdlib.security.path.assert.has_permissions "${1}" "${4}" || builtin return "$?"
}
