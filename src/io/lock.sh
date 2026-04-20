#!/bin/bash

# stdlib io lock library

builtin set -eo pipefail

STDLIB_LOCK_WORKSPACE="${STDLIB_LOCK_WORKSPACE-""}"

# @description Acquires a named exclusive execution lock, or waits until able to do so.
#   * STDLIB_LOCK_WORKSPACE: A string for the name of a managed temporary directory which has been allocated for lock operations (default="").
#   * STDLIB_LOCK_WAIT_SECONDS: An integer for the number of seconds the process will wait for the lock to become available (default=30).
# @arg $1 string A unique alpha-numeric name for this lock.
# @exitcode 0 If the lock was successfully acquired.
# @exitcode 1 If the time out elapsed without the lock becoming available.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.io.lock.acquire() {
  builtin local lock_name="${1}"
  builtin local polling_interval="0.1"
  builtin local time_start
  builtin local time_elapsed
  builtin local wait_time="${STDLIB_LOCK_WAIT_SECONDS-30}"

  [[ "${#@}" -eq 1 ]] || builtin return 127
  stdlib.string.query.is_alpha_numeric "${lock_name}" || builtin return 126

  if [[ -z "${STDLIB_LOCK_WORKSPACE}" ]]; then
    stdlib.logger.error "$(stdlib.__message.get LOCK_WORKSPACE_DOES_NOT_EXIST "${lock_name}")"
    builtin return 1
  fi

  time_start="${SECONDS}"

  while ! "${_STDLIB_BINARY_MKDIR}" "${STDLIB_LOCK_WORKSPACE}/${lock_name}" 2>/dev/null; do
    "${_STDLIB_BINARY_SLEEP}" "${polling_interval}"
    time_elapsed="$(("${SECONDS}" - "${time_start}"))"
    if (("${time_elapsed}" >= "${time_start}" + "${wait_time}")); then
      stdlib.logger.error "$(stdlib.__message.get LOCK_COULD_NOT_BE_ACQUIRED "${lock_name}")"
      builtin return 1
    fi
  done

  return 0
}

# @description Releases a named exclusive execution lock.
#   * STDLIB_LOCK_WORKSPACE: A string for the name of a managed temporary directory which has been allocated for lock operations (default="").
# @arg $1 string A unique alpha-numeric name for this lock.
# @exitcode 0 If the lock was successfully released.
# @exitcode 1 If the lock could not be released.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.io.lock.release() {
  builtin local lock_name="${1}"

  [[ "${#@}" -eq 1 ]] || builtin return 127
  stdlib.string.query.is_alpha_numeric "${lock_name}" || builtin return 126

  if [[ -z "${STDLIB_LOCK_WORKSPACE}" ]]; then
    stdlib.logger.error "$(stdlib.__message.get LOCK_WORKSPACE_DOES_NOT_EXIST "${lock_name}")"
    builtin return 1
  fi

  if ! "${_STDLIB_BINARY_RMDIR}" "${STDLIB_LOCK_WORKSPACE}/${lock_name}"; then
    stdlib.logger.error "$(stdlib.__message.get LOCK_COULD_NOT_BE_RELEASED "${lock_name}")"
    builtin return 1
  fi
}

# @description Runs a command in a named exclusive execution lock.
#   * STDLIB_LOCK_WORKSPACE: A string for the name of a managed temporary directory which has been allocated for lock operations (default="").
#   * STDLIB_LOCK_WAIT_SECONDS: An integer for the number of seconds the process will wait for the lock to become available (default=30).
# @arg $1 string A unique alpha-numeric name for this lock.
# @arg $@ string The command or function and any arguments that will be executed with this execution lock.
# @exitcode 0 If the lock was successfully acquired.
# @exitcode 1 If the time out elapsed without the lock becoming available.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.io.lock.with() {
  builtin local lock_name="${1}"
  builtin local exit_code

  [[ "${#@}" -gt 1 ]] || builtin return 127

  builtin shift

  stdlib.io.lock.workspace_allocate || builtin return "$?"

  stdlib.io.lock.acquire "${lock_name}" || builtin return "$?"

  "${@}" && exit_code="$?" || exit_code="$?"

  stdlib.io.lock.release "${lock_name}" || builtin return "$?"

  builtin return "${exit_code}"
}

# @description Creates a temporary folder dedicated for execution locking, and handles it's clean up.
#   * STDLIB_LOCK_WORKSPACE: A string for the name of a managed temporary directory which has been allocated for lock operations (default="").
# @noargs
# @exitcode 0 If the workspace was successfully allocated.
# @exitcode 1 If the workspace could not be allocated.
# @exitcode 127 If the wrong number of arguments were provided.
# @set STDLIB_LOCK_WORKSPACE string The name of a managed temporary directory which has been allocated for lock operations.
# @stderr The error message if the operation fails.
# shellcheck disable=SC2120
stdlib.io.lock.workspace_allocate() {

  [[ "${#@}" -eq 0 ]] || builtin return 127

  if [[ -n "${STDLIB_LOCK_WORKSPACE}" ]]; then
    builtin return 0
  fi

  STDLIB_LOCK_WORKSPACE="$("${_STDLIB_BINARY_MKTEMP}" -d || builtin echo "")" # noqa

  if [[ -z "${STDLIB_LOCK_WORKSPACE}" ]]; then
    stdlib.logger.error "$(stdlib.__message.get LOCK_WORKSPACE_COULD_NOT_BE_ALLOCATED)"
    builtin return 1
  fi

  STDLIB_HANDLER_EXIT_FN_ARRAY+=("stdlib.io.lock.__workspace_cleanup")
}

# @description Cleans up the temporary folder dedicated for execution locking.
#   * STDLIB_LOCK_WORKSPACE: A string for the name of a managed temporary directory which has been allocated for lock operations (default="").
# @noargs
# @exitcode 0 If the workspace was successfully removed.
# @exitcode 1 If the workspace could not be removed.
# @internal
stdlib.io.lock.__workspace_cleanup() {
  if [[ -n "${STDLIB_LOCK_WORKSPACE}" ]]; then
    "${_STDLIB_BINARY_RM}" -r "${STDLIB_LOCK_WORKSPACE}" || builtin return 1
  fi
}
