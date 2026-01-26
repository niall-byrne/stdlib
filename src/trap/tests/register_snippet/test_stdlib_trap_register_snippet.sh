#!/bin/bash

setup() {
  _mock.create stdlib.trap.__register_default_handlers
  _mock.create trap
}

test_stdlib_trap_register_snippet__sourced__creates_the_default_handlers() {
  _testing.load "${STDLIB_DIRECTORY}/trap/register.snippet" > /dev/null

  stdlib.trap.__register_default_handlers.mock.assert_called_once_with ""
}

test_stdlib_trap_register_snippet__sourced__traps_registered() {
  _testing.load "${STDLIB_DIRECTORY}/trap/register.snippet" > /dev/null

  trap.mock.assert_calls_are \
    "1(stdlib.trap.handler.err.fn) 2(ERR)" \
    "1(stdlib.trap.handler.exit.fn) 2(EXIT)"
}
