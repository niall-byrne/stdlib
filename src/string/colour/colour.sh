#!/bin/bash
# shellcheck disable=SC2034

# stdlib string colour library

builtin set -eo pipefail

# @description Colours a string and prints it without a newline.
# @arg $1 string The name of the colour to use.
# @arg $2 string The string to colour.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The coloured string without a newline.
# @stderr The error message if the operation fails.
stdlib.string.colour_n() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local string_colour

  _STDLIB_ARGS_NULL_SAFE=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"

  string_colour="$(stdlib.setting.theme.get_colour "${1}")"

  builtin echo -ne "${!string_colour}${2}${STDLIB_COLOUR_NC}"
}

# @description Colours a string and prints it with a newline.
# @arg $1 string The name of the colour to use.
# @arg $2 string The string to colour.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The coloured string with a newline.
# @stderr The error message if the operation fails.
stdlib.string.colour() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local string_output

  _STDLIB_ARGS_NULL_SAFE=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"

  string_output="$(stdlib.string.colour_n "${1}" "${2}")"

  builtin echo -e "${string_output}"
}
