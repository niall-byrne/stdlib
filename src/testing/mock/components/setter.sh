#!/bin/bash

# stdlib testing mock setter component

builtin set -eo pipefail

builtin export __STDLIB_TESTING_MOCK_COMPONENT

# shellcheck disable=SC2034
__STDLIB_TESTING_MOCK_COMPONENT="$(
  "${_STDLIB_BINARY_CAT}" << EOF
${1}.mock.set.keywords() {
  # $@: the keyword names to assign to the mock

  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local -a _mock_object_keywords

  _mock_object_keywords=("\${@}")

  _testing.__protected stdlib.array.assert.not_contains "" _mock_object_keywords || builtin return 126
  _testing.__protected stdlib.array.map.fn "$(_testing.__protected_name stdlib.var.assert.is_valid_name)" _mock_object_keywords || builtin return 126

  builtin eval "__${2}_mock_keywords=(\$(builtin printf '%q ' "\${@}"))"
}


${1}.mock.set.pipeable() {
  # $1: the boolean to enable or disable the pipeable attribute

  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"
  _testing.__protected stdlib.string.assert.is_boolean "\${1}" || builtin return 126

  builtin printf -v "__${2}_mock_pipeable" "%s" "\${1}"
}

${1}.mock.set.rc() {
  # $1: the return code to make the mock return
  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"
  _testing.__protected stdlib.string.assert.is_integer_with_range "0" "255" "\${1}" || builtin return 126

  builtin printf -v "__${2}_mock_rc" "%s" "\${1}"
}

${1}.mock.set.side_effects() {
  # $1: the array to set as a queue of side effect functions

  builtin local -a _mock_object_side_effects

  _mock_object_side_effects=("\${@}")
  _mock.__internal.security.assert.is_builtin "declare" || builtin return "\$?"

  builtin declare -p _mock_object_side_effects > "\${__${2}_mock_side_effects_file}"
  builtin printf -v "__${2}_mock_side_effects_boolean" "%s" "1"
}

${1}.mock.set.stderr() {
  # $1: the value to make the mock emit to stderr

  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  _STDLIB_ARGS_NULL_SAFE=("1")

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"

  builtin printf -v "__${2}_mock_stderr" "%s" "\${1}"
}

${1}.mock.set.stdout() {
  # $1: the value to make the mock emit to stdout

  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  _STDLIB_ARGS_NULL_SAFE=("1")

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"

  builtin printf -v "__${2}_mock_stdout" "%s" "\${1}"
}

${1}.mock.set.subcommand() {
  # $@: the subcommand to execute on each mock call

  builtin eval "__${1}_mock_subcommand() {  # noqa
      \${@}
  }"
}
EOF
)"
