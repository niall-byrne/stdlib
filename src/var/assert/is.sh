#!/bin/bash

# stdlib var assert is library

builtin set -eo pipefail

STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN=""

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

# @description Asserts a variable's value is valid against a validation function.
#   * STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN: A boolean value that controls whether the variable's name or value is passed to the validation function (default=0).
# @arg $1 string The validation function to run.  Usually this is an assertion of some kind.
# @arg $2 string The name of the variable to perform validation on.
# @exitcode 0 If the variable passes the validation function.
# @exitcode 1 If the variable fails the validation check.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.var.assert.is_valid_with() {
  builtin local return_code=0
  builtin local validate_by_name_boolean="${STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN:-0}"

  [[ "${#@}" == "2" ]] || { stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)" && builtin return 127; }

  stdlib.fn.assert.is_fn "${1}" || builtin return 126
  stdlib.var.assert.is_valid_name "${2}" || builtin return 126
  stdlib.string.assert.is_boolean "${validate_by_name_boolean}" || builtin return 126

  if [[ "${validate_by_name_boolean}" -eq 1 ]]; then
    "${1}" "${2}" || return_code="$?"
  else
    "${1}" "${!2}" || return_code="$?"
  fi

  if [[ "${return_code}" -ne 0 ]]; then
    stdlib.logger.error "$(stdlib.__message.get VAR_VALUE_INVALID "${2}")"
  fi

  builtin return "${return_code}"
}
