#!/bin/bash

# stdlib testing output capture library

builtin set -eo pipefail

# @description Captures the combined stdout and stderr of a command.
# @arg $@ array The command to execute and its arguments.
# @exitcode 0 If the operation succeeded.
# @set TEST_OUTPUT string The captured output.
_capture.output() {
  # shellcheck disable=SC2034
  TEST_OUTPUT="$("$@" 2>&1)"
}

# @description Captures the raw combined stdout and stderr of a command.
# @arg $@ array The command to execute and its arguments.
# @exitcode 0 If the operation succeeded.
# @set TEST_OUTPUT string The captured output.
_capture.output_raw() {
  # shellcheck disable=SC2034
  LC_ALL=C IFS= builtin read -rd '' TEST_OUTPUT < <("$@" 2>&1)

  builtin wait "$!"
  builtin return "$?"
}
