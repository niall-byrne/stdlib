#!/bin/bash

# stdlib string query is library

builtin set -eo pipefail

# @description Checks if a string is alphabetic.
# @arg $1 string The string to check.
# @exitcode 0 If the string is alphabetic.
# @exitcode 1 If the string is not alphabetic.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
stdlib.string.query.is_alpha() {
  [[ "${#@}" == "1" ]] || builtin return 127
  case "${1}" in
    "")
      builtin return 126
      ;;
    *[![:alpha:]]*)
      builtin return 1
      ;;
    *)
      builtin return 0
      ;;
  esac
}

# @description Checks if a string is alphanumeric.
# @arg $1 string The string to check.
# @exitcode 0 If the string is alphanumeric.
# @exitcode 1 If the string is not alphanumeric.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
stdlib.string.query.is_alpha_numeric() {
  [[ "${#@}" == "1" ]] || builtin return 127
  case "${1}" in
    "")
      builtin return 126
      ;;
    *[![:alnum:]]*)
      builtin return 1
      ;;
    *)
      builtin return 0
      ;;
  esac
}

# @description Checks if a string is a boolean (0 or 1).
# @arg $1 string The string to check.
# @exitcode 0 If the string is a boolean.
# @exitcode 1 If the string is not a boolean.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
stdlib.string.query.is_boolean() {
  [[ "${#@}" == "1" ]] || builtin return 127
  case "${1}" in
    "")
      builtin return 126
      ;;
    [0-1])
      builtin return 0
      ;;
    *)
      builtin return 1
      ;;
  esac
}

# @description Checks if a string is a single character.
# @arg $1 string The string to check.
# @exitcode 0 If the string is a single character.
# @exitcode 1 If the string is not a single character.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
stdlib.string.query.is_char() {
  [[ "${#@}" == "1" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126
  [[ "${#1}" == "1" ]] || builtin return 1
}

# @description Checks if a string consists only of digits.
# @arg $1 string The string to check.
# @exitcode 0 If the string consists only of digits.
# @exitcode 1 If the string does not consist only of digits.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
stdlib.string.query.is_digit() {
  [[ "${#@}" == "1" ]] || builtin return 127
  case "${1}" in
    "")
      builtin return 126
      ;;
    *[!0-9]*)
      builtin return 1
      ;;
    *)
      builtin return 0
      ;;
  esac
}

# @description Checks if a string is an integer.
# @arg $1 string The string to check.
# @exitcode 0 If the string is an integer.
# @exitcode 1 If the string is not an integer.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
stdlib.string.query.is_integer() {
  [[ "${#@}" == "1" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126

  if { builtin test "${1}" -gt "-1" 2> /dev/null || builtin test "${1}" -lt "1" 2> /dev/null; }; then
    builtin return 0
  fi

  builtin return 1
}

# @description Checks if a string is an integer within a specified range.
# @arg $1 integer The range start point.
# @arg $2 integer The range end point.
# @arg $3 string The string to check.
# @exitcode 0 If the string is an integer in the specified range.
# @exitcode 1 If the string is not an integer in the specified range.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
stdlib.string.query.is_integer_with_range() {
  [[ "${#@}" == "3" ]] || builtin return 127
  stdlib.string.query.is_integer "${1}" || builtin return 126
  stdlib.string.query.is_integer "${2}" || builtin return 126
  [[ "${1}" -le ${2} ]] || builtin return 126
  stdlib.string.query.is_integer "${3}" || builtin return 126

  if [[ "${3}" -ge "${1}" ]] &&
    [[ "${3}" -le "${2}" ]]; then
    builtin return 0
  fi

  builtin return 1
}

# @description Checks if a string is a valid octal permission (e.g., 644 or 0755).
# @arg $1 string The string to check.
# @exitcode 0 If the string is a valid octal permission.
# @exitcode 1 If the string is not a valid octal permission.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
stdlib.string.query.is_octal_permission() {
  [[ "${#@}" == "1" ]] || builtin return 127
  case "${1}" in
    "")
      builtin return 126
      ;;
    [0-7][0-7][0-7] | [0-7][0-7][0-7][0-7])
      builtin return 0
      ;;
    *)
      builtin return 1
      ;;
  esac

}

# @description Checks if a string matches a regular expression.
# @arg $1 string The regex to use.
# @arg $2 string The string to check.
# @exitcode 0 If the string matches the regex.
# @exitcode 1 If the string does not match the regex.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
stdlib.string.query.is_regex_match() {
  [[ "${#@}" == "2" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126
  [[ -n "${2}" ]] || builtin return 126

  if [[ "${2}" =~ ${1} ]]; then
    builtin return 0
  fi
  builtin return 1
}

# @description Checks if a variable is a non-empty string.
# @arg $1 string The string to check.
# @exitcode 0 If the string is non-empty.
# @exitcode 1 If the string is empty.
# @exitcode 127 If the wrong number of arguments was provided.
stdlib.string.query.is_string() {
  [[ "${#@}" == "1" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 1
}
