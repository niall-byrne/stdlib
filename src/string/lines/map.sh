#!/bin/bash

# stdlib string map library

builtin set -eo pipefail

# @description Maps a function over each line of a string.
#   * STDLIB_LINE_BREAK_DELIMITER_CHAR string keyword: The line break char to use (default=$'\n').
# @arg $1 string The name of the function to apply to each line.
# @arg $2 string The input string to process.
# @exitcode 0 If the operation succeeded.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The mapped lines.
# @stderr The error message if the operation fails.
stdlib.string.lines.map.fn() {
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local delimiter
  builtin local line=""
  builtin local output=""

  # shellcheck disable=SC2034
  STDLIB_ARGS_NULL_SAFE_ARRAY=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"
  stdlib.fn.assert.is_fn "${1}" || builtin return 126

  stdlib.fn.keyword.consume delimiter STDLIB_LINE_BREAK_DELIMITER_CHAR $'\n'

  STDLIB_KW_SOURCE_VAR="delimiter" \
    stdlib.fn.keyword.assert.is_valid_with stdlib.string.assert.is_char STDLIB_LINE_BREAK_DELIMITER_CHAR || builtin return 125 # validates STDLIB_LINE_BREAK_DELIMITER_CHAR

  if ! stdlib.string.query.has_substring "${delimiter}" "${2}"; then
    "${1}" "${2}"
    builtin return
  fi

  while IFS="${delimiter}" builtin read -r -d "${delimiter}" line; do
    output+="$("${1}" "${line}")${delimiter}"
  done < <(builtin echo -n "${2}${delimiter}") # KCOV_EXCLUDE_LINE

  builtin echo -e "${output%?}"
}

# @description A derivative of stdlib.string.lines.map.fn that can read from stdin.
#   * STDLIB_LINE_BREAK_DELIMITER_CHAR string keyword: The line break char to use (default=$'\n').
# @arg $1 string The name of the function to apply to each line.
# @arg $2 string (optional, default="-") The input string to process, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The input string to process.
# @stdout The mapped lines.
# @stderr The error message if the operation fails.
stdlib.string.lines.map.fn_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.lines.map.fn" "2"

# @description A derivative of stdlib.string.lines.map.fn that can read from and write to a variable.
#   * STDLIB_LINE_BREAK_DELIMITER_CHAR string keyword: The line break char to use (default=$'\n').
# @arg $1 string The name of the function to apply to each line.
# @arg $2 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.string.lines.map.fn_var() { :; }
stdlib.fn.derive.var "stdlib.string.lines.map.fn"

# @description Maps a format string over each line of a string.
#   * STDLIB_LINE_BREAK_DELIMITER_CHAR string keyword: The line break char to use (default=$'\n').
# @arg $1 string A valid printf format string.
# @arg $2 string The input string to process.
# @exitcode 0 If the operation succeeded.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The formatted lines.
# @stderr The error message if the operation fails.
stdlib.string.lines.map.format() {
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local delimiter
  builtin local line=""
  builtin local output=""

  # shellcheck disable=SC2034
  STDLIB_ARGS_NULL_SAFE_ARRAY=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"

  stdlib.fn.keyword.consume delimiter STDLIB_LINE_BREAK_DELIMITER_CHAR $'\n'

  STDLIB_KW_SOURCE_VAR="delimiter" \
    stdlib.fn.keyword.assert.is_valid_with stdlib.string.assert.is_char STDLIB_LINE_BREAK_DELIMITER_CHAR || builtin return 125 # validates STDLIB_LINE_BREAK_DELIMITER_CHAR

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

# @description A derivative of stdlib.string.lines.map.format that can read from stdin.
#   * STDLIB_LINE_BREAK_DELIMITER_CHAR string keyword: The line break char to use (default=$'\n').
# @arg $1 string A valid printf format string.
# @arg $2 string (optional, default="-") The input string to process, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The input string to process.
# @stdout The formatted lines.
# @stderr The error message if the operation fails.
stdlib.string.lines.map.format_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.lines.map.format" "2"

# @description A derivative of stdlib.string.lines.map.format that can read from and write to a variable.
#   * STDLIB_LINE_BREAK_DELIMITER_CHAR string keyword: The line break char to use (default=$'\n').
# @arg $1 string A valid printf format string.
# @arg $2 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.string.lines.map.format_var() { :; }
stdlib.fn.derive.var "stdlib.string.lines.map.format"
