#!/bin/bash

# stdlib testing parametrize debug component

builtin set -eo pipefail

# @description Outputs a debug message for eval.
# @arg $1 string The debug text to output.
# @exitcode 0 If the debug message was generated.
# @stdout The debug message for eval.
# @internal
@parametrize.__internal.debug.message() {
  builtin echo "builtin echo '${1}'"
}
