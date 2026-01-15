#!/bin/bash

# stdlib fn assert library

builtin set -eo pipefail

# @description Asserts that a function exists.
# @arg $1 The name of the function to check.
# @exitcode 1 If the function does not exist.
# @exitcode 126 If the function name is invalid.
# @exitcode 127 If an invalid argument has been provided.
# @stderr The error message if the assertion fails.
stdlib.fn.assert.is_fn() {
  builtin local return_code=0

  stdlib.fn.query.is_fn "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_FN "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string is a valid function name.
# @arg $1 The string to check.
# @exitcode 1 If the string is not a valid function name.
# @exitcode 126 If the string is empty.
# @exitcode 127 If an invalid argument has been provided.
# @stderr The error message if the assertion fails.
stdlib.fn.assert.is_valid_name() {
  builtin local return_code=0

  stdlib.fn.query.is_valid_name "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get FUNCTION_NAME_INVALID "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}
