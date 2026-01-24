#!/bin/bash

# stdlib string join library

builtin set -eo pipefail

# @description Joins lines in a string by removing a delimiter.
#   * STDLIB_LINE_BREAK_DELIMITER: A line break char sequence which is replaced to join the string (default=$'\n').
# @arg $1 string The string to process.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The joined string.
# @stderr The error message if the operation fails.
stdlib.string.lines.join() {
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local delimiter="${STDLIB_LINE_BREAK_DELIMITER:-$'\n'}"

  # shellcheck disable=SC2034
  STDLIB_ARGS_NULL_SAFE_ARRAY=("1")

  stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?"

  builtin printf '%s\n' "${1//${delimiter}/}"
}

# @description A derivative of stdlib.string.lines.join that can read from stdin.
# @arg $1 string (optional, default="-") The string to process, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The string to process.
# @stdout The joined string.
# @stderr The error message if the operation fails.
stdlib.string.lines.join_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.lines.join" "1"

# @description A derivative of stdlib.string.lines.join that can read from and write to a variable.
# @arg $1 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.string.lines.join_var() { :; }
stdlib.fn.derive.var "stdlib.string.lines.join"
