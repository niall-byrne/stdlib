#!/bin/bash
# shellcheck disable=SC2034

# stdlib colour theme library

builtin set -eo pipefail

stdlib.setting.colour.state.theme() {
  STDLIB_THEME_LOGGER_ERROR="LIGHT_RED"
  STDLIB_THEME_LOGGER_WARNING="YELLOW"
  STDLIB_THEME_LOGGER_INFO="WHITE"
  STDLIB_THEME_LOGGER_NOTICE="GREY"
  STDLIB_THEME_LOGGER_SUCCESS="GREEN"
}
