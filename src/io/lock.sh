#!/bin/bash

# stdlib io lock library

builtin set -eo pipefail

STDLIB_LOCK_PERMISSION_OCTAL=""
STDLIB_LOCK_QUIET_FAILURE_BOOLEAN=""
STDLIB_LOCK_POLLING_INTERVAL=""
STDLIB_LOCK_WAIT_SECONDS=""
STDLIB_LOCK_WORKSPACE_PERMISSION_OCTAL=""

builtin export STDLIB_LOCK_WORKSPACE=""

# @description Acquires a named exclusive execution lock, or waits until able to do so.
#   * STDLIB_LOCK_PERMISSION_OCTAL string keyword: An octal file system permission value for the created lock (default="0700").
#   * STDLIB_LOCK_POLLING_INTERVAL string keyword: A decimal value for the number of seconds the process will wait before retrying lock acquisition (default="0.1").
#   * STDLIB_LOCK_QUIET_FAILURE_BOOLEAN boolean keyword: A boolean to disable errors messages on a lock acquisition failure (default=0).
#   * STDLIB_LOCK_WAIT_SECONDS integer keyword: An integer for the number of seconds the process will wait for the lock to become available.  To create an infinite wait, use a negative value. (default=30).
#   * STDLIB_LOCK_WORKSPACE string global: The name of a managed temporary directory which has been allocated for lock operations (default="").
# @arg $1 string A unique alpha-numeric, underscored name for this lock.
# @exitcode 0 If the lock was successfully acquired.
# @exitcode 1 If the lock could not be acquired.
# @exitcode 123 If a variable reserved for use by the BASH stdlib has been assigned an invalid value.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @set STDLIB_LOCK_WORKSPACE string The name of a managed temporary directory which has been allocated for lock operations.
# @set STDLIB_LOCK_WORKSPACE string The name of a managed temporary directory which has been allocated for lock operations.
# @stderr The error message if the operation fails.
stdlib.io.lock.acquire() {
  builtin local lock_name="${1}"
  builtin local lock_permissions="${STDLIB_LOCK_PERMISSION_OCTAL:-"0700"}"
  builtin local quiet_acquisition_failure_boolean="${STDLIB_LOCK_QUIET_FAILURE_BOOLEAN:-0}"
  builtin local polling_interval="${STDLIB_LOCK_POLLING_INTERVAL:-"0.1"}"
  builtin local time_elapsed
  builtin local time_start
  builtin local wait_time="${STDLIB_LOCK_WAIT_SECONDS:-30}"

  [[ "${#@}" -eq 1 ]] || builtin return 127
  stdlib.var.query.is_valid_name "${lock_name}" || builtin return 126

  STDLIB_KW_SOURCE_VAR="lock_permissions" \
    stdlib.fn.keyword.assert.is_valid_with stdlib.string.assert.is_octal_permission STDLIB_LOCK_PERMISSION_OCTAL || builtin return 125 # validates STDLIB_LOCK_PERMISSION_OCTAL
  STDLIB_KW_SOURCE_VAR="polling_interval" \
    stdlib.fn.keyword.assert.is_valid_with stdlib.string.assert.is_decimal_positive STDLIB_LOCK_POLLING_INTERVAL || builtin return 125 # validates STDLIB_LOCK_POLLING_INTERVAL
  STDLIB_KW_SOURCE_VAR="quiet_acquisition_failure_boolean" \
    stdlib.fn.keyword.assert.is_valid_with stdlib.string.assert.is_boolean STDLIB_LOCK_QUIET_FAILURE_BOOLEAN || builtin return 125 # validates STDLIB_LOCK_QUIET_FAILURE_BOOLEAN
  STDLIB_KW_SOURCE_VAR="wait_time" \
    stdlib.fn.keyword.assert.is_valid_with stdlib.string.assert.is_integer STDLIB_LOCK_WAIT_SECONDS || builtin return 125 # validates STDLIB_LOCK_WAIT_SECONDS

  if ! stdlib.io.lock.__workspace_is_valid "${STDLIB_LOCK_WORKSPACE}"; then # validates STDLIB_LOCK_WORKSPACE
    stdlib.logger.error "$(stdlib.__message.get VAR_VALUE_INVALID_RESERVED_DETAIL STDLIB_LOCK_WORKSPACE)"
    builtin return 123
  fi

  time_start="${SECONDS}"

  while ! "${_STDLIB_BINARY_MKDIR}" "${STDLIB_LOCK_WORKSPACE}/${lock_name}" 2> /dev/null; do
    "${_STDLIB_BINARY_SLEEP}" "${polling_interval}"

    if [[ "${wait_time}" -lt "0" ]]; then
      builtin continue
    fi

    time_elapsed="$(("${SECONDS}" - "${time_start}"))"
    if (("${time_elapsed}" >= "${time_start}" + "${wait_time}")); then
      if [[ "${quiet_acquisition_failure_boolean}" -eq 0 ]]; then
        stdlib.logger.error "$(stdlib.__message.get LOCK_COULD_NOT_BE_ACQUIRED "${lock_name}")"
      fi
      builtin return 1
    fi
  done

  "${_STDLIB_BINARY_CHMOD}" "${lock_permissions}" "${STDLIB_LOCK_WORKSPACE}/${lock_name}"

  builtin return 0
}

