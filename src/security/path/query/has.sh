#!/bin/bash

# stdlib security path query has library

builtin set -eo pipefail

# @description Checks if a file or directory has the specified group ownership.
# @arg $1 The path to check.
# @arg $2 The required group name.
# @exitcode 0 If the group ownership is correct.
# @exitcode 1 If the group ownership is incorrect.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
stdlib.security.path.query.has_group() {
  builtin local required_gid

  [[ "${#@}" == "2" ]] || builtin return 127
  stdlib.io.path.query.is_exists "${1}" || builtin return 126
  [[ -n "${2}" ]] || builtin return 126

  required_gid="$(stdlib.security.get.gid "${2}")"

  if [[ "$(stat -c "%g" "${1}")" != "${required_gid}" ]]; then
    builtin return 1
  fi
}

# @description Checks if a file or directory has the specified owner.
# @arg $1 The path to check.
# @arg $2 The required user name.
# @exitcode 0 If the ownership is correct.
# @exitcode 1 If the ownership is incorrect.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
stdlib.security.path.query.has_owner() {
  builtin local required_uid

  [[ "${#@}" == "2" ]] || builtin return 127
  stdlib.io.path.query.is_exists "${1}" || builtin return 126
  [[ -n "${2}" ]] || builtin return 126

  required_uid="$(stdlib.security.get.uid "${2}")"

  if [[ "$(stat -c "%u" "${1}")" != "${required_uid}" ]]; then
    builtin return 1
  fi
}

# @description Checks if a file or directory has the specified permissions.
# @arg $1 The path to check.
# @arg $2 The required permission octal value.
# @exitcode 0 If the permissions are correct.
# @exitcode 1 If the permissions are incorrect.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
stdlib.security.path.query.has_permissions() {
  [[ "${#@}" == "2" ]] || builtin return 127
  stdlib.io.path.query.is_exists "${1}" || builtin return 126
  stdlib.string.query.is_octal_permission "${2}" || builtin return 126

  if [[ "$(stat -c "%a" "${1}")" != "${2}" ]]; then
    builtin return 1
  fi
}
