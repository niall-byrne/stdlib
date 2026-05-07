#!/bin/bash

setup() {
  _mock.create stdlib.io.path.query.is_folder
  _mock.create rm
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_cleanup__workspace_is_allocated___validates_workspace() {
  local STDLIB_LOCK_WORKSPACE="mock_workspace"
  local _STDLIB_BINARY_RM="rm"

  stdlib.io.path.query.is_folder.mock.set.rc 0

  stdlib.io.lock.__workspace_cleanup

  stdlib.io.path.query.is_folder.mock.assert_called_once_with \
    "1(${STDLIB_LOCK_WORKSPACE})"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_cleanup__workspace_is_allocated___calls_recursive_rm() {
  local STDLIB_LOCK_WORKSPACE="mock_workspace"
  local _STDLIB_BINARY_RM="rm"

  stdlib.io.path.query.is_folder.mock.set.rc 0

  stdlib.io.lock.__workspace_cleanup

  rm.mock.assert_called_once_with \
    "1(-r) 2(${STDLIB_LOCK_WORKSPACE})"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_cleanup__workspace_is_allocated___calls_recursive_rm___success__returns_status_code_0() {
  local STDLIB_LOCK_WORKSPACE="mock_workspace"
  local _STDLIB_BINARY_RM="rm"

  stdlib.io.path.query.is_folder.mock.set.rc 0
  rm.mock.set.rc 0

  _capture.rc stdlib.io.lock.__workspace_cleanup

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_cleanup__workspace_is_allocated___calls_recursive_rm___failure__returns_status_code_1() {
  local STDLIB_LOCK_WORKSPACE="mock_workspace"
  local _STDLIB_BINARY_RM="rm"

  stdlib.io.path.query.is_folder.mock.set.rc 0
  rm.mock.set.rc 99

  _capture.rc stdlib.io.lock.__workspace_cleanup

  assert_rc "1"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_cleanup__workspace_not_allocated__validates_workspace() {
  local STDLIB_LOCK_WORKSPACE="mock_workspace"
  local _STDLIB_BINARY_RM="rm"

  stdlib.io.path.query.is_folder.mock.set.rc 1

  stdlib.io.lock.__workspace_cleanup

  stdlib.io.path.query.is_folder.mock.assert_called_once_with \
    "1(${STDLIB_LOCK_WORKSPACE})"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_cleanup__workspace_not_allocated__does_not_call_rm() {
  local STDLIB_LOCK_WORKSPACE="mock_workspace"
  local _STDLIB_BINARY_RM="rm"

  stdlib.io.path.query.is_folder.mock.set.rc 1

  stdlib.io.lock.__workspace_cleanup

  rm.mock.assert_not_called
}
