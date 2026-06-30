#!/bin/bash

# stdlib string split map library

builtin set -eo pipefail

# @description Maps a function over each line of a string.
#   * STDLIB_FIELD_DELIMITER string keyword: The field separator char sequence to use (default=$'\n').
#   * STDLIB_FIELD_DELIMITER_ENCODE_CHAR string keyword: A placeholder char used to encode multi-char delimiters (default=$'\x1e').
# @arg $1 string The name of the function to apply to each line.
# @arg $2 string The input string to process.
# @exitcode 0 If the operation succeeded.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The mapped lines.
# @stderr The error message if the operation fails.
stdlib.string.split.map.fn() {
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local delimiter=""
  builtin local fn_name="${1}"
  builtin local input="${2}"
  builtin local line=""
  builtin local output=""
  builtin local placeholder=""

  # shellcheck disable=SC2034
  STDLIB_ARGS_NULL_SAFE_ARRAY=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"
  stdlib.fn.assert.is_fn "${fn_name}" || builtin return 126

  stdlib.fn.keyword.consume delimiter STDLIB_FIELD_DELIMITER $'\n'
  stdlib.fn.keyword.consume placeholder STDLIB_FIELD_DELIMITER_ENCODE_CHAR $'\x1e'

  STDLIB_KW_SOURCE_VAR="delimiter" \
    stdlib.fn.keyword.assert.is_valid_with stdlib.string.assert.not_empty STDLIB_FIELD_DELIMITER || builtin return 125 # validates STDLIB_FIELD_DELIMITER
  STDLIB_KW_SOURCE_VAR="placeholder" \
    stdlib.fn.keyword.assert.is_valid_with stdlib.string.assert.is_char STDLIB_FIELD_DELIMITER_ENCODE_CHAR || builtin return 125 # validates STDLIB_FIELD_DELIMITER_ENCODE_CHAR

  input="${input//${delimiter}/${placeholder}}"

  while IFS="${placeholder}" builtin read -r -d "${placeholder}" line; do
    output+="$("${fn_name}" "${line}")${placeholder}"
  done < <(builtin printf "%s" "${input}${placeholder}") # KCOV_EXCLUDE_LINE

  output="${output%?}"
  output="${output//${placeholder}/${delimiter}}"

  builtin echo -e "${output}"
}

# @description A derivative of stdlib.string.split.map.fn that can read from stdin.
#   * STDLIB_FIELD_DELIMITER string keyword: The field separator char sequence to use (default=$'\n').
#   * STDLIB_FIELD_DELIMITER_ENCODE_CHAR string keyword: A placeholder char used to encode multi-char delimiters (default=$'\x1e').
# @arg $1 string The name of the function to apply to each line.
# @arg $2 string (optional, default="-") The input string to process, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The input string to process.
# @stdout The mapped lines.
# @stderr The error message if the operation fails.
stdlib.string.split.map.fn_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.split.map.fn" "2"

# @description A derivative of stdlib.string.split.map.fn that can read from and write to a variable.
#   * STDLIB_FIELD_DELIMITER string keyword: The field separator char sequence to use (default=$'\n').
#   * STDLIB_FIELD_DELIMITER_ENCODE_CHAR string keyword: A placeholder char used to encode multi-char delimiters (default=$'\x1e').
# @arg $1 string The name of the function to apply to each line.
# @arg $2 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.string.split.map.fn_var() { :; }
stdlib.fn.derive.var "stdlib.string.split.map.fn"

# @description Maps a format string over each line of a string.
#   * STDLIB_FIELD_DELIMITER string keyword: The field separator char sequence to use (default=$'\n').
#   * STDLIB_FIELD_DELIMITER_ENCODE_CHAR string keyword: A placeholder char used to encode multi-char delimiters (default=$'\x1e').
# @arg $1 string A valid printf format string.
# @arg $2 string The input string to process.
# @exitcode 0 If the operation succeeded.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The formatted lines.
# @stderr The error message if the operation fails.
stdlib.string.split.map.format() {
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local delimiter
  builtin local line=""
  builtin local output=""
  builtin local fmt_string="${1}"
  builtin local input="${2}"

  # shellcheck disable=SC2034
  STDLIB_ARGS_NULL_SAFE_ARRAY=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"

  stdlib.fn.keyword.consume delimiter STDLIB_FIELD_DELIMITER $'\n'
  stdlib.fn.keyword.consume placeholder STDLIB_FIELD_DELIMITER_ENCODE_CHAR $'\x1e'

  STDLIB_KW_SOURCE_VAR="delimiter" \
    stdlib.fn.keyword.assert.is_valid_with stdlib.string.assert.not_empty STDLIB_FIELD_DELIMITER || builtin return 125 # validates STDLIB_FIELD_DELIMITER
  STDLIB_KW_SOURCE_VAR="placeholder" \
    stdlib.fn.keyword.assert.is_valid_with stdlib.string.assert.is_char STDLIB_FIELD_DELIMITER_ENCODE_CHAR || builtin return 125 # validates STDLIB_FIELD_DELIMITER_ENCODE_CHAR

  input="${input//${delimiter}/${placeholder}}"

  while IFS="${placeholder}" builtin read -r -d "${placeholder}" line; do
    # shellcheck disable=SC2059
    output+="$(builtin printf "${fmt_string}" "${line}")${placeholder}"
  done < <(builtin printf "%s" "${input}${placeholder}") # KCOV_EXCLUDE_LINE

  output="${output%?}"
  output="${output//${placeholder}/${delimiter}}"

  builtin echo -e "${output}"
}

# @description A derivative of stdlib.string.split.map.format that can read from stdin.
#   * STDLIB_FIELD_DELIMITER string keyword: The field separator char sequence to use (default=$'\n').
#   * STDLIB_FIELD_DELIMITER_ENCODE_CHAR string keyword: A placeholder char used to encode multi-char delimiters (default=$'\x1e').
# @arg $1 string A valid printf format string.
# @arg $2 string (optional, default="-") The input string to process, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The input string to process.
# @stdout The formatted lines.
# @stderr The error message if the operation fails.
stdlib.string.split.map.format_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.split.map.format" "2"

# @description A derivative of stdlib.string.split.map.format that can read from and write to a variable.
#   * STDLIB_FIELD_DELIMITER string keyword: The field separator char sequence to use (default=$'\n').
#   * STDLIB_FIELD_DELIMITER_ENCODE_CHAR string keyword: A placeholder char used to encode multi-char delimiters (default=$'\x1e').
# @arg $1 string A valid printf format string.
# @arg $2 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.string.split.map.format_var() { :; }
stdlib.fn.derive.var "stdlib.string.split.map.format"
