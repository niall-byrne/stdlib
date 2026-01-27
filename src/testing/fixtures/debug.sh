#!/bin/bash

# stdlib testing debug fixtures

builtin set -eo pipefail

# @description Prints a diff between two values for debugging.
#   * STDLIB_TESTING_THEME_DEBUG_FIXTURE: The colour to use for the debug output (default="GREY").
# @arg $1 string The expected value.
# @arg $2 string The actual value.
# @exitcode 0 If the operation succeeded.
# @stdout The debug diff output.
_testing.fixtures.debug.diff() {
  builtin local debug_colour

  debug_colour="$(stdlib.setting.theme.get_colour "${STDLIB_TESTING_THEME_DEBUG_FIXTURE}")"

  # shellcheck disable=SC2059
  builtin printf "%s\n" "$(_testing.__message.get DEBUG_DIFF_HEADER)"
  builtin printf "${!debug_colour}%s${STDLIB_COLOUR_NC}\n%q\n" "$(_testing.__message.get DEBUG_DIFF_PREFIX_EXPECTED):" "${1}"
  # shellcheck disable=SC2059
  builtin printf "${!debug_colour}%s${STDLIB_COLOUR_NC}\n%q\n" "$(_testing.__message.get DEBUG_DIFF_PREFIX_ACTUAL):" "${2}"
  builtin printf "${!debug_colour}%s${STDLIB_COLOUR_NC}\n" "$(_testing.__message.get DEBUG_DIFF_PREFIX):"
  # shellcheck disable=SC2059
  diff <(builtin printf "%s" "${1}") <(builtin printf "%s" "${2}")
  builtin printf "%s\n" "$(_testing.__message.get DEBUG_DIFF_FOOTER)"
}
