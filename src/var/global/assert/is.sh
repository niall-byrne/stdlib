#!/bin/bash

# stdlib var global assert is library

builtin set -eo pipefail

# @description Asserts a global variable's value is valid against a validation function.
#   * STDLIB_VALIDATION_SOURCE_VAR: An optional variable name that can be used as a source for validation (logging will still attribute the value to the argument provided variable name) (default="").
# @arg $1 string The validation function to run.
# @arg $2 string The name of the global variable containing the value to perform validation on.
# @arg $3 string (optional, default="value") Controls whether the 'name' or 'value' of the variable is passed to the validation function.
# @exitcode 0 If the global variable passes the validation function.
# @exitcode 1 If the global variable fails the validation check.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.var.global.assert.is_valid_with() {
  builtin local return_code=0

  stdlib.var.query.is_valid_with "${@}" || return_code="$?" # validates STDLIB_VALIDATION_SOURCE_VAR

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    125)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID)"
      ;;
    126 | 127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get VAR_VALUE_INVALID_GLOBAL_DETAIL "${2}")"
      ;;
  esac

  builtin return "${return_code}"
}
