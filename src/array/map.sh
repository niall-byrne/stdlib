#!/bin/bash

# stdlib array map library

builtin set -eo pipefail

# @description Applies a format string to each element of an array.
# @arg $1 A valid printf format string.
# @arg $2 The name of the array to process.
# @exitcode 0 If the format string was applied successfully.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
# @stdout The formatted elements of the array.
# @stderr The error message if the operation fails.
stdlib.array.map.format() {
  builtin local element
  builtin local indirect_reference
  builtin local -a indirect_array

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"
  stdlib.array.assert.is_array "${2}" || builtin return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  for element in "${indirect_array[@]}"; do
    # shellcheck disable=SC2059
    builtin printf "${1}" "${element}"
  done
}

# @description Applies a function to each element of an array.
# @arg $1 A valid function to apply to each element.
# @arg $2 The name of the array to process.
# @exitcode 0 If the function was applied successfully.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
# @stdout The output of the function being applied to each element.
# @stderr The error message if the operation fails.
stdlib.array.map.fn() {
  builtin local element
  builtin local indirect_reference
  builtin local -a indirect_array

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"
  stdlib.fn.assert.is_fn "${1}" || builtin return 126
  stdlib.array.assert.is_array "${2}" || builtin return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  for element in "${indirect_array[@]}"; do
    "${1}" "${element}"
  done
}
