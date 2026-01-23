#!/bin/bash

# stdlib string colour substring library

builtin set -eo pipefail

# @description Colours the first occurrence of a substring in a string.
# @arg $1 string The name of the colour to use.
# @arg $2 string The substring to colour.
# @arg $3 string The source string.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The string with the first occurrence of the substring coloured.
# @stderr The error message if the operation fails.
stdlib.string.colour.substring() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local string_colour

  _STDLIB_ARGS_NULL_SAFE=("2" "3")

  stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?"

  string_colour="$(stdlib.setting.theme.get_colour "${1}")"

  builtin echo -e "${3/${2}/${!string_colour}${2}${STDLIB_COLOUR_NC}}"
}

# @description Colours all occurrences of a substring in a string.
# @arg $1 string The name of the colour to use.
# @arg $2 string The substring to colour.
# @arg $3 string The source string.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The string with all occurrences of the substring coloured.
# @stderr The error message if the operation fails.
stdlib.string.colour.substrings() {
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local string_colour

  _STDLIB_ARGS_NULL_SAFE=("2" "3")

  stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?"

  string_colour="$(stdlib.setting.theme.get_colour "${1}")"

  builtin echo -e "${3//${2}/${!string_colour}${2}${STDLIB_COLOUR_NC}}"
}
