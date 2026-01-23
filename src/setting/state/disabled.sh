#!/bin/bash
# shellcheck disable=SC2034

# stdlib colour state disabled library

builtin set -eo pipefail

# @description Sets all colour variables to empty strings to disable colours.
# @noargs
# @exitcode 0 If the operation succeeded.
# @set STDLIB_COLOUR_NC string The no-colour escape sequence.
# @set STDLIB_COLOUR_BLACK string The black escape sequence.
# @set STDLIB_COLOUR_RED string The red escape sequence.
# @set STDLIB_COLOUR_GREEN string The green escape sequence.
# @set STDLIB_COLOUR_YELLOW string The yellow escape sequence.
# @set STDLIB_COLOUR_BLUE string The blue escape sequence.
# @set STDLIB_COLOUR_PURPLE string The purple escape sequence.
# @set STDLIB_COLOUR_CYAN string The cyan escape sequence.
# @set STDLIB_COLOUR_WHITE string The white escape sequence.
# @set STDLIB_COLOUR_GREY string The grey escape sequence.
# @set STDLIB_COLOUR_LIGHT_RED string The light red escape sequence.
# @set STDLIB_COLOUR_LIGHT_GREEN string The light green escape sequence.
# @set STDLIB_COLOUR_LIGHT_YELLOW string The light yellow escape sequence.
# @set STDLIB_COLOUR_LIGHT_BLUE string The light blue escape sequence.
# @set STDLIB_COLOUR_LIGHT_PURPLE string The light purple escape sequence.
# @set STDLIB_COLOUR_LIGHT_CYAN string The light cyan escape sequence.
# @set STDLIB_COLOUR_LIGHT_WHITE string The light white escape sequence.
stdlib.setting.colour.state.disabled() {
  STDLIB_COLOUR_NC=""
  STDLIB_COLOUR_BLACK=""
  STDLIB_COLOUR_RED=""
  STDLIB_COLOUR_GREEN=""
  STDLIB_COLOUR_YELLOW=""
  STDLIB_COLOUR_BLUE=""
  STDLIB_COLOUR_PURPLE=""
  STDLIB_COLOUR_CYAN=""
  STDLIB_COLOUR_WHITE=""
  STDLIB_COLOUR_GREY=""
  STDLIB_COLOUR_LIGHT_RED=""
  STDLIB_COLOUR_LIGHT_GREEN=""
  STDLIB_COLOUR_LIGHT_YELLOW=""
  STDLIB_COLOUR_LIGHT_BLUE=""
  STDLIB_COLOUR_LIGHT_PURPLE=""
  STDLIB_COLOUR_LIGHT_CYAN=""
  STDLIB_COLOUR_LIGHT_WHITE=""
}
