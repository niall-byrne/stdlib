#!/bin/bash
# shellcheck disable=SC2034

# stdlib string colour library

builtin set -eo pipefail

# @description Colours a string and prints it with a newline.
# @arg $1 string The name of the colour to use.
# @arg $2 string The string to colour.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The coloured string with a newline.
# @stderr The error message if the operation fails.
stdlib.string.colour() {
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local string_output

  STDLIB_ARGS_NULL_SAFE_ARRAY=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"

  string_output="$(stdlib.string.colour_n "${1}" "${2}")"

  builtin echo -e "${string_output}"
}

# @description Colours a string and prints it without a newline.
# @arg $1 string The name of the colour to use.
# @arg $2 string The string to colour.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The coloured string without a newline.
# @stderr The error message if the operation fails.
stdlib.string.colour_n() {
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local string_colour

  STDLIB_ARGS_NULL_SAFE_ARRAY=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"

  string_colour="$(stdlib.setting.theme.get_colour "${1}")"

  builtin echo -ne "${!string_colour}${2}${STDLIB_COLOUR_NC}"
}

# @description A derivative of stdlib.string.colour_n that can read from stdin.
# @arg $1 string The name of the colour to use.
# @arg $2 string (optional, default="-") The string to colour, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The string to colour.
# @stdout The coloured string without a newline.
# @stderr The error message if the operation fails.
stdlib.string.colour_n_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.colour_n" "2"

# @description A derivative of stdlib.string.colour that can read from stdin.
# @arg $1 string The name of the colour to use.
# @arg $2 string (optional, default="-") The string to colour, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The string to colour.
# @stdout The coloured string with a newline.
# @stderr The error message if the operation fails.
stdlib.string.colour_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.colour" "2"

# @description A derivative of stdlib.string.colour_n that can read from and write to a variable.
# @arg $1 string The name of the colour to use.
# @arg $2 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.string.colour_var() { :; }
stdlib.fn.derive.var "stdlib.string.colour_n" "stdlib.string.colour_var"
