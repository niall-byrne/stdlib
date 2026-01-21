#!/bin/bash

# stdlib string colour substring library

builtin set -eo pipefail

# @description Colours the first occurrence of a substring in a string.
# @arg $1 string The colour to use.
# @arg $2 string The substring to colour.
# @arg $3 string The source string.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments was provided.
# @stdout The string with the coloured substring.
stdlib.string.colour.substring() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local string_colour

  _STDLIB_ARGS_NULL_SAFE=("2" "3")

  stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?"

  string_colour="$(stdlib.setting.theme.get_colour "${1}")"

  builtin echo -e "${3/${2}/${!string_colour}${2}${STDLIB_COLOUR_NC}}"
}

# @description Colours all occurrences of a substring in a string.
# @arg $1 string The colour to use.
# @arg $2 string The substring to colour.
# @arg $3 string The source string.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments was provided.
# @stdout The string with the coloured substrings.
stdlib.string.colour.substrings() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local string_colour

  _STDLIB_ARGS_NULL_SAFE=("2" "3")

  stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?"

  string_colour="$(stdlib.setting.theme.get_colour "${1}")"

  builtin echo -e "${3//${2}/${!string_colour}${2}${STDLIB_COLOUR_NC}}"
}
