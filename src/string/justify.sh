#!/bin/bash

# stdlib string justify library

builtin set -eo pipefail

# @description Left-justifies a string to a specified width.
# @arg $1 integer The column width to justify to.
# @arg $2 string The string to justify.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The left-justified string.
# @stderr The error message if the operation fails.
stdlib.string.justify.left() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE

  _STDLIB_ARGS_NULL_SAFE=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"

  builtin printf "%-${1}b"$'\n' "${2}"
}

# @description A pipeable version of stdlib.string.justify.left.
# @arg $1 integer The column width to justify to.
# @arg $2 string (optional, default="-") The string to justify, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The string to justify.
# @stdout The left-justified string.
# @stderr The error message if the operation fails.
stdlib.string.justify.left_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.justify.left" "2"

# @description A version of stdlib.string.justify.left that reads from and writes to a variable.
# @arg $1 integer The column width to justify to.
# @arg $2 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.string.justify.left_var() { :; }
stdlib.fn.derive.var "stdlib.string.justify.left"

# @description Right-justifies a string to a specified width.
# @arg $1 integer The column width to justify to.
# @arg $2 string The string to justify.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The right-justified string.
# @stderr The error message if the operation fails.
stdlib.string.justify.right() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE

  _STDLIB_ARGS_NULL_SAFE=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"

  builtin printf "%${1}s"$'\n' "${2}"
}

# @description A pipeable version of stdlib.string.justify.right.
# @arg $1 integer The column width to justify to.
# @arg $2 string (optional, default="-") The string to justify, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The string to justify.
# @stdout The right-justified string.
# @stderr The error message if the operation fails.
stdlib.string.justify.right_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.justify.right" "2"

# @description A version of stdlib.string.justify.right that reads from and writes to a variable.
# @arg $1 integer The column width to justify to.
# @arg $2 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.string.justify.right_var() { :; }
stdlib.fn.derive.var "stdlib.string.justify.right"
