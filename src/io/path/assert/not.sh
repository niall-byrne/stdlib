#!/bin/bash

# stdlib io path assert not library

builtin set -eo pipefail

stdlib.io.path.assert.not_exists() {
  # $1: the path to check

  builtin local return_code=0

  stdlib.io.path.query.is_exists "${@}" || return_code="$?"

  case "${return_code}" in
    0)
      stdlib.logger.error "$(stdlib.message.get FS_PATH_EXISTS "${1}")"
      builtin return 1
      ;;
    1)
      builtin return 0
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
  esac

  builtin return "${return_code}"
}
