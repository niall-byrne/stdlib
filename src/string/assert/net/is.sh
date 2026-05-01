#!/bin/bash

# stdlib string assert net is library

builtin set -eo pipefail

# @description Asserts that a string is a valid ipv4 address.
# @arg $1 string The string to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.net.is_ipv4() {
  builtin local return_code=0

  stdlib.string.query.net.is_ipv4 "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get IS_NOT_IPV4 "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a string is a valid ipv6 address.
# @arg $1 string The string to check.
# @exitcode 0 If the assertion succeeded.
# @exitcode 1 If the assertion failed.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.string.assert.net.is_ipv6() {
  builtin local return_code=0

  stdlib.string.query.net.is_ipv6 "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    127)
      stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "$(stdlib.__message.get IS_NOT_IPV6 "${1}")"
      ;;
  esac

  builtin return "${return_code}"
}
