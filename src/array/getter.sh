#!/bin/bash

# stdlib array getter library

builtin set -eo pipefail

_STDLIB_ARRAY_BUFFER=""

# @description Gets the last element of an array.
# @arg $1 string The name of the array.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
# @set _STDLIB_ARRAY_BUFFER The last element of the array.
# @stdout The last element of the array.
stdlib.array.get.last() {
  builtin local indirect_reference
  builtin local -a indirect_array
  builtin local indirect_array_last_element_index

  stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?"
  stdlib.array.assert.not_empty "${1}" || builtin return 126

  indirect_reference="${1}[@]"
  indirect_array=("${!indirect_reference}")
  indirect_array_last_element_index="$(("${#indirect_array[@]}" - 1))"

  _STDLIB_ARRAY_BUFFER="${indirect_array[indirect_array_last_element_index]}"
  builtin echo "${_STDLIB_ARRAY_BUFFER}"
}

# @description Gets the length of an array.
# @arg $1 string The name of the array.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
# @set _STDLIB_ARRAY_BUFFER The length of the array.
# @stdout The length of the array.
stdlib.array.get.length() {
  builtin local indirect_reference
  builtin local -a indirect_array
  builtin local indirect_array_last_element_index

  stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?"
  stdlib.array.assert.is_array "${1}" || builtin return 126

  indirect_reference="${1}[@]"
  indirect_array=("${!indirect_reference}")

  _STDLIB_ARRAY_BUFFER="${#indirect_array[@]}"
  builtin echo "${_STDLIB_ARRAY_BUFFER}"
}

# @description Gets the length of the longest element in an array.
# @arg $1 string The name of the array.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
# @set _STDLIB_ARRAY_BUFFER The length of the longest element.
# @stdout The length of the longest element.
stdlib.array.get.longest() {
  builtin local indirect_reference
  builtin local -a indirect_array
  builtin local indirect_array_last_element_index
  builtin local current_array_element
  builtin local longest_array_element_length=-1

  stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?"
  stdlib.array.assert.not_empty "${1}" || builtin return 126

  indirect_reference="${1}[@]"
  indirect_array=("${!indirect_reference}")

  for current_array_element in "${indirect_array[@]}"; do
    if [[ "${#current_array_element}" -gt "${longest_array_element_length}" ]]; then
      longest_array_element_length="${#current_array_element}"
    fi
  done

  _STDLIB_ARRAY_BUFFER="${longest_array_element_length}"
  builtin echo "${_STDLIB_ARRAY_BUFFER}"
}

# @description Gets the length of the shortest element in an array.
# @arg $1 string The name of the array.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
# @set _STDLIB_ARRAY_BUFFER The length of the shortest element.
# @stdout The length of the shortest element.
stdlib.array.get.shortest() {
  builtin local indirect_reference
  builtin local -a indirect_array
  builtin local indirect_array_last_element_index
  builtin local current_array_element
  builtin local shortest_array_element_length=-1

  stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?"
  stdlib.array.assert.not_empty "${1}" || builtin return 126

  indirect_reference="${1}[@]"
  indirect_array=("${!indirect_reference}")

  for current_array_element in "${indirect_array[@]}"; do
    if [[ "${#current_array_element}" -lt "${shortest_array_element_length}" ]] ||
      [[ "${shortest_array_element_length}" == "-1" ]]; then
      shortest_array_element_length="${#current_array_element}"
    fi
  done

  _STDLIB_ARRAY_BUFFER="${shortest_array_element_length}"
  builtin echo "${_STDLIB_ARRAY_BUFFER}"
}
