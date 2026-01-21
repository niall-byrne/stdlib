#!/bin/bash

# stdlib string query has library

builtin set -eo pipefail

# @description Checks if a string has a specific character at a given index.
# @arg $1 string The character to look for.
# @arg $2 integer The index to check at.
# @arg $3 string The string to check.
# @exitcode 0 If the character matches the one at the index.
# @exitcode 1 If the character does not match or if the operation failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
stdlib.string.query.has_char_n() {
  [[ "${#@}" == "3" ]] || builtin return 127
  stdlib.string.query.is_char "${1}" || builtin return "$?"
  stdlib.string.query.is_digit "${2}" || builtin return "$?"
  [[ -n "${3}" ]] || builtin return 126

  [[ "${1}" != "${3:${2}:1}" ]] && builtin return 1
  builtin return 0
}

# @description Checks if a string contains a specific substring.
# @arg $1 string The substring to look for.
# @arg $2 string The string to check.
# @exitcode 0 If the string contains the substring.
# @exitcode 1 If the string does not contain the substring.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
stdlib.string.query.has_substring() {
  [[ "${#@}" == "2" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126
  [[ -n "${2}" ]] || builtin return 126

  [[ "${2}" != *"${1}"* ]] && builtin return 1
  builtin return 0
}
