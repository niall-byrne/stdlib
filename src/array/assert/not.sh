#!/bin/bash

# stdlib array assert is library

builtin set -eo pipefail

# @description Asserts that a variable is not an array.
# @arg $1 string The name of the variable to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
# @stderr The error message if the assertion fails.
stdlib.array.assert.not_array() {
  builtin local _stdlib_return_code=0

  stdlib.array.query.is_array "${@}" || _stdlib_return_code="$?"

  case "${_stdlib_return_code}" in
    0)
      stdlib.logger.error "$(stdlib.message.get IS_ARRAY "${1}")"
      builtin return 1
      ;;
    1)
      builtin return 0
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
  esac

  builtin return "${_stdlib_return_code}"
}

# @description Asserts that an array does not contain a specific value.
# @arg $1 string The value to look for.
# @arg $2 string The name of the array to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
# @stderr The error message if the assertion fails.
stdlib.array.assert.not_contains() {
  builtin local _stdlib_return_code=0

  stdlib.array.query.is_contains "${@}" || _stdlib_return_code="$?"

  case "${_stdlib_return_code}" in
    1)
      builtin return 0
      ;;
    126 | 127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get ARRAY_VALUE_FOUND "${1}" "${2}")"
      builtin return 1
      ;;
  esac

  builtin return "${_stdlib_return_code}"
}

# @description Asserts that an array is not empty.
# @arg $1 string The name of the array to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
# @stderr The error message if the assertion fails.
stdlib.array.assert.not_empty() {
  builtin local _stdlib_return_code=0

  stdlib.array.query.is_empty "${@}" || _stdlib_return_code="$?"

  case "${_stdlib_return_code}" in
    0)
      stdlib.logger.error "$(stdlib.message.get ARRAY_IS_EMPTY "${1}")"
      builtin return 1
      ;;
    1)
      builtin return 0
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

# @description Asserts that two arrays are not equal.
# @arg $1 string The name of the first array to compare.
# @arg $2 string The name of the second array to compare.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
# @stderr The error message if the assertion fails.
stdlib.array.assert.not_equal() {
  builtin local _stdlib_array_index
  builtin local _stdlib_array_name_1="${1}"
  builtin local _stdlib_array_name_2="${2}"
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
    builtin return 0
  fi

  for ((_stdlib_array_index = 0; _stdlib_array_index < "${#_stdlib_indirect_array_1[@]}"; _stdlib_array_index++)); do
    if [[ "${_stdlib_indirect_array_1[_stdlib_array_index]}" != "${_stdlib_indirect_array_2[_stdlib_array_index]}" ]]; then
      builtin return 0
    fi
  done

  stdlib.logger.error "$(stdlib.message.get ARRAY_ARE_EQUAL "${_stdlib_array_name_1}" "${_stdlib_array_name_2}")"
  builtin return 1
}
