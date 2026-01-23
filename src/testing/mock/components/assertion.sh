#!/bin/bash

# stdlib testing mock assertion component

builtin set -eo pipefail

builtin export __STDLIB_TESTING_MOCK_COMPONENT

# shellcheck disable=SC2034
__STDLIB_TESTING_MOCK_COMPONENT="$(
  "${_STDLIB_BINARY_CAT}" << 'EOF'

${1}.mock.__count_matches() {
  # $1: a set of call args as a string

  builtin local _mock_object_arg_string_actual
  builtin local _mock_object_arg_string_expected
  builtin local _mock_object_call_definition
  builtin local _mock_object_match_count=0

  _mock_object_arg_string_expected="\$(builtin printf "%q" "\${1}")"

  while IFS= builtin read -r _mock_object_call_definition; do
    builtin eval "\${_mock_object_call_definition}"
    builtin printf -v _mock_object_arg_string_actual "%q" "\${_mock_object_call_array[*]}"
    if [[ "\${_mock_object_arg_string_expected}" == "\${_mock_object_arg_string_actual}" ]]; then
      ((_mock_object_match_count++))
    fi
  done < "\${__${2}_mock_calls_file}"

  builtin echo "\${_mock_object_match_count}"
}

${1}.mock.assert_any_call_is() {
  # $1: a set of call args as a string

  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local _mock_object_match_count

  _STDLIB_ARGS_NULL_SAFE=("1")

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"
  _mock.__internal.security.assert.is_builtin "declare" || builtin return "\$?"

  _mock_object_match_count="\$(${1}.mock.__count_matches "\${1}")"

  assert_not_equals \
    "0" \
    "\${_mock_object_match_count}" \
    "\$(_testing.mock.message.get "MOCK_NOT_CALLED_WITH" "${1}" "\${1}")"
}

${1}.mock.assert_call_n_is() {
  # $1: the call count to assert
  # $2: a set of call args as a string

  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local _mock_object_arg_string_actual
  builtin local _mock_object_call_count

  _STDLIB_ARGS_NULL_SAFE=("2")

  _testing.__protected stdlib.fn.args.require "2" "0" "\${@}" || builtin return "\$?"
  _testing.__protected stdlib.string.assert.is_digit "\${1}" || builtin return 126
  _testing.__protected stdlib.string.assert.not_equal "0" "\${1}" || builtin return 126
  _mock.__internal.security.assert.is_builtin "declare" || builtin return "\$?"

  _mock_object_call_count="\$(${1}.mock.get.count)"

  if [[ "\${_mock_object_call_count}" -lt "\${1}" ]]; then
    fail \
      "\$(_testing.mock.message.get MOCK_CALLED_N_TIMES "${1}" "\${_mock_object_call_count}")"
  fi

  _mock_object_arg_string_actual="\$("${1}.mock.get.call" "\${1}")"

  assert_equals \
    "\${2}" \
    "\${_mock_object_arg_string_actual}" \
    "\$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "${1}" "\${1}")"
}

${1}.mock.assert_called_once_with() {
  # $1: a set of call args as a string

  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local _mock_object_arg_string_actual
  builtin local _mock_object_match_count

  _STDLIB_ARGS_NULL_SAFE=("1")

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"
  _mock.__internal.security.assert.is_builtin "declare" || builtin return "\$?"

  ${1}.mock.assert_count_is "1"

  _mock_object_match_count="\$(${1}.mock.__count_matches "\${1}")"

  if [[ "\${_mock_object_match_count}" != "1" ]]; then
    _mock_object_arg_string_actual="\$(${1}.mock.get.call "1")"
    builtin echo \
      "\$(_testing.mock.message.get MOCK_CALL_ACTUAL_PREFIX): [\${_mock_object_arg_string_actual}]"
  fi

  assert_equals \
    "1" \
    "\${_mock_object_match_count}" \
    "\$(_testing.mock.message.get MOCK_NOT_CALLED_ONCE_WITH "${1}" "\${1}")"
}

${1}.mock.assert_calls_are() {
  # $@: a set of call args as strings that should match

  builtin local _mock_object_arg_string_actual
  builtin local _mock_object_arg_string_expected
  builtin local _mock_object_call_definition=""
  builtin local _mock_object_call_index=0
  builtin local -a _mock_object_expected_mock_calls

  _mock_object_expected_mock_calls=("\${@}")
  _mock.__internal.security.assert.is_builtin "declare" || builtin return "\$?"

  while IFS= builtin read -r _mock_object_call_definition; do
    builtin eval "\${_mock_object_call_definition}"
    builtin printf -v _mock_object_arg_string_expected "%q" "\${_mock_object_expected_mock_calls[_mock_object_call_index]}"
    builtin printf -v _mock_object_arg_string_actual "%q" "\${_mock_object_call_array[*]}"

    assert_equals \
      "\${_mock_object_arg_string_expected}" \
      "\${_mock_object_arg_string_actual}" \
      "\$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "${1}" "\$((_mock_object_call_index + 1))")"
    ((_mock_object_call_index++))
  done < "\${__${2}_mock_calls_file}" || builtin true

  if [[ "\${_mock_object_call_index}" == 0 ]] && [[ "\${#@}" != 0 ]]; then
    fail "\$(_testing.mock.message.get "MOCK_NOT_CALLED" "${1}")"
  fi

  if [[ "\${_mock_object_call_index}" < "\${#_mock_object_expected_mock_calls[@]}" ]]; then
    fail "\$(_testing.mock.message.get MOCK_CALLED_N_TIMES "${1}" "\$((_mock_object_call_index))")"
  fi
}

${1}.mock.assert_count_is() {
  # $1: the call count to assert

  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local _mock_object_call_count

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"
  _testing.__protected stdlib.string.assert.is_digit "\${1}" || builtin return 126

  _mock_object_call_count="\$("${1}.mock.get.count")"

  assert_equals \
    "\${1}" \
    "\${_mock_object_call_count}" \
    "\$(_testing.mock.message.get "MOCK_CALLED_N_TIMES" "${1}" "\${_mock_object_call_count}")"
}

${1}.mock.assert_not_called() {
  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local _mock_object_call_count

  _testing.__protected stdlib.fn.args.require "0" "0" "\${@}" || builtin return "\$?"

  _mock_object_call_count="\$(${1}.mock.get.count)"

  assert_equals \
    "0" \
    "\${_mock_object_call_count}" \
    "\$(_testing.mock.message.get "MOCK_CALLED_N_TIMES" "${1}" "\${_mock_object_call_count}")"
}
EOF
)"
