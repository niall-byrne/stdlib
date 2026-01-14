#!/bin/bash

# stdlib setting theme library

builtin set -eo pipefail

stdlib.setting.theme.get_colour() {

  local theme_colour

  theme_colour="STDLIB_COLOUR_${1}"

  if [[ -z "${!theme_colour+set}" ]]; then
    stdlib.logger.warning "$(stdlib.message.get COLOUR_NOT_DEFINED "${1}")"
  fi

  builtin echo "${theme_colour}"
}

stdlib.setting.theme.load() {
  stdlib.setting.colour.state.theme
}
