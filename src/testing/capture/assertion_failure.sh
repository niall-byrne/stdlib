#!/bin/bash

# stdlib testing assertion capture library

builtin set -eo pipefail

STDLIB_TESTING_TRACEBACK_REGEX="${STDLIB_TESTING_TRACEBACK_REGEX:-$'^([^:]+:[0-9]+|environment:[0-9]+):.+$'}"

# @description Captures the output of a failed assertion.
#     STDLIB_TESTING_TRACEBACK_REGEX: The regex to use for stripping traceback info.
# @arg $@ array The assertion command to execute and its arguments.
# @exitcode 0 If the operation succeeded.
# @set TEST_OUTPUT string The captured assertion failure message.
_capture.assertion_failure() {
  builtin local output
  builtin local rc

  builtin set +e
  LC_ALL=C IFS= builtin read -rd '' output < <("$@" 2>&1)
  builtin set -e

  builtin wait "$!"
  rc="$?"

  if [[ ${rc} -eq 0 ]]; then
    fail " $(_testing.assert.__message.get ASSERT_ERROR_DID_NOT_FAIL "${1}")"
  fi

  # shellcheck disable=SC2034
  TEST_OUTPUT="$(
    # KCOV_EXCLUDE_BEGIN
    builtin echo "${output}" | # noqa
      "${_STDLIB_BINARY_SED}" -E '/^FAILURE/d' |
      "${_STDLIB_BINARY_SED}" -E "/${STDLIB_TESTING_TRACEBACK_REGEX}/d"
    # KCOV_EXCLUDE_END
  )"
}
