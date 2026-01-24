#!/bin/bash

# stdlib testing mock messages library

builtin set -eo pipefail

# @description Retrieves a message string from the mock message library.
# @arg $1 string The message key to retrieve.
# @arg $2 string (optional) The first interpolation option.
# @arg $3 string (optional) The second interpolation option.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The retrieved message string.
# @stderr The error message if the operation fails.
# @internal
_testing.mock.__message.get() {
  builtin local key="${1}"
  builtin local message

  # shellcheck disable=SC2034
  {
    builtin local option1="${2}"
    builtin local option2="${3}"
  }

  builtin local required_options=0
  builtin local return_status=0

  case "${key}" in
    MOCK_CALL_ACTUAL_PREFIX)
      required_options=0
      message="$(_testing.__gettext "Actual call")"
      ;;
    MOCK_CALL_N_NOT_AS_EXPECTED)
      required_options=2
      message="$(_testing.__gettext "Mock '\${option1}' call \${option2} was not as expected!")"
      ;;
    MOCK_CALLED_N_TIMES)
      required_options=2
      message="$(_testing.__gettext "Mock '\${option1}' was called \${option2} times!")"
      ;;
    MOCK_NOT_CALLED)
      required_options=1
      message="$(_testing.__gettext "Mock '\${option1}' was not called!")"
      ;;
    MOCK_NOT_CALLED_ONCE_WITH)
      required_options=2
      message="$(_testing.__gettext "Mock '\${option1}' was not called once with '\${option2}' !")"
      ;;
    MOCK_NOT_CALLED_WITH)
      required_options=2
      message="$(_testing.__gettext "Mock '\${option1}' was not called with '\${option2}' !")"
      ;;
    MOCK_REQUIRES_BUILTIN)
      required_options=2
      message="$(_testing.__gettext "Mock '\${option1}' requires the '\${option2}' keyword to perform this operation, but it is currently overridden.")"
      ;;
    MOCK_TARGET_INVALID)
      required_options=1
      message="$(_testing.__gettext "The object identified by '\${option1}' cannot be mocked!")"
      ;;
    "")
      required_options=0
      return_status=126
      message="$(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      required_options=0
      return_status=126
      message="$(_testing.__gettext "Unknown message key '${key}'")"
      ;;
  esac

  (("${#@}" - 1 == required_options)) || {
    message="$(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
    return_status=127
  }

  ((return_status == 0)) || {
    _testing.__protected stdlib.logger.error "${message}"
    builtin return ${return_status}
  }

  builtin echo -n "${message}"
}
