#!/bin/bash

# stdlib array query is library

builtin set -eo pipefail

# @description Checks if an array contains a specified value.
# @arg string value The value to check for.
# @arg string array_name The name of the array.
# @exitcode 0 If the array contains the value.
# @exitcode 1 If the array does not contain the value.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
stdlib.array.query.is_contains() {
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

# @description Checks if two arrays are equal.
# @arg string array1_name The name of the first array.
# @arg string array2_name The name of the second array.
# @exitcode 0 If the arrays are equal.
# @exitcode 1 If the arrays are not equal.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
stdlib.array.query.is_equal() {
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

# @description Checks if a variable is an array.
# @arg string variable_name The name of the variable to check.
# @exitcode 0 If the variable is an array.
# @exitcode 1 If the variable is not an array.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
stdlib.array.query.is_array() {
  [[ "${#@}" == "1" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126
  if builtin declare -p "${1}" 2> /dev/null | "${_STDLIB_BINARY_GREP}" -q 'declare -a'; then # noqa
    builtin return 0
  fi
  builtin return 1
}

# @description Checks if an array is empty.
# @arg string array_name The name of the array.
# @exitcode 0 If the array is empty.
# @exitcode 1 If the array is not empty.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
stdlib.array.query.is_empty() {
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
