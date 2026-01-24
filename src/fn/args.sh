#!/bin/bash

# stdlib fn args library

builtin set -eo pipefail

STDLIB_ARGS_CALLER_FN_NAME=""
STDLIB_ARGS_NULL_SAFE_ARRAY=()

# @description Validates the presence and number of arguments for a function.
#   * STDLIB_ARGS_CALLER_FN_NAME: A string presented as the name of the calling function in logging messages (default="${FUNCNAME[1]}").
#   * STDLIB_ARGS_NULL_SAFE_ARRAY: An array of argument indexes that are null safe, meaning they can be empty values (default=()).
# @arg $1 integer The number of required arguments.
# @arg $2 integer The number of optional arguments.
# @arg $@ array The list of argument values to check.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.fn.args.require() {
  builtin local -a args_null_safe_array
  # shellcheck disable=SC2034
  builtin local STDLIB_LOGGING_MESSAGE_PREFIX="${STDLIB_ARGS_CALLER_FN_NAME:-"${FUNCNAME[1]}"}"

  # shellcheck disable=SC2034
  args_null_safe_array=("${STDLIB_ARGS_NULL_SAFE_ARRAY[@]}")

  builtin local arg_index=1
  builtin local args_optional_count="${2}"
  builtin local args_required_count="${1}"

  stdlib.string.assert.is_digit "${args_required_count}" || builtin return 126
  stdlib.string.assert.is_digit "${args_optional_count}" || builtin return 126
  stdlib.array.assert.is_array args_null_safe_array || builtin return 126

  builtin shift 2

  if (("${#@}" < "${args_required_count}" || "${#@}" > "${args_required_count}" + "${args_optional_count}")); then
    stdlib.logger.error "$(stdlib.__message.get ARGUMENT_REQUIREMENTS_VIOLATION "${args_required_count}" "${args_optional_count}")"
    stdlib.logger.error "$(stdlib.__message.get ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL "${#@}")"
    builtin return 127
  fi

  for ((arg_index = 1; arg_index <= "${#@}"; arg_index++)); do
    if [[ -z "${!arg_index}" ]]; then
      if ! stdlib.array.query.is_contains "${arg_index}" args_null_safe_array; then
        stdlib.logger.error "$(stdlib.__message.get ARGUMENT_REQUIREMENTS_VIOLATION "${args_required_count}" "${args_optional_count}")"
        stdlib.logger.error "$(stdlib.__message.get ARGUMENT_REQUIREMENTS_VIOLATION_NULL "${arg_index}")"
        builtin return 126
      fi
    fi
  done
}
