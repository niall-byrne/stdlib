#!/bin/bash
# shellcheck disable=SC2034

# stdlib colour state disabled library

builtin set -eo pipefail

# @description Disables color output by clearing standard global color variables.
# @noargs
# @exitcode 0 If the operation succeeded.
# @set STDLIB_COLOUR_NC string The color reset sequence.
# @set STDLIB_COLOUR_BLACK string The black color sequence.
# @set STDLIB_COLOUR_RED string The red color sequence.
# @set STDLIB_COLOUR_GREEN string The green color sequence.
# @set STDLIB_COLOUR_YELLOW string The yellow color sequence.
# @set STDLIB_COLOUR_BLUE string The blue color sequence.
# @set STDLIB_COLOUR_PURPLE string The purple color sequence.
# @set STDLIB_COLOUR_CYAN string The cyan color sequence.
# @set STDLIB_COLOUR_WHITE string The white color sequence.
# @set STDLIB_COLOUR_GREY string The grey color sequence.
# @set STDLIB_COLOUR_LIGHT_RED string The light red color sequence.
# @set STDLIB_COLOUR_LIGHT_GREEN string The light green color sequence.
# @set STDLIB_COLOUR_LIGHT_YELLOW string The light yellow color sequence.
# @set STDLIB_COLOUR_LIGHT_BLUE string The light blue color sequence.
# @set STDLIB_COLOUR_LIGHT_PURPLE string The light purple color sequence.
# @set STDLIB_COLOUR_LIGHT_CYAN string The light cyan color sequence.
# @set STDLIB_COLOUR_LIGHT_WHITE string The light white color sequence.
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
