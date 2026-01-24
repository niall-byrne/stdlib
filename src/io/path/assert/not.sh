#!/bin/bash

# stdlib io path assert not library

builtin set -eo pipefail

# @description Asserts that a path does not exist.
# @arg $1 string The path to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.io.path.assert.not_exists() {
  builtin local return_code=0

  stdlib.io.path.query.is_exists "${@}" || return_code="$?"

  case "${return_code}" in
    0)
      stdlib.logger.error "$(stdlib.__message.get FS_PATH_EXISTS "${1}")"
      builtin return 1
      ;;
    1)
      builtin return 0
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
  esac

  builtin return "${return_code}"
}
