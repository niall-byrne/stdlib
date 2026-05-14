#!/bin/bash

# stdlib fn derive clone library

builtin set -eo pipefail

# @description Creates an assertion from an existing query function.
# @arg $1 string The name of the query function to derive this assertion from.
# @arg $2 string The message key to display on error, with the passed value as an argument.
# @arg $3 string (optional, default=s/.query./.assert./g) The name of the new assertion function.
# @exitcode 0 If the operation succeeded.
# @exitcode 123 If a variable reserved for use by the BASH stdlib has been assigned an invalid value.
# @exitcode 124 If a global variable has been assigned an invalid value.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
stdlib.fn.derive.assertion() {
  builtin local query_function_name="${1}"
  builtin local message_key="${2}"
  builtin local assertion_function_name="${3:-${query_function_name/.query./.assert.}}"

  stdlib.fn.args.require "2" "1" "${@}" || builtin return "$?"
  stdlib.fn.assert.is_fn "${query_function_name}" || builtin return 126
  stdlib.__message.get "${message_key}" "value" > /dev/null 2>&1 || builtin return 126
  stdlib.fn.assert.is_valid_name "${assertion_function_name}" || builtin return 126

  builtin eval "$(
    # KCOV_EXCLUDE_BEGIN
    "${_STDLIB_BINARY_CAT}" << EOF

${assertion_function_name}() {
  builtin local return_code=0

  "${query_function_name}" "\${@}" || return_code="\$?"

  case "\${return_code}" in
    0) ;;
    123)
      stdlib.logger.error "\$(stdlib.__message.get VAR_VALUE_INVALID_RESERVED)"
      ;;
    124)
      stdlib.logger.error "\$(stdlib.__message.get VAR_VALUE_INVALID_GLOBAL)"
      ;;
    125)
      stdlib.logger.error "\$(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID)"
      ;;
    126 | 127)
      stdlib.logger.error "\$(stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      stdlib.logger.error "\$(stdlib.__message.get "${message_key}" "\${1}")"
      ;;
  esac

  builtin return "\${return_code}"
}

EOF
  )"

}
