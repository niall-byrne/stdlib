#!/bin/bash

# stdlib builtin library

builtin set -eo pipefail

# @internal
# @description Whether to allow overriding builtins with external commands if set to "1".
_STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN=""

# @description Executes a command as a builtin unless overriding is allowed.
#     _STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN whether to allow overriding builtins (optional, default="0")
# @arg $1 string The command to execute.
# @arg $@ array The arguments to the command.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The output of the command.
# @stderr The error output of the command.
stdlib.builtin.overridable() {
  builtin local use_builtin_boolean="${_STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN:-0}"

  if [[ "${use_builtin_boolean}" == "0" ]]; then
    builtin "${@}"
  else
    "${@}"
  fi
}
