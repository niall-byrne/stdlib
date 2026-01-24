#!/bin/bash

# stdlib setting theme library

builtin set -eo pipefail

# @description Gets the name of a colour variable from the theme.
# @arg $1 string The name of the colour.
# @exitcode 0 If the operation succeeded.
# @stdout The name of the colour variable.
# @stderr The error message if the operation fails.
stdlib.setting.theme.get_colour() {
  builtin local theme_colour

  theme_colour="STDLIB_COLOUR_${1}"

  if [[ -z "${!theme_colour+set}" ]]; then
    stdlib.logger.warning "$(stdlib.__message.get COLOUR_NOT_DEFINED "${1}")"
  fi

  builtin echo "${theme_colour}"
}

# @description Loads the theme colours.
# @noargs
# @exitcode 0 If the operation succeeded.
stdlib.setting.theme.load() {
  stdlib.setting.colour.state.theme
}
