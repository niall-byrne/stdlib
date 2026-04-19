#!/bin/bash

# stdlib builtin library

builtin set -eo pipefail

STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN=""
__STDLIB_SECURE_DISTRIBUTION="${__STDLIB_SECURE_DISTRIBUTION:-"0"}"

# @description Executes a command as a builtin unless overriding is allowed.
#   * STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN: Enables overriding builtins (default="0").
# @arg $1 string The command to execute.
# @arg $@ array The arguments to the command.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The output of the command.
# @stderr The error output of the command.
# @internal
stdlib.__builtin.overridable() {
  builtin local use_builtin_boolean="${STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN:-0}"

  if [[ "${use_builtin_boolean}" == "0" ]]; then
    builtin "${@}"
  else
    "${@}"
  fi
}

if [[ "${__STDLIB_SECURE_DISTRIBUTION}" == "1" ]]; then
  # @description Executes a command as a builtin and disables the testing overrides.
  # @arg $@ array The arguments to execute as a builtin command.
  # @exitcode 0 If the operation succeeded.
  # @exitcode 127 If the wrong number of arguments were provided.
  # @stdout The output of the command.
  # @stderr The error output of the command.
  # @internal
  stdlib.__builtin.overridable() {
    builtin "${@}"
  }
fi
