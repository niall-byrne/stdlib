#!/bin/bash

# stdlib testing output capture library

builtin set -eo pipefail

# @description Captures the stdout and stderr of a command.
# @arg $@ array The command to execute.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @set TEST_OUTPUT string The combined stdout and stderr from the command.
_capture.output() {
  # shellcheck disable=SC2034
  TEST_OUTPUT="$("$@" 2>&1)"
}

# @description Captures the stdout and stderr of a command (raw).
# @arg $@ array The command to execute.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @set TEST_OUTPUT string The combined stdout and stderr from the command.
_capture.output_raw() {
  # shellcheck disable=SC2034
  LC_ALL=C IFS= builtin read -rd '' TEST_OUTPUT < <("$@" 2>&1)

  builtin wait "$!"
  builtin return "$?"
}
