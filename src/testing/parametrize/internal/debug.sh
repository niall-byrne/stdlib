#!/bin/bash

# stdlib testing parametrize debug component

builtin set -eo pipefail

# @description Outputs a debug message for a parametrized test.
# @arg $1 string The debug message text.
# @exitcode 0 If the operation succeeded.
# @stdout The code to echo the debug message.
# @internal
@parametrize.__internal.debug.message() {
  builtin echo "builtin echo '${1}'"
}
