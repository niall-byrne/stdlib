#!/bin/bash

# stdlib testing mock arg_string make library

builtin set -eo pipefail

# @description Generates a mock argument string from an array.
# @arg $1 string The name of the array containing positional arguments.
# @arg $2 string (optional) The name of the array containing keyword arguments.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The generated mock argument string.
_mock.arg_string.make.from_array() {
  builtin local _mock_arg_string=""
  builtin local _mock_arg_string_spacer=""
  builtin local _mock_array_index
  builtin local -a _mock_generated_mock_arg_array
  builtin local _mock_keyword_arg
  builtin local -a _mock_keyword_args_array
  builtin local _mock_keyword_args_array_indirect_reference
  builtin local -a _mock_position_args_array
  builtin local _mock_positional_args_array_indirect_reference

  _testing.__protected stdlib.fn.args.require "1" "1" "$@" || builtin return 127
  _testing.__protected stdlib.array.assert.is_array "${1}" || builtin return 126

  if [[ "${#@}" == 2 ]]; then
    _testing.__protected stdlib.array.assert.is_array "${2}" || builtin return 126
  fi

  _mock.__internal.arg_array.make.from_array \
    _mock_generated_mock_arg_array \
    "${@}"

  builtin echo "${_mock_generated_mock_arg_array[*]}"
}

# @description Generates a mock argument string from a delimited string.
#     _STDLIB_DELIMITER: The delimiter to use for splitting the string (default: ' ').
# @arg $1 string The delimited string of positional arguments.
# @arg $2 string (optional) The name of the array containing keyword arguments.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The generated mock argument string.
_mock.arg_string.make.from_string() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local -a _mock_args_array
  builtin local -a _mock_arg_string_args
  builtin local _mock_separator="${_STDLIB_DELIMITER:- }"

  _STDLIB_ARGS_NULL_SAFE=("2")
  _mock_arg_string_args=("_mock_args_array")

  _testing.__protected stdlib.fn.args.require "1" "1" "${@}" || builtin return 127

  if [[ -n "${2}" ]]; then
    _mock_arg_string_args+=("${2}")
  fi

  _testing.__protected stdlib.array.make.from_string _mock_args_array "${_mock_separator}" "${1}" || builtin return "$?"

  _mock.arg_string.make.from_array "${_mock_arg_string_args[@]}"
}