# @description Releases a named exclusive execution lock.
#   * STDLIB_LOCK_WORKSPACE string global: The name of a managed temporary directory which has been allocated for lock operations (default="").
# @arg $1 string A unique alpha-numeric name for this lock.
# @exitcode 0 If the lock was successfully released.
# @exitcode 1 If the lock could not be released.
# @exitcode 123 If a variable reserved for use by the BASH stdlib has been assigned an invalid value.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.io.lock.release() {
  builtin local lock_name="${1}"

  [[ "${#@}" -eq 1 ]] || builtin return 127
  stdlib.var.query.is_valid_name "${lock_name}" || builtin return 126

  if ! stdlib.io.lock.__workspace_is_valid "${STDLIB_LOCK_WORKSPACE}"; then # validates STDLIB_LOCK_WORKSPACE
    stdlib.logger.error "$(stdlib.__message.get VAR_VALUE_INVALID_RESERVED_DETAIL STDLIB_LOCK_WORKSPACE)"
    builtin return 123
  fi

  if ! "${_STDLIB_BINARY_RMDIR}" "${STDLIB_LOCK_WORKSPACE}/${lock_name}"; then
    stdlib.logger.error "$(stdlib.__message.get LOCK_COULD_NOT_BE_RELEASED "${lock_name}")"
    builtin return 1
  fi
}

# @description Runs a command with a named exclusive execution lock. A lock workspace is allocated as needed.
#   * STDLIB_LOCK_PERMISSION_OCTAL string keyword: An octal file system permission value for the created lock (default="0700").
#   * STDLIB_LOCK_POLLING_INTERVAL string keyword: A decimal value for the number of seconds the process will wait before retrying lock acquisition (default="0.1").
#   * STDLIB_LOCK_QUIET_FAILURE_BOOLEAN boolean keyword: A boolean to disable errors messages on a lock acquisition failure (default=0).
#   * STDLIB_LOCK_WAIT_SECONDS integer keyword: An integer for the number of seconds the process will wait for the lock to become available.  To create an infinite wait, use a negative value. (default=30).
#   * STDLIB_LOCK_WORKSPACE string global: The name of a managed temporary directory which has been allocated for lock operations (default="").
#   * STDLIB_LOCK_WORKSPACE_PERMISSION_OCTAL string keyword: An octal file system permission value for the created workspace folder (default="0700").
# @arg $1 string A unique alpha-numeric name for this lock.
# @arg $@ string The command or function and any arguments that will be executed with this execution lock.
# @exitcode 0 If the lock was successfully acquired.
# @exitcode 1 If the time out elapsed without the lock becoming available.
# @exitcode 123 If a variable reserved for use by the BASH stdlib has been assigned an invalid value.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @set STDLIB_LOCK_WORKSPACE string The name of a managed temporary directory which has been allocated for lock operations.
# @set STDLIB_LOCK_WORKSPACE string The name of a managed temporary directory which has been allocated for lock operations.
# @stderr The error message if the operation fails.
stdlib.io.lock.with() {
  builtin local lock_name="${1}"
  builtin local exit_code

  [[ "${#@}" -gt 1 ]] || builtin return 127

  builtin shift

  stdlib.io.lock.workspace_allocate || builtin return "$?" # validates STDLIB_LOCK_WORKSPACE

  stdlib.io.lock.acquire "${lock_name}" || builtin return "$?" # validates STDLIB_LOCK_PERMISSION_OCTAL,STDLIB_LOCK_POLLING_INTERVAL,STDLIB_LOCK_QUIET_FAILURE_BOOLEAN,STDLIB_LOCK_WAIT_SECONDS,STDLIB_LOCK_WORKSPACE_PERMISSION_OCTAL

  "${@}" && exit_code="$?" || exit_code="$?"

  stdlib.io.lock.release "${lock_name}" || builtin return "$?"

  builtin return "${exit_code}"
}

