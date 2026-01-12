#!/bin/bash

# stdlib string query has library

builtin set -eo pipefail

stdlib.string.query.has_char_n() {
  # $1 the char to check for
  # $2 the index to check at
  # $3 the string to check

  [[ "${#@}" == "3" ]] || builtin return 127
  stdlib.string.query.is_char "${1}" || builtin return "$?"
  stdlib.string.query.is_digit "${2}" || builtin return "$?"
  [[ -n "${3}" ]] || builtin return 126

  [[ "${1}" != "${3:${2}:1}" ]] && builtin return 1
  builtin return 0
}

stdlib.string.query.has_substring() {
  # $1 the substring to check for
  # $2 the string to check

  [[ "${#@}" == "2" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126
  [[ -n "${2}" ]] || builtin return 126

  [[ "${2}" != *"${1}"* ]] && builtin return 1
  builtin return 0
}
