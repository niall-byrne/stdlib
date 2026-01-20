#!/bin/bash

# stdlib testing error library

builtin set -eo pipefail

_testing.error() {
  # $@: the error messages to display

  {
    (
      while [[ -n "${1}" ]]; do
        _testing.__protected stdlib.string.colour "${STDLIB_TESTING_THEME_ERROR}" "${1}"
        builtin shift
      done
    )
  } >&2 # KCOV_EXCLUDE_LINE
}
