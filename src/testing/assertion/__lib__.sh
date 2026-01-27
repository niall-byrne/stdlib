#!/bin/bash

# stdlib testing assertion library

builtin set -eo pipefail

# shellcheck source=src/testing/assertion/array.sh
builtin source "${STDLIB_DIRECTORY}/testing/assertion/array.sh"
# shellcheck source=src/testing/assertion/fn.sh
builtin source "${STDLIB_DIRECTORY}/testing/assertion/fn.sh"
# shellcheck source=src/testing/assertion/message.sh
builtin source "${STDLIB_DIRECTORY}/testing/assertion/message.sh"
# shellcheck source=src/testing/assertion/null.sh
builtin source "${STDLIB_DIRECTORY}/testing/assertion/null.sh"
# shellcheck source=src/testing/assertion/output.sh
builtin source "${STDLIB_DIRECTORY}/testing/assertion/output.sh"
# shellcheck source=src/testing/assertion/rc.sh
builtin source "${STDLIB_DIRECTORY}/testing/assertion/rc.sh"
# shellcheck source=src/testing/assertion/snapshot.sh
builtin source "${STDLIB_DIRECTORY}/testing/assertion/snapshot.sh"

# @description Checks if a value is provided for an assertion.
# @arg $1 string The variable value to check.
# @exitcode 0 If the operation succeeded.
# @stderr The error message if the assertion fails.
# @internal
_testing.__assertion.value.check() {
  builtin local value_name="${1}"
  builtin local assertion_name="${FUNCNAME[1]}"

  if [[ -z "${value_name}" ]]; then
    fail " '${assertion_name}' $(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
  fi
}
