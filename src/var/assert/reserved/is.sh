#!/bin/bash

# stdlib var assert reserved is library

builtin set -eo pipefail

# @description Asserts a reserved stdlib variable's value is valid against a validation function.
#   * STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN: A boolean value that controls whether the variable's name or value is passed to the validation function (default=0).
#   * STDLIB_VAR_VALIDATE_DEFAULT_VAR: An optional variable name that can be used as a default source if the given variable name is unset (default="").
# @arg $1 string The validation function to run.
# @arg $2 string The name of the variable containing the value to perform validation on.
# @exitcode 0 If the variable passes the validation function.
# @exitcode 1 If the variable fails the validation check.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
# @internal
stdlib.var.assert.__reserved.is_valid_with() {
  builtin local return_code=0

  stdlib.var.query.is_valid_with "${@}" || return_code="$?" # validates STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN,STDLIB_VAR_VALIDATE_DEFAULT_VAR

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get VAR_RESERVED "${2}")"
      ;;
  esac

  builtin return "${return_code}"
}
