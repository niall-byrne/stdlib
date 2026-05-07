#!/bin/bash
# shellcheck disable=SC2034

# stdlib colour theme library

builtin set -eo pipefail

# @description Sets the default theme colours for the logger.
# @noargs
# @exitcode 0 If the operation succeeded.
# @set STDLIB_THEME_LOGGER_ERROR string The colour to use for error messages.
# @set STDLIB_THEME_LOGGER_INFO string The colour to use for info messages.
# @set STDLIB_THEME_LOGGER_NOTICE string The colour to use for notice messages.
# @set STDLIB_THEME_LOGGER_SUCCESS string The colour to use for success messages.
# @set STDLIB_THEME_LOGGER_WARNING string The colour to use for warning messages.
stdlib.setting.colour.state.theme() {
  STDLIB_THEME_LOGGER_ERROR="LIGHT_RED"
  STDLIB_THEME_LOGGER_INFO="WHITE"
  STDLIB_THEME_LOGGER_NOTICE="GREY"
  STDLIB_THEME_LOGGER_SUCCESS="GREEN"
  STDLIB_THEME_LOGGER_WARNING="YELLOW"
}
