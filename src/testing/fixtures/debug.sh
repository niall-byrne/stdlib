#!/bin/bash

# stdlib testing debug fixtures

builtin set -eo pipefail

# @description Prints a diff between two values for debugging.
#   * STDLIB_TESTING_THEME_DEBUG_FIXTURE string global: The colour to use for the debug output (default="GREY").
# @arg $1 string The expected value.
# @arg $2 string The actual value.
# @exitcode 0 If the values match.
# @exitcode 1 If the values do not match.
# @stdout The debug diff output.
_testing.fixtures.debug.diff() {
  builtin local debug_colour

  debug_colour="$(stdlib.setting.theme.get_colour "${STDLIB_TESTING_THEME_DEBUG_FIXTURE}")"  # validates STDLIB_TESTING_THEME_DEBUG_FIXTURE

  builtin printf "%s\n" "$(_testing.__message.get DEBUG_DIFF_HEADER)"
  builtin printf "${!debug_colour}%s${STDLIB_COLOUR_NC}\n%q\n" "$(_testing.__message.get DEBUG_DIFF_PREFIX_EXPECTED):" "${1}" # noqa
  builtin printf "${!debug_colour}%s${STDLIB_COLOUR_NC}\n%q\n" "$(_testing.__message.get DEBUG_DIFF_PREFIX_ACTUAL):" "${2}"   # noqa
  builtin printf "${!debug_colour}%s${STDLIB_COLOUR_NC}\n" "$(_testing.__message.get DEBUG_DIFF_PREFIX):"                     # noqa
  "${_STDLIB_BINARY_DIFF}" <(builtin printf "%s" "${1}") <(builtin printf "%s" "${2}")
  builtin printf "%s\n" "$(_testing.__message.get DEBUG_DIFF_FOOTER)"
}
