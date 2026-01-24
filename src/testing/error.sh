#!/bin/bash

# stdlib testing error library

builtin set -eo pipefail

# @description Prints one or more error messages to stderr.
#     STDLIB_TESTING_THEME_ERROR: The colour to use for the error messages.
# @arg $@ array The error messages to display.
# @exitcode 0 If the operation succeeded.
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
