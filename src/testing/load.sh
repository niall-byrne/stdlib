#!/bin/bash

# stdlib testing source library

builtin set -eo pipefail

# @description Loads a module with error support.
#   * STDLIB_TESTING_THEME_LOAD: The colour to use for the message (default="GREY").
# @arg $1 string The module path to source.
# @exitcode 0 If the module was loaded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The notification message.
# @stderr The error message if the operation fails.
_testing.load() {
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
