#!/bin/bash

# stdlib security path secure library

builtin set -eo pipefail

# @description Sets the ownership and permissions for a file or directory.
# @arg $1 string The filesystem path to secure.
# @arg $2 string The owner name to set.
# @arg $3 string The group name to set.
# @arg $4 string The permission octal value to set.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
# @stderr The error message if the operation fails.
stdlib.security.path.secure() {
  stdlib.fn.args.require "4" "0" "${@}" || builtin return "$?"

  chown "${2}":"${3}" "${1}"
  chmod "${4}" "${1}"
}
