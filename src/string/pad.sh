#!/bin/bash

# stdlib string pad library

builtin set -eo pipefail

# @description Pads a string on the left with a specified number of spaces.
# @arg $1 The number of spaces to pad with.
# @arg $2 The string to pad.
# @exitcode 127 If the wrong number of arguments is provided.
# @stdout The padded string.
stdlib.string.pad.left() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE

  _STDLIB_ARGS_NULL_SAFE=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"

  builtin printf "%*s%s"$'\n' "${1}" " " "${2}"
}

stdlib.fn.derive.pipeable "stdlib.string.pad.left" "2"

stdlib.fn.derive.var "stdlib.string.pad.left"

# @description Pads a string on the right with a specified number of spaces.
# @arg $1 The number of spaces to pad with.
# @arg $2 The string to pad.
# @exitcode 127 If the wrong number of arguments is provided.
# @stdout The padded string.
stdlib.string.pad.right() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE

  _STDLIB_ARGS_NULL_SAFE=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"

  builtin printf "%s%*s"$'\n' "${2}" "${1}" " "
}

stdlib.fn.derive.pipeable "stdlib.string.pad.right" "2"

stdlib.fn.derive.var "stdlib.string.pad.right"
