#!/bin/bash

# stdlib testing error library

builtin set -eo pipefail

# @description Logs an error message.
#   * STDLIB_TESTING_THEME_ERROR: The colour to use for the message (default="LIGHT_RED").
# @arg $@ array The error messages to log.
# @exitcode 0 If the error message was logged.
# @stderr The error message if the operation fails.
_testing.error() {
  {
    (
      while [[ -n "${1}" ]]; do
        _testing.__protected stdlib.string.colour "${STDLIB_TESTING_THEME_ERROR}" "${1}" # validates STDLIB_TESTING_THEME_ERROR
        builtin shift
      done
    )
  } >&2 # KCOV_EXCLUDE_LINE
}

# @description A pipeable version _testing.error that can read from stdin and return specific error codes when errors are found.
#   * STDLIB_TESTING_THEME_ERROR: The colour to use for the message (default="LIGHT_RED").
# @arg $1 integer (optional, default=1) The error code that should be returned if any error message is piped to this function.
# @exitcode 0 If the error message was not logged.
# @exitcode 1 If an error message is logged.  (This value is configurable via arguments).
# @stderr The error message if the operation fails.
_testing.error_pipe() {
  _testing.__protected stdlib.fn.args.require "0" "1" "${@}" || builtin return 127

  if [[ -n "${1}" ]]; then
    _testing.__protected stdlib.string.assert.is_digit "${1}" || builtin return 126
  fi

  builtin local -a received_args
  builtin local received_arg
  builtin local return_code="${1:-1}"

  while IFS= builtin read -r received_arg || [[ -n "${received_arg}" ]]; do
    received_args+=("${received_arg}")
  done

  if [[ "${#received_args[@]}" -ne 0 ]]; then
    _testing.error "${received_args[@]}" # validates STDLIB_TESTING_THEME_ERROR
    builtin return "${return_code}"
  fi

  builtin return 0
}
