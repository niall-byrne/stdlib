#!/bin/bash

# stdlib fn assert library

builtin set -eo pipefail

# @description Asserts that a function does not exist.
# @arg $1 The name of the function to check.
# @exitcode 1 If the function exists.
# @exitcode 127 The wrong number of arguments was provided.
# @stderr The error message if the assertion fails.
stdlib.fn.assert.not_fn() {
  builtin local return_code=0

  stdlib.fn.query.is_fn "${@}" || return_code="$?"

  case "${return_code}" in
    0)
      stdlib.logger.error "$(stdlib.message.get IS_FN "${1}")"
      builtin return 1
      ;;
    1)
      builtin return 0
      ;;
    127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
  esac

  builtin return "${return_code}"
}
