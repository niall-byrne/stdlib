#!/bin/bash

# stdlib fn assert library

builtin set -eo pipefail

# @description Asserts that a variable is not a function.
# @arg $1 string The name of the variable to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 127 If the wrong number of arguments was provided.
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
