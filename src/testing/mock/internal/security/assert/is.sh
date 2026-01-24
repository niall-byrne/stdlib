#!/bin/bash

# stdlib testing mock internal security assert is library

builtin set -eo pipefail

# @description Asserts that a function is a builtin and not overridden.
# @arg $1 string The function name to check.
# @exitcode 0 If the function is a builtin.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
# @internal
_mock.__internal.security.assert.is_builtin() {
  builtin local return_code=0
  builtin local requesting_mock="${FUNCNAME[1]%.mock*}"

  _testing.__protected stdlib.fn.query.is_builtin "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      _testing.error "${FUNCNAME[0]}: $(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      _testing.error "${FUNCNAME[1]}: $(_testing.mock.__message.get MOCK_REQUIRES_BUILTIN "${requesting_mock}" "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}
