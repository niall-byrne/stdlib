#!/bin/bash

# stdlib string pad library

builtin set -eo pipefail

# @description Pads a string on the left with a specified number of spaces.
# @arg $1 integer The number of spaces to pad with.
# @arg $2 string The string to pad.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The padded string.
# @stderr The error message if the operation fails.
stdlib.string.pad.left() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE

  _STDLIB_ARGS_NULL_SAFE=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"

  builtin printf "%*s%s"$'\n' "${1}" " " "${2}"
}

# @description A derivative of stdlib.string.pad.left that can read from stdin.
# @arg $1 integer The number of spaces to pad with.
# @arg $2 string (optional, default="-") The string to pad, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The string to pad.
# @stdout The padded string.
# @stderr The error message if the operation fails.
stdlib.string.pad.left_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.pad.left" "2"

# @description A derivative of stdlib.string.pad.left that can read from and write to a variable.
# @arg $1 integer The number of spaces to pad with.
# @arg $2 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.string.pad.left_var() { :; }
stdlib.fn.derive.var "stdlib.string.pad.left"

# @description Pads a string on the right with a specified number of spaces.
# @arg $1 integer The number of spaces to pad with.
# @arg $2 string The string to pad.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The padded string.
# @stderr The error message if the operation fails.
stdlib.string.pad.right() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE

  _STDLIB_ARGS_NULL_SAFE=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"

  builtin printf "%s%*s"$'\n' "${2}" "${1}" " "
}

# @description A derivative of stdlib.string.pad.right that can read from stdin.
# @arg $1 integer The number of spaces to pad with.
# @arg $2 string (optional, default="-") The string to pad, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The string to pad.
# @stdout The padded string.
# @stderr The error message if the operation fails.
stdlib.string.pad.right_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.pad.right" "2"

# @description A derivative of stdlib.string.pad.right that can read from and write to a variable.
# @arg $1 integer The number of spaces to pad with.
# @arg $2 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.string.pad.right_var() { :; }
stdlib.fn.derive.var "stdlib.string.pad.right"
