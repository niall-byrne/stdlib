#!/bin/bash

setup() {
  _mock.create stdlib.trap.create.clean_up_fn
  _mock.create stdlib.trap.create.handler
}

test_stdlib_trap__sourced__trap_handlers_are_created() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN=0 _testing.load "${STDLIB_DIRECTORY}/trap/trap.sh" > /dev/null

  stdlib.trap.create.handler.mock.assert_calls_are \
    "1(stdlib.trap.handler.err.fn) 2(STDLIB_HANDLER_ERR)" \
    "1(stdlib.trap.handler.exit.fn) 2(STDLIB_HANDLER_EXIT)"
}

test_stdlib_trap__sourced__clean_up_fn_created() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN=0 _testing.load "${STDLIB_DIRECTORY}/trap/trap.sh" > /dev/null

  stdlib.trap.create.clean_up_fn "1(stdlib.trap.fn.clean_up_on_exit) 2(STDLIB_CLEANUP_FN)"
}

test_stdlib_trap__sourced__tracebacks_are_enabled_by_default() {
  local STDLIB_TRACEBACK_DISABLE_BOOLEAN

  _testing.load "${STDLIB_DIRECTORY}/trap/trap.sh" > /dev/null

  assert_equals "1" "${STDLIB_TRACEBACK_DISABLE_BOOLEAN}"
}
