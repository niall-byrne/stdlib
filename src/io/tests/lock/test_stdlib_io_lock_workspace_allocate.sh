#!/bin/bash

setup() {
  _mock.create mktemp
  _mock.create stdlib.logger.error
}

@parametrize_with_args_and_status_codes() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args____________returns_status_code__0;;0" \
    "extra_arg__________returns_status_code_127;extra_arg;127"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__allocated_workspace_____@vary() {
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKTEMP="mktemp"
  local args=()

  mktemp.mock.set.stdout "temp_folder"
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.io.lock.workspace_allocate "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_io_lock_workspace_allocate__allocated_workspace_____@vary

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__@vary() {
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKTEMP="mktemp"
  local args=()

  mktemp.mock.set.stdout "temp_folder"
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.io.lock.workspace_allocate "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__@vary


# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__valid_args_________calls_mktemp_as_expected() {
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKTEMP="mktemp"
  local args=()

  mktemp.mock.set.stdout "temp_folder"

  stdlib.io.lock.workspace_allocate

  mktemp.mock.assert_called_once_with "1(-d)"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__valid_args_________fails_to_creates_temp__returns_status_code__1() {
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKTEMP="mktemp"
  local args=()

  mktemp.mock.set.stdout ""

  _capture.rc stdlib.io.lock.workspace_allocate

  assert_rc "1"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_allocate__no_allocated_workspace__valid_args_________fails_to_creates_temp__logs_error_message() {
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKTEMP="mktemp"
  local args=()

  mktemp.mock.set.stdout ""

  stdlib.io.lock.workspace_allocate

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get LOCK_WORKSPACE_COULD_NOT_BE_ALLOCATED))"
}
