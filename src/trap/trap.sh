#!/bin/bash

# stdlib trap handler create library

builtin set -eo pipefail

STDLIB_TRACEBACK_DISABLE_BOOLEAN="${STDLIB_TRACEBACK_DISABLE_BOOLEAN:-1}"

# shellcheck disable=SC2034
STDLIB_HANDLER_ERR_FN_ARRAY=()
# shellcheck disable=SC2034
STDLIB_HANDLER_EXIT_FN_ARRAY=()
# shellcheck disable=SC2034
STDLIB_CLEANUP_FN_TARGETS_ARRAY=()

# @description A handler function that removes files when called (by default this handler is registered to the exit signal).
#   * STDLIB_CLEANUP_FN_TARGETS_ARRAY: An array used to store file names targeted by the clean_up_on_exit function (default=()).
# @noargs
# @exitcode 0 If the operation succeeded.
stdlib.trap.fn.clean_up_on_exit() { :; }

# @description A handler function that is invoked on an error trap.
#   * STDLIB_HANDLER_ERR_FN_ARRAY: An array containing a list of functions that are run on error (default=()).
# @noargs
# @exitcode 0 If the operation succeeded.
stdlib.trap.handler.err.fn() { :; }

# @description Adds a function to the error handler, which will be invoked (without args) during an error.
# @noargs
# @exitcode 0 If the operation succeeded.
# @set STDLIB_HANDLER_ERR_FN_ARRAY array An array containing a list of functions that are run on error.
stdlib.trap.handler.err.fn.register() { :; }

# @description A handler function that is invoked on an exit trap.
#   * STDLIB_HANDLER_EXIT_FN_ARRAY: An array containing a list of functions that are run on an exit call (default=("stdlib.trap.fn.clean_up_on_exit")).
# @noargs
# @exitcode 0 If the operation succeeded.
stdlib.trap.handler.exit.fn() { :; }

# @description Adds a function to the exit handler, which will be invoked (without args) during an exit call.
# @noargs
# @exitcode 0 If the operation succeeded.
# @set STDLIB_HANDLER_EXIT_FN_ARRAY array An array containing a list of functions that are run on an exit call.
stdlib.trap.handler.exit.fn.register() { :; }

# @description Creates the default trap handlers for stdlib.
#   * STDLIB_CLEANUP_FN_TARGETS_ARRAY: An array used to store file names targeted by the clean_up_on_exit function (default=()).
#   * STDLIB_HANDLER_ERR_FN_ARRAY: An array used to store error handler functions (default=()).
#   * STDLIB_HANDLER_EXIT_FN_ARRAY: An array used to store exit handler functions (default=()).
#   * STDLIB_TRACEBACK_DISABLE_BOOLEAN: Disables the default traceback logger on errors (default=1).
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
stdlib.trap.__register_default_handlers() {
  stdlib.trap.create.handler "stdlib.trap.handler.err.fn" STDLIB_HANDLER_ERR_FN_ARRAY
  stdlib.trap.create.handler "stdlib.trap.handler.exit.fn" STDLIB_HANDLER_EXIT_FN_ARRAY
  stdlib.trap.create.clean_up_fn "stdlib.trap.fn.clean_up_on_exit" STDLIB_CLEANUP_FN_TARGETS_ARRAY

  stdlib.trap.handler.exit.fn.register "stdlib.trap.fn.clean_up_on_exit"
  if [[ "${STDLIB_TRACEBACK_DISABLE_BOOLEAN}" -eq "0" ]]; then
    stdlib.trap.handler.err.fn.register stdlib.logger.traceback
  fi
}
