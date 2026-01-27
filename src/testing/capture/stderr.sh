#!/bin/bash

# stdlib testing stderr capture library

builtin set -eo pipefail

# @description Captures the stderr of a command.
# @arg $@ array The command to execute.
# @exitcode 0 If the operation succeeded.
# @set TEST_OUTPUT string The captured stderr from the command.
_capture.stderr() {
  builtin local captured_rc

  builtin exec 3>&1
  # shellcheck disable=SC2034
  TEST_OUTPUT="$("$@" 2>&1 1> /dev/null)"
  captured_rc="$?"
  builtin exec 3>&-

  builtin return "${captured_rc}"
}

# @description Captures the stderr of a command (raw).
# @arg $@ array The command to execute.
# @exitcode 0 If the operation succeeded.
# @set TEST_OUTPUT string The captured stderr from the command.
_capture.stderr_raw() {
  builtin exec 3>&1
  # shellcheck disable=SC2034
  LC_ALL=C IFS= builtin read -rd '' TEST_OUTPUT < <("$@" 2>&1 1> /dev/null)
  builtin exec 3>&-

  builtin wait "$!"
  builtin return "$?"
}
