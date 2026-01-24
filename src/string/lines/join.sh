#!/bin/bash

# stdlib string join library

builtin set -eo pipefail

# @description Joins lines in a string by removing a delimiter.
#     _STDLIB_DELIMITER: a char sequence to replace which joins the string (optional, default=$'\n')
# @arg $1 string The string to process.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The joined string.
# @stderr The error message if the operation fails.
stdlib.string.lines.join() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local delimiter="${_STDLIB_DELIMITER:-$'\n'}"

  _STDLIB_ARGS_NULL_SAFE=("1")

  stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?"

  builtin printf '%s\n' "${1//${delimiter}/}"
}

# @description A pipeable version of stdlib.string.lines.join.
# @arg $1 string (optional, default="-") The string to process.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The string to process.
# @stdout The joined string.
# @stderr The error message if the operation fails.
stdlib.string.lines.join_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.lines.join" "1"

# @description A version of stdlib.string.lines.join that reads from and writes to a variable.
# @arg $1 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.string.lines.join_var() { :; }
stdlib.fn.derive.var "stdlib.string.lines.join"
