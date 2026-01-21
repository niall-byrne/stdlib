#!/bin/bash

# stdlib string justify library

builtin set -eo pipefail

# @description Left-justifies a string in a column of a specified width.
# @arg $1 integer The column width to justify to.
# @arg $2 string The string to justify.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
# @stdout The justified string.
stdlib.string.justify.left() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE

  _STDLIB_ARGS_NULL_SAFE=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"

  builtin printf "%-${1}b"$'\n' "${2}"
}

stdlib.fn.derive.pipeable "stdlib.string.justify.left" "2"

stdlib.fn.derive.var "stdlib.string.justify.left"

# @description Right-justifies a string in a column of a specified width.
# @arg $1 integer The column width to justify to.
# @arg $2 string The string to justify.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
# @stdout The justified string.
stdlib.string.justify.right() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE

  _STDLIB_ARGS_NULL_SAFE=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"

  builtin printf "%${1}s"$'\n' "${2}"
}

stdlib.fn.derive.pipeable "stdlib.string.justify.right" "2"

stdlib.fn.derive.var "stdlib.string.justify.right"
