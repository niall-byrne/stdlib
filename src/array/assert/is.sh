#!/bin/bash

# stdlib array assert is library

builtin set -eo pipefail

# @description Asserts that a variable is an array.
# @arg string variable_name The name of the variable to check.
# @exitcode 1 If the variable is not an array.
# @exitcode 127 If the wrong number of arguments is provided.
# @stderr The error message if the assertion fails.
stdlib.array.assert.is_array() {
  builtin local _stdlib_return_code=0

  stdlib.array.query.is_array "${@}" || _stdlib_return_code="$?"

  case "${_stdlib_return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_ARRAY "${1}")"
      ;;
  esac

  builtin return "${_stdlib_return_code}"
}

# @description Asserts that an array contains a specified value.
# @arg string value The value to check for.
# @arg string array_name The name of the array.
# @exitcode 1 If the array does not contain the value.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
# @stderr The error message if the assertion fails.
stdlib.array.assert.is_contains() {
  builtin local _stdlib_return_code=0

  stdlib.array.query.is_contains "${@}" || _stdlib_return_code="$?"

  case "${_stdlib_return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get ARRAY_VALUE_NOT_FOUND "${1}" "${2}")"
      ;;
  esac

  builtin return "${_stdlib_return_code}"
}

# @description Asserts that an array is empty.
# @arg string array_name The name of the array.
# @exitcode 1 If the array is not empty.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
# @stderr The error message if the assertion fails.
stdlib.array.assert.is_empty() {
  builtin local _stdlib_return_code=0

  stdlib.array.query.is_empty "${@}" || _stdlib_return_code="$?"

  case "${_stdlib_return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    1)
      stdlib.logger.error "$(stdlib.message.get ARRAY_IS_NOT_EMPTY "${1}")"
      ;;
    126)
      stdlib.logger.error "$(stdlib.message.get IS_NOT_ARRAY "${1}")"
      ;;
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
  esac

  builtin return "${_stdlib_return_code}"
}

# @description Asserts that two arrays are equal.
# @arg string array1_name The name of the first array.
# @arg string array2_name The name of the second array.
# @exitcode 1 If the arrays are not equal.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
# @stderr The error message if the assertion fails.
stdlib.array.assert.is_equal() {
  builtin local _stdlib_array_index
  builtin local _stdlib_array_name_1="${1}"
  builtin local _stdlib_array_name_2="${2}"
  builtin local -a _stdlib_comparison_errors_array
  builtin local -a _stdlib_indirect_array_1
  builtin local -a _stdlib_indirect_array_2
  builtin local _stdlib_indirect_reference_1
  builtin local _stdlib_indirect_reference_2

  [[ "${#@}" == "2" ]] || {
    stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
    builtin return 127
  }
  stdlib.array.assert.is_array "${1}" || builtin return 126
  stdlib.array.assert.is_array "${2}" || builtin return 126

  _stdlib_indirect_reference_1="${_stdlib_array_name_1}[@]"
  _stdlib_indirect_array_1=("${!_stdlib_indirect_reference_1}")
  _stdlib_indirect_reference_2="${_stdlib_array_name_2}[@]"
  _stdlib_indirect_array_2=("${!_stdlib_indirect_reference_2}")

  if [[ "${#_stdlib_indirect_array_1[@]}" != "${#_stdlib_indirect_array_2[@]}" ]]; then
    _stdlib_comparison_errors_array+=("$(stdlib.message.get ARRAY_LENGTH_MISMATCH "${_stdlib_array_name_1}" "${#_stdlib_indirect_array_1[@]}")")
    _stdlib_comparison_errors_array+=("$(stdlib.message.get ARRAY_LENGTH_MISMATCH "${_stdlib_array_name_2}" "${#_stdlib_indirect_array_2[@]}")")
  fi

  for ((_stdlib_array_index = 0; _stdlib_array_index < "${#_stdlib_indirect_array_1[@]}"; _stdlib_array_index++)); do
    if ((_stdlib_array_index == "${#_stdlib_indirect_array_2[@]}")); then
      builtin break
    fi
    if [[ "${_stdlib_indirect_array_1[_stdlib_array_index]}" != "${_stdlib_indirect_array_2[_stdlib_array_index]}" ]]; then
      _stdlib_comparison_errors_array+=("$(stdlib.message.get ARRAY_ELEMENT_MISMATCH "${_stdlib_array_name_1}" "${_stdlib_array_index}" "${_stdlib_indirect_array_1[_stdlib_array_index]}")")
      _stdlib_comparison_errors_array+=("$(stdlib.message.get ARRAY_ELEMENT_MISMATCH "${_stdlib_array_name_2}" "${_stdlib_array_index}" "${_stdlib_indirect_array_2[_stdlib_array_index]}")")
    fi
  done

  if [[ "${#_stdlib_comparison_errors_array[@]}" -gt "0" ]]; then
    for ((_stdlib_array_index = 0; _stdlib_array_index < "${#_stdlib_comparison_errors_array[@]}"; _stdlib_array_index++)); do
      stdlib.logger.error "${_stdlib_comparison_errors_array[_stdlib_array_index]}"
    done
    builtin return 1
  fi

  builtin return 0
}
