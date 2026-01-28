#!/bin/bash

# stdlib testing rc capture library

builtin set -eo pipefail

# @description Captures the return code of a command.
# @arg $@ array The command to execute.
# @exitcode 0 If the return code was captured successfully.
# @set TEST_RC integer The return code from the command.
_capture.rc() {
  "$@"

  # shellcheck disable=SC2034
  TEST_RC="$?"
}
