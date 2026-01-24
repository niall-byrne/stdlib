#!/bin/bash

# stdlib testing source library

builtin set -eo pipefail

_testing.load() {
  # $1: the module to source with error support

  [[ "${#@}" == 1 ]] || {
    _testing.error "_testing.load: $(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
    builtin return 127
  }

  _testing.__protected stdlib.string.colour "${STDLIB_TESTING_THEME_LOAD}" "    $(_testing.__message.get LOAD_MODULE_NOTIFICATION "${1}")"

  # shellcheck source=/dev/null
  . "${1}" 2> /dev/null || {
    _testing.error "$(_testing.__message.get LOAD_MODULE_NOT_FOUND "${1}")"
    builtin return 126
  }
}
