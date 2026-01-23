#!/bin/bash

# stdlib string query syntactic sugar library

builtin set -eo pipefail

# @description Checks if a string ends with a specified substring.
# @arg $1 string The substring to check for.
# @arg $2 string The string to check.
# @exitcode 0 If the string ends with the substring.
# @exitcode 1 If the string does not end with the substring.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.string.query.ends_with() {
  [[ "${#@}" == "2" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126
  [[ -n "${2}" ]] || builtin return 126

  [[ "${2}" == *"${1}" ]] || builtin return 1
  builtin return 0
}

# @description Checks if the first character of a string is a specified character.
# @arg $1 string The character to check for.
# @arg $2 string The string to check.
# @exitcode 0 If the first character matches.
# @exitcode 1 If the first character does not match.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.string.query.first_char_is() {
  [[ "${#@}" == "2" ]] || builtin return 127
  [[ "${#1}" == "1" ]] || builtin return 126
  [[ -n "${2}" ]] || builtin return 126

  stdlib.string.query.has_char_n "${1}" "0" "${2}"
}

# @description Checks if the last character of a string is a specified character.
# @arg $1 string The character to check for.
# @arg $2 string The string to check.
# @exitcode 0 If the last character matches.
# @exitcode 1 If the last character does not match.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.string.query.last_char_is() {
  [[ "${#@}" == "2" ]] || builtin return 127
  [[ "${#1}" == "1" ]] || builtin return 126
  [[ -n "${2}" ]] || builtin return 126

  stdlib.string.query.has_char_n "${1}" "$(("${#2}" - 1))" "${2}"
}

# @description Checks if a string starts with a specified substring.
# @arg $1 string The substring to check for.
# @arg $2 string The string to check.
# @exitcode 0 If the string starts with the substring.
# @exitcode 1 If the string does not start with the substring.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.string.query.starts_with() {
  [[ "${#@}" == "2" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126
  [[ -n "${2}" ]] || builtin return 126

  [[ "${2}" == "${1}"* ]] || builtin return 1
  builtin return 0
}