# @description Creates a temporary folder dedicated for execution locking, and handles it's clean up.
#   * STDLIB_HANDLER_EXIT_FN_ARRAY array global: An array containing a list of functions that are run on an exit call (default=()).
#   * STDLIB_LOCK_WORKSPACE string global: The name of a managed temporary directory which has been allocated for lock operations (default="").
#   * STDLIB_LOCK_WORKSPACE_PERMISSION_OCTAL string keyword: An octal file system permission value for the created workspace folder (default="0700").
# @noargs
# @exitcode 0 If the workspace was successfully allocated.
# @exitcode 1 If the workspace could not be allocated.
# @exitcode 123 If a variable reserved for use by the BASH stdlib has been assigned an invalid value.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @set STDLIB_HANDLER_EXIT_FN_ARRAY array An array containing a list of functions that are run on an exit call.
# @set STDLIB_LOCK_WORKSPACE string The name of a managed temporary directory which has been allocated for lock operations.
# @stderr The error message if the operation fails.
# shellcheck disable=SC2120
stdlib.io.lock.workspace_allocate() {
  builtin local successful_allocation_boolean=1
  builtin local lock_workspace_permissions="${STDLIB_LOCK_WORKSPACE_PERMISSION_OCTAL:-"0700"}"

  [[ "${#@}" -eq 0 ]] || builtin return 127

  STDLIB_KW_SOURCE_VAR="lock_workspace_permissions" \
    stdlib.fn.keyword.assert.is_valid_with stdlib.string.assert.is_octal_permission STDLIB_LOCK_WORKSPACE_PERMISSION_OCTAL || builtin return 125 # validates STDLIB_LOCK_WORKSPACE_PERMISSION_OCTAL

  if stdlib.io.lock.__workspace_is_valid "${STDLIB_LOCK_WORKSPACE}"; then # validates STDLIB_LOCK_WORKSPACE
    builtin return 0
  fi

  if ! stdlib.var.query.is_empty STDLIB_LOCK_WORKSPACE; then # validates STDLIB_LOCK_WORKSPACE
    stdlib.logger.error "$(stdlib.__message.get VAR_VALUE_INVALID_RESERVED_DETAIL STDLIB_LOCK_WORKSPACE)"
    builtin return 123
  fi

  STDLIB_LOCK_WORKSPACE="$("${_STDLIB_BINARY_MKTEMP}" -d)" || successful_allocation_boolean=0
  stdlib.io.path.query.is_folder "${STDLIB_LOCK_WORKSPACE}" || successful_allocation_boolean=0

  if [[ "${successful_allocation_boolean}" -eq 0 ]]; then
    stdlib.logger.error "$(stdlib.__message.get LOCK_WORKSPACE_COULD_NOT_BE_ALLOCATED)"
    builtin return 1
  fi

  "${_STDLIB_BINARY_CHMOD}" "${lock_workspace_permissions}" "${STDLIB_LOCK_WORKSPACE}"

  STDLIB_HANDLER_EXIT_FN_ARRAY+=("stdlib.io.lock.__workspace_cleanup") # validates STDLIB_HANDLER_EXIT_FN_ARRAY
}

# @description Cleans up the temporary folder dedicated for execution locking.
#   * STDLIB_LOCK_WORKSPACE string global: The name of a managed temporary directory which has been allocated for lock operations (default="").
# @noargs
# @exitcode 0 If the workspace was successfully removed.
# @exitcode 1 If the workspace could not be removed.
# @internal
stdlib.io.lock.__workspace_cleanup() {
  if stdlib.io.lock.__workspace_is_valid; then # validates STDLIB_LOCK_WORKSPACE
    "${_STDLIB_BINARY_RM}" -r "${STDLIB_LOCK_WORKSPACE}" || builtin return 1
  fi
}

# @description Validates the current value of STDLIB_LOCK_WORKSPACE.
#   * STDLIB_LOCK_WORKSPACE string global: The name of a managed temporary directory which has been allocated for lock operations (default="").
# @noargs
# @exitcode 0 If STDLIB_LOCK_WORKSPACE is set to a valid value.
# @exitcode 1 If STDLIB_LOCK_WORKSPACE is set to an invalid value.
# @internal
stdlib.io.lock.__workspace_is_valid() { # validates STDLIB_LOCK_WORKSPACE
  builtin local -a invalid_workspace_values

  # shellcheck disable=SC2034
  invalid_workspace_values=("/")

  if stdlib.io.path.query.is_folder "${STDLIB_LOCK_WORKSPACE}" &&
    ! stdlib.array.query.is_contains "${STDLIB_LOCK_WORKSPACE}" invalid_workspace_values; then # validates STDLIB_LOCK_WORKSPACE
    builtin return 0
  fi

  builtin return 1
}
