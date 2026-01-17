#!/bin/bash

# stdlib security path assert has library

builtin set -eo pipefail

# @description Asserts that a file or directory has the specified group ownership.
# @arg string path The path to check.
# @arg string group The required group name.
# @exitcode 1 If the group ownership is incorrect.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
# @stderr The error message if the assertion fails.
stdlib.security.path.assert.has_group() {
  builtin local return_code=0

  stdlib.security.path.query.has_group "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    1)
      stdlib.logger.error "$(stdlib.message.get SECURITY_INSECURE_GROUP_OWNERSHIP "${1}")"
      stdlib.logger.info "$(stdlib.message.get SECURITY_SUGGEST_CHGRP "${2}" "${1}")"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a file or directory has the specified owner.
# @arg string path The path to check.
# @arg string owner The required user name.
# @exitcode 1 If the ownership is incorrect.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
# @stderr The error message if the assertion fails.
stdlib.security.path.assert.has_owner() {
  builtin local return_code=0

  stdlib.security.path.query.has_owner "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    1)
      stdlib.logger.error "$(stdlib.message.get SECURITY_INSECURE_OWNERSHIP "${1}")"
      stdlib.logger.info "$(stdlib.message.get SECURITY_SUGGEST_CHOWN "${2}" "${1}")"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
  esac

  builtin return "${return_code}"
}

# @description Asserts that a file or directory has the specified permissions.
# @arg string path The path to check.
# @arg string permissions The required permission octal value.
# @exitcode 1 If the permissions are incorrect.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
# @stderr The error message if the assertion fails.
stdlib.security.path.assert.has_permissions() {
  builtin local return_code=0

  stdlib.security.path.query.has_permissions "${@}" || return_code="$?"

  case "${return_code}" in
    0) ;; # KCOV_EXCLUDE_LINE
    1)
      stdlib.logger.error "$(stdlib.message.get SECURITY_INSECURE_PERMISSIONS "${1}")"
      stdlib.logger.info "$(stdlib.message.get SECURITY_SUGGEST_CHMOD "${2}" "${1}")"
      ;;
    *)
      stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
  esac

  builtin return "${return_code}"
}
