#!/bin/bash

# stdlib messages library

builtin set -eo pipefail

# @description Retrieves a message string from the assertion message library.
# @arg $1 string The message key to retrieve.
# @arg $2 string (optional) The first interpolation option.
# @arg $3 string (optional) The second interpolation option.
# @arg $4 string (optional) The third interpolation option.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The retrieved message string.
# @stderr The error message if the assertion fails.
# @internal
_testing.assert.__message.get() {
  builtin local key="${1}"
  builtin local message

  # shellcheck disable=SC2034
  {
    builtin local option1="${2}"
    builtin local option2="${3}"
  }

  builtin local required_options=0
  builtin local return_status=0

  case "${key}" in
    ASSERT_ERROR_DID_NOT_FAIL)
      required_options=1
      message="$(_testing.__gettext "The assertion '\${option1}' was expected to fail, but it succeeded instead.")"
      ;;
    ASSERT_ERROR_FILE_NOT_FOUND)
      required_options=1
      message="$(_testing.__gettext "the file '\${option1}' does not exist")"
      ;;
    ASSERT_ERROR_OUTPUT_NON_MATCHING)
      required_options=0
      message="$(_testing.__gettext "the expected output string was not generated")"
      ;;
    ASSERT_ERROR_OUTPUT_NULL)
      required_options=0
      message="$(_testing.__gettext "the 'TEST_OUTPUT' value is empty, consider using '_capture.output'")"
      ;;
    ASSERT_ERROR_RC_NON_MATCHING)
      required_options=0
      message="$(_testing.__gettext "the expected status code was not returned")"
      ;;
    ASSERT_ERROR_RC_NULL)
      required_options=0
      message="$(_testing.__gettext "the 'TEST_RC' value is empty, consider using '_capture.rc'")"
      ;;
    ASSERT_ERROR_SNAPSHOT_NON_MATCHING)
      required_options=1
      message="$(_testing.__gettext "the contents of '\${option1}' does not match the received output")"
      ;;
    ASSERT_ERROR_VALUE_NOT_NULL)
      required_options=1
      message="$(_testing.__gettext "The value '\${option1}' is not null!")"
      ;;
    ASSERT_ERROR_VALUE_NULL)
      required_options=0
      message="$(_testing.__gettext "The value is null!")"
      ;;
    ASSERT_ERROR_INSUFFICIENT_ARGS)
      required_options=1
      message="$(_testing.__gettext "'\${option1}' was not given sufficient arguments")"
      ;;
    ASSERT_ERROR_ARRAY_LENGTH_NON_MATCHING)
      required_options=2
      message="$(_testing.__gettext "expected [\${option1}] but was [\${option2}]")"
      ;;
    "")
      required_options=0
      return_status=126
      message="$(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
      ;;
    *)
      required_options=0
      return_status=126
      message="$(_testing.__gettext "Unknown message key '${key}'")"
      ;;
  esac

  (("${#@}" == 1 + required_options)) || {
    message="$(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
    return_status=127
  }

  ((return_status == 0)) || {
    _testing.__protected stdlib.logger.error "${message}"
    builtin return ${return_status}
  }

  builtin echo -n "${message}"
}
