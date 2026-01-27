#!/bin/bash

# stdlib testing mock setter component

builtin set -eo pipefail

builtin export __STDLIB_TESTING_MOCK_COMPONENT

# shellcheck disable=SC2034
__STDLIB_TESTING_MOCK_COMPONENT="$(
  "${_STDLIB_BINARY_CAT}" << 'EOF'

# @description This function will set the keywords assigned to this mock.  (These keywords are variables who's value is recorded during each mock call).
# @arg $@ array These are the keywords, or variables, that the mock will record each time it's called. (Call this function without any arguments to disable this feature).
# @exitcode 0 If the operation is successful.
# @exitcode 126 If an invalid argument has been provided.
# @set __${2}_mock_keywords array These are the keywords, or variables, that the mock will record each time it's called.
# @stderr The error message if the operation fails.
${1}.mock.set.keywords() {
  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local -a _mock_object_keywords

  _mock_object_keywords=("\${@}")

  _testing.__protected stdlib.array.assert.not_contains "" _mock_object_keywords || builtin return 126
  _testing.__protected stdlib.array.map.fn "$(_testing.__protected_name stdlib.var.assert.is_valid_name)" _mock_object_keywords || builtin return 126

  builtin eval "__${2}_mock_keywords=(\$(builtin printf '%q ' "\${@}"))"
}

# @description This function will toggle the 'pipeable' behaviour of the mock.  Turning this on allows the mock to receive stdin.
# @arg $1 boolean This enables or disables the 'pipeable' behaviour of the mock, (default="0").
# @exitcode 0 If the operation is successful.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @set __${2}_mock_pipeable boolean This enables or disables the 'pipeable' behaviour of the mock.
# @stderr The error message if the operation fails.
${1}.mock.set.pipeable() {
  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"
  _testing.__protected stdlib.string.assert.is_boolean "\${1}" || builtin return 126

  builtin printf -v "__${2}_mock_pipeable" "%s" "\${1}"
}

# @description This function will set the return code (exit code) of the mock.  This behaviour can be overridden by configuring side effects or a subcommand.
# @arg $1 integer This is the return code (or exit code) you wish the mock to emit.  (Please note that any non-zero number emitted by the side effects or subcommand configured on this mock will be override this value and be returned instead).
# @exitcode 0 If the operation is successful.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @set __${2}_mock_rc integer This is the exit code the mock is configured to return.
# @stderr The error message if the operation fails.
${1}.mock.set.rc() {
  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"
  _testing.__protected stdlib.string.assert.is_integer_with_range "0" "255" "\${1}" || builtin return 126

  builtin printf -v "__${2}_mock_rc" "%s" "\${1}"
}

# @description This function will set the side effects of the mock.  These are a series of one or more commands the mock will execute each time it's called.
# @arg $@ array This is a series commands the mock will execute each time it's called. (Call this function without any arguments to disable this feature).
# @exitcode 0 If the operation is successful.
# @exitcode 126 If an invalid argument has been provided.
# @set __${2}_mock_side_effects_boolean boolean This is a boolean indicating the mock has been configured with at least one side effect.
# @stderr The error message if the operation fails.
${1}.mock.set.side_effects() {
  builtin local -a _mock_object_side_effects

  _mock_object_side_effects=("\${@}")
  _mock.__internal.security.assert.is_builtin "declare" || builtin return "\$?"

  builtin declare -p _mock_object_side_effects > "\${__${2}_mock_side_effects_file}"
  builtin printf -v "__${2}_mock_side_effects_boolean" "%s" "1"
}

# @description This function will set the stderr this mock will emit when called.
# @arg $1 string This is the string that will be emitted to stderr when the mock is called.
# @exitcode 0 If the operation is successful.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @set __${2}_mock_stderr string This is the string that will be emitted to stderr when the mock is called.
# @stderr The error message if the operation fails.
${1}.mock.set.stderr() {
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  STDLIB_ARGS_NULL_SAFE_ARRAY=("1")

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"

  builtin printf -v "__${2}_mock_stderr" "%s" "\${1}"
}

# @description This function will set the stdout this mock will emit when called.
# @arg $1 string This is the string that will be emitted to stdout when the mock is called.
# @exitcode 0 If the operation is successful.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @set __${2}_mock_stdout string This is the string that will be emitted to stdout when the mock is called.
# @stdout The error message if the operation fails.
${1}.mock.set.stdout() {
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  STDLIB_ARGS_NULL_SAFE_ARRAY=("1")

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"

  builtin printf -v "__${2}_mock_stdout" "%s" "\${1}"
}

# @description This function will set the subcommand this mock will call when the mock is called.  All arguments passed to the mock are also passed to the subcommand.
# @arg $@ array This is a series commands the mock will execute each time it's called.  This is distinct from side effects in that the subcommand will receive all arguments sent to the mock itself.
# @exitcode 0 If the operation is successful.
${1}.mock.set.subcommand() {
  # $@: the subcommand to execute on each mock call

  builtin eval "__${1}_mock_subcommand() {  # noqa
      \${@}
  }"
}

EOF
)"
