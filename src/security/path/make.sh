#!/bin/bash

# stdlib security path make library

builtin set -eo pipefail

# @description Creates a directory and sets its owner, group, and permissions.
# @arg $1 string The path to the directory to create.
# @arg $2 string The owner name to set.
# @arg $3 string The group name to set.
# @arg $4 string The octal permission value to set.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.security.path.make.dir() {
  [[ "${#@}" == "4" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126
  [[ -n "${2}" ]] || builtin return 126
  [[ -n "${3}" ]] || builtin return 126
  [[ -n "${4}" ]] || builtin return 126

  mkdir -p "${1}"
  stdlib.security.path.secure "${@}"
}

# @description Creates a file and sets its owner, group, and permissions.
# @arg $1 string The path to the file to create.
# @arg $2 string The owner name to set.
# @arg $3 string The group name to set.
# @arg $4 string The octal permission value to set.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.security.path.make.file() {
  [[ "${#@}" == "4" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126
  [[ -n "${2}" ]] || builtin return 126
  [[ -n "${3}" ]] || builtin return 126
  [[ -n "${4}" ]] || builtin return 126

  touch "${1}"
  stdlib.security.path.secure "${@}"
}
