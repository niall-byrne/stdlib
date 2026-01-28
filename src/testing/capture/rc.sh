#!/bin/bash

# stdlib testing rc capture library

builtin set -eo pipefail

# @description Captures the return code of a command.
# @arg $@ array The command to execute.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @set TEST_RC integer The return code from the command.
_capture.rc() {
  "$@"

  # shellcheck disable=SC2034
  TEST_RC="$?"
}
