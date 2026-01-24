#!/bin/bash

# stdlib testing rc capture library

builtin set -eo pipefail

# @description Captures the return code of a command.
# @arg $@ array The command to execute and its arguments.
# @exitcode 0 If the operation succeeded.
# @set TEST_RC integer The captured return code.
_capture.rc() {
  "$@"

  # shellcheck disable=SC2034
  TEST_RC="$?"
}
