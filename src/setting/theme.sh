#!/bin/bash

# stdlib setting theme library

builtin set -eo pipefail

# @description Gets the colour variable for a specified theme element.
# @arg $1 string The theme element to get the colour for.
# @exitcode 0 If the operation succeeded.
# @stdout The colour variable name.
# @stderr A warning message if the colour is not defined.
stdlib.setting.theme.get_colour() {
  builtin local theme_colour

  theme_colour="STDLIB_COLOUR_${1}"

  if [[ -z "${!theme_colour+set}" ]]; then
    stdlib.logger.warning "$(stdlib.message.get COLOUR_NOT_DEFINED "${1}")"
  fi

  builtin echo "${theme_colour}"
}

# @description Loads the colour theme.
# @noargs
# @exitcode 0 If the operation succeeded.
stdlib.setting.theme.load() {
  stdlib.setting.colour.state.theme
}
