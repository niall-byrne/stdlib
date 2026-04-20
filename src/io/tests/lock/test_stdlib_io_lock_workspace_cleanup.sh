#!/bin/bash

setup() {
  _mock.create rm
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_cleanup__workspace_not_allocated__does_not_call_rm() {
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_RM="rm"

  stdlib.io.lock.__workspace_cleanup

  rm.mock.assert_not_called
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_cleanup__workspace_is_allocated___calls_recursive_rm() {
  local STDLIB_LOCK_WORKSPACE="mock_workspace"
  local _STDLIB_BINARY_RM="rm"

  stdlib.io.lock.__workspace_cleanup

  rm.mock.assert_called_once_with \
    "1(-r) 2(${STDLIB_LOCK_WORKSPACE})"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_cleanup__workspace_is_allocated___calls_recursive_rm__success__returns_status_code_0() {
  local STDLIB_LOCK_WORKSPACE="mock_workspace"
  local _STDLIB_BINARY_RM="rm"

  rm.mock.set.rc 0

  _capture.rc stdlib.io.lock.__workspace_cleanup

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_cleanup__workspace_is_allocated___calls_recursive_rm__failure__returns_status_code_1() {
  local STDLIB_LOCK_WORKSPACE="mock_workspace"
  local _STDLIB_BINARY_RM="rm"

  rm.mock.set.rc 99

  _capture.rc stdlib.io.lock.__workspace_cleanup

  assert_rc "1"
}
