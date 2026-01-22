#!/bin/bash

# stdlib testing mock internal security assert is library

builtin set -eo pipefail

_mock.__internal.security.assert.is_builtin() {
  # $1: the function name to query

  builtin local return_code=0
  builtin local requesting_mock="${FUNCNAME[1]%.mock*}"

  _testing.__protected stdlib.fn.query.is_builtin "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      _testing.error "${FUNCNAME[0]}: $(_testing.__protected stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      _testing.error "${FUNCNAME[1]}: $(_testing.mock.message.get MOCK_REQUIRES_BUILTIN "${requesting_mock}" "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}
