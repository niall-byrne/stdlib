#!/bin/bash

# stdlib logger library

builtin set -eo pipefail

_STDLIB_LOGGING_MESSAGE_PREFIX=""
_STDLIB_LOGGING_DECORATORS=("__testing.protected")

# @description Prints a traceback of the call stack.
# @stdout The traceback of the call stack.
# @exitcode 0 If the traceback was printed successfully.
stdlib.logger.traceback() {
  builtin local fn_name_index
  builtin local fn_name_indent=">"

  stdlib.message.get TRACEBACK_HEADER
  builtin echo

  for ((fn_name_index = ("${#FUNCNAME[@]}" - 1); fn_name_index > 1; fn_name_index--)); do
    builtin echo "${fn_name_indent}  ${BASH_SOURCE["${fn_name_index}"]}:${BASH_LINENO[$(("${fn_name_index}" - 1))]}:${FUNCNAME["${fn_name_index}"]}()"
    fn_name_indent+=">"
  done
}

# @description Logs an error message to stderr.
# @arg $1 The message to log.
# @option _STDLIB_LOGGING_MESSAGE_PREFIX A prefix for the message (defaults to the calling function's name).
# @stderr The error message, prefixed with the calling function's name.
# @exitcode 0 If the message was logged successfully.
stdlib.logger.error() {
  {
    stdlib.logger.__message_prefix
    stdlib.string.colour "${STDLIB_THEME_LOGGER_ERROR}" "${1}"
  } >&2 # KCOV_EXCLUDE_LINE
}

# @description Logs a warning message to stderr.
# @arg $1 The message to log.
# @option _STDLIB_LOGGING_MESSAGE_PREFIX A prefix for the message (defaults to the calling function's name).
# @stderr The warning message, prefixed with the calling function's name.
# @exitcode 0 If the message was logged successfully.
stdlib.logger.warning() {
  {
    stdlib.logger.__message_prefix
    stdlib.string.colour "${STDLIB_THEME_LOGGER_WARNING}" "${1}"
  } >&2 # KCOV_EXCLUDE_LINE
}

# @description Logs an informational message to stdout.
# @arg $1 The message to log.
# @option _STDLIB_LOGGING_MESSAGE_PREFIX A prefix for the message (defaults to the calling function's name).
# @stdout The informational message, prefixed with the calling function's name.
# @exitcode 0 If the message was logged successfully.
stdlib.logger.info() {
  stdlib.logger.__message_prefix
  stdlib.string.colour "${STDLIB_THEME_LOGGER_INFO}" "${1}"
}

# @description Logs a notice message to stdout.
# @arg $1 The message to log.
# @option _STDLIB_LOGGING_MESSAGE_PREFIX A prefix for the message (defaults to the calling function's name).
# @stdout The notice message, prefixed with the calling function's name.
# @exitcode 0 If the message was logged successfully.
stdlib.logger.notice() {
  stdlib.logger.__message_prefix
  stdlib.string.colour "${STDLIB_THEME_LOGGER_NOTICE}" "${1}"
}

# @description Logs a success message to stdout.
# @arg $1 The message to log.
# @option _STDLIB_LOGGING_MESSAGE_PREFIX A prefix for the message (defaults to the calling function's name).
# @stdout The success message, prefixed with the calling function's name.
# @exitcode 0 If the message was logged successfully.
stdlib.logger.success() {
  stdlib.logger.__message_prefix
  stdlib.string.colour "${STDLIB_THEME_LOGGER_SUCCESS}" "${1}"
}

stdlib.logger.__message_prefix() {
  builtin local message_prefix="${_STDLIB_LOGGING_MESSAGE_PREFIX:-${FUNCNAME[3]}}"
  if stdlib.array.query.is_contains "${message_prefix}" _STDLIB_LOGGING_DECORATORS; then
    message_prefix="${FUNCNAME[4]}"
  fi

  builtin echo -n "${message_prefix}: "
}
