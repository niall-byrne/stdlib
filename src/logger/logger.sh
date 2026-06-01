#!/bin/bash

# stdlib logger library

builtin set -eo pipefail

STDLIB_LOGGING_MESSAGE_PREFIX=""
__STDLIB_LOGGING_DECORATORS_ARRAY=("_testing.__protected")

# @description Logs an error message.
#   * STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="${FUNCNAME[2]}").
#   * STDLIB_THEME_LOGGER_ERROR string global: The colour to use for the message (default="LIGHT_RED").
# @arg $1 string The message to log.
# @exitcode 0 If the operation succeeded.
# @stderr The error message.
stdlib.logger.error() {
  {
    stdlib.logger.__message_prefix                             # defaults STDLIB_LOGGING_MESSAGE_PREFIX
    stdlib.string.colour "${STDLIB_THEME_LOGGER_ERROR}" "${1}" # validates STDLIB_THEME_LOGGER_ERROR
  } >&2                                                        # KCOV_EXCLUDE_LINE
}

# @description A derivative of stdlib.logger.error that can read from stdin.
# @arg $1 string (optional, default="-") The message to log, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @stdin The message to log.
# @stderr The error message.
stdlib.logger.error_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.logger.error" "1"

# @description Logs an informational message.
#   * STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="${FUNCNAME[2]}").
#   * STDLIB_THEME_LOGGER_INFO string global: The colour to use for the message (default="WHITE").
# @arg $1 string The message to log.
# @exitcode 0 If the operation succeeded.
# @stdout The informational message.
stdlib.logger.info() {
  stdlib.logger.__message_prefix                            # defaults STDLIB_LOGGING_MESSAGE_PREFIX
  stdlib.string.colour "${STDLIB_THEME_LOGGER_INFO}" "${1}" # validates STDLIB_THEME_LOGGER_INFO
}

# @description A derivative of stdlib.logger.info that can read from stdin.
# @arg $1 string (optional, default="-") The message to log, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @stdin The message to log.
# @stdout The informational message.
stdlib.logger.info_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.logger.info" "1"

# @description Logs a notice message.
#   * STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="${FUNCNAME[2]}").
#   * STDLIB_THEME_LOGGER_NOTICE string global: The colour to use for the message (default="GREY").
# @arg $1 string The message to log.
# @exitcode 0 If the operation succeeded.
# @stdout The notice message.
stdlib.logger.notice() {
  stdlib.logger.__message_prefix                              # defaults STDLIB_LOGGING_MESSAGE_PREFIX
  stdlib.string.colour "${STDLIB_THEME_LOGGER_NOTICE}" "${1}" # validates STDLIB_THEME_LOGGER_NOTICE
}

# @description A derivative of stdlib.logger.notice that can read from stdin.
# @arg $1 string (optional, default="-") The message to log, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @stdin The message to log.
# @stdout The notice message.
stdlib.logger.notice_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.logger.notice" "1"

# @description Logs a success message.
#   * STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="${FUNCNAME[2]}").
#   * STDLIB_THEME_LOGGER_SUCCESS string global: The colour to use for the message (default="GREEN").
# @arg $1 string The message to log.
# @exitcode 0 If the operation succeeded.
# @stdout The success message.
stdlib.logger.success() {
  stdlib.logger.__message_prefix                               # defaults STDLIB_LOGGING_MESSAGE_PREFIX
  stdlib.string.colour "${STDLIB_THEME_LOGGER_SUCCESS}" "${1}" # validates STDLIB_THEME_LOGGER_SUCCESS
}

# @description A derivative of stdlib.logger.success that can read from stdin.
# @arg $1 string (optional, default="-") The message to log, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @stdin The message to log.
# @stdout The success message.
stdlib.logger.success_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.logger.success" "1"

# @description Prints a traceback of the current function calls.
# @noargs
# @exitcode 0 If the operation succeeded.
# @stdout The traceback information.
stdlib.logger.traceback() {
  builtin local fn_name_index
  builtin local fn_name_indent=">"

  stdlib.__message.get TRACEBACK_HEADER
  builtin echo

  for ((fn_name_index = ("${#FUNCNAME[@]}" - 1); fn_name_index > 1; fn_name_index--)); do
    builtin echo "${fn_name_indent}  ${BASH_SOURCE["${fn_name_index}"]}:${BASH_LINENO[$(("${fn_name_index}" - 1))]}:${FUNCNAME["${fn_name_index}"]}()"
    fn_name_indent+=">"
  done
}

# @description Logs a warning message.
#   * STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="${FUNCNAME[2]}").
#   * STDLIB_THEME_LOGGER_WARNING string global: The colour to use for the message (default="YELLOW").
# @arg $1 string The message to log.
# @exitcode 0 If the operation succeeded.
# @stderr The warning message.
stdlib.logger.warning() {
  {
    stdlib.logger.__message_prefix                               # defaults STDLIB_LOGGING_MESSAGE_PREFIX
    stdlib.string.colour "${STDLIB_THEME_LOGGER_WARNING}" "${1}" # validates STDLIB_THEME_LOGGER_WARNING
  } >&2                                                          # KCOV_EXCLUDE_LINE
}

# @description A derivative of stdlib.logger.warning that can read from stdin.
# @arg $1 string (optional, default="-") The message to log, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @stdin The message to log.
# @stderr The warning message.
stdlib.logger.warning_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.logger.warning" "1"

# @description Prints the message prefix for logging.
#   * STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="${FUNCNAME[3]}").
#   * __STDLIB_LOGGING_DECORATORS_ARRAY array global: An array containing known decorating functions used to preserve the original calling function's name (default=notated at top of file).
# @noargs
# @exitcode 0 If the operation succeeded.
# @stdout The message prefix.
# @internal
stdlib.logger.__message_prefix() {
  builtin local message_prefix="${STDLIB_LOGGING_MESSAGE_PREFIX:-${FUNCNAME[3]}}" # defaults STDLIB_LOGGING_MESSAGE_PREFIX

  if stdlib.array.query.is_contains "${message_prefix}" __STDLIB_LOGGING_DECORATORS_ARRAY; then # validates __STDLIB_LOGGING_DECORATORS_ARRAY
    message_prefix="${FUNCNAME[4]}"
  fi

  builtin echo -n "${message_prefix}: "
}
