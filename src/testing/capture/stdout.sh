#!/bin/bash

# stdlib testing stdout capture library

builtin set -eo pipefail

# @description Captures the stdout of a command.
# @arg $@ array The command to execute.
# @exitcode 0 If the operation succeeded.
# @set TEST_OUTPUT string The captured stdout from the command.
_capture.stdout() {
  # shellcheck disable=SC2034
  TEST_OUTPUT="$("$@" 2> /dev/null)"
}

# @description Captures the stdout of a command (raw).
# @arg $@ array The command to execute.
# @exitcode 0 If the operation succeeded.
# @set TEST_OUTPUT string The captured stdout from the command.
_capture.stdout_raw() {
  # shellcheck disable=SC2034
  LC_ALL=C IFS= builtin read -rd '' TEST_OUTPUT < <("$@" 2> /dev/null)

  builtin wait "$!"
  builtin return "$?"
}
