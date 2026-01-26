#!/bin/bash

# stdlib trap handler create library

builtin set -eo pipefail

STDLIB_TRACEBACK_DISABLE_BOOLEAN="${STDLIB_TRACEBACK_DISABLE_BOOLEAN:-1}"

# shellcheck disable=SC2034
STDLIB_HANDLER_ERR=()
# shellcheck disable=SC2034
STDLIB_HANDLER_EXIT=()
# shellcheck disable=SC2034
STDLIB_CLEANUP_FN=()

# @description Creates the default trap handlers for stdlib.
#   * STDLIB_CLEANUP_FN: An array used to store file names targeted by the clean_up_on_exit function (default=()).
#   * STDLIB_HANDLER_ERR: An array used to store error handler functions (default=()).
#   * STDLIB_HANDLER_EXIT: An array used to store exit handler functions (default=()).
#   * STDLIB_TRACEBACK_DISABLE_BOOLEAN: Disables the default traceback logger on errors (default=1).
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
stdlib.trap.__register_default_handlers() {
  stdlib.trap.create.handler "stdlib.trap.handler.err.fn" STDLIB_HANDLER_ERR
  stdlib.trap.create.handler "stdlib.trap.handler.exit.fn" STDLIB_HANDLER_EXIT
  stdlib.trap.create.clean_up_fn "stdlib.trap.fn.clean_up_on_exit" STDLIB_CLEANUP_FN

  stdlib.trap.handler.exit.fn.register "stdlib.trap.fn.clean_up_on_exit"
  if [[ "${STDLIB_TRACEBACK_DISABLE_BOOLEAN}" -eq "0" ]]; then
    stdlib.trap.handler.err.fn.register stdlib.logger.traceback
  fi
}
