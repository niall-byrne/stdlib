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
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local string_colour

  # shellcheck disable=SC2034
  STDLIB_ARGS_NULL_SAFE_ARRAY=("2" "3")

  stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?"

  string_colour="$(stdlib.setting.theme.get_colour "${1}")"

  builtin echo -e "${3/${2}/${!string_colour}${2}${STDLIB_COLOUR_NC}}"
}

# @description A derivative of stdlib.string.colour.substring that can read from stdin.
# @arg $1 string The name of the colour to use.
# @arg $2 string The substring to colour.
# @arg $3 string (optional, default="-") The source string, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The source string.
# @stdout The string with the first occurrence of the substring coloured.
# @stderr The error message if the operation fails.
stdlib.string.colour.substring_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.colour.substring" "3"

# @description A derivative of stdlib.string.colour.substring that can read from and write to a variable.
# @arg $1 string The name of the colour to use.
# @arg $2 string The substring to colour.
# @arg $3 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.string.colour.substring_var() { :; }
stdlib.fn.derive.var "stdlib.string.colour.substring"

# @description Colours all occurrences of a substring in a string.
# @arg $1 string The name of the colour to use.
# @arg $2 string The substring to colour.
# @arg $3 string The source string.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The string with all occurrences of the substring coloured.
# @stderr The error message if the operation fails.
stdlib.string.colour.substrings() {
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local string_colour

  # shellcheck disable=SC2034
  STDLIB_ARGS_NULL_SAFE_ARRAY=("2" "3")

  stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?"

  string_colour="$(stdlib.setting.theme.get_colour "${1}")"

  builtin echo -e "${3//${2}/${!string_colour}${2}${STDLIB_COLOUR_NC}}"
}

# @description A derivative of stdlib.string.colour.substrings that can read from stdin.
# @arg $1 string The name of the colour to use.
# @arg $2 string The substring to colour.
# @arg $3 string (optional, default="-") The source string, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The source string.
# @stdout The string with all occurrences of the substring coloured.
# @stderr The error message if the operation fails.
stdlib.string.colour.substrings_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.colour.substrings" "3"

# @description A derivative of stdlib.string.colour.substrings that can read from and write to a variable.
# @arg $1 string The name of the colour to use.
# @arg $2 string The substring to colour.
# @arg $3 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.string.colour.substrings_var() { :; }
stdlib.fn.derive.var "stdlib.string.colour.substrings"
