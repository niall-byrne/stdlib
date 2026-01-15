#!/bin/bash

# stdlib security path assert is library

builtin set -eo pipefail

# @description Asserts that a file or directory has the specified owner, group, and permissions.
# @arg $1 The filesystem path to check.
# @arg $2 The required user name.
# @arg $3 The required group name.
# @arg $4 The required permission octal value.
# @exitcode 1 If the ownership or permissions are incorrect.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
# @stderr The error message if the assertion fails.
stdlib.security.path.assert.is_secure() {
  [[ "${#@}" == "4" ]] || builtin return 127

  stdlib.security.path.assert.has_owner "${1}" "${2}" || builtin return "$?"
  stdlib.security.path.assert.has_group "${1}" "${3}" || builtin return "$?"
  stdlib.security.path.assert.has_permissions "${1}" "${4}" || builtin return "$?"
}
