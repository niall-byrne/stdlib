#!/bin/bash

# stdlib security assert user library

builtin set -eo pipefail

# @description Asserts that the current user is the root user.
# @noargs
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.security.user.assert.is_root() {
  builtin local return_code=0

  stdlib.security.user.query.is_root "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    1)
      stdlib.logger.error "$(stdlib.message.get SECURITY_MUST_BE_RUN_AS_ROOT)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
  esac

  builtin return "${return_code}"
}
