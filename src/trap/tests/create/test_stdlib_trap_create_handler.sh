#!/bin/bash

# shellcheck disable=SC2034
setup() {
  TEST_ARRAY=()
  NOT_AN_ARRAY="not an array"

  _mock.create stdlib.logger.error
  _mock.create _fn1
  _mock.create _fn2
}

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args__________returns_status_code_127;;127" \
    "name_is_null_____returns_status_code_126;|TEST_ARRAY;126" \
    "array_is_string__returns_status_code_126;handler_name|NOT_AN_ARRAY;126" \
    "extra_arg________returns_status_code_127;handler_name|TEST_ARRAY|extra_arg;127" \
    "valid_args_______returns_status_code___0;handler_name|TEST_ARRAY;0"
}

@parametrize_with_handler_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "valid_args________returns_status_code___0;;0" \
    "extra_arg_________returns_status_code_127;extra_arg;127"
}

@parametrize_with_register_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args___________returns_status_code_127;;127" \
    "not_a_fn__________returns_status_code_126;not_a_fn;126" \
    "extra_arg_________returns_status_code_127;_fn1|extra_arg;127" \
    "valid_args________returns_status_code___0;_fn1;0"
}

test_stdlib_trap_create_handler__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.trap.create.handler "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_trap_create_handler__@vary

# shellcheck disable=SC2034
test_stdlib_trap_create_handler__valid_args_______creates_handler_function() {
  stdlib.trap.create.handler test_handler TEST_ARRAY

  assert_is_fn test_handler
}

test_stdlib_trap_create_handler__valid_args_______creates_register_function() {
  stdlib.trap.create.handler test_handler TEST_ARRAY

  assert_is_fn test_handler.register
}

# shellcheck disable=SC2034
test_stdlib_trap_create_handler__valid_args_______handler_function___________valid_args________calls_each_fn_in_array() {
  stdlib.trap.create.handler test_handler TEST_ARRAY

  TEST_ARRAY+=("_fn1")
  TEST_ARRAY+=("_fn2")

  test_handler

  _fn1.mock.assert_called_once_with ""
  _fn2.mock.assert_called_once_with ""
}

test_stdlib_trap_create_handler__valid_args_______handler_function___________@vary() {
  local args=()

  stdlib.trap.create.handler test_handler TEST_ARRAY
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc test_handler "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_handler_arg_combos \
  test_stdlib_trap_create_handler__valid_args_______handler_function___________@vary

# shellcheck disable=SC2034
test_stdlib_trap_create_handler__valid_args_______handler_function___________array_overwitten__returns_status_code_126() {
  stdlib.trap.create.handler test_handler TEST_ARRAY

  # shellcheck disable=SC2178
  declare TEST_ARRAY="no longer an array"

  _capture.rc test_handler

  assert_rc "126"
}

# shellcheck disable=SC2034
test_stdlib_trap_create_handler__valid_args_______handler_function___________array_overwitten__logs_an_error_message() {
  stdlib.trap.create.handler test_handler TEST_ARRAY

  # shellcheck disable=SC2178
  declare TEST_ARRAY="no longer an array"

  test_handler

  stdlib.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get IS_NOT_ARRAY TEST_ARRAY))" \
    "1($(stdlib.__message.get VAR_VALUE_INVALID_RESERVED_DETAIL TEST_ARRAY))"
}

test_stdlib_trap_create_handler__valid_args_______register_function__________@vary() {
  local args=()

  stdlib.trap.create.handler test_handler TEST_ARRAY
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc test_handler.register "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_register_arg_combos \
  test_stdlib_trap_create_handler__valid_args_______register_function__________@vary

test_stdlib_trap_create_handler__valid_args_______register_function__________array_overwitten__returns_status_code_126() {
  local args=()

  stdlib.trap.create.handler test_handler TEST_ARRAY
  # shellcheck disable=SC2178
  declare TEST_ARRAY="overwritten with string"

  _capture.rc test_handler.register _fn1

  assert_rc "126"
}

test_stdlib_trap_create_handler__valid_args_______register_function__________array_overwitten__logs_an_error_message() {
  local args=()

  stdlib.trap.create.handler test_handler TEST_ARRAY
  # shellcheck disable=SC2178
  declare TEST_ARRAY="overwritten with string"

  test_handler.register _fn1

  stdlib.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get IS_NOT_ARRAY TEST_ARRAY))" \
    "1($(stdlib.__message.get VAR_VALUE_INVALID_RESERVED_DETAIL TEST_ARRAY))"
}

# shellcheck disable=SC2034
test_stdlib_trap_create_handler__valid_args_______register_function__________valid_args________adds_functions_to_array() {
  local test_expected_handlers=("_fn1" "_fn2")

  stdlib.trap.create.handler test_handler TEST_ARRAY

  test_handler.register _fn1
  test_handler.register _fn2

  assert_array_equals TEST_ARRAY test_expected_handlers
}
