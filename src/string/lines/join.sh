#!/bin/bash

# stdlib string join library

builtin set -eo pipefail

# @description Joins a multi-line string into a single line.
#     _STDLIB_DELIMITER: The character sequence to join the lines with. Defaults to a newline.
# @arg $1 The string to process.
# @exitcode 127 If the wrong number of arguments is provided.
# @stdout The joined string.
stdlib.string.lines.join() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local delimiter="${_STDLIB_DELIMITER:-$'\n'}"

  _STDLIB_ARGS_NULL_SAFE=("1")

  stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?"

  builtin printf '%s\n' "${1//${delimiter}/}"
}

stdlib.fn.derive.pipeable "stdlib.string.lines.join" "1"

stdlib.fn.derive.var "stdlib.string.lines.join"
