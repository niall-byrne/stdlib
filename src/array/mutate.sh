#!/bin/bash

# stdlib array mutate library

builtin set -eo pipefail

# @description Appends a string to each element of an array, modifying the array in place.
# @arg $1 The string to append.
# @arg $2 The name of the array to modify.
# @exitcode 126 If an invalid argument has been provided.
# @stderr The error message if the operation fails.
stdlib.array.mutate.append() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local -a indirect_array
  builtin local indirect_array_index
  builtin local indirect_reference

  _STDLIB_ARGS_NULL_SAFE=("1")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"
  stdlib.array.assert.is_array "${2}" || builtin return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  for ((indirect_array_index = 0; indirect_array_index < "${#indirect_array[@]}"; indirect_array_index++)); do
    indirect_array[indirect_array_index]="${indirect_array[indirect_array_index]}${1}"
  done

  if [[ "${#indirect_array[@]}" == 0 ]]; then
    builtin eval "${2}=()"
  else
    builtin eval "${2}=($(builtin printf '%q ' "${indirect_array[@]}"))"
  fi
}

# @description Applies a function to each element of an array, modifying the array in place.
# @arg $1 The name of the function to apply.
# @arg $2 The name of the array to modify.
# @exitcode 126 If an invalid argument has been provided.
# @stderr The error message if the operation fails.
stdlib.array.mutate.fn() {
  builtin local -a indirect_array
  builtin local indirect_array_index=0
  builtin local indirect_reference

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"
  stdlib.fn.assert.is_fn "${1}" || builtin return 126
  stdlib.array.assert.is_array "${2}" || builtin return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  for ((indirect_array_index = 0; indirect_array_index < "${#indirect_array[@]}"; indirect_array_index++)); do
    # shellcheck disable=SC2059
    indirect_array[indirect_array_index]="$("${1}" "${indirect_array[indirect_array_index]}")"
  done

  if [[ "${#indirect_array[@]}" == 0 ]]; then
    builtin eval "${2}=()"
  else
    builtin eval "${2}=($(builtin printf '%q ' "${indirect_array[@]}"))"
  fi
}

# @description Filters an array in place using a provided filter function.
# @arg $1 The name of the filter function. A match is based on a return status code of 0.
# @arg $2 The name of the array to modify.
# @exitcode 126 If an invalid argument has been provided.
# @stderr The error message if the operation fails.
stdlib.array.mutate.filter() {
  builtin local array_element
  builtin local -a new_array
  builtin local -a indirect_array
  builtin local indirect_reference

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"
  stdlib.fn.assert.is_fn "${1}" || builtin return 126
  stdlib.array.assert.is_array "${2}" || builtin return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  for array_element in "${indirect_array[@]}"; do
    if "${1}" "${array_element}"; then
      new_array+=("${array_element}")
    fi
  done

  if [[ "${#new_array[@]}" == 0 ]]; then
    builtin eval "${2}=()"
  else
    builtin eval "${2}=($(builtin printf '%q ' "${new_array[@]}"))"
  fi
}

# @description Applies a printf format string to each element of an array, modifying the array in place.
# @arg $1 A valid printf format string.
# @arg $2 The name of the array to modify.
# @exitcode 126 If an invalid argument has been provided.
# @stderr The error message if the operation fails.
stdlib.array.mutate.format() {
  builtin local -a indirect_array
  builtin local indirect_array_index=0
  builtin local indirect_reference

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"
  stdlib.array.assert.is_array "${2}" || builtin return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  for ((indirect_array_index = 0; indirect_array_index < "${#indirect_array[@]}"; indirect_array_index++)); do
    # shellcheck disable=SC2059
    indirect_array[indirect_array_index]="$(builtin printf "${1}" "${indirect_array[indirect_array_index]}")"
  done

  if [[ "${#indirect_array[@]}" == 0 ]]; then
    builtin eval "${2}=()"
  else
    builtin eval "${2}=($(builtin printf '%q ' "${indirect_array[@]}"))"
  fi
}

