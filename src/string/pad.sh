#!/bin/bash

# stdlib string pad library

builtin set -eo pipefail

# @description Pads a string to the left with spaces to a specified width.
# @arg $1 integer The width to pad with.
# @arg $2 string The string to pad.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
# @stdout The padded string.
stdlib.string.pad.left() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE

  _STDLIB_ARGS_NULL_SAFE=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"

  builtin printf "%*s%s"$'\n' "${1}" " " "${2}"
}

stdlib.fn.derive.pipeable "stdlib.string.pad.left" "2"

stdlib.fn.derive.var "stdlib.string.pad.left"

# @description Pads a string to the right with spaces to a specified width.
# @arg $1 integer The width to pad with.
# @arg $2 string The string to pad.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
# @stdout The padded string.
stdlib.string.pad.right() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE

  _STDLIB_ARGS_NULL_SAFE=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"

  builtin printf "%s%*s"$'\n' "${2}" "${1}" " "
}

stdlib.fn.derive.pipeable "stdlib.string.pad.right" "2"

stdlib.fn.derive.var "stdlib.string.pad.right"
