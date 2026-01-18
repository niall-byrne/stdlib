#!/bin/bash

# stdlib testing messages library

builtin set -eo pipefail

_testing.message.get() {
  # $1: the message key to retrieve
  # $2: interpolation option 1

  builtin local key="${1}"
  builtin local message
  builtin local option1="${2}"
  builtin local required_options=0
  builtin local return_status=0

  case "${key}" in
    DEBUG_DIFF_FOOTER)
      required_options=0
      message="== End Debug Diff =="
      ;;
    DEBUG_DIFF_HEADER)
      required_options=0
      message="== Start Debug Diff =="
      ;;
    DEBUG_DIFF_PREFIX)
      required_options=0
      message="Diff"
      ;;
    DEBUG_DIFF_PREFIX_ACTUAL)
      required_options=0
      message="ACTUAL"
      ;;
    DEBUG_DIFF_PREFIX_EXPECTED)
      required_options=0
      message="EXPECTED"
      ;;
    LOAD_MODULE_NOT_FOUND)
      required_options=1
      message="The module '${option1}' could not be found!"
      ;;
    LOAD_MODULE_NOTIFICATION)
      required_options=1
      message="Loading module '${option1}' ..."
      ;;
    MOCK_TARGET_INVALID)
      required_options=1
      message="The object identified by '${option1}' cannot be mocked!"
      ;;
    "")
      required_options=0
      return_status=126
      message="$(__testing.protected stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      required_options=0
      return_status=126
      message="Unknown message key '${key}'"
      ;;
  esac

  (("${#@}" == 1 + required_options)) || {
    message="$(__testing.protected stdlib.message.get ARGUMENTS_INVALID)"
    return_status=127
  }

  ((return_status == 0)) || {
    __testing.protected stdlib.logger.error "${message}"
    builtin return ${return_status}
  }

  builtin echo -n "${message}"
}
