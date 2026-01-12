#!/bin/bash

# stdlib string query syntactic sugar library

builtin set -eo pipefail

stdlib.string.query.ends_with() {
  # $1 the substring to check for
  # $2 the string to check

  [[ "${#@}" == "2" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126
  [[ -n "${2}" ]] || builtin return 126

  [[ "${2}" == *"${1}" ]] || builtin return 1
  builtin return 0
}

stdlib.string.query.first_char_is() {
  # $1 the char to check for
  # $2 the string to check

  [[ "${#@}" == "2" ]] || builtin return 127
  [[ "${#1}" == "1" ]] || builtin return 126
  [[ -n "${2}" ]] || builtin return 126

  stdlib.string.query.has_char_n "${1}" "0" "${2}"
}

stdlib.string.query.last_char_is() {
  # $1 the char to check for
  # $2 the string to check

  [[ "${#@}" == "2" ]] || builtin return 127
  [[ "${#1}" == "1" ]] || builtin return 126
  [[ -n "${2}" ]] || builtin return 126

  stdlib.string.query.has_char_n "${1}" "$(("${#2}" - 1))" "${2}"
}

stdlib.string.query.starts_with() {
  # $1 the substring to check for
  # $2 the string to check

  [[ "${#@}" == "2" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126
  [[ -n "${2}" ]] || builtin return 126

  [[ "${2}" == "${1}"* ]] || builtin return 1
  builtin return 0
}
