#!/bin/bash

# stdlib testing mock arg_string make library

builtin set -eo pipefail

_mock.arg_string.make.from_array() {
  # $1: the array name to generate an arg string from
  # $2: an optional array name to generate keyword args from

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

_mock.arg_string.make.from_string() {
  # $1: the string to generate an arg string from
  # $2: an optional array name to generate keyword args from
  # STDLIB_LINE_BREAK_DELIMITER: a char sequence to split the string with, defaults to ' '

  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local -a _mock_args_array
  builtin local -a _mock_arg_string_args
  builtin local _mock_separator="${STDLIB_LINE_BREAK_DELIMITER:- }"

  # shellcheck disable=SC2034
  STDLIB_ARGS_NULL_SAFE_ARRAY=("2")
  _mock_arg_string_args=("_mock_args_array")

  _testing.__protected stdlib.fn.args.require "1" "1" "${@}" || builtin return 127

  if [[ -n "${2}" ]]; then
    _mock_arg_string_args+=("${2}")
  fi

  _testing.__protected stdlib.array.make.from_string _mock_args_array "${_mock_separator}" "${1}" || builtin return "$?"

  _mock.arg_string.make.from_array "${_mock_arg_string_args[@]}"
}
