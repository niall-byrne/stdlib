#!/bin/bash

# stdlib array make library

builtin set -eo pipefail

# @description Creates a copy of an existing array.
# @arg $1 string The name of the array to create.
# @arg $2 string The name of the existing array to copy.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.array.make.from_array() {
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local -a indirect_array
  builtin local indirect_reference

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"
  stdlib.var.assert.is_valid_name "${1}" || builtin return 126
  stdlib.array.assert.is_array "${2}" || builtin return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  if [[ "${#indirect_array[@]}" == 0 ]]; then
    builtin eval "${1}=()"
  else
    builtin eval "${1}=($(builtin printf '%q ' "${indirect_array[@]}"))"
  fi
}

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
  stdlib.var.assert.is_valid_name "${1}" || builtin return 126
  stdlib.string.assert.is_char "${2}" || builtin return 126
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
  stdlib.var.assert.is_valid_name "${1}" || builtin return 126
  stdlib.string.assert.is_char "${2}" || builtin return 126

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
  stdlib.var.assert.is_valid_name "${1}" || builtin return 126
  stdlib.string.assert.is_digit "${2}" || builtin return 126

  for ((array_index = 0; array_index < "${2}"; array_index++)); do
    builtin printf -v "${1}[${array_index}]" "%s" "${3}"
  done
}
