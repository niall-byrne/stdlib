#!/bin/bash
# shellcheck disable=SC2034

# stdlib colour state disabled library

builtin set -eo pipefail

# @description Disables color output by clearing standard global color variables.
# @noargs
# @exitcode 0 If the operation succeeded.
# @set STDLIB_COLOUR_NC The color reset sequence.
# @set STDLIB_COLOUR_BLACK The black color sequence.
# @set STDLIB_COLOUR_RED The red color sequence.
# @set STDLIB_COLOUR_GREEN The green color sequence.
# @set STDLIB_COLOUR_YELLOW The yellow color sequence.
# @set STDLIB_COLOUR_BLUE The blue color sequence.
# @set STDLIB_COLOUR_PURPLE The purple color sequence.
# @set STDLIB_COLOUR_CYAN The cyan color sequence.
# @set STDLIB_COLOUR_WHITE The white color sequence.
# @set STDLIB_COLOUR_GREY The grey color sequence.
# @set STDLIB_COLOUR_LIGHT_RED The light red color sequence.
# @set STDLIB_COLOUR_LIGHT_GREEN The light green color sequence.
# @set STDLIB_COLOUR_LIGHT_YELLOW The light yellow color sequence.
# @set STDLIB_COLOUR_LIGHT_BLUE The light blue color sequence.
# @set STDLIB_COLOUR_LIGHT_PURPLE The light purple color sequence.
# @set STDLIB_COLOUR_LIGHT_CYAN The light cyan color sequence.
# @set STDLIB_COLOUR_LIGHT_WHITE The light white color sequence.
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
