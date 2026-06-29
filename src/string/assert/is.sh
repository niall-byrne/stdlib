#!/bin/bash

# stdlib string assert is library

builtin set -eo pipefail

# @description Asserts that a string contains only alphabetic characters.
# @arg $1 string The string to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_alpha() {
  builtin local return_code=0

  stdlib.string.query.is_alpha "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get IS_NOT_ALPHABETIC "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string contains only alphanumeric characters.
# @arg $1 string The string to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_alpha_numeric() {
  builtin local return_code=0

  stdlib.string.query.is_alpha_numeric "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get IS_NOT_ALPHA_NUMERIC "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string is a boolean (0 or 1).
# @arg $1 string The string to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_boolean() {
  builtin local return_code=0

  stdlib.string.query.is_boolean "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get IS_NOT_BOOLEAN "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string is a single character.
# @arg $1 string The string to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_char() {
  builtin local return_code=0

  stdlib.string.query.is_char "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get IS_NOT_CHAR "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string is a valid decimal.
# @arg $1 string The string to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_decimal() {
  builtin local return_code=0

  stdlib.string.query.is_decimal "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get IS_NOT_DECIMAL "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string is a valid positive decimal.
# @arg $1 string The string to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_decimal_positive() {
  builtin local return_code=0

  stdlib.string.query.is_decimal_positive "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get IS_NOT_DECIMAL_POSITIVE "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string contains only digits.
# @arg $1 string The string to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_digit() {
  builtin local return_code=0

  stdlib.string.query.is_digit "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get IS_NOT_DIGIT "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a value is a non-empty string.
# @arg $1 string The value to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_empty() {
  builtin local return_code=0

  stdlib.string.query.is_empty "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get IS_NOT_EMPTY_STRING "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that two strings are equal.
# @arg $1 string The first string to compare.
# @arg $2 string The second string to compare.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_equal() {
  builtin local return_code=0

  stdlib.string.query.is_equal "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get IS_NOT_EQUAL "${1}" "${2}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string is an integer.
# @arg $1 string The string to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_integer() {
  builtin local return_code=0

  stdlib.string.query.is_integer "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get IS_NOT_INTEGER "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string is an integer within a specified range.
# @arg $1 integer The range start point.
# @arg $2 integer The range end point.
# @arg $3 string The string to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_integer_with_range() {
  builtin local return_code=0

  stdlib.string.query.is_integer_with_range "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get IS_NOT_INTEGER_IN_RANGE "${1}" "${2}" "${3}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string is a valid octal permission (3 or 4 digits).
# @arg $1 string The string to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_octal_permission() {
  builtin local return_code=0

  stdlib.string.query.is_octal_permission "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get IS_NOT_OCTAL_PERMISSION "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string matches a regular expression.
# @arg $1 string The regular expression to use.
# @arg $2 string The string to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_regex_match() {
  builtin local return_code=0

  stdlib.string.query.is_regex_match "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get REGEX_DOES_NOT_MATCH "${1}" "${2}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string is in snake case.
# @arg $1 string The string to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_snake_case() {
  builtin local return_code=0

  stdlib.string.query.is_snake_case "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get IS_NOT_SNAKE_CASE "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string is in upper snake case.
# @arg $1 string The string to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.is_snake_case_upper() {
  builtin local return_code=0

  stdlib.string.query.is_snake_case_upper "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get IS_NOT_SNAKE_CASE_UPPER "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}
