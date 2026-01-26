#!/bin/bash

setup() {
  _mock.create stdlib.trap.create.cleanup_fn
  _mock.create stdlib.trap.create.handler

  _mock.create stdlib.trap.handler.exit.fn.register
  _mock.create stdlib.trap.handler.err.fn.register
}

@parametrize_with_traceback_setting() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_TRACEBACK_VALUE" \
    "traceback_enabled_;0" \
    "traceback_disabled;0"
}

@parametrize_with_handlers() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_HANDLER_NAME;TEST_HANDLER_ARRAY" \
    "creates_err_handler_;stdlib.trap.handler.err.fn;STDLIB_HANDLER_ERR_FN_ARRAY" \
    "creates_exit_handler;stdlib.trap.handler.exit.fn;STDLIB_HANDLER_EXIT_FN_ARRAY"
}

test_stdlib_trap_register_default_handlers__@vary__creates_cleanup_fn() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN="${TEST_TRACEBACK_VALUE}" \
    stdlib.trap.__register_default_handlers

  stdlib.trap.create.cleanup_fn.mock.assert_called_once_with \
    "1(stdlib.trap.fn.cleanup_on_exit) 2(STDLIB_CLEANUP_FN_TARGETS_ARRAY)"
}

@parametrize_with_traceback_setting \
  test_stdlib_trap_register_default_handlers__@vary__creates_cleanup_fn

test_stdlib_trap_register_default_handlers__@vary__@vary() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN="${TEST_TRACEBACK_VALUE}" \
    stdlib.trap.__register_default_handlers

  stdlib.trap.create.handler.mock.assert_count_is 2
  stdlib.trap.create.handler.mock.assert_any_call_is \
    "1(${TEST_HANDLER_NAME}) 2(${TEST_HANDLER_ARRAY})"
}

@parametrize.compose \
  test_stdlib_trap_register_default_handlers__@vary__@vary \
  @parametrize_with_traceback_setting \
  @parametrize_with_handlers

test_stdlib_trap_register_default_handlers__@vary__registers_cleanup_fn() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN="${TEST_TRACEBACK_VALUE}" \
    stdlib.trap.__register_default_handlers

  stdlib.trap.handler.exit.fn.register.mock.assert_called_once_with \
    "1(stdlib.trap.fn.cleanup_on_exit)"
}

@parametrize_with_traceback_setting \
  test_stdlib_trap_register_default_handlers__@vary__registers_cleanup_fn

test_stdlib_trap_register_default_handlers__traceback_disabled__stdlib_logger_traceback_is_not_registered() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN="1" \
    stdlib.trap.__register_default_handlers

  stdlib.trap.handler.err.fn.register.mock.assert_not_called
}

test_stdlib_trap_register_default_handlers__traceback_disabled__stdlib_logger_traceback_is_registered() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN="0" \
    stdlib.trap.__register_default_handlers

  stdlib.trap.handler.err.fn.register.mock.assert_called_once_with \
    "1(stdlib.logger.traceback)"
}
