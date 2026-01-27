#!/bin/bash

# stdlib testing mock getter component

builtin set -eo pipefail

builtin export __STDLIB_TESTING_MOCK_COMPONENT

# shellcheck disable=SC2034
__STDLIB_TESTING_MOCK_COMPONENT="$(
  "${_STDLIB_BINARY_CAT}" << 'EOF'

# @description This function will iterate through each call made with this mock, and evaluate a given conditional command.  If this command passes, then the subsequent given commands are then executed.
# @arg $1 string An escaped bash command that can be safely evaluated as the function iterates through each mock call.
# @arg $@ array Additional bash commands that will be evaluated and executed if the comparison succeeds.
# @exitcode 0 If the operation is successful.
# @internal
${1}.mock.__get_apply_to_matching_mock_calls() {
  builtin local _mock_object_call_file_index=1
  builtin local _mock_object_call_file_line

  while builtin read -r _mock_object_call_file_line; do
    builtin eval "\${_mock_object_call_file_line}"
    builtin printf -v _mock_object_escaped_args "%q" "\${_mock_object_call_array[*]}"
    if builtin eval "\${1}"; then
      builtin eval "\${@:2}"
    fi
    ((_mock_object_call_file_index++))
  done < "\${__${2}_mock_calls_file}"
}

# @description This function will retrieve the call at the specified index from the mock's call history.
# @arg $1 integer An index (from 1) in the mock's call history to retrieve.
# @exitcode 0 If the operation is successful.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The specified mock call as an arg string.
# @stderr The error message if the operation fails.
${1}.mock.get.call() {
  # $1: the call to retrieve

  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local _mock_object_escaped_args

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"
  _testing.__protected stdlib.string.assert.is_digit "\${1}" || builtin return 126
  _testing.__protected stdlib.string.assert.not_equal "0" "\${1}" || builtin return 126
  _mock.__internal.security.assert.is_builtin "declare" || builtin return "\$?"

  builtin printf -v _mock_object_escaped_args "%q" "\${1}"

  ${1}.mock.__get_apply_to_matching_mock_calls \
    "[[ "\\\${_mock_object_call_file_index}" == "\${_mock_object_escaped_args}" ]]" \
    builtin printf '%s\\\\n' '"\${_mock_object_call_array[*]}"'
}

# @description This function will retrieve all calls from the mock's call history.
# @noargs
# @exitcode 0 If the operation is successful.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout All calls made by this mock as new line separated arg strings.
# @stderr The error message if the operation fails.
${1}.mock.get.calls() {
  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local _mock_object_escaped_args

  _testing.__protected stdlib.fn.args.require "0" "0" "\${@}" || builtin return "\$?"
  _mock.__internal.security.assert.is_builtin "declare" || builtin return "\$?"

  ${1}.mock.__get_apply_to_matching_mock_calls \
    "true" \
    builtin printf '%s\\\\n' '"\${_mock_object_call_array[*]}"'
}

# @description This function will retrieve a count of the number of times this mock has been called.
# @noargs
# @exitcode 0 If the operation is successful.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout A count of the the number of times this mock has been called.
# @stderr The error message if the operation fails.
${1}.mock.get.count() {
  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  _testing.__protected stdlib.fn.args.require "0" "0" "\${@}" || builtin return "\$?"

  < "\${__${2}_mock_calls_file}" wc -l
}

# @description This function will retrieve the keywords assigned to this mock.  (These keywords are variables who's value is recorded during each mock call).
# @noargs
# @exitcode 0 If the operation is successful.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The keywords currently assigned to this mock.
# @stderr The error message if the operation fails.
${1}.mock.get.keywords() {
  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  _testing.__protected stdlib.fn.args.require "0" "0" "\${@}" || builtin return "\$?"

  builtin echo "\${__${2}_mock_keywords[*]}"
}
EOF
)"
