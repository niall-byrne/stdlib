#!/bin/bash

# stdlib testing stderr capture library

builtin set -eo pipefail

# @description Captures the stderr of a command.
# @arg $@ array The command to execute and its arguments.
# @exitcode 0 If the operation succeeded.
# @set TEST_OUTPUT string The captured stderr output.
_capture.stderr() {
  builtin local captured_rc

  builtin exec 3>&1
  # shellcheck disable=SC2034
  TEST_OUTPUT="$("$@" 2>&1 1> /dev/null)"
  captured_rc="$?"
  builtin exec 3>&-

  builtin return "${captured_rc}"
}

# @description Captures the raw stderr of a command.
# @arg $@ array The command to execute and its arguments.
# @exitcode 0 If the operation succeeded.
# @set TEST_OUTPUT string The captured stderr output.
_capture.stderr_raw() {
  builtin exec 3>&1
  # shellcheck disable=SC2034
  LC_ALL=C IFS= builtin read -rd '' TEST_OUTPUT < <("$@" 2>&1 1> /dev/null)
  builtin exec 3>&-

  builtin wait "$!"
  builtin return "$?"
}
