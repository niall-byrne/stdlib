#!/bin/bash

# stdlib var assert is library

builtin set -eo pipefail

# @description Asserts that a variable is an empty value (unset variables, empty arrays, empty associative arrays, empty strings and empty integers).
# @arg $1 string The name of the variable to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.var.assert.is_empty() {
  builtin local return_code=0

  stdlib.var.query.is_empty "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get VAR_VALUE_NOT_EMPTY "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a variable is set.
# @arg $1 string The name of the variable to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.var.assert.is_set() {
  builtin local return_code=0

  stdlib.var.query.is_set "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get VAR_NOT_SET "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

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
#   * STDLIB_VALIDATION_SOURCE_VAR string keyword: An optional variable name that can be used as a source for validation (logging will still attribute the value to the argument provided variable name) (default="").
# @arg $1 string The validation function to run.
# @arg $2 string The name of the variable containing the value to perform validation on.
# @arg $3 string (optional, default="value") Controls whether the 'name' or 'value' of the variable is passed to the validation function.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.var.assert.is_valid_with() {
  builtin local return_code=0

  stdlib.var.query.is_valid_with "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    125)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID)"
      ;;
    126 | 127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get VAR_VALUE_INVALID "${2}")"
      ;;
  esac

  builtin return "${return_code}"
}
