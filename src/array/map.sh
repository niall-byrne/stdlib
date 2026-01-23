#!/bin/bash

# stdlib array map library

builtin set -eo pipefail

# @description Maps each element of an array to a string using a printf format string.
# @arg $1 string The printf format string.
# @arg $2 string The name of the array.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The formatted elements.
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

# @description Maps each element of an array to a string using a function.
# @arg $1 string The name of the function to apply.
# @arg $2 string The name of the array.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The results of applying the function to each element.
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
