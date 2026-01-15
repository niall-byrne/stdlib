#!/bin/bash
# shellcheck disable=SC2034

# stdlib string colour library

builtin set -eo pipefail

# @description Colours a string without adding a newline.
# @arg $1 The colour to use.
# @arg $2 The string to colour.
# @exitcode 127 If the wrong number of arguments is provided.
# @stdout The coloured string.
stdlib.string.colour_n() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local string_colour

  _STDLIB_ARGS_NULL_SAFE=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"

  string_colour="$(stdlib.setting.theme.get_colour "${1}")"

  builtin echo -ne "${!string_colour}${2}${STDLIB_COLOUR_NC}"
}

# @description Colours a string and adds a newline.
# @arg $1 The colour to use.
# @arg $2 The string to colour.
# @exitcode 127 If the wrong number of arguments is provided.
# @stdout The coloured string.
stdlib.string.colour() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local string_output

  _STDLIB_ARGS_NULL_SAFE=("2")

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"

  string_output="$(stdlib.string.colour_n "${1}" "${2}")"

  builtin echo -e "${string_output}"
}
