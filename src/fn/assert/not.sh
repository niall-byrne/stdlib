#!/bin/bash

# stdlib fn assert not library

builtin set -eo pipefail

stdlib.fn.assert.not_fn() {
  # $1: the function name to assert does not exist

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
