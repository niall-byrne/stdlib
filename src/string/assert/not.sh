#!/bin/bash

# stdlib string assert not library

builtin set -eo pipefail

# @description Asserts that two strings are not equal.
# @arg $1 string The comparison value string.
# @arg $2 string The string to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.not_equal() {
  builtin local return_code=0

  [[ "${1}" != "${2}" ]] || return_code="1"
  [[ -n "${1}" ]] || return_code="126"
  [[ "${#@}" == "2" ]] || return_code="127"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_EQUAL "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}
