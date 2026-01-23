#!/bin/bash

# stdlib setting theme library

builtin set -eo pipefail

# @description Returns the name of the global variable corresponding to a color name.
# @arg $1 string The color name.
# @exitcode 0 If the operation succeeded.
# @stdout The global variable name for the color.
# @stderr The warning message if the color is not defined.
stdlib.setting.theme.get_colour() {
  builtin local theme_colour

  theme_colour="STDLIB_COLOUR_${1}"

  if [[ -z "${!theme_colour+set}" ]]; then
    stdlib.logger.warning "$(stdlib.message.get COLOUR_NOT_DEFINED "${1}")"
  fi

  builtin echo "${theme_colour}"
}

# @description Loads the default logger theme.
# @noargs
# @exitcode 0 If the operation succeeded.
stdlib.setting.theme.load() {
  stdlib.setting.colour.state.theme
}
