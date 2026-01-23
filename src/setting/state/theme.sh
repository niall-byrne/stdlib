#!/bin/bash
# shellcheck disable=SC2034

# stdlib colour theme library

builtin set -eo pipefail

# @description Sets the default logger theme colors.
# @noargs
# @exitcode 0 If the operation succeeded.
# @set STDLIB_THEME_LOGGER_ERROR string The color for error messages.
# @set STDLIB_THEME_LOGGER_WARNING string The color for warning messages.
# @set STDLIB_THEME_LOGGER_INFO string The color for info messages.
# @set STDLIB_THEME_LOGGER_NOTICE string The color for notice messages.
# @set STDLIB_THEME_LOGGER_SUCCESS string The color for success messages.
stdlib.setting.colour.state.theme() {
  STDLIB_THEME_LOGGER_ERROR="LIGHT_RED"
  STDLIB_THEME_LOGGER_WARNING="YELLOW"
  STDLIB_THEME_LOGGER_INFO="WHITE"
  STDLIB_THEME_LOGGER_NOTICE="GREY"
  STDLIB_THEME_LOGGER_SUCCESS="GREEN"
}
