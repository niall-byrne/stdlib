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
        _testing.__protected stdlib.string.colour "${STDLIB_TESTING_THEME_ERROR}" "${1}"
        builtin shift
      done
    )
  } >&2 # KCOV_EXCLUDE_LINE
}
