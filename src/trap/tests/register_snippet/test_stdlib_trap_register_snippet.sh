#!/bin/bash

# shellcheck disable=SC2034
setup() {
  _mock.create stdlib.trap.__register_default_handlers
  _mock.create trap

  __STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN=1
}

teardown() {
  unset __STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN
}

@parametrize_with_array_name() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARRAY_NAME" \
    "stdlib_handler_err_fn_array____;STDLIB_HANDLER_ERR_FN_ARRAY" \
    "stdlib_handler_exit_fn_array___;STDLIB_HANDLER_EXIT_FN_ARRAY" \
    "stdlib_cleanup_fn_targets_array;STDLIB_CLEANUP_FN_TARGETS_ARRAY"
}

test_stdlib_trap_register_snippet__sourced__handler_creator_called() {
  _testing.load "${STDLIB_DIRECTORY}/trap/register.snippet" > /dev/null

  stdlib.trap.__register_default_handlers.mock.assert_called_once_with ""
}

test_stdlib_trap_register_snippet__sourced__@vary__is_initialized_as_array() {
  _testing.load "${STDLIB_DIRECTORY}/trap/register.snippet" > /dev/null

  assert_is_array "${TEST_ARRAY_NAME}"
}

@parametrize_with_array_name \
  test_stdlib_trap_register_snippet__sourced__@vary__is_initialized_as_array

test_stdlib_trap_register_snippet__sourced__handler_creator_called___________success__traps_registered() {
  stdlib.trap.__register_default_handlers.mock.set.rc 0

  _testing.load "${STDLIB_DIRECTORY}/trap/register.snippet" > /dev/null

  trap.mock.assert_calls_are \
    "1(stdlib.trap.handler.err.fn) 2(ERR)" \
    "1(stdlib.trap.handler.exit.fn) 2(EXIT)"
}

test_stdlib_trap_register_snippet__sourced__handler_creator_called___________failure__traps_not_registered() {
  stdlib.trap.__register_default_handlers.mock.set.rc 1

  _testing.load "${STDLIB_DIRECTORY}/trap/register.snippet" > /dev/null 2>&1 || /bin/true

  trap.mock.assert_not_called
}
