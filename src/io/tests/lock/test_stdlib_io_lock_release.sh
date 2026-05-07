#!/bin/bash

setup() {
  _mock.create rmdir
  _mock.create stdlib.logger.error
  _mock.create stdlib.io.lock.__workspace_is_valid
}

@parametrize_with_args_and_status_codes() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args____________returns_status_code_127;;127" \
    "extra_arg__________returns_status_code_127;lockname|extra_arg;127" \
    "null_lock_name_____returns_status_code_126;|;126" \
    "invalid_lock_name__returns_status_code_126;lock name|;126" \
    "valid_args_________returns_status_code___0;lockname;0"
}

@parametrize_with_rmdir_status() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_RMDIR_STATUS" \
    "unable_to_release______;1" \
    "released_______________;0"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_release__valid_workspace____@vary() {
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_RMDIR="rmdir"
  local args=()

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.io.lock.release "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_io_lock_release__valid_workspace____@vary

# shellcheck disable=SC2034
test_stdlib_io_lock_release__valid_workspace____valid_args_________validates_workspace() {
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_RMDIR="rmdir"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  stdlib.io.lock.release "lockname"

  stdlib.io.lock.__workspace_is_valid.mock.assert_called_once_with \
    "1(${STDLIB_LOCK_WORKSPACE})"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_release__valid_workspace____valid_args_________@vary__calls_rmdir_with_correct_args() {
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_RMDIR="rmdir"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0

  stdlib.io.lock.release "lockname"

  rmdir.mock.assert_called_once_with \
    "1(${STDLIB_LOCK_WORKSPACE}/lockname)"
}

@parametrize_with_rmdir_status \
  test_stdlib_io_lock_release__valid_workspace____valid_args_________@vary__calls_rmdir_with_correct_args

# shellcheck disable=SC2034
test_stdlib_io_lock_release__valid_workspace____valid_args_________unable_to_release________returns_status_code__1() {
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_RMDIR="rmdir"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  rmdir.mock.set.rc 1

  _capture.rc stdlib.io.lock.release "lockname"

  assert_rc "1"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_release__valid_workspace____valid_args_________unable_to_release________logs_error_message() {
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_RMDIR="rmdir"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  rmdir.mock.set.rc 1

  stdlib.io.lock.release "lockname"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get LOCK_COULD_NOT_BE_RELEASED "lockname"))"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_release__valid_workspace____valid_args_________released_________________returns_status_code__0() {
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_RMDIR="rmdir"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  rmdir.mock.set.rc 0

  _capture.rc stdlib.io.lock.release "lockname"

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_release__invalid_workspace__valid_args_________validates_workspace() {
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_RMDIR="rmdir"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1
  stdlib.io.lock.release "lockname"

  stdlib.io.lock.__workspace_is_valid.mock.assert_called_once_with \
    "1(${STDLIB_LOCK_WORKSPACE})"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_release__invalid_workspace__valid_args_________returns_status_code_123() {
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_RMDIR="rmdir"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1
  _capture.rc stdlib.io.lock.release "lockname"

  assert_rc "123"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_release__invalid_workspace__valid_args_________logs_error_message() {
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_RMDIR="rmdir"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1

  stdlib.io.lock.release "lockname"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get VAR_VALUE_INVALID_RESERVED_DETAIL STDLIB_LOCK_WORKSPACE))"
}
