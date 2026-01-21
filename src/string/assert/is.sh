#!/bin/bash

# stdlib string assert is library

builtin set -eo pipefail

# @description Asserts that a string is alphabetic.
# @arg $1 string The string to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 127 If the wrong number of arguments was provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_alpha() {
  builtin local return_code=0

  stdlib.string.query.is_alpha "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_ALPHABETIC "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string is alphanumeric.
# @arg $1 string The string to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 127 If the wrong number of arguments was provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_alpha_numeric() {
  builtin local return_code=0

  stdlib.string.query.is_alpha_numeric "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_ALPHA_NUMERIC "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string is a boolean (0 or 1).
# @arg $1 string The string to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 127 If the wrong number of arguments was provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_boolean() {
  builtin local return_code=0

  stdlib.string.query.is_boolean "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_BOOLEAN "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string is a single character.
# @arg $1 string The string to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 127 If the wrong number of arguments was provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_char() {
  builtin local return_code=0

  stdlib.string.query.is_char "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_CHAR "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string consists only of digits.
# @arg $1 string The string to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 127 If the wrong number of arguments was provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_digit() {
  builtin local return_code=0

  stdlib.string.query.is_digit "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_DIGIT "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string is an integer.
# @arg $1 string The string to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 127 If the wrong number of arguments was provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_integer() {
  builtin local return_code=0

  stdlib.string.query.is_integer "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_INTEGER "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string is an integer within a specified range.
# @arg $1 integer The range start point.
# @arg $2 integer The range end point.
# @arg $3 string The string to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_integer_with_range() {
  builtin local return_code=0

  stdlib.string.query.is_integer_with_range "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_INTEGER_IN_RANGE "${1}" "${2}" "${3}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string is a valid octal permission (e.g., 644 or 0755).
# @arg $1 string The string to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 127 If the wrong number of arguments was provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_octal_permission() {
  builtin local return_code=0

  stdlib.string.query.is_octal_permission "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_OCTAL_PERMISSION "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string matches a regular expression.
# @arg $1 string The regex to match.
# @arg $2 string The string to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 127 If the wrong number of arguments was provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_regex_match() {
  builtin local return_code=0

  stdlib.string.query.is_regex_match "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get REGEX_DOES_NOT_MATCH "${1}" "${2}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a variable is a non-empty string.
# @arg $1 string The string to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 127 If the wrong number of arguments was provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_string() {
  builtin local return_code=0

  stdlib.string.query.is_string "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_SET_STRING "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}
