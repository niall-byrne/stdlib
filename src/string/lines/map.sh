#!/bin/bash

# stdlib string map library

builtin set -eo pipefail

# @description Maps each line of a string to a new string using a printf format string.
#     _STDLIB_DELIMITER: A char sequence to split the string with for processing.
# @arg $1 string The printf format string.
# @arg $2 string The input string to process.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments was provided.
# @stdout The formatted lines.
stdlib.string.lines.map.format() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local delimiter="${_STDLIB_DELIMITER:-$'\n'}"
  builtin local line=""
  builtin local output=""

  _STDLIB_ARGS_NULL_SAFE=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"

  if ! stdlib.string.query.has_substring "${delimiter}" "${2}"; then
    # shellcheck disable=SC2059
    builtin printf "${1}" "${2}"
    builtin return
  fi

  while IFS="${delimiter}" builtin read -r -d "${delimiter}" line; do
    # shellcheck disable=SC2059
    output+="$(builtin printf "${1}" "${line}")${delimiter}"
  done < <(builtin echo -n "${2}${delimiter}") # KCOV_EXCLUDE_LINE

  builtin echo -e "${output%?}"
}

stdlib.fn.derive.pipeable "stdlib.string.lines.map.format" "2"

stdlib.fn.derive.var "stdlib.string.lines.map.format"

# @description Maps each line of a string to a new string using a function.
#     _STDLIB_DELIMITER: A char sequence to split the string with for processing.
# @arg $1 string The name of the function to apply.
# @arg $2 string The input string to process.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
# @stdout The mapped lines.
stdlib.string.lines.map.fn() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local delimiter="${_STDLIB_DELIMITER:-$'\n'}"
  builtin local line=""
  builtin local output=""

  _STDLIB_ARGS_NULL_SAFE=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"
  stdlib.fn.assert.is_fn "${1}" || builtin return 126

  if ! stdlib.string.query.has_substring "${delimiter}" "${2}"; then
    "${1}" "${2}"
    builtin return
  fi

  while IFS="${delimiter}" builtin read -r -d "${delimiter}" line; do
    output+="$("${1}" "${line}")${delimiter}"
  done < <(builtin echo -n "${2}${delimiter}") # KCOV_EXCLUDE_LINE

  builtin echo -e "${output%?}"
}

stdlib.fn.derive.pipeable "stdlib.string.lines.map.fn" "2"

stdlib.fn.derive.var "stdlib.string.lines.map.fn"
