#!/bin/bash

# stdlib array make library

builtin set -eo pipefail

# @description Creates an array from a file using a separator.
# @arg $1 string The name of the array to create.
# @arg $2 string The separator character.
# @arg $3 string The path to the source file.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.array.make.from_file() {
  stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?"
  stdlib.io.path.assert.is_file "${3}" || builtin return 126

  IFS="${2}" builtin read -ra "${1}" < "${3}"
}

# @description Creates an array from a string using a separator.
# @arg $1 string The name of the array to create.
# @arg $2 string The separator character.
# @arg $3 string The source string.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.array.make.from_string() {
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY

  # shellcheck disable=SC2034
  STDLIB_ARGS_NULL_SAFE_ARRAY=("3")

  stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?"

  IFS="${2}" builtin read -d "" -ra "${1}" < <(builtin echo -n "${3}") || builtin return 0 # noqa
}

# @description Creates an array by repeating a string a specified number of times.
# @arg $1 string The name of the array to create.
# @arg $2 integer The number of times to repeat the string.
# @arg $3 string The string to repeat.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.array.make.from_string_n() {
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local array_index

  # shellcheck disable=SC2034
  STDLIB_ARGS_NULL_SAFE_ARRAY=("3")

  stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?"
  stdlib.string.assert.is_digit "${2}" || builtin return 126

  for ((array_index = 0; array_index < "${2}"; array_index++)); do
    builtin printf -v "${1}[${array_index}]" "%s" "${3}"
  done
}
