#!/bin/bash

# stdlib security path query has library

builtin set -eo pipefail

# @description Checks if a path has the specified group ownership.
# @arg $1 string The path to check.
# @arg $2 string The required group name.
# @exitcode 0 If the path has the specified group ownership.
# @exitcode 1 If the path does not have the specified group ownership.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
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

# @description Checks if a path has the specified user ownership.
# @arg $1 string The path to check.
# @arg $2 string The required user name.
# @exitcode 0 If the path has the specified user ownership.
# @exitcode 1 If the path does not have the specified user ownership.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
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

# @description Checks if a path has the specified octal permissions.
# @arg $1 string The path to check.
# @arg $2 string The required octal permission value.
# @exitcode 0 If the path has the specified permissions.
# @exitcode 1 If the path does not have the specified permissions.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.security.path.query.has_permissions() {
  [[ "${#@}" == "2" ]] || builtin return 127
  stdlib.io.path.query.is_exists "${1}" || builtin return 126
  stdlib.string.query.is_octal_permission "${2}" || builtin return 126

  if [[ "$(stat -c "%a" "${1}")" != "${2}" ]]; then
    builtin return 1
  fi
}
