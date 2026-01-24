#!/bin/bash

# stdlib string trim library

builtin set -eo pipefail

# @description Trims leading whitespace from a string.
# @arg $1 string The string to trim.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The trimmed string.
# @stderr The error message if the operation fails.
stdlib.string.trim.left() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE

  _STDLIB_ARGS_NULL_SAFE=("1")

  stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?"

  builtin shopt -s extglob
  builtin printf '%s\n' "${1##+([[:space:]])}"
  builtin shopt -u extglob
}

# @description A pipeable version of stdlib.string.trim.left.
# @arg $1 string (optional, default="-") The string to trim.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The string to trim.
# @stdout The trimmed string.
# @stderr The error message if the operation fails.
stdlib.string.trim.left_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.trim.left" "1"

# @description A version of stdlib.string.trim.left that reads from and writes to a variable.
# @arg $1 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.string.trim.left_var() { :; }
stdlib.fn.derive.var "stdlib.string.trim.left"

# @description Trims trailing whitespace from a string.
# @arg $1 string The string to trim.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The trimmed string.
# @stderr The error message if the operation fails.
stdlib.string.trim.right() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE

  _STDLIB_ARGS_NULL_SAFE=("1")

  stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?"

  builtin shopt -s extglob
  builtin printf '%s\n' "${1%%+([[:space:]])}"
  builtin shopt -u extglob
}

# @description A pipeable version of stdlib.string.trim.right.
# @arg $1 string (optional, default="-") The string to trim.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The string to trim.
# @stdout The trimmed string.
# @stderr The error message if the operation fails.
stdlib.string.trim.right_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.trim.right" "1"

# @description A version of stdlib.string.trim.right that reads from and writes to a variable.
# @arg $1 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.string.trim.right_var() { :; }
stdlib.fn.derive.var "stdlib.string.trim.right"
