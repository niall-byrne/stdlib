#!/bin/bash

setup() {
  _mock.create stdlib.trap.handler.err.fn.register
  _mock.create stdlib.trap.handler.exit.fn.register
  _mock.create trap
}

test_stdlib_trap_register_snippet___traceback_enabled___sourced__clean_up_fn_registered() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN=0 _testing.load "${STDLIB_DIRECTORY}/trap/register.snippet" > /dev/null

  stdlib.trap.handler.exit.fn.register.mock.assert_called_once_with "1(stdlib.trap.fn.clean_up_on_exit)"
}

test_stdlib_trap_register_snippet___traceback_enabled___sourced__stdlib_logger_traceback_is_registered() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN=0 _testing.load "${STDLIB_DIRECTORY}/trap/register.snippet" > /dev/null

  stdlib.trap.handler.err.fn.register.mock.assert_called_once_with "1(stdlib.logger.traceback)"
}

test_stdlib_trap_register_snippet___traceback_enabled___sourced__traps_registered() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN=0 _testing.load "${STDLIB_DIRECTORY}/trap/register.snippet" > /dev/null

  trap.mock.assert_calls_are \
    "1(stdlib.trap.handler.err.fn) 2(ERR)" \
    "1(stdlib.trap.handler.exit.fn) 2(EXIT)"
}

test_stdlib_trap_register_snippet___traceback_disabled__sourced__clean_up_fn_registered() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN=1 _testing.load "${STDLIB_DIRECTORY}/trap/register.snippet" > /dev/null

  stdlib.trap.handler.exit.fn.register.mock.assert_called_once_with "1(stdlib.trap.fn.clean_up_on_exit)"
}

test_stdlib_trap_register_snippet___traceback_disabled__sourced__stdlib_logger_traceback_is_not_registered() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN=1 _testing.load "${STDLIB_DIRECTORY}/trap/register.snippet" > /dev/null

  stdlib.trap.handler.err.fn.register.mock.assert_not_called
}

test_stdlib_trap_register_snippet___traceback_disabled__sourced__traps_registered() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN=1 _testing.load "${STDLIB_DIRECTORY}/trap/register.snippet" > /dev/null

  trap.mock.assert_calls_are \
    "1(stdlib.trap.handler.err.fn) 2(ERR)" \
    "1(stdlib.trap.handler.exit.fn) 2(EXIT)"
}
