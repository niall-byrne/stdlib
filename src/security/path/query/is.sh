#!/bin/bash

# stdlib security path query is library

builtin set -eo pipefail

# @description Checks if a filesystem path is secure by checking its owner, group, and permissions.
# @arg $1 string The filesystem path to check.
# @arg $2 string The required owner name.
# @arg $3 string The required group name.
# @arg $4 string The required octal permission value.
# @exitcode 0 If the path is secure.
# @exitcode 1 If the path is not secure.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.security.path.query.is_secure() {
  [[ "${#@}" == "4" ]] || builtin return 127

  if ! stdlib.security.path.query.has_owner "${1}" "${2}" ||
    ! stdlib.security.path.query.has_group "${1}" "${3}" ||
    ! stdlib.security.path.query.has_permissions "${1}" "${4}"; then
    builtin return 1
  fi
}
