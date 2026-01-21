#!/bin/bash

# stdlib io path assert library

builtin set -eo pipefail

# @description Asserts that a path exists.
# @arg $1 string The path to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the path does not exist.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
# @stderr The error message if the assertion fails.
stdlib.io.path.assert.is_exists() {
  builtin local return_code=0

  stdlib.io.path.query.is_exists "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get FS_PATH_DOES_NOT_EXIST "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a path is a file.
# @arg $1 string The path to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the path is not a file.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
# @stderr The error message if the assertion fails.
stdlib.io.path.assert.is_file() {
  builtin local return_code=0

  stdlib.io.path.query.is_file "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get FS_PATH_IS_NOT_A_FILE "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a path is a folder.
# @arg $1 string The path to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the path is not a folder.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
# @stderr The error message if the assertion fails.
stdlib.io.path.assert.is_folder() {
  builtin local return_code=0

  stdlib.io.path.query.is_folder "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get FS_PATH_IS_NOT_A_FOLDER "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}
