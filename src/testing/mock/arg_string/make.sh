#!/bin/bash

# stdlib testing mock arg_string make library

builtin set -eo pipefail

# @description Generates a mock argument string from an array.
# @arg $1 string The name of the array containing positional arguments.
# @arg $2 string (optional) The name of the array containing keyword arguments.
# @exitcode 0 If the mock argument string was generated.
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

  _mock.__internal.arg_array.make.from_array _mock_generated_mock_arg_array "${@}"

  builtin echo "${_mock_generated_mock_arg_array[*]}"
}

# @description Generates a mock argument string from a delimited string.
#   * STDLIB_FIELD_DELIMITER string keyword: The field separator char sequence to use (default=' ').
#   * STDLIB_FIELD_DELIMITER_ENCODE_CHAR string keyword: A placeholder char used to encode multi-char delimiters (default=$'\x1e').
# @arg $1 string The delimited string of positional arguments.
# @arg $2 string (optional) The name of the array containing keyword arguments.
# @exitcode 0 If the mock argument string was generated.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The generated mock argument string.
_mock.arg_string.make.from_string() {
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local -a _mock_args_array
  builtin local -a _mock_arg_string_args
  builtin local _mock_delimiter=""
  builtin local _mock_placeholder=""

  # shellcheck disable=SC2034
  STDLIB_ARGS_NULL_SAFE_ARRAY=("2")
  _mock_arg_string_args=("_mock_args_array")

  _testing.__protected stdlib.fn.args.require "1" "1" "${@}" || builtin return 127

  _testing.__protected stdlib.fn.keyword.consume _mock_delimiter STDLIB_FIELD_DELIMITER " "
  _testing.__protected stdlib.fn.keyword.consume _mock_placeholder STDLIB_FIELD_DELIMITER_ENCODE_CHAR $'\x1e'

  STDLIB_KW_SOURCE_VAR="_mock_delimiter" \
    _testing.__protected stdlib.fn.keyword.assert.is_valid_with "$(_testing.__protected_name stdlib.string.assert.not_empty)" STDLIB_FIELD_DELIMITER || builtin return 125 # validates STDLIB_FIELD_DELIMITER
  STDLIB_KW_SOURCE_VAR="_mock_placeholder" \
    _testing.__protected stdlib.fn.keyword.assert.is_valid_with "$(_testing.__protected_name stdlib.string.assert.is_char)" STDLIB_FIELD_DELIMITER_ENCODE_CHAR || builtin return 125 # validates STDLIB_FIELD_DELIMITER_ENCODE_CHAR

  if [[ -n "${2}" ]]; then
    _mock_arg_string_args+=("${2}")
  fi

  STDLIB_FIELD_DELIMITER_ENCODE_CHAR="${_mock_placeholder}" _testing.__protected \
    stdlib.array.make.from_string _mock_args_array "${_mock_delimiter}" "${1}" || builtin return "$?"

  _mock.arg_string.make.from_array "${_mock_arg_string_args[@]}"
}
