#!/bin/bash

# stdlib trap handler create library

builtin set -eo pipefail

# @description A handler function that removes files when called (by default this handler is registered to the exit signal).
#   * STDLIB_CLEANUP_FN_TARGETS_ARRAY array global: An array containing a list of file names targeted by the cleanup_on_exit function (default=()).
# @noargs
# @exitcode 0 If the operation succeeded.
stdlib.trap.fn.cleanup_on_exit() { :; } # validates STDLIB_CLEANUP_FN_TARGETS_ARRAY

# @description A handler function that is invoked on an error trap.
#   * STDLIB_HANDLER_ERR_FN_ARRAY array global: An array containing a list of functions that are run on an error (default=()).
# @noargs
# @exitcode 0 If the operation succeeded.
stdlib.trap.handler.err.fn() { :; } # validates STDLIB_HANDLER_ERR_FN_ARRAY

# @description Adds a function to the error handler, which will be invoked (without args) during an error.
# @arg $1 string The name of the function to register.
# @exitcode 0 If the operation succeeded.
# @set STDLIB_HANDLER_ERR_FN_ARRAY array An array containing a list of functions that are run on an error.
stdlib.trap.handler.err.fn.register() { :; }

# @description A handler function that is invoked on an exit trap.
#   * STDLIB_HANDLER_EXIT_FN_ARRAY array global: An array containing a list of functions that are run on an exit call (default=("stdlib.trap.fn.cleanup_on_exit")).
# @noargs
# @exitcode 0 If the operation succeeded.
stdlib.trap.handler.exit.fn() { :; } # validates STDLIB_HANDLER_EXIT_FN_ARRAY

# @description Adds a function to the exit handler, which will be invoked (without args) during an exit call.
# @arg $1 string The name of the function to register.
# @exitcode 0 If the operation succeeded.
# @set STDLIB_HANDLER_EXIT_FN_ARRAY array An array containing a list of functions that are run on an exit call.
stdlib.trap.handler.exit.fn.register() { :; }

# @description Creates the default trap handlers for stdlib.
#   * STDLIB_CLEANUP_FN_TARGETS_ARRAY array global: An array containing a list of file names targeted by the cleanup_on_exit function (default=()).
#   * STDLIB_HANDLER_ERR_FN_ARRAY array global: An array containing a list of functions that are run on an error (default=()).
#   * STDLIB_HANDLER_EXIT_FN_ARRAY array global: An array containing a list of functions that are run on an exit call (default=()).
#   * STDLIB_TRACEBACK_DISABLE_BOOLEAN array global: Disables the default traceback logger on errors (default=1).
# @noargs
# @exitcode 0 If the operation succeeded.
# @exitcode 123 If a variable reserved for use by the BASH stdlib has been assigned an invalid value.
# @internal
stdlib.trap.__register_default_handlers() {
  stdlib.var.global.assert.is_valid_with stdlib.array.assert.is_array STDLIB_CLEANUP_FN_TARGETS_ARRAY name || builtin return 123 # validates STDLIB_CLEANUP_FN_TARGETS_ARRAY
  stdlib.var.global.assert.is_valid_with stdlib.array.assert.is_array STDLIB_HANDLER_ERR_FN_ARRAY name || builtin return 123     # validates STDLIB_HANDLER_ERR_FN_ARRAY
  stdlib.var.global.assert.is_valid_with stdlib.array.assert.is_array STDLIB_HANDLER_EXIT_FN_ARRAY name || builtin return 123    # validates STDLIB_HANDLER_EXIT_FN_ARRAY
  stdlib.var.global.assert.is_valid_with stdlib.string.assert.is_boolean STDLIB_TRACEBACK_DISABLE_BOOLEAN || builtin return 123  # validates STDLIB_TRACEBACK_DISABLE_BOOLEAN

  stdlib.trap.create.handler "stdlib.trap.handler.err.fn" STDLIB_HANDLER_ERR_FN_ARRAY
  stdlib.trap.create.handler "stdlib.trap.handler.exit.fn" STDLIB_HANDLER_EXIT_FN_ARRAY
  stdlib.trap.create.cleanup_fn "stdlib.trap.fn.cleanup_on_exit" STDLIB_CLEANUP_FN_TARGETS_ARRAY

  stdlib.trap.handler.exit.fn.register "stdlib.trap.fn.cleanup_on_exit"
  if [[ "${STDLIB_TRACEBACK_DISABLE_BOOLEAN}" -eq "0" ]]; then
    stdlib.trap.handler.err.fn.register stdlib.logger.traceback
  fi
}
