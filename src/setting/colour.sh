#!/bin/bash

# stdlib setting colour library

builtin set -eo pipefail

STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN=""

# @description Disables terminal colours.
# @noargs
# @exitcode 0 If the operation succeeded.
stdlib.setting.colour.disable() {
  stdlib.setting.colour.state.disabled
  stdlib.setting.theme.load
}

# @description Enables terminal colours.
#   * STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN: Disables the error message on failure (default="0").
# @noargs
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @stderr The error message if the operation fails.
stdlib.setting.colour.enable() {
  builtin local silent_fallback_boolean="${STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN:-0}"
  builtin local error_message=""

  if ! "${_STDLIB_BINARY_TPUT}" init 2> /dev/null; then
    if [[ "${silent_fallback_boolean}" != "1" ]]; then
      stdlib.setting.colour.enable.__generate_error_message
      builtin return 1
    fi
    stdlib.setting.colour.disable
    builtin return 0
  fi

  stdlib.setting.colour.state.enabled
  stdlib.setting.theme.load
}

# @description Generates and prints an error message when colour initialization fails.
# @noargs
# @exitcode 0 If the operation succeeded.
# @stdout The error message.
# @stderr The error message.
# @internal
stdlib.setting.colour.enable.__generate_error_message() {
  builtin local error_message=""

  error_message+="$(stdlib.__message.get COLOUR_INITIALIZE_ERROR)\n"
  if [[ -z "${TERM}" ]]; then
    error_message+="$(stdlib.__message.get COLOUR_INITIALIZE_ERROR_TERM)\n"
  fi

  builtin echo -en "${error_message}" >&2
}
