#!/bin/bash

# stdlib logger library

builtin set -eo pipefail

# @internal
# @description A prefix for the log message.
#     If empty, it defaults to the name of the calling function.
_STDLIB_LOGGING_MESSAGE_PREFIX=""
# @internal
# @description A list of function names that should be ignored when determining the message prefix.
_STDLIB_LOGGING_DECORATORS=("_testing.__protected")

# @description Prints a traceback of the current function calls.
# @noargs
# @exitcode 0 If the operation succeeded.
# @stdout The traceback information.
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

# @description Logs an error message.
#     _STDLIB_LOGGING_MESSAGE_PREFIX a prefix for the message (optional, default="${FUNCNAME[3]}")
# @arg $1 string The message to log.
# @exitcode 0 If the operation succeeded.
# @stderr The error message.
stdlib.logger.error() {
  {
    stdlib.logger.__message_prefix
    stdlib.string.colour "${STDLIB_THEME_LOGGER_ERROR}" "${1}"
  } >&2 # KCOV_EXCLUDE_LINE
}

# @description Logs a warning message.
#     _STDLIB_LOGGING_MESSAGE_PREFIX a prefix for the message (optional, default="${FUNCNAME[3]}")
# @arg $1 string The message to log.
# @exitcode 0 If the operation succeeded.
# @stderr The warning message.
stdlib.logger.warning() {
  {
    stdlib.logger.__message_prefix
    stdlib.string.colour "${STDLIB_THEME_LOGGER_WARNING}" "${1}"
  } >&2 # KCOV_EXCLUDE_LINE
}

# @description Logs an informational message.
#     _STDLIB_LOGGING_MESSAGE_PREFIX a prefix for the message (optional, default="${FUNCNAME[3]}")
# @arg $1 string The message to log.
# @exitcode 0 If the operation succeeded.
# @stdout The informational message.
stdlib.logger.info() {
  stdlib.logger.__message_prefix
  stdlib.string.colour "${STDLIB_THEME_LOGGER_INFO}" "${1}"
}

# @description Logs a notice message.
#     _STDLIB_LOGGING_MESSAGE_PREFIX a prefix for the message (optional, default="${FUNCNAME[3]}")
# @arg $1 string The message to log.
# @exitcode 0 If the operation succeeded.
# @stdout The notice message.
stdlib.logger.notice() {
  stdlib.logger.__message_prefix
  stdlib.string.colour "${STDLIB_THEME_LOGGER_NOTICE}" "${1}"
}

# @description Logs a success message.
#     _STDLIB_LOGGING_MESSAGE_PREFIX a prefix for the message (optional, default="${FUNCNAME[3]}")
# @arg $1 string The message to log.
# @exitcode 0 If the operation succeeded.
# @stdout The success message.
stdlib.logger.success() {
  stdlib.logger.__message_prefix
  stdlib.string.colour "${STDLIB_THEME_LOGGER_SUCCESS}" "${1}"
}

# @description Prints the message prefix for logging.
# @noargs
# @exitcode 0 If the operation succeeded.
# @stdout The message prefix.
# @internal
stdlib.logger.__message_prefix() {
  builtin local message_prefix="${_STDLIB_LOGGING_MESSAGE_PREFIX:-${FUNCNAME[3]}}"
  if stdlib.array.query.is_contains "${message_prefix}" _STDLIB_LOGGING_DECORATORS; then
    message_prefix="${FUNCNAME[4]}"
  fi

  builtin echo -n "${message_prefix}: "
}
