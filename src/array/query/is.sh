#!/bin/bash

# stdlib array query is library

builtin set -eo pipefail

stdlib.array.query.is_contains() {
  # $1: the value to query for
  # $2: the array name to query

  builtin local indirect_reference
  builtin local -a indirect_array
  builtin local check_value
  builtin local query_value="${1}"

  [[ "${#@}" == "2" ]] || builtin return 127
  stdlib.array.query.is_array "${2}" || builtin return 126

  indirect_reference="${2}[@]"
  indirect_array=("${!indirect_reference}")

  for check_value in "${indirect_array[@]}"; do
    if [[ ${check_value} == "${query_value}" ]]; then
      builtin return 0
    fi
  done

  builtin return 1
}

stdlib.array.query.is_equal() {
  # $1: the name of the first array to compare
  # $2: the name of the second array to compare

  builtin local indirect_reference_1
  builtin local -a indirect_array_1
  builtin local indirect_reference_2
  builtin local -a indirect_array_2

  [[ "${#@}" == "2" ]] || builtin return 127
  stdlib.array.query.is_array "${1}" || builtin return 126
  stdlib.array.query.is_array "${2}" || builtin return 126

  builtin local array_name_1="${1}"
  builtin local array_name_2="${2}"

  builtin local array_index

  indirect_reference_1="${array_name_1}[@]"
  indirect_array_1=("${!indirect_reference_1}")
  indirect_reference_2="${array_name_2}[@]"
  indirect_array_2=("${!indirect_reference_2}")

  builtin test "${#indirect_array_1[*]}" == "${#indirect_array_2[*]}" || builtin return 1

  for ((array_index = 0; array_index < "${#indirect_array_1[*]}"; array_index++)); do
    builtin test "${indirect_array_1[array_index]}" == "${indirect_array_2[array_index]}" || builtin return 1
  done

  builtin return 0
}

stdlib.array.query.is_array() {
  # $1: the array name to query

  [[ "${#@}" == "1" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126
  if builtin declare -p "${1}" 2> /dev/null | "${_STDLIB_BINARY_GREP}" -q 'declare -a'; then # noqa
    builtin return 0
  fi
  builtin return 1
}

stdlib.array.query.is_empty() {
  # $1: the array name to query

  builtin local indirect_reference
  builtin local -a indirect_array

  [[ "${#@}" == "1" ]] || builtin return 127
  stdlib.array.query.is_array "${1}" || builtin return 126

  indirect_reference="${1}[@]"
  indirect_array=("${!indirect_reference}")

  if [[ "${#indirect_array[@]}" == "0" ]]; then
    builtin return 0
  fi
  builtin return 1
}
