#!/bin/bash

# stdlib string map library

builtin set -eo pipefail

# @description Applies a printf format string to each line of a string.
#   _STDLIB_DELIMITER: The character sequence to split the string with. Defaults to a newline.
# @arg $1 string A valid printf format string.
# @arg $2 string The string to process.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments is provided.
# @stdout The formatted string.
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

# @description Applies a function to each line of a string.
#   _STDLIB_DELIMITER: The character sequence to split the string with. Defaults to a newline.
# @arg $1 function The name of the function to apply.
# @arg $2 string The string to process.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
# @stdout The processed string.
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