# @description Inserts a string into an array at a specified index, modifying the array in place.
# @arg $1 The string to insert.
# @arg $2 The index to insert the string at.
# @arg $3 The name of the array to modify.
# @exitcode 126 If an invalid argument has been provided.
# @stderr The error message if the operation fails.
stdlib.array.mutate.insert() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local -a indirect_array
  builtin local indirect_reference

  _STDLIB_ARGS_NULL_SAFE=("1")

  stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?"
  stdlib.array.assert.is_array "${3}" || builtin return 126

  indirect_reference="${3}[@]"
  indirect_array=("${!indirect_reference}")

  stdlib.string.assert.is_integer_with_range "0" "${#indirect_array[@]}" "${2}" || builtin return 126

  indirect_array=("${indirect_array[@]:"0":"${2}"}" "${1}" "${indirect_array[@]:"${2}"}")
  builtin eval "${3}=($(builtin printf '%q ' "${indirect_array[@]}"))"
}

# @description Prepends a string to each element of an array, modifying the array in place.
# @arg $1 The string to prepend.
# @arg $2 The name of the array to modify.
# @exitcode 126 If an invalid argument has been provided.
# @stderr The error message if the operation fails.
stdlib.array.mutate.prepend() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local -a indirect_array
  builtin local indirect_array_index
  builtin local indirect_reference

  _STDLIB_ARGS_NULL_SAFE=("1")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"
  stdlib.array.assert.is_array "${2}" || builtin return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  for ((indirect_array_index = 0; indirect_array_index < "${#indirect_array[@]}"; indirect_array_index++)); do
    indirect_array[indirect_array_index]="${1}${indirect_array[indirect_array_index]}"
  done

  if [[ "${#indirect_array[@]}" == 0 ]]; then
    builtin eval "${2}=()"
  else
    builtin eval "${2}=($(builtin printf '%q ' "${indirect_array[@]}"))"
  fi
}

# @description Removes an element from an array at a specified index, modifying the array in place.
# @arg $1 The index of the element to remove.
# @arg $2 The name of the array to modify.
# @exitcode 126 If an invalid argument has been provided.
# @stderr The error message if the operation fails.
stdlib.array.mutate.remove() {
  builtin local -a indirect_array
  builtin local indirect_reference

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"
  stdlib.array.assert.is_array "${2}" || builtin return 126
  stdlib.array.assert.not_empty "${2}" || builtin return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  stdlib.string.assert.is_integer_with_range "0" "$(("${#indirect_array[@]}" - 1))" "${1}" || builtin return 126

  builtin unset 'indirect_array["${1}"]'
  builtin eval "${2}=($(builtin printf '%q ' "${indirect_array[@]}"))"
}

# @description Reverses the order of elements in an array, modifying the array in place.
# @arg $1 The name of the array to modify.
# @exitcode 126 If an invalid argument has been provided.
# @stderr The error message if the operation fails.
stdlib.array.mutate.reverse() {
  builtin local element
  builtin local -a indirect_array
  builtin local indirect_array_index_1
  builtin local indirect_array_index_2
  builtin local indirect_reference

  stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?"
  stdlib.array.assert.is_array "${1}" || builtin return 126

  indirect_reference="${1}[@]"
  indirect_array=("${!indirect_reference}")

  for ((indirect_array_index_1 = 0, indirect_array_index_2 = "${#indirect_array[@]}" - 1; indirect_array_index_1 < indirect_array_index_2; indirect_array_index_1++, indirect_array_index_2--)); do
    element="${indirect_array[indirect_array_index_1]}"
    indirect_array[indirect_array_index_1]="${indirect_array[indirect_array_index_2]}"
    indirect_array[indirect_array_index_2]="${element}"
  done

  if [[ "${#indirect_array[@]}" == 0 ]]; then
    builtin eval "${1}=()"
  else
    builtin eval "${1}=($(builtin printf '%q ' "${indirect_array[@]}"))"
  fi
}
