#!/bin/bash

# stdlib string colour substring library

builtin set -eo pipefail

stdlib.string.colour.substring() {
  # $1: the colour
  # $2: the substring to colour
  # $3: the source string

  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local string_colour

  _STDLIB_ARGS_NULL_SAFE=("2" "3")

  stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?"

  string_colour="$(stdlib.setting.theme.get_colour "${1}")"

  builtin echo -e "${3/${2}/${!string_colour}${2}${STDLIB_COLOUR_NC}}"
}

stdlib.string.colour.substrings() {
  # $1: the colour
  # $2: the substring to colour
  # $3: the source string

  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local string_colour

  _STDLIB_ARGS_NULL_SAFE=("2" "3")

  stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?"

  string_colour="$(stdlib.setting.theme.get_colour "${1}")"

  builtin echo -e "${3//${2}/${!string_colour}${2}${STDLIB_COLOUR_NC}}"
}
