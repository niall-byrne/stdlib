#!/bin/bash

# stdlib string query has library

builtin set -eo pipefail

# @description Checks if a specific character exists at a given index in a string.
# @arg $1 The character to check for.
# @arg $2 The index to check at.
# @arg $3 The string to check.
# @exitcode 0 If the character is found at the specified index.
# @exitcode 1 If the character is not found at the specified index.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
stdlib.string.query.has_char_n() {
  [[ "${#@}" == "3" ]] || builtin return 127
  stdlib.string.query.is_char "${1}" || builtin return "$?"
  stdlib.string.query.is_digit "${2}" || builtin return "$?"
  [[ -n "${3}" ]] || builtin return 126

  [[ "${1}" != "${3:${2}:1}" ]] && builtin return 1
  builtin return 0
}

# @description Checks if a string contains a specified substring.
# @arg $1 The substring to check for.
# @arg $2 The string to check.
# @exitcode 0 If the substring is found.
# @exitcode 1 If the substring is not found.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
stdlib.string.query.has_substring() {
  [[ "${#@}" == "2" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126
  [[ -n "${2}" ]] || builtin return 126

  [[ "${2}" != *"${1}"* ]] && builtin return 1
  builtin return 0
}
