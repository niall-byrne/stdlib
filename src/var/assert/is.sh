#!/bin/bash

# stdlib var assert is library

builtin set -eo pipefail

# @description Asserts that a string is a valid variable name.
# @arg $1 string The string to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.var.assert.is_valid_name() {
  builtin local return_code=0

  stdlib.var.query.is_valid_name "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get VAR_NAME_INVALID "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}
