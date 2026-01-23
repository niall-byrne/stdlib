#!/bin/bash

# stdlib string trim library

builtin set -eo pipefail

# @description Trims leading whitespace from a string.
# @arg $1 string The string to process.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The trimmed string.
stdlib.string.trim.left() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE

  _STDLIB_ARGS_NULL_SAFE=("1")

  stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?"

  builtin shopt -s extglob
  builtin printf '%s\n' "${1##+([[:space:]])}"
  builtin shopt -u extglob
}

stdlib.fn.derive.pipeable "stdlib.string.trim.left" "1"

stdlib.fn.derive.var "stdlib.string.trim.left"

# @description Trims trailing whitespace from a string.
# @arg $1 string The string to process.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The trimmed string.
stdlib.string.trim.right() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE

  _STDLIB_ARGS_NULL_SAFE=("1")

  stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?"

  builtin shopt -s extglob
  builtin printf '%s\n' "${1%%+([[:space:]])}"
  builtin shopt -u extglob
}

stdlib.fn.derive.pipeable "stdlib.string.trim.right" "1"

stdlib.fn.derive.var "stdlib.string.trim.right"
