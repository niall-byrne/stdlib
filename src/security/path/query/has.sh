#!/bin/bash

# stdlib security path query has library

builtin set -eo pipefail

# @description Checks if a path has a specific group ownership.
# @arg $1 string The path to check.
# @arg $2 string The required group name.
# @exitcode 0 If the path has the correct group ownership.
# @exitcode 1 If the path does not have the correct group ownership.
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

# @description Checks if a path has a specific owner.
# @arg $1 string The path to check.
# @arg $2 string The required user name.
# @exitcode 0 If the path has the correct owner.
# @exitcode 1 If the path does not have the correct owner.
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

stdlib.security.path.query.has_permissions() {
  # $1: the path to check
  # $2: the permission octal value required

  [[ "${#@}" == "2" ]] || builtin return 127
  stdlib.io.path.query.is_exists "${1}" || builtin return 126
  stdlib.string.query.is_octal_permission "${2}" || builtin return 126

  if [[ "$(stat -c "%a" "${1}")" != "${2}" ]]; then
    builtin return 1
  fi
}
