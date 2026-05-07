#!/bin/bash

setup() {
  _mock.create stdlib.io.path.query.is_folder
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_is_valid__workspace_is_valid_______validates_path() {
  local STDLIB_LOCK_WORKSPACE="mock_workspace"

  stdlib.io.path.query.is_folder.mock.set.rc 0

  stdlib.io.lock.__workspace_is_valid

  stdlib.io.path.query.is_folder.mock.assert_called_once_with \
    "1(${STDLIB_LOCK_WORKSPACE})"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_is_valid__workspace_is_valid_______returns_status_code___0() {
  local STDLIB_LOCK_WORKSPACE="mock_workspace"

  stdlib.io.path.query.is_folder.mock.set.rc 0

  _capture.rc stdlib.io.lock.__workspace_is_valid

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_is_valid__workspace_is_invalid_____validates_path() {
  local STDLIB_LOCK_WORKSPACE="mock_workspace"

  stdlib.io.path.query.is_folder.mock.set.rc 1

  stdlib.io.lock.__workspace_is_valid

  stdlib.io.path.query.is_folder.mock.assert_called_once_with \
    "1(${STDLIB_LOCK_WORKSPACE})"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_is_valid__workspace_is_invalid_____returns_status_code___1() {
  local STDLIB_LOCK_WORKSPACE="mock_workspace"

  stdlib.io.path.query.is_folder.mock.set.rc 1

  _capture.rc stdlib.io.lock.__workspace_is_valid

  assert_rc "1"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_is_valid__workspace_is_restricted__validates_path() {
  local STDLIB_LOCK_WORKSPACE="/"

  stdlib.io.path.query.is_folder.mock.set.rc 0

  stdlib.io.lock.__workspace_is_valid

  stdlib.io.path.query.is_folder.mock.assert_called_once_with \
    "1(${STDLIB_LOCK_WORKSPACE})"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_workspace_is_valid__workspace_is_restricted__returns_status_code___1() {
  local STDLIB_LOCK_WORKSPACE="/"

  stdlib.io.path.query.is_folder.mock.set.rc 0

  _capture.rc stdlib.io.lock.__workspace_is_valid

  assert_rc "1"
}
