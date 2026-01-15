#!/bin/bash

# stdlib array make library

builtin set -eo pipefail

# @description Creates an array from the contents of a file.
# @arg $1 The name of the array to create.
# @arg $2 The separator to split the file content by.
# @arg $3 The path to the source file.
# @exitcode 126 An invalid argument was provided.
# @stderr The error message if the operation fails.
stdlib.array.make.from_file() {
  stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?"
  stdlib.io.path.assert.is_file "${3}" || builtin return 126

  IFS="${2}" builtin read -ra "${1}" < "${3}"
}

# @description Creates an array from a string.
# @arg $1 The name of the array to create.
# @arg $2 The separator to split the string by.
# @arg $3 The source string.
# @exitcode 126 An invalid argument was provided.
# @stderr The error message if the operation fails.
stdlib.array.make.from_string() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE

  _STDLIB_ARGS_NULL_SAFE=("3")

  stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?"

  IFS="${2}" builtin read -d "" -ra "${1}" < <(builtin echo -n "${3}") || builtin return 0
}

# @description Creates an array by repeating a string a specified number of times.
# @arg $1 The name of the array to create.
# @arg $2 The number of times to repeat the string.
# @arg $3 The string to repeat.
# @exitcode 126 An invalid argument was provided.
# @stderr The error message if the operation fails.
stdlib.array.make.from_string_n() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local array_index

  _STDLIB_ARGS_NULL_SAFE=("3")

  stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?"
  stdlib.string.assert.is_digit "${2}" || builtin return 126

  for ((array_index = 0; array_index < "${2}"; array_index++)); do
    builtin printf -v "${1}[${array_index}]" "%s" "${3}"
  done
}
