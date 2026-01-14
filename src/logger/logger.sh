#!/bin/bash

# stdlib logger library

builtin set -eo pipefail

_STDLIB_LOGGING_MESSAGE_PREFIX=""
_STDLIB_LOGGING_DECORATORS=("__testing.protected")

# @description Prints a traceback of the call stack to stderr.
# @noargs
# @exitcode 0 If the traceback was printed successfully.
# @stderr The traceback of the call stack.
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

# @description Prints an error message to stderr.
# @arg $1 The message to print.
# @option STDLIB_THEME_LOGGER_ERROR The colour to use for the message.
# @exitcode 0 If the message was printed successfully.
# @stderr The error message.
stdlib.logger.error() {
  {
    stdlib.logger.__message_prefix
    stdlib.string.colour "${STDLIB_THEME_LOGGER_ERROR}" "${1}"
  } >&2 # KCOV_EXCLUDE_LINE
}

# @description Prints a warning message to stderr.
# @arg $1 The message to print.
# @option STDLIB_THEME_LOGGER_WARNING The colour to use for the message.
# @exitcode 0 If the message was printed successfully.
# @stderr The warning message.
stdlib.logger.warning() {
  {
    stdlib.logger.__message_prefix
    stdlib.string.colour "${STDLIB_THEME_LOGGER_WARNING}" "${1}"
  } >&2 # KCOV_EXCLUDE_LINE
}

# @description Prints an info message to stdout.
# @arg $1 The message to print.
# @option STDLIB_THEME_LOGGER_INFO The colour to use for the message.
# @exitcode 0 If the message was printed successfully.
# @stdout The info message.
stdlib.logger.info() {
  stdlib.logger.__message_prefix
  stdlib.string.colour "${STDLIB_THEME_LOGGER_INFO}" "${1}"
}

# @description Prints a notice message to stdout.
# @arg $1 The message to print.
# @option STDLIB_THEME_LOGGER_NOTICE The colour to use for the message.
# @exitcode 0 If the message was printed successfully.
# @stdout The notice message.
stdlib.logger.notice() {
  stdlib.logger.__message_prefix
  stdlib.string.colour "${STDLIB_THEME_LOGGER_NOTICE}" "${1}"
}

# @description Prints a success message to stdout.
# @arg $1 The message to print.
# @option STDLIB_THEME_LOGGER_SUCCESS The colour to use for the message.
# @exitcode 0 If the message was printed successfully.
# @stdout The success message.
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
