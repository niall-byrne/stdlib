#!/bin/bash

# stdlib var assert is library

builtin set -eo pipefail

stdlib.var.assert.is_valid_name() {
  # $1: the var name to query

  builtin local return_code=0

  stdlib.var.query.is_valid_name "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    126 | 127)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get VAR_NAME_INVALID "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}
