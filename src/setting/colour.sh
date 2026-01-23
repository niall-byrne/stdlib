#!/bin/bash

# stdlib setting colour library

builtin set -eo pipefail

_STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN=""

# @description Initializes color output.
# @noargs
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if initialization fails and silent fallback is disabled.
stdlib.setting.colour.enable() {
  builtin local silent_fallback_boolean="${_STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN:-0}"
  builtin local error_message=""

  if ! "${_STDLIB_BINARY_TPUT}" init 2> /dev/null; then
    if [[ "${silent_fallback_boolean}" != "1" ]]; then
      stdlib.setting.colour.enable._generate_error_message
      builtin return 127
    fi
    stdlib.setting.colour.disable
    builtin return 0
  fi

  stdlib.setting.colour.state.enabled
  stdlib.setting.theme.load
}

stdlib.setting.colour.enable._generate_error_message() {
  builtin local error_message=""

  error_message+="$(stdlib.message.get COLOUR_INITIALIZE_ERROR)\n"
  if [[ -z "${TERM}" ]]; then
    error_message+="$(stdlib.message.get COLOUR_INITIALIZE_ERROR_TERM)\n"
  fi

  builtin echo -en "${error_message}" >&2
}

# @description Disables color output.
# @noargs
# @exitcode 0 If the operation succeeded.
stdlib.setting.colour.disable() {
  stdlib.setting.colour.state.disabled
  stdlib.setting.theme.load
}
