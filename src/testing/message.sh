#!/bin/bash

# stdlib testing messages library

builtin set -eo pipefail

# @description Retrieves a testing message by its key and optionally interpolates values.
# @arg $1 string The message key to retrieve.
# @arg $2 string (optional) Interpolation option 1.
# @exitcode 0 If the message was retrieved successfully.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The retrieved and interpolated message.
# @stderr The error message if the operation fails.
# @internal
_testing.__message.get() {
  builtin local key="${1}"
  builtin local message

  # shellcheck disable=SC2034
  builtin local option1="${2}"

  builtin local required_options=0
  builtin local return_status=0

  case "${key}" in
    DEBUG_DIFF_FOOTER)
      required_options=0
      message="$(_testing.__gettext "== End Debug Diff ==")"
      ;;
    DEBUG_DIFF_HEADER)
      required_options=0
      message="$(_testing.__gettext "== Start Debug Diff ==")"
      ;;
    DEBUG_DIFF_PREFIX)
      required_options=0
      message="$(_testing.__gettext "Diff")"
      ;;
    DEBUG_DIFF_PREFIX_ACTUAL)
      required_options=0
      message="$(_testing.__gettext "ACTUAL")"
      ;;
    DEBUG_DIFF_PREFIX_EXPECTED)
      required_options=0
      message="$(_testing.__gettext "EXPECTED")"
      ;;
    LOAD_MODULE_NOT_FOUND)
      required_options=1
      message="$(_testing.__gettext "The module '\${option1}' could not be found!")"
      ;;
    LOAD_MODULE_NOTIFICATION)
      required_options=1
      message="$(_testing.__gettext "Loading module '\${option1}' ...")"
      ;;
    "")
      required_options=0
      return_status=126
      message="$(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      required_options=0
      return_status=126
      message="$(_testing.__gettext "Unknown message key '\${key}'")"
      ;;
  esac

  (("${#@}" == 1 + required_options)) || {
    message="$(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
    return_status=127
  }

  ((return_status == 0)) || {
    _testing.__protected stdlib.logger.error "${message}"
    builtin return ${return_status}
  }

  builtin echo -n "${message}"
}
