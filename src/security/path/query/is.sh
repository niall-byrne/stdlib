#!/bin/bash

# stdlib security path query is library

builtin set -eo pipefail

# @description Checks if a file or directory has the specified owner, group, and permissions.
# @arg $1 The filesystem path to check.
# @arg $2 The required user name.
# @arg $3 The required group name.
# @arg $4 The required permission octal value.
# @exitcode 0 If the ownership and permissions are correct.
# @exitcode 1 If the ownership or permissions are incorrect.
# @exitcode 127 If the wrong number of arguments is provided.
stdlib.security.path.query.is_secure() {
  [[ "${#@}" == "4" ]] || builtin return 127

  if ! stdlib.security.path.query.has_owner "${1}" "${2}" ||
    ! stdlib.security.path.query.has_group "${1}" "${3}" ||
    ! stdlib.security.path.query.has_permissions "${1}" "${4}"; then
    builtin return 1
  fi
}
