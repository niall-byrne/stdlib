#!/bin/bash

# stdlib testing mock internal arg_array make library

builtin set -eo pipefail

# @description Generates a string representation of an array element for a mock.
# @noargs
# @exitcode 0 If the operation succeeded.
# @stdout The string representation of the array element.
# @internal
_mock.__internal.arg_array.make.element.from_array() {
  builtin local _mock_keyword_array_arg_indirect_reference
  builtin local -a _mock_keyword_array_arg
  builtin local _mock_keyword_array_arg_as_string

  _mock_keyword_array_arg_indirect_reference="${_mock_keyword_arg}[@]"
  _mock_keyword_array_arg=("${!_mock_keyword_array_arg_indirect_reference}")

  if [[ "${#_mock_keyword_array_arg[@]}" -eq 0 ]]; then
    _mock_keyword_array_arg_as_string=" "
  else
    _mock_keyword_array_arg_as_string="$(builtin printf "'%q' " "${_mock_keyword_array_arg[@]}")"
  fi

  builtin echo "${_mock_keyword_array_arg_as_string%?}"
}

# @description Generates an array of mock argument strings.
# @arg $1 string The name of the array to create.
# @arg $2 string The name of the array containing positional arguments.
# @arg $3 string (optional) The name of the array containing keyword arguments.
# @exitcode 0 If the operation succeeded.
# @internal
_mock.__internal.arg_array.make.from_array() {
  builtin local -a _mock_arg_array
  builtin local _mock_array_index
  builtin local _mock_arg_element
  builtin local -a _mock_keyword_args_array
  builtin local _mock_keyword_args_array_indirect_reference
  builtin local -a _mock_position_args_array
  builtin local _mock_positional_args_array_indirect_reference

  _mock_positional_args_array_indirect_reference="${2}[@]"
  _mock_position_args_array=("${!_mock_positional_args_array_indirect_reference}")

  if [[ -n "${3}" ]]; then
    _mock_keyword_args_array_indirect_reference="${3}[@]"
    _mock_keyword_args_array=("${!_mock_keyword_args_array_indirect_reference}")
  fi

  for ((_mock_array_index = 0; _mock_array_index < "${#_mock_position_args_array[@]}"; _mock_array_index++)); do
    _mock_arg_array+=("$((_mock_array_index + 1))(${_mock_position_args_array[_mock_array_index]})")
  done

  for ((_mock_array_index = 0; _mock_array_index < "${#_mock_keyword_args_array[@]}"; _mock_array_index++)); do
    _mock_keyword_arg="${_mock_keyword_args_array[_mock_array_index]}"
    if [[ -n "${_mock_keyword_arg}" ]]; then
      if _testing.__protected stdlib.array.query.is_array "${_mock_keyword_arg}"; then
        _mock_arg_array+=("${_mock_keyword_arg}($(_mock.__internal.arg_array.make.element.from_array))")
      else
        _mock_arg_array+=("${_mock_keyword_arg}(${!_mock_keyword_arg})")
      fi
    fi
  done

  if [[ ${#_mock_arg_array[@]} == "0" ]]; then
    builtin eval "${1}=()"
  else
    builtin eval "${1}=($(builtin printf '%q ' "${_mock_arg_array[@]}"))"
  fi
}
