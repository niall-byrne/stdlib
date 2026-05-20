#!/bin/bash

# stdlib fn keyword assert is library

builtin set -eo pipefail

# @description Checks if a keyword's value is valid against a validation function.
#   * STDLIB_KW_SOURCE_VAR: An optional variable name that can be used as a source for validation (logging will still attribute the value to the argument provided keyword) (default="").
# @arg $1 string The validation function to run.
# @arg $2 string The name of the keyword to perform validation on.
# @arg $3 string (optional, default="value") Controls whether the 'name' or 'value' of the keyword is passed to the validation function.
# @exitcode 0 If the keyword passes the validation function.
# @exitcode 1 If the keyword fails the validation check.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.fn.keyword.assert.is_valid_with() {
  builtin local return_code=0

  # shellcheck disable=SC2034
  builtin local STDLIB_LOGGING_MESSAGE_PREFIX="${STDLIB_LOGGING_MESSAGE_PREFIX:-"${FUNCNAME[2]}"}"

  stdlib.fn.keyword.query.is_valid_with "${@}" || return_code="$?" # validates STDLIB_KW_SOURCE_VAR

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    125)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID)"
      ;;
    126 | 127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID_DETAIL "${2}")"
      ;;
  esac

  builtin return "${return_code}"
}
