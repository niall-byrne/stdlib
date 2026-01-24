#!/bin/bash

# stdlib fn assert not library

builtin set -eo pipefail

# @description Asserts that a command is not a bash builtin.
# @arg $1 string The command name to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.fn.assert.not_builtin() {
  builtin local return_code=0

  stdlib.fn.query.is_builtin "${@}" || return_code="$?"

  case "${return_code}" in
    0)
      stdlib.logger.error "$(stdlib.__message.get IS_BUILTIN "${1}")"
      builtin return 1
      ;;
    1)
      builtin return 0
      ;;
    127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a function name is not defined.
# @arg $1 string The function name to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 1 If the operation failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.fn.assert.not_fn() {
  builtin local return_code=0

  stdlib.fn.query.is_fn "${@}" || return_code="$?"

  case "${return_code}" in
    0)
      stdlib.logger.error "$(stdlib.__message.get IS_FN "${1}")"
      builtin return 1
      ;;
    1)
      builtin return 0
      ;;
    127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
  esac

  builtin return "${return_code}"
}
