#!/bin/bash

setup() {
  _mock.create mktemp
  _mock.create stdlib.logger.error
  _mock.create stdlib.io.lock.__workspace_is_valid
  _mock.create stdlib.io.path.query.is_folder

  mktemp.mock.set.stdout "temp_folder"
}

@parametrize_with_args_and_status_codes() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args____________returns_status_code___0;;0" \
    "extra_arg__________returns_status_code_127;extra_arg;127"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__allocated_workspace_____@vary() {
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKTEMP="mktemp"
  local args=()

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.io.lock.workspace_allocate "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_io_lock_workspace_allocate__allocated_workspace_____@vary

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__allocated_workspace_____valid_args_________validates_workspace() {
  local STDLIB_LOCK_WORKSPACE="existing_value"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0

  stdlib.io.lock.workspace_allocate

  stdlib.io.lock.__workspace_is_valid.mock.assert_calls_are \
    "1(existing_value)"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__allocated_workspace_____valid_args_________does_not_call_mktemp() {
  local STDLIB_LOCK_WORKSPACE="existing_value"
  local _STDLIB_BINARY_MKTEMP="mktemp"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0

  stdlib.io.lock.workspace_allocate

  mktemp.mock.assert_not_called
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__allocated_workspace_____valid_args_________does_not_register_cleanup_function() {
  local STDLIB_HANDLER_EXIT_FN_ARRAY=()
  local STDLIB_LOCK_WORKSPACE="existing_value"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0

  stdlib.io.lock.workspace_allocate

  assert_array_length 0 STDLIB_HANDLER_EXIT_FN_ARRAY
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__@vary() {
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKTEMP="mktemp"
  local args=()

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1
  stdlib.io.path.query.is_folder.mock.set.rc 0
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.io.lock.workspace_allocate "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__@vary

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__invalid_workspace__returns_status_code_123() {
  local STDLIB_LOCK_WORKSPACE="invalid_workspace"
  local _STDLIB_BINARY_MKTEMP="mktemp"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1
  stdlib.io.path.query.is_folder.mock.set.rc 0

  _capture.rc stdlib.io.lock.workspace_allocate

  assert_rc "123"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__invalid_workspace__logs_an_error_message() {
  local STDLIB_LOCK_WORKSPACE="invalid_workspace"
  local _STDLIB_BINARY_MKTEMP="mktemp"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1
  stdlib.io.path.query.is_folder.mock.set.rc 0

  stdlib.io.lock.workspace_allocate

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get VAR_VALUE_INVALID_RESERVED_DETAIL STDLIB_LOCK_WORKSPACE))"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__invalid_workspace__validates_workspace() {
  local STDLIB_LOCK_WORKSPACE="invalid_workspace"
  local _STDLIB_BINARY_MKTEMP="mktemp"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1
  stdlib.io.path.query.is_folder.mock.set.rc 0

  stdlib.io.lock.workspace_allocate

  stdlib.io.lock.__workspace_is_valid.mock.assert_calls_are \
    "1(invalid_workspace)"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__invalid_workspace__does_not_call_mktemp() {
  local STDLIB_LOCK_WORKSPACE="invalid_workspace"
  local _STDLIB_BINARY_MKTEMP="mktemp"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1
  stdlib.io.path.query.is_folder.mock.set.rc 0

  stdlib.io.lock.workspace_allocate

  mktemp.mock.assert_not_called
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__valid_args_________validates_workspace() {
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKTEMP="mktemp"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1
  stdlib.io.path.query.is_folder.mock.set.rc 0

  stdlib.io.lock.workspace_allocate

  stdlib.io.lock.__workspace_is_valid.mock.assert_calls_are \
    "1()"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__valid_args_________confirms_workspace_creation() {
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKTEMP="mktemp"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1
  stdlib.io.path.query.is_folder.mock.set.rc 0

  stdlib.io.lock.workspace_allocate

  stdlib.io.path.query.is_folder.mock.assert_calls_are \
    "1(temp_folder)"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__valid_args_________calls_mktemp_as_expected() {
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKTEMP="mktemp"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1
  stdlib.io.path.query.is_folder.mock.set.rc 0

  stdlib.io.lock.workspace_allocate

  mktemp.mock.assert_called_once_with "1(-d)"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__valid_args_________success_creating_temp_______________returns_status_code___0() {
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKTEMP="mktemp"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1
  stdlib.io.path.query.is_folder.mock.set.rc 0

  _capture.rc stdlib.io.lock.workspace_allocate

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__valid_args_________success_creating_temp_______________does_not_log_error_message() {
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKTEMP="mktemp"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1
  stdlib.io.path.query.is_folder.mock.set.rc 0

  stdlib.io.lock.workspace_allocate

  stdlib.logger.error.mock.assert_not_called
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__valid_args_________success_creating_temp_______________registers_cleanup_function() {
  local STDLIB_HANDLER_EXIT_FN_ARRAY=()
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKTEMP="mktemp"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1
  stdlib.io.path.query.is_folder.mock.set.rc 0

  stdlib.io.lock.workspace_allocate

  assert_is_array_containing \
    "stdlib.io.lock.__workspace_cleanup" \
    STDLIB_HANDLER_EXIT_FN_ARRAY
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__valid_args_________fails_to_creates_temp_______________returns_status_code__1() {
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKTEMP="mktemp"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1
  stdlib.io.path.query.is_folder.mock.set.rc 1
  mktemp.mock.set.rc 0

  _capture.rc stdlib.io.lock.workspace_allocate

  assert_rc "1"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__valid_args_________fails_to_creates_temp_______________logs_error_message() {
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKTEMP="mktemp"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1
  stdlib.io.path.query.is_folder.mock.set.rc 1
  mktemp.mock.set.rc 0

  stdlib.io.lock.workspace_allocate

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get LOCK_WORKSPACE_COULD_NOT_BE_ALLOCATED))"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__valid_args_________fails_to_creates_temp_______________does_not_register_cleanup_function() {
  local STDLIB_HANDLER_EXIT_FN_ARRAY=()
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKTEMP="mktemp"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1
  stdlib.io.path.query.is_folder.mock.set.rc 1
  mktemp.mock.set.rc 0

  stdlib.io.lock.workspace_allocate

  assert_array_length 0 STDLIB_HANDLER_EXIT_FN_ARRAY
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__valid_args_________error_creating_temp_________________returns_status_code__1() {
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKTEMP="mktemp"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1
  stdlib.io.path.query.is_folder.mock.set.rc 1
  mktemp.mock.set.rc 1

  _capture.rc stdlib.io.lock.workspace_allocate

  assert_rc "1"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__valid_args_________error_creating_temp_________________logs_error_message() {
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKTEMP="mktemp"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1
  stdlib.io.path.query.is_folder.mock.set.rc 1
  mktemp.mock.set.rc 1

  stdlib.io.lock.workspace_allocate

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get LOCK_WORKSPACE_COULD_NOT_BE_ALLOCATED))"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__valid_args_________error_creating_temp_________________does_not_register_cleanup_function() {
  local STDLIB_HANDLER_EXIT_FN_ARRAY=()
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKTEMP="mktemp"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1
  stdlib.io.path.query.is_folder.mock.set.rc 1
  mktemp.mock.set.rc 1

  stdlib.io.lock.workspace_allocate

  assert_array_length 0 STDLIB_HANDLER_EXIT_FN_ARRAY
}
