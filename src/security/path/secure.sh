#!/bin/bash

# stdlib security path secure library

builtin set -eo pipefail

# @description Secures a filesystem path by setting its owner, group, and permissions.
# @arg $1 string The filesystem path to secure.
# @arg $2 string The owner name to set.
# @arg $3 string The group name to set.
# @arg $4 string The octal permission value to set.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.security.path.secure() {
  stdlib.fn.args.require "4" "0" "${@}" || builtin return "$?"

  chown "${2}":"${3}" "${1}"
  chmod "${4}" "${1}"
}
